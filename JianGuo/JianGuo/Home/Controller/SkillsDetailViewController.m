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
#import "LCCKConversationViewController.h"
#import "MineChatViewController.h"

#import "JGHTTPClient+Skill.h"
#import "JGHTTPClient+Demand.h"

#import "CommentModel.h"
#import "SkillDetailModel.h"

#import "DemandDetailImageCell.h"
#import "DDTitleCell.h"
#import "DDScanCountCell.h"
#import "DDUserInfoCell.h"
#import "CommentCell.h"

#import "StarView.h"
#import "ShareView.h"
#import "CommentInputView.h"
#import "UITextView+placeholder.h"
#import <IQKeyboardManager.h>

#import "XLPhotoBrowser.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"


@interface SkillsDetailViewController () <UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,CommentCellDelegate,FinishEditDelegate,XLPhotoBrowserDelegate,XLPhotoBrowserDatasource>
{
    SkillDetailModel *detailModel;
    BOOL firstImage;
    BOOL secondImage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *buyB;
@property (weak, nonatomic) IBOutlet UITabBarItem *likeItem;
@property (nonatomic,strong) CommentInputView *commentView;
@property (nonatomic,strong) UITextView *commentTV;

@property (nonatomic,strong) NSMutableArray *imagesArr;
@property (nonatomic,strong) NSMutableArray *commentArr;
@property (nonatomic,strong) NSMutableArray *commentAll;
@property (nonatomic,strong) NSMutableDictionary *imageHeightDic;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UIButton *followHeaderB;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *saleCountL;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *skillTitleL;
@property (weak, nonatomic) IBOutlet UILabel *labelL;
@property (nonatomic,strong) UIButton *collectionB;

@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *toUserId;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SkillsDetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)viewDidLayoutSubviews
{
    self.commentView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_W, 45);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.hidden = YES;
    
    self.imageHeightDic = @{}.mutableCopy;
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.commentAll = @[].mutableCopy;
    
    self.navigationItem.title = @"技能详情";
    
    self.tabBar.delegate = self;

    self.tableView.estimatedRowHeight = 100;
    
    [self setNavigationBarItem];
    
    [self customCommentKeyboard];
    
    [self requestDetail];
    IMP_BLOCK_SELF(SkillsDetailViewController);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        __block NSInteger blockPageCount = ((int)block_self.commentArr.count/10) + ((int)(block_self.commentArr.count/10)>=1?1:2) + ((block_self.commentArr.count%10)>0&&block_self.commentArr.count>10?1:0);
        [block_self requestWithCount:[NSString stringWithFormat:@"%ld",(long)blockPageCount]];
    }];
    [self requestWithCount:@"1"];
    
//    [self gotImageToRefreshCellHeight];
}

-(void)gotImageToRefreshCellHeight
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (detailModel.descImages.count>1) {
            if (firstImage && secondImage) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self gotImageToRefreshCellHeight];
            }
        }else{
            if (detailModel.descImages.count==1) {
                if (firstImage) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [self gotImageToRefreshCellHeight];
                }
            }else{
                return ;
            }
        }
    });
}

-(void)setNavigationBarItem
{
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_r setBackgroundImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(collectionSkill:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 18, 18);
    self.collectionB = btn_r;
    
    UIButton * btn_r2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r2 setBackgroundImage:[UIImage imageNamed:@"demandshare"] forState:UIControlStateNormal];
    [btn_r2 addTarget:self action:@selector(shareSkill:) forControlEvents:UIControlEventTouchUpInside];
    btn_r2.frame = CGRectMake(0, 0, 16, 15);
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn_r2];
    UIBarButtonItem *rightBtnMiddle = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)]];
    
    self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtnMiddle,rightBtn1];
    
    
}

