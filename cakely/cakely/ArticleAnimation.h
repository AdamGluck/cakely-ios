//
//  ArticleAnimation.h
//  cakely
//
//  Created by Adam Gluck on 2/7/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AnimationTypePresent,
    AnimationTypeDismiss
} AnimationType;

@interface ArticleAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType animationType;
@property (strong, nonatomic) UITableViewCell * selectedCell;
@property (assign, nonatomic) CGPoint contentOffset;

@end
