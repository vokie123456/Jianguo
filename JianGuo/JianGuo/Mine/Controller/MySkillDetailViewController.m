//
//  MySkillDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySkillDetailViewController.h"


#import "DemandDetailCell.h"
#import "MySignDemandCell.h"
#import "MineHeaderCell.h"
#import "DemandStatusCell.h"
#import "DemandProgressCell.h"
#import "BillCell.h"

#import <UIButton+AFNetworking.h>
#import "UIImageView+WebCache.h"
#import <POPSpringAnimation.h>

@interface MySkillDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据元数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MySkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"技能管理";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"投诉订单" style:UIBarButtonItemStylePlain target:self action:@selector(complain:)];
    item.tintColor = GreenColor;
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.estimatedRowHeight = 80;
    
}

-(void)complain:(UIButton *)sender
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return self.dataArr.count+10;
    }else
        return 1;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            return 65;
        }else
            return 44;
        
    }else if (indexPath.section == 1){
        
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            return 44;
        }else
            return 70;
        
    }else if (indexPath.section == 4){
        
        return 100;
        
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",@"144343"];
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
//            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 1){
            BillCell *cell = [BillCell cellWithTableView:tableView];
//            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.demandModel.publishHeadImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
//            cell.leftConst.constant = 15;
//            cell.titleL.text = self.demandModel.title;
//            cell.timeL.text = self.demandModel.demandDesc;
//            if ([self.demandModel.money containsString:@"."]) {
//                cell.moneyL.text = [NSString stringWithFormat:@"￥ %.2f",self.demandModel.money.floatValue];
//            }else{
//                cell.moneyL.text = [@"￥ " stringByAppendingString:self.demandModel?self.demandModel.money:@"  "];
//            }
            cell.moneyL.textColor = [UIColor orangeColor];
            
            return cell;
        }else if (indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"1";
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            cell.detailTextLabel.text = @"购买数量";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 3){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"订单时间";
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
//            cell.detailTextLabel.text = self.demandModel.limitTimeStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else
            return nil;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",self.demandModel.demandId];
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
            //            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 1){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",@"123123"];
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
            //            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
            
        }else if (indexPath.row == 2){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"买家留言: %@",@"服务不好不给钱服务不好不给钱服务不好不给钱服务不好不给钱服务不好不给钱服务不好不给钱服务不好不给钱服务不好不给钱服务不好不给钱"];
            cell.detailTextLabel.numberOfLines = 0;
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
            //            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
            
        }return nil;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            cell.textLabel.text = [NSString stringWithFormat:@"服务者信息"];
            cell.textLabel.textColor = RGBCOLOR(102, 102, 102);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.height-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else{
            MineHeaderCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MineHeaderCell class]) owner:nil options:nil] lastObject];
            cell.iconBtn.layer.cornerRadius = 20;
//            cell.delegate = self;
//            if (self.demandModel) {
//                [cell.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.demandModel.enrollHeadImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
//                cell.nameL.text = self.demandModel.enrollNickname.length?self.demandModel.enrollNickname:@"未填写";
//                cell.schoolL.text = self.demandModel.enrollSchoolName.length?self.demandModel.enrollSchoolName:@"未填写";
//                cell.genderView.image = [UIImage imageNamed:self.demandModel.enrollSex.integerValue == 2?@"boy":@"girlsex"];
//            }
            return cell;
        }
    }else if (indexPath.section == 3){
        
        DemandStatusCell *cell = [DemandStatusCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            ani.springSpeed = 20.f;
            ani.velocity = @1200;
            ani.springBounciness = 20;
            [cell.layer pop_addAnimation:ani forKey:nil];
            //            [ani setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
            //                if (finish) {
            //                    [cell.layer pop_removeAllAnimations];
            //
            //                }
            //            }];
            cell.topView.hidden = YES;
            cell.contentL.textColor = GreenColor;
            cell.timeL.textColor = GreenColor;
            cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
        }else if (indexPath.row == self.dataArr.count-1){
            cell.bottomView.hidden = YES;
        }
//        cell.model = self.demandModel.logs[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 4){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        
        UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
        
        centerB.layer.cornerRadius = 5;
        centerB.backgroundColor = GreenColor;
        centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
        [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:centerB];
        [centerB setTitle:@"下架任务" forState:UIControlStateNormal];
        
        return cell;
    }else{
        
        return nil;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)clickCenterB:(UIButton *)sender
{
    
}


@end
