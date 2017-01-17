//
//  SelectScrollView.m
//  JianGuo
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SelectScrollView.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define bottomViewH 3
#define baseTagValue 1000
#define lineColor RGBCOLOR(220, 220, 220)

@interface SelectScrollView ()
{
    UIView *bottomView;
    UIView *moveView;
}

@end

@implementation SelectScrollView

+(instancetype)aSelectViewWithTittles:(NSArray *)tittles frame:(CGRect )frame
{
    SelectScrollView *selectView = [[SelectScrollView alloc] initWithFrame:frame];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.tittles = tittles;
    selectView.count = tittles.count;
    [selectView createUI];
    
    return selectView;
}

-(void)createUI
{
    [self createButtons];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-bottomViewH, screenW, bottomViewH)];
    bottomView.backgroundColor = lineColor;
    [self addSubview:bottomView];
    
    moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW/self.count, bottomViewH)];
    moveView.backgroundColor = BLUECOLOR;
    [bottomView addSubview:moveView];
    
    
}

-(void)createButtons
{
    for (int i=0; i<self.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(screenW*i/self.count, 0, screenW/self.count, self.height-bottomViewH);
        btn.tag = baseTagValue + i;
        [btn setTitle:self.tittles[i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
}

-(void)clickBtn:(UIButton *)sender
{
    for (int i=0; i<self.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i+baseTagValue];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    [sender setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    CGRect rect = moveView.frame;
    rect.origin.x = screenW*(sender.tag-baseTagValue)/self.count;
    [UIView animateWithDuration:0.3 animations:^{
        moveView.frame = rect;
    }];
    
    if (self.clickSelectBlock) {
        self.clickSelectBlock(sender.tag-baseTagValue);
    }
}

@end
