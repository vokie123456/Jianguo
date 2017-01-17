//
//  StudentInfoCell.h
//  JianGuo
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *qqTF;
@property (weak, nonatomic) IBOutlet UITextView *introduceTF;
@end
