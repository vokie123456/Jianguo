//
//  DemandProgressCell.m
//  JianGuo
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandProgressCell.h"
#import "DemandModel.h"
@interface DemandProgressCell()
@property (weak, nonatomic) IBOutlet UILabel *firstL;
@property (weak, nonatomic) IBOutlet UILabel *secondL;
@property (weak, nonatomic) IBOutlet UILabel *thirdL;

@property (weak, nonatomic) IBOutlet UILabel *firstViewL;
@property (weak, nonatomic) IBOutlet UILabel *secViewL;
@property (weak, nonatomic) IBOutlet UILabel *thirdViewL;
@property (weak, nonatomic) IBOutlet UILabel *stateDescriptionL;

@end
@implementation DemandProgressCell

-(void)setModel:(DemandModel *)model
{
    _model = model;
    NSInteger status = model.enroll_status.integerValue;
    
    switch (status) {
        case 0:{
            
            
            
            break;
        } case 1:{
            
            
            
            break;
        } case 2:{
            
            
            
            break;
        } case 3:{
            
            
            
            break;
        } case 4:{
            
            
            
            break;
        } case 5:{
            
            
            
            break;
        } case 6:{
            
            
            
            break;
        } case 7:{
            
            
            
            break;
        }
        default:
            break;
    }

    
}

-(void)currentStatus:(UILabel *)label
{
    label.backgroundColor = GreenColor;
    label.textColor = WHITECOLOR;
}

-(void)notCurrentStatus:(UILabel *)label
{
    label.backgroundColor = WHITECOLOR;
    label.textColor = GreenColor;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    DemandProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
