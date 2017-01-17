//
//  DemandTypeView.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandTypeView.h"
#import <POP.h>

#define radius 120

@interface DemandTypeView()
{
    void (^selectedBlock)(NSInteger index,NSString *title);
    NSMutableArray *btnArr;
    NSInteger count;
}

@end
@implementation DemandTypeView


+(instancetype)demandTypeViewselectBlock:(void(^)(NSInteger index,NSString *title))complectionBlock;
{
    DemandTypeView *bgView = [[DemandTypeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.8f];
    [APPLICATION.keyWindow addSubview:bgView];
    bgView -> btnArr = @[].mutableCopy;
    bgView -> selectedBlock = complectionBlock;
    return bgView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (!self.titleArr.count) {
            self.titleArr = @[@"学习",@"代办",@"求助",@"娱乐",@"情感",@"生活"];
            [self setSubViews];
        }
    }
    return self;
}

-(void)setTitleArr:(NSArray *)titleArr
{
    _titleArr = titleArr;
    [self setSubViews];
}

-(void)setSubViews
{
    for (int i=1; i<=self.titleArr.count; i++) {
        self.userInteractionEnabled = NO;
        [self performSelector:@selector(createBtns:) withObject:[NSNumber numberWithInt:i-1] afterDelay:(i-1)*0.10];
    }

}

-(void)selectDemandType:(UIButton *)btn
{
    selectedBlock(btn.tag-100,btn.currentTitle);
    
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
}

-(void)scaleAnimate:(UIButton *)btn
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [btn.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

-(void)createBtns:(NSNumber *)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 60);
    btn.center = APPLICATION.keyWindow.center;
    btn.layer.cornerRadius = btn.width/2;
    btn.tag = 101+index.integerValue;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = FONT(14);
    [btn setTitle:self.titleArr[index.integerValue] forState:UIControlStateNormal];
    [btn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btn setBackgroundColor:GreenColor];
    [btn addTarget:self action:@selector(selectDemandType:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(scaleAnimate:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    
    [btnArr insertObject:btn atIndex:0];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.velocity = [NSValue valueWithCGPoint:CGPointMake(0.5,0.5)];//这个值要跟toValue和fromValue是一个类型 的赋值(即都是 整型 或者都是 通过 NSValue 赋值)
    animation.springBounciness = 20;
    animation.springSpeed = 20;
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(btn.center.x+ radius*cos(index.integerValue*2*M_PI/self.titleArr.count), btn.center.y+radius*sin(index.integerValue*2*M_PI/self.titleArr.count))];

    
    [btn pop_addAnimation:animation forKey:@"center"];
    if (index.integerValue == self.titleArr.count-1) {
        self.userInteractionEnabled = YES;
    }
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

-(void)dismiss
{
    
    for (NSInteger i=0;i<btnArr.count;i++) {
        UIButton *btn = btnArr[i];
        [self performSelector:@selector(dismissAnimation:) withObject:btn afterDelay:i*0.1];
    }
    
//    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1*self.titleArr.count+0.5];
    
}

-(void)dismissAnimation:(UIButton *)btn
{

    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
//    animation.velocity = [NSValue valueWithCGPoint:CGPointMake(0.5,0.5)];//这个值要跟toValue和fromValue是一个类型 的赋值(即都是 整型 或者都是 通过 NSValue 赋值)
//    animation.springBounciness = 20;
//    animation.springSpeed = 20;
    animation.toValue = [NSValue valueWithCGPoint:APPLICATION.keyWindow.center];
    animation.duration = 0.1;
    
    [btn pop_addAnimation:animation forKey:@"center"];
    
    NSInteger index = [btnArr indexOfObject:btn];
    if (index+1 == self.titleArr.count) {
        [animation setCompletionBlock:^(POPAnimation *ani, BOOL finish) {
            [self removeFromSuperview];//由于 performSelector 开线程延迟执行,所以这个方法执行时间并不是很准确
        }];
    }
    
}

@end
