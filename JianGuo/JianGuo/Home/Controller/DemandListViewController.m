//
//  DemandListViewController.m
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandListViewController.h"
#import "PostDemandViewController.h"
#import "DemandListCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <IQKeyboardManager.h>
#import "DemandDetailController.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
//#import "YYFPSLabel.h"
#import "LabelCell.h"
#import "CommentInputView.h"
#import "CitySchoolViewController.h"
#import "SchoolModel.h"
#import "CityModel.h"
#import "DemandTypeModel.h"
#import "MineChatViewController.h"

#define lineViewHeight 3
#define sizeWidth SCREEN_W/titleArr.count
#define spaceWidth 20

static NSString *identifier = @"DemandListCell";

@interface DemandListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ClickLikeBtnDelegate,FinishEditDelegate>{
    
    UIView *inputView;
    
    __weak IBOutlet NSLayoutConstraint *leftCons;
    NSMutableArray *titleArr;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *emojiBtn;
@property (nonatomic,strong) UITextView *commentTV;
@property (nonatomic,weak) CommentInputView *commentView;
@property (nonatomic,strong) DemandModel *currentModel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,copy) NSString *type;

@end

@implementation DemandListViewController



-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = @[].mutableCopy;
    
    self.schoolId = USER.schoolId?USER.schoolId:@"0";
    
    UIButton *btn_l = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_l setBackgroundImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    [btn_l addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btn_l.frame = CGRectMake(-10, 0, 10, 12);
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setTitle:[CityModel city].cityName forState:UIControlStateNormal];
    btnLocation.titleLabel.font = FONT(14);
    [btnLocation addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(0, 0, 30, 20);
    self.cityBtn = btnLocation;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    UIBarButtonItem *bbtLocation = [[UIBarButtonItem alloc] initWithCustomView:btnLocation];
    self.navigationItem.rightBarButtonItems = @[bbtLocation,leftBtn];
    
//    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_r setImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
//    [btn_r addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
//    btn_r.frame = CGRectMake(0, 0, 20, 20);
//    
//    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
//    
//    self.navigationItem.rightBarButtonItem = rightBtn;

    
    
    self.type = @"0";
    NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
    for (DemandTypeModel *model in demandTypeArr) {
        [titleArr addObject:model.type_name];
    }
//    titleArr = @[@"全部",@"学习",@"代办",@"求助",@"娱乐"];
    
//    YYFPSLabel *fps = [YYFPSLabel new];
//    fps.center = CGPointMake(60, self.view.bottom-100);
//    [self.view addSubview:fps];
    
    self.navigationItem.title = @"任务大厅";
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    self.tableView.estimatedRowHeight = 140;
//    self.tableView.rowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    
    [self configCollectionView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0?1:0);
        
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];

    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    //    [self customCommentKeyboard];
//    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.commentView removeFromSuperview];//从父视图上删除并没有把对象置空
    self.commentView = nil;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)selectCitySChool:(UIButton *)btn
{
    CitySchoolViewController *schoolVC = [[CitySchoolViewController alloc] init];
    schoolVC.hidesBottomBarWhenPushed = YES;
    schoolVC.selectSchoolBlock = ^(SchoolModel *school,CityModel *city){
        if (school) {
             self.schoolId = school.id;
        }else if (city){
            [CityModel saveCity:city];
            [self.cityBtn setTitle:city.cityName forState:UIControlStateNormal];
        }
        [self requestWithCount:@"1"];
    };
    [self.navigationController pushViewController:schoolVC animated:YES];
}


-(void)customCommentKeyboard
{
    CommentInputView *view = [CommentInputView aReplyCommentView:nil];
    self.commentView = view;
    self.commentTV = view.commentTV;
    view.delegate = self;
    [APPLICATION.keyWindow addSubview:view];
    [APPLICATION.keyWindow bringSubviewToFront:view];
    
    
    if (self.commentView.commentTV.text.length) {
        CGRect rect = [self.commentView.commentTV.text boundingRectWithSize:CGSizeMake(self.commentView.commentTV.size.width,   MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.commentView.commentTV.font} context:nil];
        self.commentView.frame = CGRectMake(0, 0, SCREEN_W, rect.size.height+10);
    }else{
        self.commentView.frame = CGRectMake(0, 0, SCREEN_W, 40);
    }
    
    self.commentView.center = CGPointMake(SCREEN_W/2,self.view.bottom+100);
}



