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
@interface TransitionManager : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) SecondViewController *modalController;
@end