//添加输入框
-(void)customCommentKeyboard
{
    CommentInputView *view = [CommentInputView aReplyCommentView:nil];
    view.delegate = self;
    self.commentView = view;
    self.commentTV = view.commentTV;
    view.commentTV.placeholder = @"请输入文字";
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

-(void)requestWithCount:(NSString *)count
{
    
    [JGHTTPClient getSkillCommentsListWithPageNum:count skillId:self.skillId Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            NSMutableArray *addArr = @[].mutableCopy;
            [self.commentArr addObjectsFromArray:[CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            for (CommentModel *model in [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.commentAll addObject:model];
                [self.commentAll addObjectsFromArray:model.childComments];
                [addArr addObject:model];
                [addArr addObjectsFromArray:model.childComments];
            }
            
            [self.tableView reloadData];
            
            
            return;
            
        }else{
            self.commentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.commentAll removeAllObjects];
            for (CommentModel *model in self.commentArr) {
                [self.commentAll addObject:model];
                [self.commentAll addObjectsFromArray:model.childComments];
            }
            [self.tableView reloadData];
            return;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}

-(void)requestDetail
{
    
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getSkillDetailsWithSkillId:self.skillId  userId:nil Success:^(id responseObject) {
        JGLog(@"%@",responseObject);
        
        self.tableView.hidden = NO;
        if ([responseObject[@"code"] integerValue] ==200) {
            detailModel = [SkillDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",detailModel.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
            self.nameL.text = detailModel.nickname.length?detailModel.nickname:@"未填写";
            self.schoolL.text = [NSString stringWithFormat:@"发布在 %@",detailModel.publishSchoolName.length?detailModel.publishSchoolName:detailModel.publishCityName];
            self.saleCountL.text = [NSString stringWithFormat:@"已售 %ld 次",(long)detailModel.saleCount];
            if ([detailModel.price containsString:@"."]) {
                self.moneyL.text = [NSString stringWithFormat:@"%.2f元",detailModel.price.floatValue];
            }else{
                self.moneyL.text = [NSString stringWithFormat:@"%@元",detailModel.price];
            }
            self.scoreL.text = [NSString stringWithFormat:@"%.1f分",detailModel.averageScore];
            
            self.starView.score = detailModel.averageScore;
            self.skillTitleL.text = detailModel.title;
            self.labelL.text = detailModel.masterTitle.length?[[@" " stringByAppendingString:detailModel.masterTitle] stringByAppendingString:@" "]:nil;
            if (detailModel.isFavourite) {
                [self.collectionB setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
            }
            if (detailModel.isLike) {
                self.likeItem.image = [UIImage imageNamed:@"xin"];
                self.likeItem.selectedImage = [UIImage imageNamed:@"xin"];
            }
            if (detailModel.isFollow) {
                self.followHeaderB.hidden = YES;
            }
            if (detailModel.status) {
                
                self.buyB.userInteractionEnabled = NO;
                [self.buyB setTitle:@"暂停接单" forState:UIControlStateNormal];
                [self.buyB setBackgroundColor:LIGHTGRAY1];
                
            }
            /*
            if (detailModel.demandStatus.integerValue==1) {
                
                
                if (detailModel.enrollStatus.integerValue!=0) {
                    [self.signButton setTitle:@"已报名" forState:UIControlStateNormal];
                    self.signButton.userInteractionEnabled = NO;
                    [self.signButton setBackgroundColor:LIGHTGRAY1];
                }
                
            }else{
                
                [self.signButton setTitle:@"已完成" forState:UIControlStateNormal];
                self.signButton.userInteractionEnabled = NO;
                [self.signButton setBackgroundColor:LIGHTGRAY1];
            }
            
            self.likeView.image = [UIImage imageNamed:detailModel.isLike.integerValue == 1?@"xin":@"fabulous"];
            
            
            if (detailModel.limitTime.integerValue == 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.headerView layoutIfNeeded];
                    timeLimitViewCons.constant = 0;
                    self.headerView.height = 115-44;
                }];
            }
            */
            [self.tableView reloadData];
            
        }else if ([responseObject[@"code"] integerValue] == 600){
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1.5];
    }];
}

-(void)collectionSkill:(UIButton *)sender
{//收藏
    
    if (USER.login_id.integerValue<1) {
        [self gotoCodeVC];
        return;
    }
    NSString *status;
    if (detailModel.isFavourite) {
        status = @"0";
    }else{
        status = @"1";
    }
    sender.userInteractionEnabled = NO;
    [JGHTTPClient collectionSkillById:[NSString stringWithFormat:@"%ld",detailModel.skillId] status:status Success:^(id responseObject) {
        
        sender.userInteractionEnabled = YES;
        if ([responseObject[@"code"] integerValue] == 200) {
            detailModel.isFavourite = status.integerValue;
            
            if (self.callBack) {
                self.callBack(status.integerValue);
            }
            
            if (detailModel.isFavourite) {
                
                [sender setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
                   
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1.5f];
        sender.userInteractionEnabled = YES;
    }];
    
}

-(void)shareSkill:(UIButton *)sender
{//分享
    
    [APPLICATION.keyWindow endEditing:YES];
    ShareView *shareView = [ShareView aShareView];
    shareView.skillModel = detailModel;
    [shareView show];
    
}

- (IBAction)follow:(UIButton *)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    //1==关注 , 0==取消
    NSString *userId = [NSString stringWithFormat:@"%ld",detailModel.publishUid];
    
    [JGHTTPClient followUserWithUserId:userId status:@"1" Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showAlertViewWithText:@"关注成功" duration:1];
            [sender setHidden:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

//点击发送按钮
-(void)finishEdit
{
    [self.commentTV resignFirstResponder];
    JGSVPROGRESSLOAD(@"正在请求...");
    [JGHTTPClient postAcommentWithSkillId:self.skillId content:self.commentTV.text pid:self.pid toUserId:self.toUserId Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self requestWithCount:@"1"];
            
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1.f];
        
    }];
    
    self.commentTV.text = nil;
    self.commentTV.placeholder = @"请输入文字";
}


- (IBAction)checkEvaluates:(UIButton *)sender {
    
    ConsumerEvaluatesViewController *consumerVC = [[ConsumerEvaluatesViewController alloc] init];
    consumerVC.hidesBottomBarWhenPushed = YES;
    consumerVC.skillId = self.skillId;
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
        commentCountL.text = [NSString stringWithFormat:@"%ld",detailModel.commentCount];
        
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
        if (indexPath.row == 0||indexPath.row == detailModel.descImages.count+1||indexPath.row == 3+detailModel.aptitudeImages.count+detailModel.descImages.count||indexPath.row == 2+detailModel.aptitudeImages.count+detailModel.descImages.count) {
            return UITableViewAutomaticDimension;
        }else if (indexPath.row == 4+detailModel.aptitudeImages.count+detailModel.descImages.count){
            return 44;
        }else{
//            if ([[NSString stringWithFormat:@"%@",[self.imageHeightDic allKeys]] containsString:[NSString stringWithFormat:@"%@",indexPath]] ) {
//                return [[self.imageHeightDic valueForKey:[NSString stringWithFormat:@"%@",indexPath]] floatValue];
//            }
            return UITableViewAutomaticDimension;
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
        return 5+detailModel.aptitudeImages.count+detailModel.descImages.count;
    }else if (section == 1){
        return 1;
    }else if (section==2){
        return self.commentAll.count;
    }else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0||indexPath.row == 1+detailModel.descImages.count||indexPath.row == 2+detailModel.aptitudeImages.count+detailModel.descImages.count||indexPath.row == 3+detailModel.aptitudeImages.count+detailModel.descImages.count) {
            DDTitleCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDTitleCell class]) owner:nil options:nil].lastObject;
            cell.typeL.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == detailModel.descImages.count+1) {
                cell.lineView.hidden = NO;
            }
            if (indexPath.row == 0) {
                cell.titleL.text = @"服务详情";
                cell.contentL.text = detailModel.skillDesc;
                if (detailModel.descImages.count == 0) {
                    cell.lineView.hidden = NO;
                }
            }else if (indexPath.row == 1+detailModel.descImages.count){
                cell.titleL.text = @"技能资质";
                cell.contentL.text = detailModel.skillAptitude;
            }else if (indexPath.row == 2+detailModel.aptitudeImages.count+detailModel.descImages.count){
                cell.titleL.text = @"价格说明";
                cell.contentL.text = detailModel.priceDesc;
                cell.lineView.hidden = NO;
            }else if (indexPath.row == 3+detailModel.aptitudeImages.count+detailModel.descImages.count){
                
                NSString *serviceName;
                switch (detailModel.serviceMode) {
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
                cell.titleL.text = [@"服务方式: " stringByAppendingString:serviceName?serviceName:@""];
                if (detailModel.serviceMode!=2) {
                    cell.contentL.text = [NSString stringWithFormat:@"联系地址:%@",detailModel.serviceAddress];
                }else{
                    cell.contentL.text = nil;
                }
            }
            return cell;
            
        }else if (indexPath.row == 4+detailModel.aptitudeImages.count+detailModel.descImages.count){
            DDScanCountCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDScanCountCell class]) owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.scanL.text = [NSString stringWithFormat:@"%ld",detailModel.viewCount];
            cell.likeL.text = [NSString stringWithFormat:@"%ld",detailModel.likeCount];
            return cell;
        }else{
            DemandDetailImageCell *cell = [DemandDetailImageCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row<=detailModel.descImages.count) {
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.descImages[indexPath.row-1]] placeholderImage:[UIImage imageNamed:@"placeholderPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    cell.iconViewHeightCons.constant = (SCREEN_W-40)*image.size.height/image.size.width;
                    
                    
                    NSString *url = [NSString stringWithFormat:@"%@",imageURL];
                    
                    NSInteger index = [detailModel.descImages indexOfObject:url];
                    
                    DemandDetailImageCell *cell_ = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
                    
                    if (cell_.iconView.height == 240) {
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }

                }];
            }else{
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.aptitudeImages[indexPath.row-detailModel.descImages.count-2]] placeholderImage:[UIImage imageNamed:@"placeholderPic"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    
                    cell.iconViewHeightCons.constant = (SCREEN_W-40)*image.size.height/image.size.width;
                    
                    NSString *url = [NSString stringWithFormat:@"%@",imageURL];
                    
                    NSInteger index = [detailModel.aptitudeImages indexOfObject:url];
                    
                    DemandDetailImageCell *cell_ = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+2+detailModel.descImages.count inSection:0]];
                    
                    if (cell_.iconView.height == 240) {
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                }];
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        DDUserInfoCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDUserInfoCell class]) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.skillDetailM = detailModel;
        if (detailModel.isFollow) {
            cell.followB.hidden = YES;
        }
        
        return cell;
    }else{
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
        cell.delegate = self;
        CommentModel *model = self.commentAll[indexPath.row];
        cell.model = model;
        
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row>0&&indexPath.row<=detailModel.descImages.count) {
        
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.tag = 100;
        browser.datasource = self;
        browser.imageCount = detailModel.descImages.count;
        browser.currentImageIndex = indexPath.row-1;
        [browser show];
//        XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row-1 imageCount:detailModel.descImages.count datasource:self];

        [browser setActionSheetWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        
    }else if (indexPath.section ==0&&indexPath.row>=detailModel.descImages.count+2&&indexPath.row<=detailModel.descImages.count+detailModel.aptitudeImages.count+1){
        
        XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
        browser.tag = 101;
        browser.datasource = self;
        browser.imageCount = detailModel.aptitudeImages.count;
        browser.currentImageIndex = indexPath.row-detailModel.descImages.count-2;
        [browser show];
//        XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row-detailModel.descImages.count-2 imageCount:detailModel.aptitudeImages.count datasource:self];
        
        [browser setActionSheetWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        
    }else if (indexPath.section == 1){
        
        if (![self checkExistPhoneNum]) {
            [self gotoCodeVC];
            return;
        }
        MineChatViewController *userVC = [[MineChatViewController alloc] init];
        userVC.hidesBottomBarWhenPushed = YES;
        userVC.userId = [NSString stringWithFormat:@"%ld",detailModel.publishUid];
        [self.navigationController pushViewController:userVC animated:YES];
        
    }else if (indexPath.section == 2){
        if (![self checkExistPhoneNum]) {
            [self gotoCodeVC];
            return;
        }
        CommentModel *model = self.commentAll[indexPath.row];
        self.toUserId = model.userId;
        self.pid = model.pid.integerValue==0?model.id:model.pid;
        self.commentTV.placeholder = [NSString stringWithFormat:@"回复:%@",model.nickname];
        [self.commentTV becomeFirstResponder];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2) {
        CommentModel *model = self.commentAll[indexPath.row];
        if (model.canDelete.boolValue) {
            return UITableViewCellEditingStyleDelete;
        }
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CommentModel *model = self.commentAll[indexPath.row];
        
        //TODO: 调用删除评论的接口
        [JGHTTPClient deleteCommentWithCommentId:model.id Success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [self.commentAll removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
            }else{
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}


- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    if (actionSheetindex==0) {
        [browser saveCurrentShowImage];
    }
}

-(NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    JGLog(@"%ld",browser.tag);
    if (browser.tag == 100) {
        return [NSURL URLWithString:detailModel.descImages[index]];
    }else{
        return [NSURL URLWithString:detailModel.aptitudeImages[index]];
    }
}

-(UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"placeholderPic"];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{//tag: 100==果聊;101==评论;102==点赞
    
    if (USER.login_id.integerValue<1) {
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
    
    switch (item.tag) {
        case 100:{//果聊
            
            
            if (detailModel.publishUid == USER.login_id.integerValue) {
                [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
                return ;
            }
            
            LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:[NSString stringWithFormat:@"%ld",detailModel.publishUid]]];
            
            [self.navigationController pushViewController:conversationViewController animated:YES];
            
            break;
        }
        case 101:{//评论
            
            self.toUserId = @"0";
            self.pid = @"0";
            self.commentTV.placeholder = @"请输入文字";
            [self.commentTV becomeFirstResponder];
            
            break;
        }
        case 102:{//点赞
            
            NSString *status;
            if (detailModel.isLike == 1) {
                status = @"0";
            }else{
                status = @"1";
            }
            [JGHTTPClient praiseSkillById:self.skillId status:status Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"] integerValue] == 200) {
                    
                    detailModel.isLike = status.integerValue;
                    item.image = [UIImage imageNamed:status.integerValue == 1?@"xin":@"fabulous"];
                    item.selectedImage = [UIImage imageNamed:status.integerValue == 1?@"xin":@"fabulous"];
                    
                    
                }
                
            } failure:^(NSError *error) {
                
            }];
            
            
            break;
        }
    }
    
}


//点击评论cell的头像
-(void)clickIcon:(NSString *)userId
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.hidesBottomBarWhenPushed = YES;
    mineChatVC.userId = [NSString stringWithFormat:@"%@",userId];
    [self.navigationController pushViewController:mineChatVC animated:YES];
}

