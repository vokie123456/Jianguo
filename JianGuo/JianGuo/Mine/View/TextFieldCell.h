//
//  TextFieldCell.h
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/23.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextChangedDelegate <NSObject>

-(void)textChanged:(UITextField *)textField;

@end

@interface TextFieldCell : UITableViewCell


@property (nonatomic,weak) id<TextChangedDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UITextField *txfName;

+ (TextFieldCell *)aTextFieldCell;
@end
