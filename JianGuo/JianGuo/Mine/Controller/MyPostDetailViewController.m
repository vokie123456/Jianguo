//
//  MyPostDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyPostDetailViewController.h"
#import "DemandDetailNewViewController.h"
#import "MineChatViewController.h"
#import "SignDemandViewController.h"
#import "TextReasonViewController.h"

#import "DemandDetailCell.h"
#import "MySignDemandCell.h"
#import "MineHeaderCell.h"
#import "DemandStatusCell.h"
#import "DemandProgressCell.h"
#import "BillCell.h"

#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+DemandOperation.h"
#import "MyPostDemandDetailModel.h"
#import "DemandStatusLogModel.h"
#import "SignUsers.h"
#import "JGHTTPClient+Money.h"
#import <UIButton+AFNetworking.h>
#import "QLAlertView.h"
#import "QLHudView.h"
#import "LCChatKit.h"
#import "UIImageView+WebCache.h"
#import <POPSpringAnimation.h>

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"


@interface MyPostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ClickPersonDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *bottomCons;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) MyPostDemandDetailModel *demandModel;
@property (nonatomic,strong) SignUsers *user;
@property (nonatomic,copy) NSString *payType;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic,strong) UIButton  *telBtn;
@property (nonatomic,strong) UIButton *chatBtn;

@end

@implementation MyPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    
    self.navigationItem.title = @"任务详情";
    
    
    self.tableView.estimatedRowHeight = 80;
    
    [self requestDemandDetail];
    
//    if ([self.statusStr isEqualToString:@"报名中"]) {
//        [self.bottomBtn setTitle:@"下架此任务" forState:UIControlStateNormal];
//    }else if ([self.statusStr isEqualToString:@"待确认完工"]){
//        [self.bottomBtn setTitle:@"确认完工" forState:UIControlStateNormal];
//    }else{
//        bottomCons.constant = -40;
//        self.bottomBtn.hidden = YES;
//    }
    bottomCons.constant = -40;
    self.bottomBtn.hidden = YES;
    
}

/**
 *  电话联系
 */
//-(void)callSomeOne
//{
//    if (self.user.b_user_id.integerValue ==0) {
//        [self showAlertViewWithText:@"还没有人报名呢" duration:1];
//        return;
//    }
//    [QLAlertView showAlertTittle:@"确认呼叫服务人员?" message:nil isOnlySureBtn:NO compeletBlock:^{
//        [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.user.tel]]];
//    }];
//}
///**
// *  聊天
// */
//-(void)chat
//{
//    if (self.user.b_user_id.integerValue ==0) {
//    [self showAlertViewWithText:@"还没有人报名呢" duration:1];
//    return;
//    }
//    if (self.user.b_user_id.integerValue == USER.login_id.integerValue) {
//        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
//        return ;
//    }
//    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.user.b_user_id]];
//    
//    [self.navigationController pushViewController:conversationViewController animated:YES];
//    
//}
/**
 *  去个人页面
 *
 */
