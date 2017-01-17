//
//  PartJobSelectView.h
//  JianGuo
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartJobSelectView : UIView

@property (nonatomic,copy) void(^rightBtnBlock)();
@property (nonatomic,copy) void(^leftBtnBlock)();
@property (nonatomic,copy) void(^middleBtnBlock)();
-(void)clickLeft:(UIButton *)btn;
-(void)clickRight:(UIButton *)btn;
-(void)clickMiddle:(UIButton *)btn;

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *middleBtn;
@property (nonatomic,strong) UIButton *rightBtn;
+(instancetype)aSelectView;
@end
