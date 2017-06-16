//
//  TimePickerView.m
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/13.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import "TimePickerView.h"

@interface TimePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
	NSMutableArray *_arrayLeft;
	NSArray *_arrayCenter;
	NSArray *_arrayRight;
	
	NSDateComponents *_comps;
	NSCalendar *_calendar;
	NSInteger _unitFlags;
	
	void (^_block)(NSString *timeString);
}
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@end

@implementation TimePickerView
{
	__weak IBOutlet UIPickerView *_pickerView;
}

+(TimePickerView *)aTimePickerViewWithBlock:(void (^)(NSString *))block
{
	TimePickerView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
	view->_block = block;
	return view;
}

- (void)show
{
	for (int i = 0; i < 30; i++) {  //上门从第二天开始，到店后延十分钟
		NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(self.isArriveStore?i:i+1)*24*3600];
		_comps = [_calendar components:_unitFlags fromDate:date];
		
		NSString *weekString;

		switch ([_comps weekday]) {
			case 1:
				weekString = @"周日";
				break;
			case 2:
				weekString = @"周一";
				break;
			case 3:
				weekString = @"周二";
				break;
			case 4:
				weekString = @"周三";
				break;
			case 5:
				weekString = @"周四";
				break;
			case 6:
				weekString = @"周五";
				break;
			case 7:
				weekString = @"周六";
				break;
		}
		
		NSString *timeString = [NSString stringWithFormat:@"%ld年%ld月%ld日(%@)",(long)_comps.year%2000, (long)_comps.month, (long)_comps.day, weekString];
		
		[_arrayLeft addObject:timeString];
	}

	self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
	self.frame = [UIApplication sharedApplication].keyWindow.bounds;
	self.whiteView.transform = CGAffineTransformMakeTranslation(0, self.whiteView.height);
	[[UIApplication sharedApplication].keyWindow addSubview:self];
    if (self.isArriveStore) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_pickerView reloadAllComponents];
            [_pickerView selectRow:9 inComponent:1 animated:NO];
        }];
        [_pickerView selectRow:1 inComponent:0 animated:NO];
        [CATransaction commit];
    }
	[UIView animateWithDuration:0.3 animations:^{
		self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
		self.whiteView.transform = CGAffineTransformIdentity;
	}];
}

- (void)dismiss
{
	[UIView animateWithDuration:0.3 animations:^{
		self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
		self.whiteView.transform = CGAffineTransformMakeTranslation(0, self.whiteView.height);
	} completion:^(BOOL finished) {
		_block = nil;
		[self removeFromSuperview];
	}];
}

- (void)awakeFromNib
{
	self.backgroundColor = [UIColor clearColor];
	self.frame = [UIApplication sharedApplication].keyWindow.bounds;
		self.transform = CGAffineTransformMakeTranslation(0, [UIApplication sharedApplication].keyWindow.height);
	
	_pickerView.delegate = self;
	_pickerView.dataSource = self;
	_arrayLeft = [[NSMutableArray alloc] initWithCapacity:30];
	
	 _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	 _unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit |	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self cancle:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat width = self.width-4*8;
	if (component == 0) {
		return width/8*6;   //年月日宽度为四分之三，其余分别为八分之一
	} else
		return width/8;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	_comps = [_calendar components:_unitFlags fromDate:[NSDate date]];
	
	if (component == 0) {
		return 30;     //30天
	} else if (component == 1) {
		
		if(!self.isArriveStore) { //上门
			return 23 - 9 + 1;
		}
		if ([pickerView selectedRowInComponent:0] == 0) {  //到店当天

			if ([_comps minute] > 40) {  //  过了40分，选择下一个小时
				return 23-[_comps hour];
			} else {
				return 23-[_comps hour] + 1;
			}
		}  //隔天无限制
		return 24;
	} else {
		
		if ([pickerView selectedRowInComponent:0] == 0 && [pickerView selectedRowInComponent:1] == 0 &&[_comps minute] <= 40 && self.isArriveStore) {      //当天第一个小时没过40分
			if ([_comps minute]%10 == 0) {
				return 6 - [_comps minute]/10 - 1;
			} else {
				return 6 - [_comps minute]/10 - 2;
			}
		}
		return 6;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0) {
		return _arrayLeft[row];
		
	} else if (component == 1) {
		
		if (!self.isArriveStore) {  //上门
			return [NSString stringWithFormat:@"%d", (int)(row+9)];
		}
		
		_comps = [_calendar components:_unitFlags fromDate:[NSDate date]];
		
		if ([pickerView selectedRowInComponent:0] == 0) {
			if ([_comps minute] > 40) {
				return [NSString stringWithFormat:@"%ld", row + [_comps hour] + 1];
			} else {
				return [NSString stringWithFormat:@"%ld", row + [_comps hour]];
			}
		}
		if (row == 0) {
			return @"00";
		}
		return [NSString stringWithFormat:@"%ld", row];
		
	} else {
		
		if ([pickerView selectedRowInComponent:0] == 0 && [pickerView selectedRowInComponent:1] == 0 &&[_comps minute] <= 40 && self.isArriveStore) {
			if ([_comps minute] % 10 == 0) {
				return [NSString stringWithFormat:@"%ld", ([_comps minute]/10+row+1)*10];
			} else {
				return [NSString stringWithFormat:@"%ld", ([_comps minute]/10+row+2)*10];
			}
		}
		if(row == 0)
			return @"00";
		return [NSString stringWithFormat:@"%ld", row*10];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0) {
		[pickerView reloadAllComponents];
	}
	if ([pickerView selectedRowInComponent:0] == 0 && component == 1) {
		[pickerView reloadComponent:2];
	}
}

- (IBAction)commit:(id)sender {
	if (_block) {
		_block([NSString stringWithFormat:@"%@ %@:%@", [self pickerView:_pickerView titleForRow:[_pickerView selectedRowInComponent:0] forComponent:0], [self pickerView:_pickerView titleForRow:[_pickerView selectedRowInComponent:1] forComponent:1],[self pickerView:_pickerView titleForRow:[_pickerView selectedRowInComponent:2] forComponent:2]]);
	}
	[self dismiss];
}
- (IBAction)cancle:(id)sender {
	
	[self dismiss];
}
@end