-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getDemandListWithSchoolId:self.schoolId type:self.type sex:nil userId:USER.login_id pageCount:count Success:^(id responseObject) {
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
            
            NSMutableArray *sections = [NSMutableArray array];
            for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexSet* section = [NSIndexSet indexSetWithIndex:self.dataArr.count-1];
                [sections addObject:section];
            }
            
//            [_tableView insertRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArr.count-sections.count, sections.count)] withRowAnimation:UITableViewRowAnimationFade];

            return;
            
        }else{
            self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
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
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DemandModel *model = self.dataArr[indexPath.section];
    
    cell.model = model;
    cell.delegate = self;
    
    IMP_BLOCK_SELF(DemandListViewController);
    cell.sendCellIndex = ^(id object){
        JGLog(@"%@",model);
        block_self.currentModel = model;
    };
    
    return cell;
}

-(void)clickLike:(DemandModel *)model
{
    NSString *status = model.like_status.integerValue==1?@"1":@"0";
    
    [JGHTTPClient praiseForDemandWithDemandId:model.id likeStatus:status Success:^(id responseObject) {
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)signDemand:(UIButton *)userId
{
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandDetailController *detailVC = [DemandDetailController new];
    detailVC.demandId = [(DemandModel *)self.dataArr[indexPath.section] id];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.callBackBlock = ^(){
        [self requestWithCount:@"1"];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)keyboardWillAppear:(NSNotification *)noti
{
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
          self.commentView.frame = CGRectMake(0, SCREEN_H-rect.size.height-self.commentView.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
        [self.commentTV becomeFirstResponder];
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
//        self.commentView.transform = CGAffineTransformIdentity;
        self.commentView.frame = CGRectMake(0, rect.origin.y+rect.size.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {//拦截点击retrun按钮时间,并不影响换行按钮事件
        if (self.commentTV.text.length == 0) {
            [self showAlertViewWithText:@"评论点儿东西吧" duration:1];
            return NO;
        }
        JGLog(@"%@ ––––––> %@",self.currentModel.title,self.currentModel.id);
        
        [JGHTTPClient postAcommentWithDemandId:self.currentModel.id content:self.commentView.commentTV.text userId:USER.login_id toUserId:self.currentModel.b_user_id Success:^(id responseObject) {
            
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            
        } failure:^(NSError *error) {
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
        
        [textView resignFirstResponder];
        textView.text = nil;
        return NO;
    }
    return YES;
}

-(void)finishEdit
{
    if (self.commentTV.text.length == 0) {
        [APPLICATION.keyWindow endEditing:YES];
        [self showAlertViewWithText:@"评论点儿东西吧" duration:1];
        return;
    }
    [JGHTTPClient postAcommentWithDemandId:self.currentModel.id content:self.commentView.commentTV.text userId:USER.login_id toUserId:self.currentModel.b_user_id Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
    [self.commentTV resignFirstResponder];
    self.commentTV.text = nil;
}
- (IBAction)postDemand:(id)sender {
    
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
    PostDemandViewController *postDemandVC = [[PostDemandViewController alloc] init];
    postDemandVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDemandVC animated:YES];
    
}

-(void)clickIcon:(NSString *)userId
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.hidesBottomBarWhenPushed = YES;
    mineChatVC.userId = userId;
    [self.navigationController pushViewController:mineChatVC animated:YES];
}

#pragma mark 设置头部滑动的标题 <UICollectionView>
-(void)configCollectionView
{
    self.collectionView.backgroundColor = WHITECOLOR;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LabelCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LabelCell class])];
    
    UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(spaceWidth/2, self.collectionView.height-lineViewHeight, sizeWidth-spaceWidth, lineViewHeight)];
    lineView.backgroundColor = GreenColor;
    [self.collectionView addSubview:lineView];
    self.lineView = lineView;
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return titleArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LabelCell class]) forIndexPath:indexPath];
    cell.contentL.textColor = [UIColor darkTextColor];
    if (indexPath.item == 0) {
        cell.contentL.textColor = GreenColor;
    }
    cell.contentL.text = titleArr[indexPath.item];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(sizeWidth, self.collectionView.height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell0 = (LabelCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell0.contentL.textColor = [UIColor darkTextColor];
    
    LabelCell *cell = (LabelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect frame = self.lineView.frame;
    frame.origin.x = sizeWidth*indexPath.item+spaceWidth/2;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = frame;
        cell.contentL.textColor = GreenColor;
    }];
    self.type = [NSString stringWithFormat:@"%ld",indexPath.item];
    [self requestWithCount:@"1"];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = (LabelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentL.textColor = [UIColor darkTextColor];
}



-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}




@end
