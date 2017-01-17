//
//  StarView.m
//  LimitDemo
//
//  Created by pk on 15/3/25.
//  Copyright (c) 2015年 pk. All rights reserved.
//

#import "StarView.h"

@interface StarView (){
    UIView* _backView;
    UIView* _foreView;
}

@end

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeView];
    }
    return self;
}

- (void)awakeFromNib{
    [self makeView];
}

- (void)makeView{
    //15*14  75*14
    self.backgroundColor = [UIColor clearColor];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 14)];
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    _foreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 14)];
    //裁剪子视图
    _foreView.clipsToBounds = YES;
    [self addSubview:_foreView];
    
    for (int i = 0; i < 5; i++) {
        //空心 1.主页_16.png
        UIImageView* backStar = [[UIImageView alloc] initWithFrame:CGRectMake(i * 15, 3, 15, 14)];
        backStar.image = [UIImage imageNamed:@"icon_star2"];
        [_backView addSubview:backStar];
        
        //实心 1.主页_14.png
        UIImageView* foreStar = [[UIImageView alloc] initWithFrame:CGRectMake(i * 15, 3, 15, 14)];
        foreStar.image = [UIImage imageNamed:@"icon_star"];
        [_foreView addSubview:foreStar];
    }
}

- (void)setScore:(float)score{
    _foreView.frame = CGRectMake(0, 0, 75 * (score / 5.0), 14);
}




@end
