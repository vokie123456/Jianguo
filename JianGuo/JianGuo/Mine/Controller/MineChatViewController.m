//
//  MineChatViewController.m
//  JianGuo
//
//  Created by apple on 17/6/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineChatViewController.h"
#import "EditProfileViewController.h"
#import "DemandDetailNewViewController.h"
#import "FunsFollowViewController.h"
#import "LCCKConversationViewController.h"
#import "SkillsDetailViewController.h"

#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+Mine.h"
#import "JGHTTPClient+Skill.h"


#import "DemandListCell.h"
#import "EvaluateCell.h"
#import "SkillsCell.h"

#import "DemandModel.h"
#import "EvaluateModel.h"
#import "UserInfoModel.h"
#import "SkillListModel.h"

#import "DateOrTimeTool.h"
#import "UIImageView+WebCache.h"
#import "XLPhotoBrowser.h"

@interface MineChatViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger dataSourceCount;//1==任务;2==评价;3==技能
    __weak IBOutlet NSLayoutConstraint *toolBarHeightCons;
    NSInteger pageCount;
    UserInfoModel *userModel;
    __weak IBOutlet NSLayoutConstraint *lineLeftCons;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UIButton *birthDateB;
@property (weak, nonatomic) IBOutlet UILabel *starL;
@property (weak, nonatomic) IBOutlet UIButton *followB;
@property (weak, nonatomic) IBOutlet UIButton *funsB;
@property (weak, nonatomic) IBOutlet UILabel *introduceL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIButton *evaluateB;
@property (weak, nonatomic) IBOutlet UIButton *demandB;
@property (weak, nonatomic) IBOutlet UIButton *skillB;
@property (weak, nonatomic) IBOutlet UIButton *followUserB;

