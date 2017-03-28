//
//  BaseViewController.h
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

/**
 *  显示错误提示框
 *
 *  @param text 错误信息
 */
- (void)showErrorViewWithText:(NSString *)text;
/**
 *  显示提示信息
 *
 *  @param text 信息
 */
- (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration;
#pragma 正则匹配手机号
- (BOOL)checkTelNumber:(NSString*) phoneNum;
/**
 *  检查是否已经登录
 */
-(BOOL)checkExistPhoneNum;

/**
 *  删除左滑返回手势
 */
- (void)removeSwipeGestureRecognizer;
/**
 *  添加button的shake动画
 */
-(void)addShakeAnimation:(UIButton *)button;

/**
 *  去登录
 */
-(void)gotoCodeVC;
/**
 *  去填写资料
 */
-(void)gotoProfileVC;

@end
