//
//  TransitionManager.m
//  interactive-transition
//
//  Created by Hitoshi Saito on 2015/01/09.
//  Copyright (c) 2015年 Hitoshi Saito. All rights reserved.
//

#import "TransitionManager.h"
#import "SecondViewController.h"

@interface TransitionManager () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation TransitionManager

- (id)initWithFromViewController:(UIViewController*)fromViewController withScrollView:(UIScrollView*)scrollView {
    self = [super init];
    if (self) {
        _fromViewController = fromViewController;
        _scrollView = scrollView;
        
        _fromViewController.transitioningDelegate = self;
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
        _panGesture.delegate = self;
        [_fromViewController.view addGestureRecognizer:_panGesture];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:_panGesture]) {
        CGPoint location = [gestureRecognizer locationInView:[_fromViewController.view window]];
        if (location.y > 200) {
            _scrollView.scrollEnabled = YES;
        } else {
            _scrollView.scrollEnabled = NO;
        }
    }
    return YES;
}

#pragma mark -

- (void)gestureHandler:(UIPanGestureRecognizer*)recognizer{
    if (recognizer.state==UIGestureRecognizerStateBegan){
        [_fromViewController dismissViewControllerAnimated:YES completion:NULL];
        [recognizer setTranslation:CGPointZero inView:_fromViewController.view.superview];
        [self updateInteractiveTransition:0];
        return;
    }
    
    CGFloat percentage = [recognizer translationInView:_fromViewController.view.superview].y/_fromViewController.view.superview.bounds.size.height;
    
    [self updateInteractiveTransition:percentage];
    
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        
        CGFloat velocityY = [recognizer velocityInView:recognizer.view.superview].y;
        BOOL cancel=(velocityY<0) || (velocityY==0 && recognizer.view.frame.origin.y<_fromViewController.view.superview.bounds.size.height/2);
        CGFloat points = cancel ? recognizer.view.frame.origin.y : _fromViewController.view.superview.bounds.size.height-recognizer.view.frame.origin.y;
        NSTimeInterval duration = points / velocityY;
        
        if (duration<.2) {
            duration=.2;
        }else if(duration>.6){
            duration=.6;
        }
        
        cancel ? [self cancelInteractiveTransitionWithDuration:duration] : [self finishInteractiveTransitionWithDuration:duration];
        
    }else if (recognizer.state==UIGestureRecognizerStateFailed){
        
        [self cancelInteractiveTransitionWithDuration:.35];
        
    }
}


#pragma mark - UIViewControllerAnimatedTransitioning -

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (_isNoNeedInteractive) {
        UIView *containerView = [transitionContext containerView];
        
        CGRect finalFrame=[transitionContext finalFrameForViewController:fromVC];
        finalFrame.origin.y = finalFrame.size.height;
        
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
        
        CGRect toFrame = toVC.view.frame;
        toFrame.origin.y = 0;
        toVC.view.frame = toFrame;
        toVC.view.transform=CGAffineTransformMakeScale(.95, .95);
        toVC.view.alpha = 0.5;
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toVC.view.transform=CGAffineTransformIdentity;
                             toVC.view.alpha = 1;
                             

                             fromVC.view.frame=finalFrame;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    } else {
        UIView *containerView = [transitionContext containerView];
        
        CGRect finalFrame=[transitionContext finalFrameForViewController:toVC];
        
        toVC.view.frame=CGRectMake(0, fromVC.view.bounds.size.height, finalFrame.size.width, finalFrame.size.height);
        [containerView addSubview:toVC.view];
        
        fromVC.view.transform=CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             fromVC.view.transform=CGAffineTransformMakeScale(.95, .95);
                             fromVC.view.alpha = 0.5;
                             
                             toVC.view.frame=finalFrame;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             fromVC.view.transform = CGAffineTransformIdentity;
                             fromVC.view.alpha = 1;
                         }];
    }
    

}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext=transitionContext;
    
    UIView* inView = [transitionContext containerView];
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    toViewController.view.transform=CGAffineTransformMakeScale(.95, .95);
    fromViewController.view.transform=CGAffineTransformIdentity;
    toViewController.view.alpha=0.5;
    [inView insertSubview:toViewController.view belowSubview:fromViewController.view];
}

#pragma mark - UIPercentDrivenInteractiveTransition

- (void)updateInteractiveTransition:(CGFloat)percentComplete{
    if (percentComplete<0) {
        percentComplete=0;
    }else if (percentComplete>1){
        percentComplete=1;
    }
    
    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGFloat scale=0.95+(1-0.95)*percentComplete;
    CGFloat alpha =0.5+(1-0.5)*percentComplete;
    
    CGRect frame=fromViewController.view.frame;
    frame.origin.y=fromViewController.view.bounds.size.height*percentComplete;
    fromViewController.view.frame=frame;
    
    toViewController.view.transform=CGAffineTransformMakeScale(scale,scale);
    toViewController.view.alpha = alpha;
}

- (void)cancelInteractiveTransitionWithDuration:(CGFloat)duration{
    
    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toViewController.view.transform=CGAffineTransformMakeScale(.95, .95);
                         fromViewController.view.transform=CGAffineTransformIdentity;
                         toViewController.view.alpha=0.5;
                         
                         CGRect fromFrame = fromViewController.view.frame;
                         fromFrame.origin.y = 0;
                         fromViewController.view.frame = fromFrame;
                     } completion:^(BOOL finished) {
                         [toViewController.view removeFromSuperview];
                         [self.transitionContext cancelInteractiveTransition];
                         [self.transitionContext completeTransition:NO];
                         self.transitionContext=nil;
                     }];
    
    
    [self cancelInteractiveTransition];
}

- (void)finishInteractiveTransitionWithDuration:(CGFloat)duration{
    
    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.alpha = 1;
                         
                         CGRect frame=toViewController.view.frame;
                         frame.origin.y=0;
                         toViewController.view.frame=frame;
                         
                         CGRect fromFrame = fromViewController.view.frame;
                         fromFrame.origin.y = fromFrame.size.height;
                         fromViewController.view.frame = fromFrame;
                     } completion:^(BOOL finished) {
                         [fromViewController.view removeFromSuperview];
                         [self.transitionContext completeTransition:YES];
                         self.transitionContext=nil;
                     }];
    
    [self finishInteractiveTransition];
}



#pragma mark - UIViewControllerTransitioningDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (_isNoNeedInteractive) {
        return nil;
    }
    return self;
}

@end
