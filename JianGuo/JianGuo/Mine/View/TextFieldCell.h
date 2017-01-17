//
//  TextFieldCell.h
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/23.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UITextField *txfName;

+ (TextFieldCell *)aTextFieldCell;
@end
