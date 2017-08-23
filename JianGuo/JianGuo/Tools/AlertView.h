//
//  AlertView.h
//  JianGuo
//
//  Created by apple on 17/8/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView <UITextFieldDelegate>


+(instancetype)aAlertViewCallBackBlock:(void(^)(NSString *))block;

-(void)show;

@end
