//
//  starView.m
//  staView
//
//  Created by 李振华 on 15/11/2.
//  Copyright © 2015年 李振华. All rights reserved.
//

#import "StarView.h"

@interface StarView ()

@end

#define countOfStar 5
#define space 6;

@implementation StarView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _score = 5.f;
        [self initSubView];
    }
    return self;
}

- (void)awakeFromNib {
    [self initSubView];
}

- (void)initSubView {
    for (int i=0; i<countOfStar; i++) {
        UIView *grayView = [UIView new];
        grayView.tag = 100 + i;
        [self addSubview:grayView];
        
        UIView *lightView = [UIView new];
        lightView.tag = 100 + countOfStar + i;
        [self addSubview:lightView];
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.size.width = countOfStar * rect.size.height + (countOfStar - 1) * space;
    [super setFrame:rect];
}

- (void)setScore:(float)score {
    if (_score != score) {
        _score = score;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImage *grayImage = [UIImage imageNamed:@"xingxing"];
    UIImage *lightImage = [UIImage imageNamed:@"stars"];
    int lightScoreCount = (int)self.score;
    for (int i=0; i<countOfStar; i++) {
        CGFloat x = self.bounds.size.height + space;
        
        UIView *grayView = [self viewWithTag:100+i];
        grayView.backgroundColor = [UIColor colorWithPatternImage:grayImage];
        grayView.transform = CGAffineTransformMakeScale(self.bounds.size.height/grayImage.size.width, self.bounds.size.height/grayImage.size.height);
        grayView.frame = CGRectMake(i * x, 0, self.bounds.size.height, self.bounds.size.height);
        
        UIView *lightView = [self viewWithTag:100 + countOfStar + i];
        lightView.backgroundColor = [UIColor colorWithPatternImage:lightImage];
        lightView.transform = CGAffineTransformMakeScale(self.bounds.size.height/lightImage.size.width, self.bounds.size.height/lightImage.size.height);
        if (i < lightScoreCount) {
            lightView.frame = CGRectMake( i * x, 0, self.bounds.size.height, self.bounds.size.height);
        }
        
        if (i == lightScoreCount && self.score != lightScoreCount  ) {
            lightView.frame = CGRectMake(i * x, 0, (self.score - lightScoreCount) * self.bounds.size.height , self.bounds.size.height);
        }
    }
}

@end
