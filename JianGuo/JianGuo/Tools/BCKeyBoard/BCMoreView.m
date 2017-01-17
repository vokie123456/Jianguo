//
//  BCMoreView.m
//  BCDemo
//
//  Created by baochao on 15/7/27.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import "BCMoreView.h"

@implementation BCMoreView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
    }
    return self;
}
- (void)setImageArray:(NSArray *)imageArray
{
//    CGFloat padding = ([UIScreen mainScreen].bounds.size.width - 42*4)/5;
//    for(int i=0;i<imageArray.count;i++){
//        int clo = i % 4;
//        int lin = i / 4;
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(padding + (padding+42)*clo,20+(padding+42)*lin, 42, 42);
//        btn.tag = i;
//        [btn setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.center.y-80, self.frame.size.width, 40)];
    label.textColor = LIGHTGRAYTEXT;
    label.font = FONT(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"语音及图片消息还在开发中,敬请期待";
    [self addSubview:label];
}
- (void)selectImage:(UIButton *)btn{
    if(self.delegate){
        [self.delegate didselectImageView:btn.tag];
    }
}

@end
