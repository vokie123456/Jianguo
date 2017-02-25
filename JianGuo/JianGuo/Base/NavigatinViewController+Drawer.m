//
//  NavigatinViewController+Drawer.m
//  JianGuo
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController+Drawer.h"
#import "POP.h"

#define kDrawerCloseX (self.view.width)


@implementation NavigatinViewController (Drawer)

- (UIView *) setupDrawerWithContent:(UIView *)content scrollConent:(UIScrollView *)scrollContent
{
    CGFloat blankWidth = 50;
    
    UIView *drawerView = [[UIView alloc] initWithFrame:(CGRect){kDrawerCloseX,0,content.width+blankWidth,content.height}];
    drawerView.backgroundColor = WHITECOLOR;
    [self.view addSubview:drawerView];
    
    // 将content添加到drawer中
    [drawerView addSubview:content];
    
    // loading
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]
                                           initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    CGPoint center = CGPointMake(content.width/2, content.height/2);
    activityView.center = center;
    activityView.hidesWhenStopped = YES;
    [drawerView addSubview:activityView];
    self.drawer_activityView = activityView;
    
    // 加阴影
    CALayer *layer = drawerView.layer;
    layer.shadowOffset = CGSizeMake(-0.5, 3);
    layer.shadowColor = [[UIColor grayColor] CGColor];
    layer.shadowOpacity = 0.5f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    //加手势
    UIPanGestureRecognizer *drawer_recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(drawer_paningGestureReceive:)];
    [drawerView addGestureRecognizer:drawer_recognizer];
    self.drawerView = drawerView;
    self.drawer_Content = content;
    self.drawer_ScrollContent = scrollContent;
    return drawerView;
}

#pragma mark – 手势处理
- (void)drawer_paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    //监听开始
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        self.drawer_touchBeganPoint = touchPoint;
        self.drawer_ScrollContent.scrollEnabled = NO;
    }
    //监听结束
    else if (recoginzer.state == UIGestureRecognizerStateEnded)
    {
        self.drawer_ScrollContent.scrollEnabled = YES;
        if (self.drawerView.frame.origin.x>kDrawerOpenX) {
            [self closeDrawer];
        }
        else
        {
            [self showDrawer];
        }
    }
    //手势移动
    else
    {
        self.drawer_ScrollContent.scrollEnabled = NO;
        CGFloat xOffSet = touchPoint.x - self.drawer_touchBeganPoint.x + kDrawerOpenX;
        if (xOffSet < kDrawerOpenX) {
            return;
        }
        self.drawerView.left = xOffSet;
    }
}

- (void)drawerStartLoading
{
    self.drawer_activityView.hidden = NO;
    [self.drawerView bringSubviewToFront:self.drawer_activityView];
    [self.drawer_activityView startAnimating];
}

- (void)drawerStopLoading
{
    [self.drawer_activityView stopAnimating];
}

- (void)showDrawer
{
    if (self.drawerView == nil || self.isDrawered) {
        return;
    }
    [self.drawerView setHidden:NO];
    self.isDrawered = YES;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.drawerView.width*0.5+kDrawerOpenX, self.drawerView.center.y)];
    [self.drawerView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    positionAnimation.dynamicsTension = 10.f;
    positionAnimation.dynamicsFriction = 1.0f;
    positionAnimation.springBounciness = 10.0f;
    @weakify(self);
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL isfinished) {
        @strongify(self);
        [self openDrawerCompleted];
    }];
    [self.drawerView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)closeDrawer
{
    if (self.drawerView == nil || self.isDrawered==NO) {
        return;
    }
    self.isDrawered = NO;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.drawerView.left = SCREEN_W+10;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.drawerView.hidden = YES;
                             [self closeDrawerCompleted];
                         }
                     }];
}

- (void) closeDrawerCompleted
{
}

- (void) openDrawerCompleted
{
}

@end
