//
//  DemandListViewController.m
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandListViewController.h"
#import "CitySchoolViewController.h"
#import "MineChatViewController.h"
#import "PostDemandNewViewController.h"
#import "SearchDemandsViewController.h"
#import "DemandDetailNewViewController.h"
#import "WebViewController.h"

#import "SignDemandViewController.h"
#import "JianZhiDetailController.h"
#import "MyWalletNewViewController.h"
#import "RealNameNewViewController.h"
#import "MyPartJobViewController.h"
#import "MySignDetailViewController.h"
#import "MyPostDetailViewController.h"
#import "RemindMsgViewController.h"
#import "BillsViewController.h"

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
@property (nonatomic,strong) NSMutableArray *imagesScrollArr;

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
        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];
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
    
    
    self.tableView.estimatedRowHeight = 278;
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
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
        
        JGLog(@"one ====  %d",(int)self.dataArr.count/10);
        JGLog(@"two ==== %d",((int)(self.dataArr.count/10)>=1?1:2));
        JGLog(@"three ==== %d",(((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0));
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
//        footer.pullingPercent = 0.5;
        footer;
    });
    
    [self.tableView.mj_header beginRefreshing];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DOPIndexPath *indexPath = [DOPIndexPath indexPathWithCol:[USERDEFAULTS integerForKey:@"column"] row:[USERDEFAULTS integerForKey:@"row"]];
        if (indexPath) {
            [self.selectMenu selectIndexPath:indexPath triggerDelegate:YES];
        }
    });
    
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
                self.imagesScrollArr = [ImagesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
        self.selectMenu.fontSize = 12;
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    //    [self customCommentKeyboard];
//    [self.tableView.mj_header beginRefreshing];
    
    [self handleRemoteNotifcation];
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
                                   cityCode:self.cityCode keywords:nil orderBy:self.orderType type:self.type sex:self.sex userId:nil pageCount:count Success:^(id responseObject) {
   
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
            [_tableView reloadData];
//            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
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
//                [self.tableView setContentSize:CGSizeMake(SCREEN_W, SCREEN_H*2)];
//                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            //            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    return self.dataArr.count?self.dataArr.count:3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count ==0) {
        cell.contentView.hidden = YES;
        return cell;
    }else{
        cell.contentView.hidden = NO;
    }
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
    
//    [NotificationCenter postNotificationName:kNotificationGetNewNotiNews object:nil];
//    return;
    if (self.dataArr.count==0) {
        return;
    }
    
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

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    cell.layer.transform = CATransform3DRotate(cell.layer.transform, M_PI, 1, 0, 0);//沿x轴正轴旋转60度
//    //    cell.transform = CGAffineTransformTranslate(cell.transform, -SCREEN_W/2, 0);
////    cell.alpha = 0.0;
//    
//    [UIView animateWithDuration:0.8 animations:^{
//        
//        cell.layer.transform = CATransform3DRotate(cell.layer.transform, M_PI, 1, 0, 0);
//        
////        cell.alpha = 1.0;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}

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
//    
//
//    [self.selectMenu selectIndexPath:[DOPIndexPath indexPathWithCol:1 row:0]];
//    return;
    
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
    [BHBPopView showToView:self.view.window andImages:@[@"study-1",@"run",@"technology-1",@"amusement",@"emotion-1",@"shopping"] andTitles:@[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"] andSelectBlock:^(BHBItem *item) {
        
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
        self.schoolId = @"0";
        [self getSchoolsByCityCode:model.code];
        
        [self.selectMenu selectIndexPath:[DOPIndexPath indexPathWithCol:1 row:0] triggerDelegate:NO];
        
        [USERDEFAULTS setInteger:indexPath.row forKey:@"row"];
        [USERDEFAULTS setInteger:indexPath.column forKey:@"column"];
        
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
    
    animator.scale=1.3;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ImagesModel *model = self.imagesScrollArr[index];
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.url = model.url;
    [self.navigationController pushViewController:webVC animated:YES];

}


-(void)clickNotification:(NSNotification *)noti//点击通知进入应用
{
    NSDictionary *userInfo = noti.object;
    [self fromNotiToMyjobVC:userInfo];
}


/**
 *  处理远程推送的跳转逻辑
 */
-(void)handleRemoteNotifcation
{
    NSDictionary *userInfo = [USERDEFAULTS objectForKey:@"push"];
    if (userInfo) {
        
        NSDictionary *userInfo = [USERDEFAULTS objectForKey:@"push"];
        if (userInfo) {
            
            NSArray *array = [[userInfo objectForKey:@"aps"] allKeys];
            if ([array containsObject:@"type"]||[[userInfo allKeys] containsObject:@"type"]) {
                
                [self fromNotiToMyjobVC:userInfo];
                
            }else{
                UITabBarController *tabVc = (UITabBarController *)APPLICATION.keyWindow.rootViewController;
                [tabVc setSelectedIndex:2];
                
            }
            
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"push"];
        
    }
}


-(void)fromNotiToMyjobVC:(NSDictionary *)userInfo
{
    int intType = [userInfo[@"type"] intValue];
    UIViewController *VC;
    switch (intType) {
        case 4:
        case 1:{//报名推送
            
            VC = [[MyPartJobViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 2:
        case 3:{//主页推送,留在主页就行,不用额外操作
            
            
            JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
            
            jzdetailVC.hidesBottomBarWhenPushed = YES;
            
            jzdetailVC.jobId = userInfo[@"job_id"];
            
            [self.navigationController pushViewController:jzdetailVC animated:YES];
            break;
            
            break;
        }
        case 5:{//钱包推送
            
            VC = [[MyWalletNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 7:
        case 6:{//实名推送
            
            VC = [[RealNameNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 8:{//收到了果聊消息 –––> 果聊联系人页面
            
            [self.tabBarController setSelectedIndex:1];
            
            break;
        }
        case 9:{//报名了外露的兼职(主要是发短信的形式) –––>不做处理
            
            break;
        }
        case 10:{//发布的任务收到了新报名(–––>我发布的报名列表)
            
            SignDemandViewController *signVC = [SignDemandViewController new];
            signVC.demandId = userInfo[@"jobid"];
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            
            break;
        }
            // ***  报名的需求  ***
        case 14://被投诉,收到投诉处理结果(––––>任务详情页面)
        case 13://被雇主投诉(––––>任务详情页面)
        case 16://报名的需求被录用(––––>任务详情页面)
        case 17:{//报名的需求被拒绝(–––>我发布的报名列表)
            MySignDetailViewController *detailVC = [[MySignDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 15:{//任务服务费用到账(–––>钱包明细,收入明细)
            
            BillsViewController *billVC = [[BillsViewController alloc] init];
            billVC.hidesBottomBarWhenPushed = YES;
            billVC.type = @"1";
            billVC.navigationItem.title = @"收入明细";
            [self.navigationController pushViewController:billVC animated:YES];
            break;
        }
            // ***  发布的需求  ***
        case 11://发布的任务未通过审核
        case 12://发布需求,投诉了服务者,收到了投诉处理结果
        case 18:{//发布的需求收到了新评论(–––>也是任务详情页)
            MyPostDetailViewController *detailVC = [[MyPostDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 19:{//收到了评论,去普通的需求详情页
            DemandDetailNewViewController *detailVC = [[DemandDetailNewViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 23:{//自定义推送
            
            RemindMsgViewController *msgVC = [[RemindMsgViewController alloc] init];
            
            msgVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:msgVC animated:YES];
            
            break;
            
        }
        case 24:{//活动推送(H5)
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = userInfo[@"html_url"];
            
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 25:{//评价推送(H5)
            
            MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
            mineChatVC.hidesBottomBarWhenPushed = YES;
            mineChatVC.userId = [NSString stringWithFormat:@"%@",USER.login_id];
            [self.navigationController pushViewController:mineChatVC animated:YES];
            break;
        }
            
            
        case 100:{//活动推送(H5)
            
            break;
        }
    }
}



-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter removeObserver:self name:kNotificationClickNotification object:nil];
    
}




@end
