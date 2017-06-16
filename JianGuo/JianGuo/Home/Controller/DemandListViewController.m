//
//  DemandListViewController.m
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandListViewController.h"
#import "PostDemandViewController.h"
#import "CitySchoolViewController.h"
#import "DemandDetailController.h"
#import "MineChatViewController.h"
#import "PostDemandNewViewController.h"
#import "SearchDemandsViewController.h"
#import "DemandDetailNewViewController.h"

#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+Mine.h"
#import "JGHTTPClient+Home.h"


#import "DemandModel.h"
#import "CityModel.h"
//#import "YYFPSLabel.h"
#import "MineIconCell.h"
#import "CommentInputView.h"
#import "SchoolModel.h"
#import "CityModel.h"
#import "DemandTypeModel.h"
#import "ImagesModel.h"

#import "SDCycleScrollView.h"
#import "DOPDropDownMenu.h"
#import "BHBPopView.h"
#import "DemandListCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <IQKeyboardManager.h>
#import "DismissingAnimator.h"
#import "PresentingAnimator.h"

#define lineViewHeight 3
#define sizeWidth (SCREEN_W-30)/3
#define spaceWidth 20

static NSString *identifier = @"DemandListCell";

@interface DemandListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ClickLikeBtnDelegate,FinishEditDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,SDCycleScrollViewDelegate>{
    
    UIView *inputView;
    
    __weak IBOutlet NSLayoutConstraint *leftCons;
    NSMutableArray *imagesArr;
    __weak IBOutlet NSLayoutConstraint *topTableViewCons;
    __weak IBOutlet SDCycleScrollView *scrollImagesView;
    __weak IBOutlet UIView *headerView;
    
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
@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,strong) NSString *orderType;
@property (nonatomic,strong) NSString *sex;

@property (nonatomic, strong) DOPDropDownMenu *selectMenu;

@property (nonatomic,strong) NSMutableArray *cityArr;
@property (nonatomic,strong) NSMutableArray *schoolArr;

@end

