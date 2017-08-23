//
//  MySkillDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySkillDetailViewController.h"
#import "MakeEvaluateViewController.h"
#import "LCCKConversationViewController.h"
#import "MineChatViewController.h"
#import "SkillsDetailViewController.h"


#import "JGHTTPClient+Skill.h"

#import "MySkillDetailModel.h"

#import "DemandDetailCell.h"
#import "MySignDemandCell.h"
#import "MineHeaderCell.h"
#import "DemandStatusCell.h"
#import "DemandProgressCell.h"
#import "OrderTitleCell.h"
#import "AddressReadonlyCell.h"

#import <UIButton+AFNetworking.h>
#import "UIImageView+WebCache.h"
#import <POPSpringAnimation.h>
#import "AlertView.h"
#import "QLAlertView.h"
#import "QLHudView.h"

@interface MySkillDetailViewController () <ClickPersonDelegate>
{
    MySkillDetailModel *model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据元数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MySkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    self.tableView.estimatedRowHeight = 80;
    
    JGSVPROGRESSLOAD(@"正在加载...");
    [JGHTTPClient getMySkillDetailWithOrderNo:self.orderNo Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 200) {
            model = [MySkillDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
            
            [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:2];
        
    }];
    
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
        return model.logs.count;
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
        
        if (model.serviceMode!=2&&model.serviceMode!=1) {
            return UITableViewAutomaticDimension;
        }else{
            if (indexPath.row == 1) {
                return 0;
            }
            return UITableViewAutomaticDimension;
        }
        
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
            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",model.orderNo];
            cell.textLabel.font = FONT(15);
            cell.textLabel.textColor = LIGHTGRAYTEXT;
            cell.detailTextLabel.font = FONT(15);
            cell.detailTextLabel.textColor = [UIColor redColor];
//            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 1){
            OrderTitleCell *cell = [OrderTitleCell cellWithTableView:tableView];
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.cover]] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];
//            cell.leftConst.constant = 15;
//            cell.titleL.text = model.title;
//            cell.timeL.text = model.demandDesc;
            cell.titleL.text = model.title;
            cell.titleL.font = FONT(15);
            cell.moneyL.text = [NSString stringWithFormat:@"￥ %.2f",model.realPrice];
            cell.moneyL.textColor = [UIColor orangeColor];
            
            return cell;
        }else if (indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"购买数量";
            cell.textLabel.font = FONT(14);
            cell.textLabel.textColor = LIGHTGRAYTEXT;
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",model.skillCount];
            cell.detailTextLabel.font = FONT(18);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 3){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"订单时间";
            cell.textLabel.textColor = LIGHTGRAYTEXT;
            cell.textLabel.font = FONT(15);
            cell.detailTextLabel.font = FONT(15);
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            cell.detailTextLabel.text = model.orderTimeStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else
            return nil;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            NSString *serviceName;
            switch (model.serviceMode) {
                case 1:{
                    
                    serviceName = @"到店服务";
                    
                    break;
                } case 2:{
                    
                    serviceName = @"线上服务";
                    
                    break;
                } case 3:{
                    
                    serviceName = @"上门服务";
                    
                    break;
                } case 4:{
                    
                    serviceName = @"邮寄服务";
                    
                    break;
                }
            }
            cell.textLabel.text = [NSString stringWithFormat:@"服务方式: %@",serviceName];
            cell.textLabel.font = FONT(15);
            cell.textLabel.textColor = LIGHTGRAYTEXT;
            cell.detailTextLabel.font = FONT(15);
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 1){
            
            AddressReadonlyCell *cell = [AddressReadonlyCell cellWithTableView:tableView];
            
            cell.model = model.address;
            if (model.serviceMode!=2&&model.serviceMode!=1) {
                cell.contentView.hidden = NO;
            }else{
                cell.contentView.hidden = YES;
            }
            
            return cell;
            
        }else if (indexPath.row == 2){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"买家留言: %@",model.orderMessage.length?model.orderMessage:@"买家没有留言"];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = FONT(15);
            cell.detailTextLabel.font = FONT(15);
            cell.textLabel.textColor = LIGHTGRAYTEXT;
            cell.detailTextLabel.textColor = [UIColor redColor];
            //            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
