//
//  SelectView.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SelectView.h"

#define HEIGHT 47
#define SPEEDSECOND 0.2

@interface SelectView()
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIImageView *bottomLine;

@end
@implementation SelectView

+(instancetype)aSelectView
{
    SelectView *selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, HEIGHT)];
    [selectView setSubViews:selectView];
    return selectView;
}

-(void)setSubViews:(SelectView *)selectView
{
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, SCREEN_W/2, 40);
    [self.leftBtn setTitle:@"收藏的兼职" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectView.leftBtn];
    
    //中间的分割线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(selectView.center.x-0.5, 0, 1, HEIGHT)];
    lineView.image = [UIImage imageNamed:@"icon_fengexian"];
    [selectView addSubview:lineView];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, 40);
    [self.rightBtn setTitle:@"关注的商家" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectView.rightBtn];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_W, 1)];
    bottomLine.backgroundColor = RGBACOLOR(200, 200, 200, 0.5);
    [selectView addSubview:bottomLine];
    
    UIImageView *bottonLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_W/2, 7)];
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
    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:SPEEDSECOND animations:^{
        
        CGRect rect = self.bottomLine.frame;
        if (rect.origin.x == SCREEN_W/2) {
            rect.origin.x -= SCREEN_W/2;
        }
        self.bottomLine.frame = rect;
        
    }completion:^(BOOL finished) {
    }];
    
    self.leftBtnBlock();
}
/**
 *  点击右边按钮
 *
 *  @param btn
 */
-(void)clickRight:(UIButton *)btn
{
    [self.leftBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:SPEEDSECOND animations:^{
       
        CGRect rect = self.bottomLine.frame;
        if (rect.origin.x == 0) {
            rect.origin.x += SCREEN_W/2;
        }
        self.bottomLine.frame = rect;
        
    }completion:^(BOOL finished) {
    }];
    if (self.rightBtnBlock) {
        self.rightBtnBlock();
    }
}

@end
