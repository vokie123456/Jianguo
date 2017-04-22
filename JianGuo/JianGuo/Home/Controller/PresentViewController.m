//
//  PresentViewController.m
//  JianGuo
//
//  Created by apple on 17/4/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PresentViewController.h"
#import "TransitionAnimationScale.h"

@interface PresentViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    TransitionAnimationScale *transitinPresent = [[TransitionAnimationScale alloc] init];
    transitinPresent.type = @"present";
    return transitinPresent;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    TransitionAnimationScale *transitinDismiss = [[TransitionAnimationScale alloc] init];
    transitinDismiss.type = @"dismiss";
    return transitinDismiss;
}

@end
