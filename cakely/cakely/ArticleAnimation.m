//
//  ArticleAnimation.m
//  cakely
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "ArticleAnimation.h"

@interface ArticleAnimation()

@property (strong, nonatomic) UIViewController *fromViewController;
@property (strong, nonatomic) UIViewController *toViewController;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation ArticleAnimation 

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.containerView = [transitionContext containerView];
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [self.containerView insertSubview:self.toViewController.view belowSubview:self.fromViewController.view];
    
    if (self.animationType == AnimationTypePresent){
        [self animationTypePresentTransition:transitionContext];
    } else if (self.animationType == AnimationTypeDismiss){
        // hide from view controller view so one can see the animation
        // fromViewController is removed from the stack anyway after pop so we don't have to worry about state later
        self.fromViewController.view.alpha = 0.0f;
        
        // set base toViewController alpha so animation looks better
        self.toViewController.view.alpha = 0.2f;
        
        // woo hoo!
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.toViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

#pragma mark - Animations
#pragma mark - Animation Type Present
-(void)animationTypePresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // variables to base calculations on
    // acounts for content offset of the tableView
    // add in the fromViewController origin since it might be offset by a navigation controller
    CGFloat fromViewControllerOriginOffset = self.fromViewController.view.frame.origin.y;
    CGRect selectedCellFrameInView = CGRectOffset(self.selectedCell.frame, -self.contentOffset.x, (-self.contentOffset.y + fromViewControllerOriginOffset));
    
    UIImageView * selectedCellImageView = [self selectedCellImageView:selectedCellFrameInView];
    [self.containerView insertSubview:selectedCellImageView aboveSubview:self.fromViewController.view];

    UIImageView * aboveCellImageView = [self aboveCellImageView:selectedCellFrameInView];
    [self.containerView insertSubview:aboveCellImageView aboveSubview:self.fromViewController.view];
    
    UIImageView * belowCellImageView = [self belowCellImageView:selectedCellFrameInView];
    [self.containerView insertSubview:belowCellImageView aboveSubview:self.fromViewController.view];
    
    //hide view so just images
    //self.fromViewController.view.center = CGPointMake(self.fromViewController.view.center.x, self.fromViewController.view.center.y + self.fromViewController.view.frame.size.height);
    self.fromViewController.view.alpha = 0.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        selectedCellImageView.center = CGPointMake(selectedCellImageView.center.x + selectedCellImageView.frame.size.width, selectedCellImageView.center.y);
        selectedCellImageView.alpha = 0.0f;

        aboveCellImageView.center = CGPointMake(aboveCellImageView.center.x, aboveCellImageView.center.y -aboveCellImageView.frame.size.height);
        aboveCellImageView.alpha = 0.0f;

        belowCellImageView.center = CGPointMake(belowCellImageView.center.x, belowCellImageView.center.y + belowCellImageView.frame.size.height);
        belowCellImageView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {

        [transitionContext completeTransition:YES];
    }];
    
}

#pragma mark - AnimationTypePresent helper functions
-(UIImageView *)selectedCellImageView:(CGRect)selectedCellFrame
{
    UIImageView * selectedCellImageView = [[UIImageView alloc] initWithFrame:selectedCellFrame];
    selectedCellImageView.image = [self grabImageInRect:selectedCellFrame fromView:self.containerView];
    return selectedCellImageView;
}

-(UIImageView *)aboveCellImageView:(CGRect)selectedCellFrame
{
    CGFloat distanceAboveSelectedCell = selectedCellFrame.origin.y;
    CGRect aboveCellRect = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, self.containerView.frame.size.width, distanceAboveSelectedCell);
    UIImageView * aboveCellImageView = [[UIImageView alloc] initWithFrame:aboveCellRect];
    aboveCellImageView.image = [self grabImageInRect:aboveCellRect fromView:self.containerView];
    return aboveCellImageView;
}

-(UIImageView *)belowCellImageView:(CGRect)selectedCellFrame
{
    CGFloat bottomOfCellY = selectedCellFrame.origin.y + selectedCellFrame.size.height;
    CGFloat distanceBelowCell = self.containerView.frame.size.height - bottomOfCellY;
    CGRect belowCellRect = CGRectMake(self.containerView.frame.origin.x, bottomOfCellY, self.containerView.frame.size.width, distanceBelowCell);
    UIImageView * belowCellImageView = [[UIImageView alloc] initWithFrame:belowCellRect];
    belowCellImageView.image = [self grabImageInRect:belowCellRect fromView:self.containerView];
    return belowCellImageView;
}

#pragma mark - AnimateTypeDismiss transition
#pragma mark - Main Method

#pragma mark - screen image helper functions

-(UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width, view.bounds.size.height), view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)grabImageInRect:(CGRect)rect fromView:(UIView *)view {
    UIImage * viewImage = [self imageWithView:view];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGImageRef image = CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale));
    UIImage * partOfViewImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return partOfViewImage;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end
