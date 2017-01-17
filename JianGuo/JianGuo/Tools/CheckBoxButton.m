//
//  CheckBoxButton.m
//  JianGuo
//
//  Created by apple on 17/1/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CheckBoxButton.h"

@implementation CheckBoxButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    };
    return self;
}

-(void)setUI
{
    UIImageView *imgV = [[UIImageView alloc] init];
    self.imageV = imgV;
    imgV.image = [UIImage imageNamed:@"writecomment"];
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(16, 15)]);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    self.label = label;
    label.text = @"评论";
    label.textColor = LIGHTGRAYTEXT;
    label.font = FONT(12);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.top.equalTo(imgV.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(self.mas_width);
    }];
}

-(void)click:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}

@end