//            line.backgroundColor = BACKCOLORGRAY;
//            [cell.contentView addSubview:line];
            
            return cell;
            
        }return nil;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            cell.textLabel.text = [NSString stringWithFormat:@"购买者信息"];
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
            cell.delegate = self;
            if (model) {
                [cell.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
                cell.nameL.text = model.nickname.length?model.nickname:@"未填写";
                cell.schoolL.text = model.schoolName.length?model.schoolName:@"未填写";
                cell.genderView.image = [UIImage imageNamed:model.sex == 2?@"boy":@"girlsex"];
            }
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
            
            cell.topView.hidden = YES;
            cell.contentL.textColor = GreenColor;
            cell.timeL.textColor = GreenColor;
            cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
        }else if (indexPath.row == self.dataArr.count-1){
            cell.bottomView.hidden = YES;
        }
        cell.model = model.logs[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 4){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        

        if (model.orderStatus == 1) {
            
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"价格调整" forState:UIControlStateNormal];
        }else if (model.orderStatus == 2){
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"服务完成" forState:UIControlStateNormal];
        }else if (model.orderStatus == 3){
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"催TA确认" forState:UIControlStateNormal];
        }else if (model.orderStatus == -2) {//只有 3 的时候才会显示两个按钮
            
//            if (model.completeStatus.integerValue == 2) {
                UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
                [leftB setTitle:@"拒绝退款" forState:UIControlStateNormal];
                leftB.layer.cornerRadius = 5;
                leftB.backgroundColor = GreenColor;
                leftB.frame = CGRectMake(20, 10, (SCREEN_W-60)/2, 40);
                [leftB addTarget:self action:@selector(clickLeftB:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:leftB];
                
                
                UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightB setTitle:@"同意退款" forState:UIControlStateNormal];
                rightB.layer.cornerRadius = 5;
                rightB.backgroundColor = GreenColor;
                rightB.frame = CGRectMake(leftB.right+20, 10, (SCREEN_W-60)/2, 40);
                [rightB addTarget:self action:@selector(clickRightB:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:rightB];
                
                
//            }else{
//                UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
//                
//                [centerB setTitle:@"确认完工" forState:UIControlStateNormal];
//                centerB.layer.cornerRadius = 5;
//                centerB.backgroundColor = GreenColor;
//                centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
//                [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:centerB];
//            }
        }else if (model.orderStatus == 4||model.orderStatus == 5){
            
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"去评价" forState:UIControlStateNormal];
            
        }
        return cell;
    }else{
        
        return nil;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 1) {
        
        SkillsDetailViewController *detailVC = [[SkillsDetailViewController alloc] init];
        
        detailVC.skillId = [NSString stringWithFormat:@"%ld",model.skillId];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)clickCenterB:(UIButton *)sender
{
    
    if ([sender.currentTitle containsString:@"调整"]) {
        [[AlertView aAlertViewCallBackBlock:^(NSString *price) {
            
            [JGHTTPClient alertSkillPriceWithOrderNo:model.orderNo changePrice:price Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }] show];
    }else if ([sender.currentTitle containsString:@"完成"]){
        [QLAlertView showAlertTittle:@"确定已经完成服务?" message:nil isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient skillExpertSureOrderCompletedWithOrderNo:model.orderNo Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }else if ([sender.currentTitle containsString:@"催"]){
        
        [QLAlertView showAlertTittle:@"确定催TA确认?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient remindToDoSkillWithOrderNo:model.orderNo type:@"2" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
        
    }else if ([sender.currentTitle containsString:@"评价"]){
        MakeEvaluateViewController *evaluateVC = [[MakeEvaluateViewController alloc] init];
        evaluateVC.type = @"2";
        evaluateVC.orderNo = model.orderNo;
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }
    
}
-(void)clickLeftB:(UIButton *)sender
{//拒绝支付
    
    if ([sender.currentTitle containsString:@"拒绝退款"]) {
        [QLAlertView showAlertTittle:@"确定拒绝退款申请?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient decideDealRefundWithOrderNo:model.orderNo type:@"2" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }
    
}

-(void)clickRightB:(UIButton *)sender
{//确认完工
    
    if ([sender.currentTitle containsString:@"同意退款"]){
        [QLAlertView showAlertTittle:@"确定同意退款?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient decideDealRefundWithOrderNo:model.orderNo type:@"1" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }
    
}

/**
 *  去个人页面
 *
 */
-(void)clickPerson:(NSString *)userId
{
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.userId = [NSString stringWithFormat:@"%ld",model.buyUid];
    [self.navigationController pushViewController:mineChatVC animated:YES];
}

-(void)callSomeOne
{
    if (model.tel.length == 0) {
        [QLHudView showAlertViewWithText:@"电话是空号" duration:1];
        return;
    }
    [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:model.tel]]];
    
}

-(void)chatSomeOne
{
    
    if (model.buyUid == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithFormat:@"%ld",model.buyUid]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
}


@end