-(void)clickPerson:(NSString *)userId
{
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.userId = self.user.b_user_id;
    [self.navigationController pushViewController:mineChatVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)requestDemandDetail
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMyPostDemandDetailWithDemandId:self.demandId Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [SVProgressHUD dismiss];
            
            self.demandModel = [MyPostDemandDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            if (self.user.b_user_id.integerValue == 0) {
                self.telBtn.hidden  = YES;
                self.chatBtn.hidden = YES;
            }
            
            
            [self.tableView reloadData];
            
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.demandModel.enrollUid.integerValue==0) {
        if (section==1) {
            return 0.1;
        }else
            return 15;
    }
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
        
    }else if (indexPath.section == 3){
        
            return 100;
        
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.demandModel.status.integerValue>1) {
//        return 3;
//    }
    if (self.type.integerValue==5) {
        return 3;
    }
//    if (self.demandModel.enrollUid.integerValue == 0) {
//        return 3;
//    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        case 0:
            
            if (self.demandModel.limitTimeStr.length>4) {
                return 4;
            }
            return 3;

        case 1:
            
            if (self.demandModel.enrollUid.integerValue==0) {
                return 0;
            }
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
            
            return cell;
        }else if (indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"已报名 %@人",self.demandModel.enrollCount];
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            cell.detailTextLabel.text = @"查看报名";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 3){
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
        
        if (self.demandModel.status.integerValue<2) {
            return nil;
        }
        
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
            cell.delegate = self;
            if (self.demandModel) {
                [cell.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.demandModel.enrollHeadImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
                cell.nameL.text = self.demandModel.enrollNickname.length?self.demandModel.enrollNickname:@"未填写";
                cell.schoolL.text = self.demandModel.enrollSchoolName.length?self.demandModel.enrollSchoolName:@"未填写";
                cell.genderView.image = [UIImage imageNamed:self.demandModel.enrollSex.integerValue == 2?@"boy":@"girlsex"];
            }
            return cell;
        }
        
    }else if (indexPath.section == 2){
        
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
        cell.model = self.demandModel.logs[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 3){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        
        
        if (self.demandModel.status.integerValue == 1) {
            
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"下架任务" forState:UIControlStateNormal];
        }else if (self.demandModel.status.integerValue == 2){
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"催TA干活" forState:UIControlStateNormal];
        }else if (self.demandModel.status.integerValue == 3) {//只有 3 的时候才会显示两个按钮
                
                if (self.demandModel.completeStatus.integerValue == 2) {
                    UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
                    [leftB setTitle:@"拒绝支付" forState:UIControlStateNormal];
                    leftB.layer.cornerRadius = 5;
                    leftB.backgroundColor = GreenColor;
                    leftB.frame = CGRectMake(20, 10, (SCREEN_W-60)/2, 40);
                    [leftB addTarget:self action:@selector(clickLeftB:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:leftB];
                    
                    
                    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
                    [rightB setTitle:@"确认完工" forState:UIControlStateNormal];
                    rightB.layer.cornerRadius = 5;
                    rightB.backgroundColor = GreenColor;
                    rightB.frame = CGRectMake(leftB.right+20, 10, (SCREEN_W-60)/2, 40);
                    [rightB addTarget:self action:@selector(clickRightB:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:rightB];

                
            }else{
                UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [centerB setTitle:@"确认完工" forState:UIControlStateNormal];
                centerB.layer.cornerRadius = 5;
                centerB.backgroundColor = GreenColor;
                centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
                [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:centerB];
            }
        }else if (self.demandModel.status.integerValue == 4){
            
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            [centerB setTitle:@"去评价" forState:UIControlStateNormal];
            
            if (self.demandModel.evaluateStatus.integerValue == 1) {
                centerB.hidden = YES;
            }else{
                centerB.hidden = NO;
            }
            
        }else{
            
            UIButton *centerB = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerB.layer.cornerRadius = 5;
            centerB.backgroundColor = GreenColor;
            centerB.frame = CGRectMake(20, 10, SCREEN_W-40, 40);
            [centerB addTarget:self action:@selector(clickCenterB:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:centerB];
            centerB.hidden = YES;
        }
        
        
        return cell;
        
    }else
        return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        
        if (indexPath.row == 2) {
            SignDemandViewController *usersVC = [[SignDemandViewController alloc] init];
            usersVC.demandId = self.demandId;
            usersVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:usersVC animated:YES];
        }else if (indexPath.row == 1){
            DemandDetailNewViewController *detailVC = [[DemandDetailNewViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;

            detailVC.demandId = self.demandId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }else if (indexPath.section == 1) {
        
        MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
        mineChatVC.userId = self.demandModel.enrollUid;
        [self.navigationController pushViewController:mineChatVC animated:YES];
        
    }
}

-(void)callSomeOne
{
    if (self.demandModel.enrollTel.length == 0) {
        [QLHudView showAlertViewWithText:@"电话是空号" duration:1];
        return;
    }
    [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.demandModel.enrollTel]]];
}

-(void)chatSomeOne
{
    
    if (self.demandModel.enrollUid.integerValue == USER.login_id.integerValue) {
            [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
            return ;
        }
        LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.demandModel.enrollUid]];
    
        [self.navigationController pushViewController:conversationViewController animated:YES];
    
}

-(void)clickLeftB:(UIButton *)sender
{//拒绝支付
    
    TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
    reasonVC.transitioningDelegate = self;
    reasonVC.demandId = self.demandId;
    reasonVC.userId = self.demandModel.enrollUid;
    reasonVC.modalPresentationStyle = UIModalPresentationCustom;
    reasonVC.functionType = ControllerFunctionTypeRefusePay;
    IMP_BLOCK_SELF(MyPostDetailViewController);
    reasonVC.callBackBlock = ^(){
        
        [block_self changedStautsCallBack];
        
    };
    [self presentViewController:reasonVC animated:YES completion:nil];
    
}

-(void)clickRightB:(UIButton *)sender
{//确认完工
    
    sender.userInteractionEnabled = NO;
    [JGHTTPClient sureToFinishDemandWithDemandId:self.demandId type:@"2" Success:^(id responseObject) {
        
        sender.userInteractionEnabled = YES;
        [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
        [self changedStautsCallBack];
        
    } failure:^(NSError *error) {
        
        sender.userInteractionEnabled = YES;
    }];
    
}

-(void)clickCenterB:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    if ([sender.currentTitle containsString:@"下架"]) {
        [JGHTTPClient offDemandWithDemandId:self.demandId reason:nil money:nil Success:^(id responseObject) {
            
            sender.userInteractionEnabled = YES;
            [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
            [self changedStautsCallBack];
            
        } failure:^(NSError *error) {
            sender.userInteractionEnabled = YES;
            
        }];
    }else if ([sender.currentTitle containsString:@"催TA干活"]){
        [JGHTTPClient remindUserWithDemandId:self.demandId Success:^(id responseObject) {
            
            sender.userInteractionEnabled = YES;
            [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
            
            [self changedStautsCallBack];
            
        } failure:^(NSError *error) {
            
            sender.userInteractionEnabled = YES;
        }];
    }else if ([sender.currentTitle containsString:@"确认完工"]){
        
        [JGHTTPClient sureToFinishDemandWithDemandId:self.demandId type:@"2" Success:^(id responseObject) {
            
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
        reasonVC.userId = self.demandModel.enrollUid;
        reasonVC.modalPresentationStyle = UIModalPresentationCustom;
        reasonVC.functionType = ControllerFunctionTypePublisherEvualuate;
        IMP_BLOCK_SELF(MyPostDetailViewController);
        reasonVC.callBackBlock = ^(){
            
            [block_self changedStautsCallBack];
            
        };
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
