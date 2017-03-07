//
//  PartJobSelectView.m
//  JianGuo
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "PartJobSelectView.h"

#define HEIGHT 47

#define SPEEDSECOND 0.2

@interface PartJobSelectView()
{
    
}

@property (nonatomic,strong) UIImageView *bottomLine;

@end

@implementation PartJobSelectView


+(instancetype)aSelectView
{
    PartJobSelectView *selectView = [[PartJobSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, HEIGHT)];
    [selectView setSubViews:selectView];
    return selectView;
}

-(void)setSubViews:(PartJobSelectView *)selectView
{
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, SCREEN_W/3, 40);
    [self.leftBtn setTitle:@"待录取" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectView.leftBtn];
    
    
    
    //中间的分割线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/3-0.5, 0, 1, HEIGHT)];
    lineView.image = [UIImage imageNamed:@"icon_fengexian"];
    [selectView addSubview:lineView];
    
    self.middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.middleBtn.frame = CGRectMake(self.leftBtn.right, 0, SCREEN_W/3, 40);
    [self.middleBtn setTitle:@"已录取" forState:UIControlStateNormal];
    [self.middleBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self.middleBtn addTarget:self action:@selector(clickMiddle:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectView.middleBtn];
    
    
    
    //中间的分割线
    UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(2*SCREEN_W/3-0.5, 0, 1, HEIGHT)];
    lineView2.image = [UIImage imageNamed:@"icon_fengexian"];
    [selectView addSubview:lineView2];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(self.middleBtn.right, 0, SCREEN_W/3, 40);
    [self.rightBtn setTitle:@"已完成" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectView.rightBtn];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_W, 1)];
    bottomLine.backgroundColor = RGBACOLOR(200, 200, 200, 0.5);
    [selectView addSubview:bottomLine];
    
    UIImageView *bottonLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_W/3, 2)];
    bottonLine.backgroundColor = GreenColor;
    bottonLine.image = [UIImage imageNamed:@"icon_fubiao"];
    [selectView addSubview:bottonLine];
    self.bottomLine = bottonLine;
}
/**
 *  点击左边按钮
 *
 *  @param btn
 */
-(void)clickLeft:(UIButton *)btn
{
    [self.rightBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self.middleBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    [UIView animateWithDuration:SPEEDSECOND animations:^{
        
        CGRect rect = self.bottomLine.frame;
        rect.origin.x = 0;
        self.bottomLine.frame = rect;
        
    }completion:^(BOOL finished) {
    }];
    
    if (self.leftBtnBlock) {
        self.leftBtnBlock();
    }
}
/**
 *  点击右边按钮
 *
 *  @param btn
 */
-(void)clickRight:(UIButton *)btn
{
    [self.leftBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self.middleBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    [UIView animateWithDuration:SPEEDSECOND animations:^{
        
        CGRect rect = self.bottomLine.frame;
        rect.origin.x = 2*SCREEN_W/3;
        self.bottomLine.frame = rect;
        
    }completion:^(BOOL finished) {
    }];
    if (self.rightBtnBlock) {
        self.rightBtnBlock();
    }
}
/**
  *  点击中间按钮
  *
  *  @param btn
  */
-(void)clickMiddle:(UIButton *)btn
{
    [self.leftBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    [UIView animateWithDuration:SPEEDSECOND animations:^{
        
        CGRect rect = self.bottomLine.frame;
        rect.origin.x = SCREEN_W/3;
        self.bottomLine.frame = rect;
        
    }completion:^(BOOL finished) {
    }];
    if (self.middleBtnBlock) {
        self.middleBtnBlock();
    }
}

@end
