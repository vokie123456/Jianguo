//
//  MySignDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//


#import "MySignDetailViewController.h"
#import "DemandDetailNewViewController.h"
#import "TextReasonViewController.h"

#import "MySignDemandCell.h"
#import "DemandStatusCell.h"
#import "BillCell.h"
#import "MineHeaderCell.h"

#import "JGHTTPClient+DemandOperation.h"
#import "SignUsers.h"
#import "QLAlertView.h"
#import "QLHudView.h"
#import "LCChatKit.h"
#import <UIButton+AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "POPSpringAnimation.h"


#import "MySignDemandDetailModel.h"
#import "DemandStatusModel.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"


@interface MySignDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ClickPersonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) MySignDemandDetailModel *demandModel;
@property (nonatomic,strong) SignUsers *user;

@end

@implementation MySignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    
    self.navigationItem.title = @"报名详情页";
    self.tableView.estimatedRowHeight = 70;

//    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_r setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
//    [btn_r addTarget:self action:@selector(callSomeOne) forControlEvents:UIControlEventTouchUpInside];
//    btn_r.frame = CGRectMake(0, 0, 20, 20);
//    
//    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
//    
//    
//    UIButton * btn_r2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_r2 setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
//    [btn_r2 addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
//    btn_r2.frame = CGRectMake(0, 0, 20, 20);
//    
//    
//    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn_r2];
//    
//    self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtn];
    
    [self requestDemandDetail];
    
}
-(void)requestDemandDetail
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getMySignDemandDetailWithDemandId:self.demandId Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            self.demandModel = [MySignDemandDetailModel mj_objectWithKeyValues:responseObject[@"data"]];

            [self.tableView reloadData];
            
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}
/**
// *  电话联系
// */
//-(void)callSomeOne
//{
//    [QLAlertView showAlertTittle:@"确定呼叫发布者?" message:nil isOnlySureBtn:NO compeletBlock:^{
//        
//        [APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.demandModel.publishTel]]];
//        
//    }];
//}
///**
// *  聊天
// */
//-(void)chat
//{
//    
//    if (self.demandModel.publishUid.integerValue == USER.login_id.integerValue) {
//        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
//        return ;
//    }
//    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.demandModel.publishUid]];
//    
//    [self.navigationController pushViewController:conversationViewController animated:YES];
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            return 65;
        }else
            return 44;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            return 44;
        }else
            return 70;
        
    }else if (indexPath.section == 1){
        
        return 100;
        
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type.integerValue==5) {
        return 3;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        case 0:
            
            if (self.demandModel.limitTimeStr.length>4) {
                return 3;
            }
            return 2;
            
        case 1:
            
            return 2;
            
        case 2:
            
            return self.demandModel.logs.count;//进度显示
            
        case 3:
            
            return 1;
            
        default:
            return 0;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",self.demandModel.demandId];
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.text = self.statusStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 1){
            BillCell *cell = [BillCell cellWithTableView:tableView];
            
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.demandModel.publishHeadImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
            cell.leftConst.constant = 15;
            cell.titleL.text = self.demandModel.title;
            cell.timeL.text = self.demandModel.demandDesc;
            if ([self.demandModel.money containsString:@"."]) {
                cell.moneyL.text = [NSString stringWithFormat:@"￥ %.2f",self.demandModel.money.floatValue];
            }else{
                cell.moneyL.text = [@"￥ " stringByAppendingString:self.demandModel?self.demandModel.money:@"  "];
            }
            cell.moneyL.textColor = [UIColor orangeColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if (indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"任务时限";
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.text = self.demandModel.limitTimeStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else
            return nil;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            cell.textLabel.text = [NSString stringWithFormat:@"发布者信息"];
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
            if (self.demandModel) {
                [cell.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.demandModel.publishHeadImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
                cell.nameL.text = self.demandModel.publishNickname.length?self.demandModel.publishNickname:@"未填写";
                cell.schoolL.text = self.demandModel.publishSchoolName.length?self.demandModel.publishSchoolName:@"未填写";
                cell.genderView.image = [UIImage imageNamed:self.demandModel.publishSex.integerValue == 2?@"boy":@"girlsex"];
            }
            return cell;
        }
        
    }else if (indexPath.section == 2){
        
        DemandStatusCell *cell = [DemandStatusCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            ani.springSpeed = 30.f;
            ani.repeatCount = 5;
            ani.velocity = @1200;
            ani.springBounciness = 20;
            [cell.layer pop_addAnimation:ani forKey:nil];
            [ani setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
                if (finish) {
                    [cell.layer pop_removeAllAnimations];
                    
                }
            }];
            cell.topView.hidden = YES;
            cell.contentL.textColor = GreenColor;
            cell.timeL.textColor = GreenColor;
            cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
        }else if (indexPath.row == self.dataArr.count-1){
            cell.bottomView.hidden = YES;
        }
        cell.model = self.demandModel.logs[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 3){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        
        if (self.type.integerValue != 5) {
            
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.demandModel.status.integerValue == 1) {
                [centerB setTitle:@"取消报名" forState:UIControlStateNormal];
                if (self.demandModel.enrollStatus.integerValue == 4) {
                    centerB.hidden = YES;
                }
            }else if (self.demandModel.status.integerValue == 2){
                [centerB setTitle:@"确认完工" forState:UIControlStateNormal];
            }else if (self.demandModel.status.integerValue == 3){
                [centerB setTitle:@"催TA确认" forState:UIControlStateNormal];
            }else if (self.demandModel.status.integerValue == 4){
                if (self.demandModel.evaluateStatus.integerValue == 0) {
                    [centerB setTitle:@"去评价" forState:UIControlStateNormal];
                }else{
                    centerB.hidden = YES;
                }
            }else{
                centerB.hidden = YES;
            }
            
            [cell.contentView addSubview:centerB];
        }
        
        return cell;

        
    }else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        DemandDetailNewViewController *detailVC = [[DemandDetailNewViewController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.demandId = self.demandId;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}


-(void)callSomeOne
{
    if (self.demandModel.publishTel.length == 0) {
        [QLHudView showAlertViewWithText:@"电话是空号" duration:1];
        return;
    }
    [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.demandModel.publishTel]]];

}

