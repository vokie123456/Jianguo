//
//  UIImage+sretchImage.m
//  WinterGame
//
//  Created by XQL on 15/12/16.
//  Copyright © 2015年 XQL. All rights reserved.
//

#import "UIImage+sretchImage.h"

@implementation UIImage (sretchImage)

+(UIImage *)stretchAImage:(UIImage *)image
{
    
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 0; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

@end
