//
//  BindCell.h
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAcountDelegate <NSObject>

-(void)clickBtnOfCell:(UIButton *)btn;
-(void)clickUnBandBtn:(UIButton *)sender;

@end

@interface BindCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *bindTypeL
;
@property (weak, nonatomic) IBOutlet UILabel *bindStateL;
@property (weak, nonatomic) IBOutlet UIImageView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouView;
@property (nonatomic,weak) id <SelectAcountDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *unBindBtn;

@end
