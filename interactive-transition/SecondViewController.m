//
//  SecondViewController.m
//  interactive-transition
//
//  Created by Hitoshi Saito on 2014/12/23.
//  Copyright (c) 2014年 Hitoshi Saito. All rights reserved.
//

#import "SecondViewController.h"
#import "TransitionManager.h"

@interface SecondViewController ()

@property (nonatomic, strong) TransitionManager *transitionManager;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:animated];
    
    _transitionManager = [[TransitionManager alloc] init];
    _transitionManager.modalController = self;
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

- (IBAction)closeButtonAction:(id)sender {
    self.transitioningDelegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
