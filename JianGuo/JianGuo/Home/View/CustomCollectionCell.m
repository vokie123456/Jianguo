//
//  CustomCollectionCell.m
//  JianGuo
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "CustomCollectionCell.h"

#define shadowWidth 5

@interface CustomCollectionCell()
{
    
}

@end
@implementation CustomCollectionCell

- (void)awakeFromNib {//这是啥用xib的话调用的方法 (跟collectionview调用的注册方法有关 registerNib: 用这个方法才调用这个)
//    self.iconView.layer.shadowColor = GreenColor.CGColor;
//    self.iconView.layer.shadowOpacity = 0.5;
//    self.iconView.layer.shadowOffset = CGSizeMake(shadowWidth, shadowWidth);
////    self.iconView.layer.shadowRadius = 5;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    CGFloat w = self.iconView.width;
//    CGFloat h = self.iconView.height;
//    CGFloat x = self.iconView.frame.origin.x;
//    CGFloat y = self.iconView.frame.origin.y;
//    
//    CGPoint firstP = CGPointMake(self.iconView.bounds.origin.x-shadowWidth, self.iconView.bounds.origin.y-shadowWidth);
//    CGPoint secondP = CGPointMake(firstP.x+w+shadowWidth, firstP.y);
//    CGPoint thirdP = CGPointMake(secondP.x, y+h+shadowWidth);
//    CGPoint forthP = CGPointMake(firstP.x, thirdP.y);
//    
//    [path moveToPoint:firstP];
//    [path addLineToPoint:secondP];
//    [path addLineToPoint:thirdP];
//    [path addLineToPoint:forthP];
//    [path closePath];
//    
//    self.iconView.layer.shadowPath = path.CGPath;
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}




-(instancetype)initWithFrame:(CGRect)frame//不用xib时调用的方法(跟collectionview调用的注册方法有关 registerClass 用这个方法才调用这个)
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        iconV.image = [UIImage imageNamed:@"1"];
        [self.contentView addSubview:iconV];
    }
    return self;
}

@end
