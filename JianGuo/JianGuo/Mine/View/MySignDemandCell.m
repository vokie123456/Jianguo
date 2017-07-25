//
//  MyDemandToFinishCell.m
//  JianGuo
//
//  Created by apple on 17/6/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySignDemandCell.h"
#import "DemandSignModel.h"
#import "DemandTypeModel.h"
#import "UIColor+Hex.h"

@implementation MySignDemandCell
{
    NSMutableArray *colorArr;
    NSMutableArray *titleArr;
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MySignDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


-(void)setModel:(DemandSignModel *)model
{
    _model = model;
    self.typeL.text = titleArr[model.demandType.integerValue-1];
    self.typeL.backgroundColor = colorArr[model.demandType.integerValue-1];
    self.titleL.text = model.title;
    self.descriptionL.text = model.demandDesc;
    self.timeL.text = model.createTimeStr;
    self.timeLimitL.text = model.limitTimeStr;
    if ([model.money containsString:@"."]) {
        self.moneyL.text = [NSString stringWithFormat:@"￥%.2f元",model.money.floatValue];
    }else{
        self.moneyL.text = [NSString stringWithFormat:@"￥%@元",model.money];
    }
    switch (model.type.integerValue) {
        case 1:{
            
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"取消报名" forState:UIControlStateNormal];
            self.stateL.text = [NSString stringWithFormat:@"已报名 %@人",model.enrollCount];
            
            break;
        } case 2:{
            
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"确认完工" forState:UIControlStateNormal];
            self.stateL.text = @"已被录取";
            
            break;
        } case 3:{
            
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"催TA确认" forState:UIControlStateNormal];
            self.stateL.text = @"任务已完成";
            
            
            break;
        } case 4:{
            
            
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
            self.stateL.text = @"发布者已确认完工";
            
            
            break;
        } case 5:{//TODO:状态描述
            
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            if (_model.status.integerValue == 7) {
                self.stateL.text = @"已下架";
            }else if (_model.status.integerValue == 5){
                self.stateL.text = @"任务被投诉";
            }else if (_model.status.integerValue == 6){
                self.stateL.text = @"投诉已处理";
            }else{
                if (_model.enrollStatus.integerValue == 4) {
                    self.stateL.text = @"已取消报名";
                }else if (_model.enrollStatus.integerValue == 3){
                    self.stateL.text = @"未被录取";
                }else if (_model.enrollStatus.integerValue == 2){
                    self.stateL.text = @"已完成";
                }
            }
            
            break;
        }
        default:
            break;
    }
    
}

- (IBAction)clickLeft:(id)sender {
    
    switch (_model.type.integerValue) {
        case 1:{//隐藏无操作
            
            
            
            break;
        } case 2:{//隐藏无操作
            
            
            
            break;
        } case 3:{//拒绝付款
            
            
            
            break;
        } case 4:{//隐藏了––>无操作
            
            
            
            break;
        } case 5:{//隐藏––>无操作
            
            
            
            break;
        }
        default:
            break;
    }
    
}

- (IBAction)clickRight:(id)sender {
    
    switch (_model.type.integerValue) {
        case 1:{//取消报名
            
            
            
            break;
        } case 2:{//确认完工
            
            
            
            break;
        } case 3:{//催TA确认
            
            
            
            break;
        } case 4:{//去评价
            
            
            
            break;
        } case 5:{//隐藏––>无操作
            
            
            
            break;
        }
        default:
            break;
    }
    
}

- (void)awakeFromNib {
    // Initialization code
    NSArray *array = @[@"#feb369",@"#70a9fc",@"#8e96e9",@"#c9a269",@"#fa7070",@"#71c268"];
    colorArr = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *color = [UIColor colorWithHexString:obj];
        [colorArr addObject:color];
    }];
    
//    NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
    titleArr = @[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"].mutableCopy;
//    for (DemandTypeModel *model in demandTypeArr) {
//        if (model.type_id.integerValue == 0) {
//            continue;
//        }
//        [titleArr addObject:model.type_name];
//    }
}


@end