@implementation DemandListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.cityArr = JGKeyedUnarchiver(JGCityArr);
        CityModel *model = self.cityArr.firstObject;
        
        [JGHTTPClient searchSchoolByName:nil cityCode:model.code Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue] == 200) {
                self.schoolArr = [SchoolModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                SchoolModel *school = [[SchoolModel alloc] init];
                school.id = @"0";
                school.name = @"全部学校";
                [self.schoolArr insertObject:school atIndex:0];
                [self.selectMenu reloadData];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
        [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imagesArr = @[@"study",@"errands",@"technology",@"emotion",@"entertainment",@"purchase"].mutableCopy;
    
    self.schoolId = @"0";
    self.orderType = @"create_time";
    self.cityCode = [CityModel city].code;
    self.sex = @"0";
    self.type = @"0";
    
//    UIButton *btn_l = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_l setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [btn_l addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
//    btn_l.frame = CGRectMake(-10, 0, 10, 12);
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnLocation setTitle:[CityModel city].cityName forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btnLocation.titleLabel.font = FONT(14);
    [btnLocation addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(0, 0, 20, 20);
    self.cityBtn = btnLocation;
    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    UIBarButtonItem *bbtLocation = [[UIBarButtonItem alloc] initWithCustomView:btnLocation];
    self.navigationItem.rightBarButtonItems = @[bbtLocation];
   
   
    self.navigationItem.title = @"校约";
    self.navigationItem.leftBarButtonItem = nil;
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    self.tableView.estimatedRowHeight = 140;
//    self.tableView.rowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    [self initMenu];
    
    [self configCollectionView];
    
    [self configSDCycleView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self refreshBanner];
        [self requestWithCount:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
        
        JGLog(@"one ====  %d",(int)self.dataArr.count/10);
        JGLog(@"two ==== %d",((int)(self.dataArr.count/10)>=1?1:2));
        JGLog(@"three ==== %d",(((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0));
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];

    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)configSDCycleView
{
    
    scrollImagesView.localizationImageNamesGroup = @[@"kobe",@"kobe",@"kobe"];
    
    //设置pageControl位置
    scrollImagesView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    scrollImagesView.delegate = self;
    // 自定义分页控件小圆标颜色
    scrollImagesView.currentPageDotColor = YELLOWCOLOR;
    scrollImagesView.pageDotColor = WHITECOLOR;
    [scrollImagesView setShowPageControl:YES];
    scrollImagesView.pageControlDotSize = CGSizeMake(100, 20);
    
    
}

-(void)refreshBanner
{
    [JGHTTPClient getImgsOfScrollviewWithCategory:@"1" Success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[@"code"] integerValue] == 200) {
                NSMutableArray *images = [NSMutableArray array];
                [[ImagesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ImagesModel *model = obj;
                    [images addObject:model.image];
                }];
                scrollImagesView.imageURLStringsGroup = images;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//配置筛选控件
-(void)initMenu{
    self.selectMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.selectMenu.delegate = self;
    self.selectMenu.dataSource = self;
    self.selectMenu.textSelectedColor = GreenColor;
    if (SCREEN_W == 320) {
        self.selectMenu.detailTextFont = [UIFont systemFontOfSize:5];
    }
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
    [IQKeyboardManager sharedManager].enable = NO;
    [self.commentView removeFromSuperview];//从父视图上删除并没有把对象置空
    self.commentView = nil;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    topTableViewCons.constant = 0;
    CGRect frame = headerView.frame;
    frame.size.height = scrollImagesView.height*2;
    headerView.frame = frame;
}

-(void)selectCitySChool:(UIButton *)btn
{
    SearchDemandsViewController *searchVC = [[SearchDemandsViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
    
    [JGHTTPClient getDemandListWithSchoolId:self.schoolId
                                   cityCode:self.cityCode keywords:nil orderBy:self.orderType type:self.type sex:self.sex userId:USER.login_id pageCount:count Success:^(id responseObject) {
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
    return section == 0?44:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.selectMenu;
    }
    return nil;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DemandModel *model = self.dataArr[indexPath.row];
    
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
    DemandDetailNewViewController *detailVC = [DemandDetailNewViewController new];
    if (self.dataArr.count>indexPath.row) {
        detailVC.demandId = [(DemandModel *)self.dataArr[indexPath.row] demandId];
    }
    detailVC.hidesBottomBarWhenPushed = YES;
//    detailVC.callBackBlock = ^(){
//        [self requestWithCount:@"1"];
//    };
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
        
        [JGHTTPClient postAcommentWithDemandId:self.currentModel.id content:self.commentView.commentTV.text pid:USER.login_id toUserId:self.currentModel.b_user_id Success:^(id responseObject) {
            
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
    [JGHTTPClient postAcommentWithDemandId:self.currentModel.id content:self.commentView.commentTV.text pid:USER.login_id toUserId:self.currentModel.b_user_id Success:^(id responseObject) {
        
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
    
    //添加popview
    [BHBPopView showToView:self.view.window andImages:@[@"study-1",@"run",@"technology-1",@"emotion-1",@"shopping",@"amusement"] andTitles:@[@"学习交流",@"跑腿代劳",@"技能服务",@"情感地带",@"娱乐生活",@"易货求购"] andSelectBlock:^(BHBItem *item) {
        
        PostDemandNewViewController *postDemandVC = [[PostDemandNewViewController alloc] init];
        postDemandVC.demandType = [NSString stringWithFormat:@"%ld",item.index.integerValue+1];
        postDemandVC.demandTypeStr = item.title;
        postDemandVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDemandVC animated:YES];
        
    }];
    
    
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
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MineIconCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MineIconCell class])];
    
//    UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(spaceWidth/2, self.collectionView.height-lineViewHeight, sizeWidth-spaceWidth, lineViewHeight)];
//    lineView.backgroundColor = GreenColor;
//    [self.collectionView addSubview:lineView];
//    self.lineView = lineView;
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MineIconCell class]) forIndexPath:indexPath];
    cell.iconView.image = [UIImage imageNamed:imagesArr[indexPath.item]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(sizeWidth, sizeWidth*15/23);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayId = @[@"1",@"2",@"3",@"5",@"4",@"6"];
    NSArray *arrayName = @[@"学习交流",@"跑腿代劳",@"技能服务",@"情感地带",@"娱乐生活",@"易货求购"];
    
    SearchDemandsViewController *searchVC = [[SearchDemandsViewController alloc] init];
    searchVC.isModule = YES;
    searchVC.type = arrayId[indexPath.item];
    searchVC.navigationItem.title = arrayName[indexPath.item];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineIconCell *cell = (MineIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
}



#pragma mark DOPDropDownMenuDataSource (三方筛选控件代理方法)
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{//有几列
    return 4;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{//哪一列有几行
    if (column == 0) {
        return self.cityArr.count;
    }else if (column == 1){
        return self.schoolArr.count;
    }else if (column == 2){
        return 3;
    }else {
        return 2;
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{//设置哪一列的哪一行 的名字
    
    if (indexPath.column == 0) {
        CityModel *model = self.cityArr[indexPath.row];
        return model.cityName;
    } else if (indexPath.column == 1){

        SchoolModel *model = self.schoolArr[indexPath.row];
        return model.name;
        
    } else if (indexPath.column == 2){
        NSArray *titleArr = @[@"不限男女",@"只看女",@"只看男 "];
        return titleArr[indexPath.row];
    } else {
        NSArray *titleArr = @[@"最新",@"最热"];
        return titleArr[indexPath.row];
    }
    
}
#pragma mark - DOPDropDownMenuDelegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{//选择第几行执行什么操作
    
    if (indexPath.column == 0) {
        
        CityModel *model = self.cityArr[indexPath.row];
        self.cityCode = model.code;
        [self getSchoolsByCityCode:model.code];
        
    } else if (indexPath.column == 1){
        
        SchoolModel *school = self.schoolArr[indexPath.row];
        self.schoolId = school.id;
        
    } else if (indexPath.column == 2){
        
        if (indexPath.row == 0) {
            self.sex = @"0";//不限男女
        }else if (indexPath.row == 1){
            self.sex = @"1";//只看女
        }else if (indexPath.row == 2){
            self.sex = @"2";//只看男
        }
        
    } else if (indexPath.column == 3){
        
        if (indexPath.row == 0) {
            self.orderType = @"create_time";//最新
        }else if (indexPath.row == 1){
            self.orderType = @"like_count";//最热
        }
        
    }
    [self requestWithCount:@"1"];
    
}

-(void)getSchoolsByCityCode:(NSString *)cityCode
{
    [JGHTTPClient searchSchoolByName:nil cityCode:cityCode Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 200) {
            self.schoolArr = [SchoolModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            SchoolModel *school = [[SchoolModel alloc] init];
            school.id = @"0";
            school.name = @"全部学校";
            [self.schoolArr insertObject:school atIndex:0];
            //                [self.selectMenu reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    PresentingAnimator *animator = [PresentingAnimator new];
    
    animator.scale=1.2;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}


-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}




@end