-(void)chatSomeOne
{
    
    if (self.demandModel.publishUid.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.demandModel.publishUid]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
}


-(void)clickCenterB:(UIButton *)sender
{
    
    sender.userInteractionEnabled = NO;
    
    if ([sender.currentTitle containsString:@"取消报名"]) {
        
        [JGHTTPClient cancelSignWithDemandId:self.demandId Success:^(id responseObject) {
            
            sender.userInteractionEnabled = YES;
            [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
            [self changedStautsCallBack];
            if ([responseObject[@"code"] integerValue] == 200) {
                
            }
            
        } failure:^(NSError *error) {
            
            sender.userInteractionEnabled = YES;
        }];
    }else if ([sender.currentTitle containsString:@"确认完工"]){
        [JGHTTPClient sureToFinishDemandWithDemandId:self.demandId type:@"1" Success:^(id responseObject) {
            
            sender.userInteractionEnabled = YES;
            [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
            [self changedStautsCallBack];
            
        } failure:^(NSError *error) {
            
            sender.userInteractionEnabled = YES;
        }];
    }else if ([sender.currentTitle containsString:@"催TA确认"]){
        
        [JGHTTPClient remindPublisherWithDemandId:self.demandId Success:^(id responseObject) {
            
            sender.userInteractionEnabled = YES;
            [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
            [self changedStautsCallBack];
            
        } failure:^(NSError *error) {
            
            sender.userInteractionEnabled = YES;
        }];
        
    }else if ([sender.currentTitle containsString:@"评价"]){//去评价
        
        TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
        reasonVC.transitioningDelegate = self;
        reasonVC.demandId = self.demandId;
        reasonVC.userId = self.demandModel.publishUid;
        reasonVC.modalPresentationStyle = UIModalPresentationCustom;
        reasonVC.functionType = ControllerFunctionTypeWaiterEvaluate;
        IMP_BLOCK_SELF(MySignDetailViewController);
        reasonVC.callBackBlock = ^(){
            
            [block_self changedStautsCallBack];
            
        };
        sender.userInteractionEnabled = YES;
        [self presentViewController:reasonVC animated:YES completion:nil];
        
    }
}

-(void)changedStautsCallBack
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.changeStatusBlock) {
            self.changeStatusBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

@end
