//
//  CheckBox.h
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBox : UIView;
+(instancetype)aCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *Btn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (weak, nonatomic) IBOutlet UILabel *labeYysOrNo;
@end
