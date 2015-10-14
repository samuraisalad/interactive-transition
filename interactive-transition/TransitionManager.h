//
//  TransitionManager.h
//  interactive-transition
//
//  Created by Hitoshi Saito on 2015/01/09.
//  Copyright (c) 2015年 Hitoshi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SecondViewController;
@interface TransitionManager : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>
@property (nonatomic, readwrite) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, assign) BOOL isNoNeedInteractive;

- (id)initWithFromViewController:(UIViewController*)fromViewController withScrollView:(UIScrollView*)scrollView;

- (void)cancelInteractiveTransitionWithDuration:(CGFloat)duration;
- (void)finishInteractiveTransitionWithDuration:(CGFloat)duration;

@end