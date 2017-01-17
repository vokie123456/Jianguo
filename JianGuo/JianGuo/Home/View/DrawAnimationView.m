//
//  DrawAnimationView.m
//  JianGuo
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "DrawAnimationView.h"
#import <QuartzCore/QuartzCore.h>
@interface DrawAnimationView()
{
    CAShapeLayer *arcLayer;
    CAShapeLayer *bgLayer;
}

@end
@implementation DrawAnimationView

-(void)awakeFromNib
{
//    [self intiUIOfView];
}

-(void)setStudentNum:(CGFloat)studentNum
{
    _studentNum = studentNum;
    [self intiUIOfView];
}

-(void)intiUIOfView
{
    UIBezierPath *bgpath=[UIBezierPath bezierPath];
    self.backgroundColor = [UIColor clearColor];
    
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [bgpath addArcWithCenter:CGPointMake(33,33) radius:25 startAngle:0 endAngle:M_PI*2 clockwise:NO];
    
    bgLayer=[CAShapeLayer layer];
    bgLayer.path=bgpath.CGPath;//46,169,230
    bgLayer.fillColor=[UIColor clearColor].CGColor;
    bgLayer.strokeColor=BACKCOLORGRAY.CGColor;
    bgLayer.lineWidth=2;
    bgLayer.frame=self.bounds;
    [self.layer addSublayer:bgLayer];
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    self.backgroundColor = [UIColor clearColor];
    
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    
//    arcLayer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
    
    if (_studentNum >0&&_studentNum<1) {
        [path addArcWithCenter:CGPointMake(33,33) radius:25 startAngle:0 endAngle:(-M_PI*2)*(1-_studentNum) clockwise:YES];
        arcLayer=[CAShapeLayer layer];
        arcLayer.path=path.CGPath;//46,169,230
        arcLayer.fillColor=[UIColor clearColor].CGColor;
        arcLayer.strokeColor=RGBCOLOR(0, 218, 211).CGColor;
        arcLayer.lineWidth=2;
        arcLayer.frame=self.bounds;
        [self.layer addSublayer:arcLayer];
        [self drawLineAnimation:arcLayer];
    }else if (_studentNum>=1){
        [path addArcWithCenter:CGPointMake(33,33) radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        arcLayer=[CAShapeLayer layer];
        arcLayer.path=path.CGPath;//46,169,230
        arcLayer.fillColor=[UIColor clearColor].CGColor;
        arcLayer.strokeColor=RGBCOLOR(0, 218, 211).CGColor;
        arcLayer.lineWidth=2;
        arcLayer.frame=self.bounds;
        [self.layer addSublayer:arcLayer];
        [self drawLineAnimation:arcLayer];
    }else{
        return;
    }
    
    
    
}
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}
@end
