//
//  CheckBoxButton.h
//  JianGuo
//
//  Created by apple on 17/1/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxButton : UIView

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *label;

@property (nonatomic,copy) void(^clickBlock)(UIButton *sender);

@end
