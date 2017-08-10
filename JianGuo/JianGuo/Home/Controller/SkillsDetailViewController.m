//
//  SkillsDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/7/27.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillsDetailViewController.h"
#import "PlaceOrderViewController.h"
#import "ConsumerEvaluatesViewController.h"

#import "CommentModel.h"
#import "DemandDetailModel.h"

#import "DemandDetailImageCell.h"
#import "DDTitleCell.h"
#import "DDScanCountCell.h"
#import "DDUserInfoCell.h"
#import "CommentCell.h"

#import "StarView.h"

#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"

@interface SkillsDetailViewController () <UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *buyB;
@property (weak, nonatomic) IBOutlet UITabBarItem *likeItem;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UIButton *followHeaderB;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *saleCountL;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;
@property (weak, nonatomic) IBOutlet StarView *starView;


/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SkillsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"技能详情";
    
    self.tabBar.delegate = self;
    self.starView.score = 4.6;
    self.tableView.estimatedRowHeight = 100;
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_r setTitle:@"<#名字#>" forState:UIControlStateNormal];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(collectionSkill:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 16, 16);
    
    UIButton * btn_r2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn_r setTitle:@"<#名字#>" forState:UIControlStateNormal];
    [btn_r2 setBackgroundImage:[UIImage imageNamed:@"demandshare"] forState:UIControlStateNormal];
    [btn_r2 addTarget:self action:@selector(shareSkill:) forControlEvents:UIControlEventTouchUpInside];
    btn_r2.frame = CGRectMake(0, 0, 16, 15);
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn_r2];
    UIBarButtonItem *rightBtnMiddle = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)]];
    
    self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtnMiddle,rightBtn1];
    
}

-(void)collectionSkill:(UIButton *)sender
{//收藏
    
}

-(void)shareSkill:(UIButton *)sender
{//分享
    
}

- (IBAction)checkEvaluates:(UIButton *)sender {
    
    ConsumerEvaluatesViewController *consumerVC = [[ConsumerEvaluatesViewController alloc] init];
    consumerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:consumerVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==2?60:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
        headerView.backgroundColor = BACKCOLORGRAY;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_W, 45)];
        view.backgroundColor = WHITECOLOR;
        
        UIImageView *commentView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 21, 21)];
        commentView.image = [UIImage imageNamed:@"msessage"];
        
        UILabel *commentCountL = [[UILabel alloc] initWithFrame:CGRectMake(commentView.right+10, 0, 100, 43)];
        commentCountL.textColor = LIGHTGRAYTEXT;
        commentCountL.font = FONT(15);
//        commentCountL.text = detailModel.commentCount;
        
        [view addSubview:commentView];
        [view addSubview:commentCountL];
        
        [headerView addSubview:view];
        
        return headerView;
        
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0||indexPath.row == 3||indexPath.row == 5||indexPath.row == 6) {
            return UITableViewAutomaticDimension;
        }else if (indexPath.row == 7){
            return 44;
        }else{
            return 250;
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 8;
    }else if (section == 1){
        return 1;
    }else if (section==2){
        return 10;
    }else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0||indexPath.row == 3||indexPath.row == 5||indexPath.row == 6) {
            DDTitleCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDTitleCell class]) owner:nil options:nil].lastObject;
            cell.typeL.hidden = YES;
            if (indexPath.row == 5) {
                cell.lineView.hidden = NO;
            }
            cell.titleL.text = @"服务详情";
            cell.contentL.text = @"换屏幕,换电池,贴膜,恢复数据,解决各种卡机问题";
            return cell;
        }else if (indexPath.row == 7){
            DDScanCountCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDScanCountCell class]) owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            DemandDetailImageCell *cell = [DemandDetailImageCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.images[indexPath.row-1]] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];
            return cell;
        }
    }else if (indexPath.section == 1){
        DDUserInfoCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDUserInfoCell class]) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DemandDetailModel *model = [[DemandDetailModel alloc] init];
        model.schoolName = @"中国人民大学";
        model.authStatus = @"1";
        model.nickname = @"Mr.weather";
        model.publishDemandCount = @"300";
        model.completedDemandCount = @"50";
        model.sex = @"1";
        cell.detailModel = model;
        
        return cell;
    }else{
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
//        cell.delegate = self;
//        CommentModel *model = self.commentAll[indexPath.row];
//        
//        cell.model = model;
        CommentModel *model = [[CommentModel alloc] init];
        model.content = @"是肯定和反馈说的话";
        cell.model = model;
        
        return cell;
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{//tag: 100==果聊;101==评论;102==点赞
    
}
- (IBAction)buy:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"小果果建议您在购买技能之前与卖家通过果聊沟通好服务时间,以确保服务顺利完成哦!" preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"果聊TA" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {//去果聊
        
    }];
    UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"直接购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//跳到购买页面
        
        PlaceOrderViewController *orderVC = [[PlaceOrderViewController alloc] init];
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }];
    [alertVC addAction:cancelAC];
    [alertVC addAction:sureAC];
        
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


@end