- (IBAction)headerIcon:(id)sender {
    
    [self clickIcon:[NSString stringWithFormat:@"%ld",detailModel.publishUid]];
    
}



- (IBAction)buy:(UIButton *)sender {
    
    
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    if (detailModel.publishUid == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"你不能购买自己的技能!" duration:2];
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"想要服务保质保量？先果聊一下!" preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"果聊TA" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {//去果聊
        
        LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithFormat:@"%ld",detailModel.publishUid]];
        
        [self.navigationController pushViewController:conversationViewController animated:YES];
        
    }];
    UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"直接购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//跳到购买页面
        
        PlaceOrderViewController *orderVC = [[PlaceOrderViewController alloc] init];
        NSString *serviceName;
        switch (detailModel.serviceMode) {
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
        orderVC.serviceModeStr = serviceName;
        orderVC.serviceMode = detailModel.serviceMode;
        orderVC.skillTitle = detailModel.title;
        orderVC.price = [NSString stringWithFormat:@"￥ %.2f",detailModel.price.floatValue];
        orderVC.coverImg = [NSString stringWithFormat:@"%@",detailModel.cover];
        orderVC.hidesBottomBarWhenPushed = YES;
        orderVC.skillId = self.skillId;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }];
    [alertVC addAction:cancelAC];
    [alertVC addAction:sureAC];
        
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


-(void)keyboardWillAppear:(NSNotification *)noti
{
    self.tableView.scrollEnabled = NO;
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        
        self.commentView.frame = CGRectMake(0, self.view.height-rect.size.height-self.commentView.height, SCREEN_W, self.commentView.height);
        
    } completion:^(BOOL finished) {
        [IQKeyboardManager sharedManager].enable = YES;
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    self.tableView.scrollEnabled = YES;
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        //        self.commentView.transform = CGAffineTransformIdentity;
        self.commentView.frame = CGRectMake(0, rect.origin.y+rect.size.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
        [IQKeyboardManager sharedManager].enable = NO;
    }];
}

-(void)dealloc
{
    JGLog(@"\n控制器销毁...............")
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}




@end
