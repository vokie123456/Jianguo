//
//  OrderCountCell.h
//  JianGuo
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderCountCellDelegate <NSObject>

-(void)countChanged:(NSString *)count;

@end

@interface OrderCountCell : UITableViewCell


@property (nonatomic,weak) id<OrderCountCellDelegate> delegate;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UITextField *countTF;

@end
