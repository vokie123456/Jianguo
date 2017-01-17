//
//  UIView+AlertView.h
//  JianGuo
//
//  Created by apple on 16/3/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AlertView)
- (void)showErrorViewWithText:(NSString *)text;
- (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration;

@end
