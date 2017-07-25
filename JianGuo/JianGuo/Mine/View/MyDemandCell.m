//
//  MyDemandCell.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyDemandCell.h"
#import "DemandPostModel.h"
#import "DemandTypeModel.h"
#import "UIImageView+WebCache.h"
#import "MyTabBarController.h"
#import "TextReasonViewController.h"
#import "QLAlertView.h"
#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+DemandOperation.h"

#import "QLHudView.h"
#import "NSObject+HudView.h"
#import "UIColor+Hex.h"

#import "SignDemandViewController.h"
#import "DemandStatusParentViewController.h"

@interface MyDemandCell()<UIViewControllerTransitioningDelegate>
@end
@implementation MyDemandCell
{
    NSMutableArray *colorArr;
    NSMutableArray *titleArr;
}

-(void)prepareForReuse
{
    
    [super prepareForReuse];
    self.leftB.hidden = NO;
    self.rightB.hidden = NO;
//    self.timeLimitHeightCons.constant = 0;
//    self.timeLimitL.hidden = YES;
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MyDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


-(void)setModel:(DemandPostModel *)model
{
    _model = model;
    if (model.limitTimeStr.length == 0) {
        self.timeLimitHeightCons.constant = 0;
        self.timeLimitL.hidden = YES;
    }else{
        self.timeLimitHeightCons.constant = 35;
    }
    self.titleL.text = model.title;
    self.descriptionL.text = model.demandDesc;
    self.timeL.text = model.createTimeStr;
    self.timeLimitL.text = model.limitTimeStr;
    self.typeL.text = titleArr[model.demandType.integerValue-1];
    self.typeL.backgroundColor = colorArr[model.demandType.integerValue-1];
    if ([model.money containsString:@"."]) {
        self.moneyL.text = [NSString stringWithFormat:@"￥%.2f元",model.money.floatValue];
    }else{
        self.moneyL.text = [NSString stringWithFormat:@"￥%@元",model.money];
    }
    
    switch (model.type.integerValue) {
        case 1:{
            
            [self.leftB setTitle:@"下架任务" forState:UIControlStateNormal];
            [self.rightB setTitle:@"查看报名" forState:UIControlStateNormal];
            self.stateL.text = [NSString stringWithFormat:@"已报名 %@人",model.enrollCount];
            
            break;
        } case 2:{
            
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"催TA干活" forState:UIControlStateNormal];
            self.stateL.text = @"已录取";
            
            break;
        } case 3:{
            
            if (model.isTimeout.boolValue) {
                self.leftB.hidden = NO;
                [self.leftB setTitle:@"拒绝支付" forState:UIControlStateNormal];
            }else{
                self.leftB.hidden = YES;
            }
            [self.rightB setTitle:@"确认完工" forState:UIControlStateNormal];
            self.stateL.text = @"对方已完成任务";
            
            
            break;
        } case 4:{
            
            
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
            self.stateL.text = @"已确认完工";
            
            
            break;
        } case 5:{//TODO:状态描述
            
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            if (_model.status.integerValue == 4) {
                self.stateL.text = @"已结束";
            }else if (_model.status.integerValue == 5){
                self.stateL.text = @"投诉处理中";
            }else if (_model.status.integerValue == 6){
                self.stateL.text = @"投诉已处理";
            }else{
                self.stateL.text = @"已下架";
            }
            
            break;
        }
        default:
            break;
    }

    
}


- (void)awakeFromNib {
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
