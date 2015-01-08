//
//  TransitionManager.m
//  interactive-transition
//
//  Created by Hitoshi Saito on 2015/01/09.
//  Copyright (c) 2015年 Hitoshi Saito. All rights reserved.
//

#import "TransitionManager.h"
#import "SecondViewController.h"

@implementation TransitionManager

- (void)setModalController:(SecondViewController *)modalController {
    _modalController = modalController;
    _modalController.transitioningDelegate = self;

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
    [_modalController.view addGestureRecognizer:panGesture];
}

#pragma mark - UIViewControllerAnimatedTransitioning -

- (void)gestureHandler:(UIPanGestureRecognizer*)recognizer{
    CGPoint location = [recognizer locationInView:[_modalController.view window]];
//    CGPoint velocity = [recognizer velocityInView:[_modalController.view window]];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (location.y < CGRectGetMidY(recognizer.view.bounds)) {
            [_modalController dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat animationRatio = location.y / CGRectGetHeight(_modalController.view.bounds);
//        NSLog(@"animationRatio : %f  location : %f  velocity : %f", animationRatio, location.y, velocity.y);
        [self updateInteractiveTransition:animationRatio];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (location.y > CGRectGetHeight(_modalController.view.bounds) / 2) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
        _modalController = nil;
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    [container insertSubview:toVC.view belowSubview:fromVC.view];

    [UIView animateWithDuration:1.f
                         animations:^{
                             CGRect frame = fromVC.view.frame;
                             frame.origin.y = CGRectGetMaxY([UIScreen mainScreen].bounds);
                             fromVC.view.frame = frame;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    
}


#pragma mark - UIViewControllerTransitioningDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self;
}

@end
