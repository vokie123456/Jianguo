//
//  QLSuccessHudView.m
//  CADemos
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 Kitten Yang. All rights reserved.
//

#import "QLSuccessHudView.h"

static const CGFloat width = 80;
static const NSTimeInterval animationDuration = 0.3;

@implementation QLSuccessHudView

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
    }
    return self;
}

+(instancetype)shareInstance
{
    QLSuccessHudView *hud = [[QLSuccessHudView alloc]init];
    return hud;
}

-(void)show:(NSString *)textStr
{
    
    self.backgroundColor = [UIColor colorWithRed:0.1803921568627451 green:0.8 blue:0.44313725490196076 alpha:1.0];
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    bgView.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:bgView];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    visualEffectView.frame = CGRectMake(0, 0, 150, 180);
    visualEffectView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    visualEffectView.layer.cornerRadius = 10;
    visualEffectView.clipsToBounds = YES;
    
    self.frame = CGRectMake(visualEffectView.frame.size.width/2-width/2, visualEffectView.frame.size.height/2-width/2-20, width, width);
    
    self.layer.cornerRadius = self.frame.size.width/2;

    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *ano = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    ano.frame = CGRectMake(0, 0, 150, 180);
    ano.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    UILabel *textL = ({ UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)+10, visualEffectView.frame.size.width, 30)];
        label.text = textStr;
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    

    [visualEffectView.contentView addSubview:textL];
    
    [visualEffectView.contentView addSubview:ano];
    

    
    [visualEffectView.contentView addSubview:self];
    
    
    visualEffectView.transform = CGAffineTransformMakeScale(1/1000, 1/1000);
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.99 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        visualEffectView.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self animate];
        }
    }];
    
    [bgView addSubview:visualEffectView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss:bgView visualView:visualEffectView];
    });
    
}

-(void)animate
{
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0))/2, self.bounds.size.width*(1-1/sqrt(2.0))/2);
    [path moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/9, rectInCircle.origin.y + rectInCircle.size.height*2/3)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/3,rectInCircle.origin.y + rectInCircle.size.height*9/10)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width*8/10, rectInCircle.origin.y + rectInCircle.size.height*2/10)];
    
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10.0;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.3f;
//    checkAnimation.beginTime = CACurrentMediaTime()+0.5;
    checkAnimation.fromValue = @(0.f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
}

-(void)dismiss:(UIView *)bgView visualView:(UIView *)visualEffectView
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        visualEffectView.transform = CGAffineTransformMakeScale(5, 5);
        visualEffectView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

@end
