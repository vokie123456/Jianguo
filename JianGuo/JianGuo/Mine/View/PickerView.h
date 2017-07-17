//
//  PickerView.h
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/20.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerView : UIView

+(PickerView *)aPickerView:(void (^)(NSString *))block;
+(PickerView *)aProvincePickerView:(void (^)(NSString *str,NSString *Id))block;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property(nonatomic, strong)NSArray *arrayData;
@property(nonatomic, assign)BOOL isDatePicker;
@property(nonatomic, assign)BOOL isCityPicker;
@property(nonatomic, assign)BOOL isAreaPicker;
@property (nonatomic,strong) NSDate *defaultDate;


@property (nonatomic,copy) NSString *initalDateStr;


- (void)show;
- (void)dismiss;
@end
