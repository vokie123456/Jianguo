//
//  LimitTimeCell.h
//  JianGuo
//
//  Created by apple on 17/6/5.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LimitTimeCell : UITableViewCell

@property (nonatomic,copy) void(^moneyChangedBlock)(NSString *money);

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitL;
@property (weak, nonatomic) IBOutlet UIButton *alertB;
@property (weak, nonatomic) IBOutlet UIButton *cancelB;

@property (weak, nonatomic) IBOutlet UIButton *setB;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
