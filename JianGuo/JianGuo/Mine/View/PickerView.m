//
//  PickerView.m
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/20.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import "PickerView.h"
#import "NSDate+Addition.h"
#import "AreaModel.h"

@interface PickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
	void (^_block)(NSString *);
    void (^_provinceBlock)(NSString *,NSString *);
	NSArray *_arrayProvince;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation PickerView


-(NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

-(void)setInitalDateStr:(NSString *)initalDateStr
{
    _initalDateStr = initalDateStr;
    self.datePickerView.date = [self.formatter dateFromString:initalDateStr];
}

+(PickerView *)aPickerView:(void (^)(NSString *))block
{
	PickerView *view = [[[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:nil options:nil] lastObject];
	view->_arrayProvince = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"]];
	view->_block = block;
   	return view;
}


+(PickerView *)aProvincePickerView:(void (^)(NSString *str,NSString *Id))block
{
    PickerView *view = [[[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:nil options:nil] lastObject];
    view->_arrayProvince = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"]];
    view->_provinceBlock = block;
   	return view;
}

- (void)awakeFromNib
{
    [self.boardView bringSubviewToFront:self.cancelBtn];
    [self.boardView bringSubviewToFront:self.finishBtn];
    
	self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
	self.datePickerView.maximumDate = [NSDate date];
	self.datePickerView.minimumDate = [NSDate stringToDate:@"1940-01-01" format:@"yyyy-MM-dd"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self cancel:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//	if (self.isCityPicker) {
		return 2;
//	}
//	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//	if (self.isCityPicker) {
		if(component == 0) {
			return _arrayProvince.count;
		} else {
			NSArray *arrayCity = _arrayProvince[[pickerView selectedRowInComponent:0]][@"cities"];
			return arrayCity.count;
		}
//	}
//	return [self.arrayData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (self.isCityPicker) {
		if(component == 0) {
			return _arrayProvince[row][@"name"];
		} else {
//            return @"XXXX";
			NSArray *arrayCity = _arrayProvince[[pickerView selectedRowInComponent:0]][@"cities"];
			if (row <= [arrayCity count] - 1) {
				return arrayCity[row][@"name"];
			} else {
				return @"...";
			}
		}
	}
    if (self.isAreaPicker) {
        AreaModel *model = self.arrayData[row];
        return model.areaName;
    }
	return self.arrayData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0 && self.isCityPicker) {
		[pickerView reloadComponent:1];
		[pickerView selectRow:0 inComponent:1 animated:YES];
	}
}

- (void)show
{
	if (self.isDatePicker) {
		self.pickerView.hidden = YES;
	} else {
		self.datePickerView.hidden = YES;
	}
	self.frame = [UIApplication sharedApplication].keyWindow.bounds;
	self.boardView.transform = CGAffineTransformMakeTranslation(0, self.boardView.height);
	[[UIApplication sharedApplication].keyWindow addSubview:self];
	[UIView animateWithDuration:0.3f animations:^{
		
		self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
		self.boardView.transform = CGAffineTransformIdentity;
	}];
}

-(void)dismiss
{
	[UIView animateWithDuration:0.3 animations:^{
		self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
		self.boardView.transform = CGAffineTransformMakeTranslation(0, self.boardView.height);
	} completion:^(BOOL finished) {
		_block = nil;
		[self removeFromSuperview];
	}];
}

- (IBAction)done:(id)sender {
	if (_block) {
		if (self.isDatePicker) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			_block([dateFormatter stringFromDate:self.datePickerView.date]);
			
        } else if (self.isCityPicker) {
            NSString *province = _arrayProvince[[self.pickerView selectedRowInComponent:0]][@"name"];
            NSString *city = _arrayProvince[[self.pickerView selectedRowInComponent:0]][@"cities"][[self.pickerView selectedRowInComponent:1]][@"citycode"];
            _provinceBlock(province,city);
        }  else if (self.isAreaPicker) {
            AreaModel *model = self.arrayData[[self.pickerView selectedRowInComponent:0]];
            _block([NSString stringWithFormat:@"%@=%@",model.id,model.areaName]);
        } else {
			_block(_arrayData[[self.pickerView selectedRowInComponent:0]]);
		}
    }else if (_provinceBlock){
        NSString *province = _arrayProvince[[self.pickerView selectedRowInComponent:0]][@"name"];
        NSString *city = _arrayProvince[[self.pickerView selectedRowInComponent:0]][@"cities"][[self.pickerView selectedRowInComponent:1]][@"name"];
        NSString *cityCode = _arrayProvince[[self.pickerView selectedRowInComponent:0]][@"cities"][[self.pickerView selectedRowInComponent:1]][@"citycode"];
        _provinceBlock([NSString stringWithFormat:@"%@ %@",province,city],cityCode);
    }
	[self dismiss];
}
- (IBAction)cancel:(id)sender {
	[self dismiss];
}

@end
