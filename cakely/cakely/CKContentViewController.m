//
//  CKContentViewController.m
//  cakely
//
//  Created by Adam Gluck on 2/24/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKContentViewController.h"

@interface CKContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *articleLoadingBar;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIView *coverLoadingView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSTimer * timer;

@end

@implementation CKContentViewController

#pragma mark - view loaded information
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(tickProgressBar:) userInfo:nil repeats:YES];
    self.articleLoadingBar.progress = 0.0;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:self.contentURL];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - loading sequence helpers

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.timer invalidate];
    self.articleLoadingBar.progress = 1.0;
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.coverLoadingView.alpha = 0.0;
        } completion:nil];
 
}

-(void)tickProgressBar:(NSTimer *)timer
{
    NSUInteger randomProgressJolt = arc4random_uniform(20);
    float progressIncrement = randomProgressJolt / 100.0;
    self.articleLoadingBar.progress += progressIncrement;
    if (self.articleLoadingBar.progress >= .95){
        self.articleLoadingBar.progress = .95;
       [timer invalidate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