@property (weak, nonatomic) IBOutlet UIButton *editB;
@property (weak, nonatomic) IBOutlet UIButton *backB;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MineChatViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;//这个页面出现时隐藏了导航条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.editB];
    [self.view bringSubviewToFront:self.backB];
    
    dataSourceCount = 3;
    
    if (self.userId.integerValue == USER.login_id.integerValue) {
        toolBarHeightCons.constant = 0;
    }else{
        self.editB.hidden = YES;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showIcon)];
    [self.iconView addGestureRecognizer:tap];
    
    [self requestUserInfo];
    
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (dataSourceCount == 1) {
        [self requestDemandsWithCount:@"1"];
    }else if (dataSourceCount == 2){
        [self requestEvaluatesWithCount:@"1"];
    }else if (dataSourceCount == 3){
        [self requestSkillsWithCount:@"1"];
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        
        [self requestUserInfo];
        if (dataSourceCount == 1) {
            [self requestDemandsWithCount:@"1"];
        }else if (dataSourceCount == 2){
            [self requestEvaluatesWithCount:@"1"];
        }else if (dataSourceCount == 3){
            [self requestSkillsWithCount:@"1"];
        }
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
        if (dataSourceCount == 1) {
            [self requestDemandsWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        }else if (dataSourceCount == 2){
            [self requestEvaluatesWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        }else if (dataSourceCount == 3){
            [self requestSkillsWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        }
        
    }];
    
}

-(void)showIcon
{
    [XLPhotoBrowser showPhotoBrowserWithImages:@[[NSURL URLWithString:userModel.headImg]] currentImageIndex:0];
}

-(void)requestUserInfo
{
    
    [JGHTTPClient getUserInfoWithUserId:self.userId Success:^(id responseObject) {
        
        userModel = [UserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",userModel.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
        self.nameL.text = userModel.nickname.length?userModel.nickname:@"未填写姓名";
        [self.birthDateB setTitle:[userModel.birthDate.length?userModel.birthDate:@"1998-01-01" substringFromIndex:5] forState:UIControlStateNormal];
        
        [self.birthDateB setImage:[UIImage imageNamed:userModel.sex.integerValue == 1?@"girl_mine":@"boy_mine"] forState:UIControlStateNormal];
        [self.birthDateB setBackgroundColor:userModel.sex.integerValue == 1?RedColor:RGBCOLOR(114, 170, 249)];
        self.starL.text = [DateOrTimeTool getConstellation:userModel.birthDate.length?userModel.birthDate:@"1998-01-01"];
        self.schoolL.text = userModel.schoolName.length?userModel.schoolName:@"未填写学校信息";
        if (userModel.userId.integerValue == USER.login_id.integerValue) {
            [self.followB setTitle:[NSString stringWithFormat:@"我的关注%@",userModel.followNum] forState:UIControlStateNormal];
            [self.funsB setTitle:[NSString stringWithFormat:@"我的粉丝%@",userModel.fansNum] forState:UIControlStateNormal];
        }else{
            [self.followB setTitle:[NSString stringWithFormat:@"TA的关注%@",userModel.followNum] forState:UIControlStateNormal];
            [self.funsB setTitle:[NSString stringWithFormat:@"TA的粉丝%@",userModel.fansNum] forState:UIControlStateNormal];
        }
        self.introduceL.text = [NSString stringWithFormat:@"简介 :%@",userModel.introduce];
        
        if (userModel.isFollow.boolValue) {
            [self.followUserB setTitle:@"已关注" forState:UIControlStateNormal];
            [self.followUserB setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
            self.followUserB.userInteractionEnabled = NO;
        }
        [self.demandB setTitle:[NSString stringWithFormat:@"任务%@",userModel.demandNum] forState:UIControlStateNormal];
        [self.evaluateB setTitle:[NSString stringWithFormat:@"评价%@",userModel.demandEvaluateNum] forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
        
    }];
}

-(void)requestDemandsWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getDemandListWithSchoolId:nil
                                   cityCode:nil keywords:nil orderBy:nil type:nil sex:nil userId:self.userId pageCount:count Success:^(id responseObject) {
                                       //        [SVProgressHUD dismiss];
                                       //        JGLog(@"%@",responseObject);
                                       //        self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                       //        [self.tableView reloadData];
                                       
                                       [SVProgressHUD dismiss];
                                       [self.tableView.mj_header endRefreshing];
                                       [self.tableView.mj_footer endRefreshing];
                                       JGLog(@"%@",responseObject);
                                       
                                       if (count.integerValue>1) {//上拉加载
                                           
                                           if ([[DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                                               [self showAlertViewWithText:@"没有更多数据" duration:1];
                                               return ;
                                           }
                                           
                                           
                                           NSMutableArray *indexPaths = [NSMutableArray array];
                                           for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                                               [self.dataArr addObject:model];
                                               NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                                               [indexPaths addObject:indexPath];
                                           }
                                           
                                           
                                           [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                                           /*
                                            NSMutableArray *sections = [NSMutableArray array];
                                            for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                                            [self.dataArr addObject:model];
                                            NSIndexSet* section = [NSIndexSet indexSetWithIndex:self.dataArr.count-1];
                                            [sections addObject:section];
                                            }
                                            [_tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArr.count-sections.count, sections.count)] withRowAnimation:UITableViewRowAnimationFade];
                                            */
                                           return;
                                           
                                       }else{
                                           self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                           //            if (self.dataArr.count == 0) {
                                           //                bgView.hidden = NO;
                                           //            }else{
                                           //                bgView.hidden = YES;
                                           //            }
                                       }
                                       
                                       [self.tableView reloadData];
                                       if ([DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
                                           [self showAlertViewWithText:@"没有更多数据" duration:1];
                                           return ;
                                       }
                                       
                                   } failure:^(NSError *error) {
                                       [SVProgressHUD dismiss];
                                       [self.tableView.mj_header endRefreshing];
                                       [self.tableView.mj_footer endRefreshing];
                                       [self showAlertViewWithText:NETERROETEXT duration:1];
                                       
                                   }];
}

-(void)requestEvaluatesWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getEvaluatesWithUserId:self.userId pageNum:count Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[EvaluateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (EvaluateModel *model in [EvaluateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            /*
             NSMutableArray *sections = [NSMutableArray array];
             for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
             [self.dataArr addObject:model];
             NSIndexSet* section = [NSIndexSet indexSetWithIndex:self.dataArr.count-1];
             [sections addObject:section];
             }
             [_tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArr.count-sections.count, sections.count)] withRowAnimation:UITableViewRowAnimationFade];
             */
            return;
            
        }else{
            self.dataArr = [EvaluateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            //            if (self.dataArr.count == 0) {
            //                bgView.hidden = NO;
            //            }else{
            //                bgView.hidden = YES;
            //            }
        }
        
        [self.tableView reloadData];
        if ([EvaluateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
            [self showAlertViewWithText:@"没有更多数据" duration:1];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)requestSkillsWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getSkillListWithSchoolId:nil cityCode:nil keywords:nil orderBy:nil type:nil sex:nil userId:self.userId pageCount:count Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (SkillListModel *model in [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            return;
            
        }else{
            self.dataArr = [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            [self.tableView reloadData];
            if ([SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSourceCount == 3){
        return 335;
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSourceCount == 1) {
        DemandListCell *cell = [DemandListCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DemandModel *model = self.dataArr[indexPath.row];
        
        cell.model = model;
        return cell;
        
    }else if(dataSourceCount == 2){
        EvaluateCell *cell = [EvaluateCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        EvaluateModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        return cell;
    }else{
        SkillsCell *cell = [SkillsCell cellWithTableView:tableView];
        cell.model = self.dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[DemandListCell class]]) {//点击任务
        
        DemandDetailNewViewController *detailVC = [DemandDetailNewViewController new];
        if (self.dataArr.count>indexPath.row) {
            detailVC.demandId = [(DemandModel *)self.dataArr[indexPath.row] demandId];
        }
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([cell isKindOfClass:[EvaluateCell class]]){//点击评价
        
        DemandDetailNewViewController *detailVC = [DemandDetailNewViewController new];
        if (self.dataArr.count>indexPath.row) {
            EvaluateModel *model = self.dataArr[indexPath.row];
            detailVC.demandId = model.demandId;
        }
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([cell isKindOfClass:[SkillsCell class]]){//点击评价
        
        SkillsDetailViewController *detailVC = [SkillsDetailViewController new];
        if (self.dataArr.count>indexPath.row) {
            SkillListModel *model = self.dataArr[indexPath.row];
            detailVC.skillId = [NSString stringWithFormat:@"%ld",model.skillId];
        }
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}
- (IBAction)clickSkill:(UIButton *)sender {
    
    dataSourceCount = 3;//技能
    lineLeftCons.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.segmentView layoutIfNeeded];
    }];
    
    [self requestSkillsWithCount:@"1"];
    
}

- (IBAction)clickDemand:(id)sender {
    
    dataSourceCount = 1;//任务
    lineLeftCons.constant = SCREEN_W/3;
    [UIView animateWithDuration:0.3 animations:^{
        [self.segmentView layoutIfNeeded];
    }];
    [self requestDemandsWithCount:@"1"];
    
}
- (IBAction)clickEvaluate:(id)sender {
    
    dataSourceCount = 2;//评价
    lineLeftCons.constant = SCREEN_W*2/3;
    [UIView animateWithDuration:0.3 animations:^{
        [self.segmentView layoutIfNeeded];
    }];
    [self requestEvaluatesWithCount:@"1"];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)editProfile:(id)sender {
    
    EditProfileViewController *editVC = [[EditProfileViewController alloc] init];
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (IBAction)follows:(id)sender {
    
    FunsFollowViewController *funsVC = [[FunsFollowViewController alloc] init];
    funsVC.hidesBottomBarWhenPushed = YES;
    funsVC.userId = self.userId;
    [self.navigationController pushViewController:funsVC animated:YES];
    
}
- (IBAction)funs:(id)sender {
    
    FunsFollowViewController *funsVC = [[FunsFollowViewController alloc] init];
    funsVC.hidesBottomBarWhenPushed = YES;
    funsVC.userId = self.userId;
    [self.navigationController pushViewController:funsVC animated:YES];
    
}

- (IBAction)followUser:(id)sender {
    
    UIButton *btn = sender;
    [JGHTTPClient followUserWithUserId:self.userId status:@"1" Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            [btn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)chat:(id)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    if (USER.resume.intValue == 0){
        [self showAlertViewWithText:@"请您先去完善资料" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoProfileVC];
        });
        return;
    }
    if (self.userId.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.userId]];

    [self.navigationController pushViewController:conversationViewController animated:YES];
    
}

-(UIImage *)imageWithBgColor:(UIColor *)color {//用颜色生成一个image对象
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


@end
