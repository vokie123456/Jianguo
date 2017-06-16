//
//  TimePickerView.h
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/13.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView

+(TimePickerView *)aTimePickerViewWithBlock:(void (^)(NSString *timeString)) block;

@property(nonatomic, assign)BOOL isArriveStore;

-(void)show;

-(void)dismiss;

@end
