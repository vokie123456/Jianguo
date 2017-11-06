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
#import "UIImageView+WebCache.h"

#import "SignDemandViewController.h"
#import "DemandStatusParentViewController.h"

static NSString *identifier = @"DemandCellIdentifier";

@interface MyDemandCell()<UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    self.collectionBgView.hidden = YES;
    
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
    
    if (model.kind.integerValue == 1) {
        self.stateHeaderL.text = @"我发布的";
        self.headerView.backgroundColor = RGBCOLOR(195, 220, 138);
        
        if (model.limitTimeStr.length == 0) {
            self.timeLimitHeightCons.constant = 0;
            self.timeLimitL.hidden = YES;
        }else{
            self.timeLimitHeightCons.constant = 35;
        }
        if (model.enrolls.count) {
            [self.collectionView reloadData];
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
        
        switch (model.status.integerValue) {
            case 1:{
                
                [self.leftB setTitle:@"下架任务" forState:UIControlStateNormal];
                [self.rightB setTitle:@"查看报名" forState:UIControlStateNormal];
                self.enrollCountL.text = [NSString stringWithFormat:@"已报名 %@人",model.enrollCount];
                self.collectionBgView.hidden = NO;
                
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
                
                
                if (model.publishEvaluateStatus.integerValue) {
                    
                    self.leftB.hidden = YES;
                    self.rightB.hidden = YES;
                    self.stateL.text = @"已结束";
                    self.collectionBgView.hidden = YES;
                }else{
                    self.leftB.hidden = YES;
                    [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
                    self.stateL.text = @"已确认完工";
                }
                
                
                break;
            } case 5:case 6:case 7:{//TODO:状态描述
                
                self.leftB.hidden = YES;
                self.rightB.hidden = YES;
                if (_model.status.integerValue == 5){
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

        
    }else if (model.kind.integerValue == 2){
        self.stateHeaderL.text = @"我报名的";
        self.headerView.backgroundColor = RGBCOLOR(253, 185, 111);
        
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
        
        
        if (_model.enrollStatus.integerValue == 4) {
            self.stateL.text = @"已取消报名";
            self.collectionBgView.hidden = YES;
        }else if (_model.enrollStatus.integerValue == 3){
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            self.stateL.text = @"未被录取";
            self.collectionBgView.hidden = YES;
        }else if (_model.enrollStatus.integerValue == 1){//报名了
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"取消报名" forState:UIControlStateNormal];
            self.stateL.text = [NSString stringWithFormat:@"已报名 %@人",model.enrollCount];
            self.collectionBgView.hidden = NO;
        }else{
            
            switch (model.status.integerValue) {
                case 1:{
                    
                    self.leftB.hidden = YES;
                    [self.rightB setTitle:@"取消报名" forState:UIControlStateNormal];
                    self.stateL.text = [NSString stringWithFormat:@"已报名 %@ 人",model.enrollCount];
                    
                    break;
                } case 2:{
                    
                    self.leftB.hidden = YES;
                    [self.rightB setTitle:@"确认完工" forState:UIControlStateNormal];
                    self.stateL.text = @"已被录取";
                    self.enrollCountL.text = [NSString stringWithFormat:@"已被录取"];
                    self.collectionBgView.hidden = NO;
                    
                    break;
                } case 3:{
                    
                    self.leftB.hidden = YES;
                    [self.rightB setTitle:@"催TA确认" forState:UIControlStateNormal];
                    self.stateL.text = @"任务已完成";
                    self.collectionBgView.hidden = YES;
                    
                    
                    break;
                } case 4:{
                    
                    if (model.receiveEvaluateStatus.integerValue) {
                        
                        self.leftB.hidden = YES;
                        self.rightB.hidden = YES;
                        self.stateL.text = @"已完成";
                        self.collectionBgView.hidden = YES;
                    }else{
                        self.leftB.hidden = YES;
                        [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
                        self.stateL.text = @"发布者已确认完工";
                        self.collectionBgView.hidden = YES;
                    }
                    
                    break;
                } case 5:case 6:case 7:{//TODO:状态描述
                    
                    self.leftB.hidden = YES;
                    self.rightB.hidden = YES;
                    if (_model.status.integerValue == 7) {
                        self.stateL.text = @"已下架";
                        self.collectionBgView.hidden = YES;
                    }else if (_model.status.integerValue == 5){
                        self.stateL.text = @"任务被投诉";
                        self.collectionBgView.hidden = YES;
                    }else if (_model.status.integerValue == 6){
                        self.stateL.text = @"投诉已处理";
                        self.collectionBgView.hidden = YES;
                    }
                    
                    break;
                }
                default:
                    break;
            }
        }
        
    }
    
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    NSArray *array = @[@"#feb369",@"#70a9fc",@"#8e96e9",@"#c9a269",@"#fa7070",@"#71c268"];
    colorArr = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *color = [UIColor colorWithHexString:obj];
        [colorArr addObject:color];
    }];
    titleArr = @[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"].mutableCopy;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.enrolls.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(30, 30);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Enrolls *user = _model.enrolls[indexPath.item];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:cell.bounds];
    iconView.layer.cornerRadius = 30/2;
    iconView.layer.masksToBounds = YES;
    [cell.contentView addSubview:iconView];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",user.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Enrolls *user = _model.enrolls[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(lookUser:)]) {
        [self.delegate lookUser:user.enrollUid];
    }
    JGLog(@"%@",indexPath);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
@end
