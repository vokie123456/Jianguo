//
//  TransitionAnimationScale.m
//  JianGuo
//
//  Created by apple on 17/4/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "TransitionAnimationScale.h"

@implementation TransitionAnimationScale

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.type isEqualToString: @"present"]) {
        [self presentVC:transitionContext];
    }else if ([self.type isEqualToString: @"dismiss"]){
        [self dismiss:transitionContext];
    }
    
}

-(void)presentVC:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *tempView = fromVC.view;
//    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//    fromVC.view.hidden = YES;
    
    UIView *containerView = [transitionContext containerView];//这是一个做转场动画必须用的一个中间View,需要把转场的View添加到这个view上才能添加动画
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    toVC.view.frame = CGRectMake(0, containerView.height, containerView.width, 400);
    
    //开始添加动画
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        APPLICATION.keyWindow.backgroundColor = [UIColor blackColor];
        
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -toVC.view.height);
        
        tempView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        
    } completion:^(BOOL finished) {
        //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不是用手势的话直接传YES也是可以的，我们必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在，会出现无法交互的情况，切记
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        //转场失败后的处理
//        if ([transitionContext transitionWasCancelled]) {
//            //失败后，我们要把vc1显示出来
//            fromVC.view.hidden = NO;
//            //然后移除截图视图，因为下次触发present会重新截图
//            [tempView removeFromSuperview];
//        }
    }];
}

-(void)dismiss:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView *containerView = [transitionContext containerView];//这是一个做转场动画必须用的一个中间View,需要把转场的View添加到这个view上才能添加动画
    NSArray *subviewsArray = containerView.subviews;
    UIView *tempView = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    
    //动画吧
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了接标记失败
            [transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
    
}

@end
