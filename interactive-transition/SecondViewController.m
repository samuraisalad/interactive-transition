//
//  SecondViewController.m
//  interactive-transition
//
//  Created by Hitoshi Saito on 2014/12/23.
//  Copyright (c) 2014年 Hitoshi Saito. All rights reserved.
//

#import "SecondViewController.h"
#import "TransitionManager.h"

@interface SecondViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) TransitionManager *transitionManager;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _transitionManager = [[TransitionManager alloc] initWithFromViewController:self withScrollView:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) * 2);
    
//    NSArray *gestureRecognizers = _scrollView.gestureRecognizers;
//    for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
//        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//            _scrollViewPanGesture = gestureRecognizer;
//        }
//    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openButtonAction:(id)sender {
    SecondViewController *secondViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SecondViewController"];
    [self presentViewController:secondViewController animated:YES completion:nil];
}

- (IBAction)closeButtonAction:(id)sender {
    _transitionManager.isNoNeedInteractive = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
