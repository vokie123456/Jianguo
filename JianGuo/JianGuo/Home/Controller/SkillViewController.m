//
//  SkillViewController.m
//  JianGuo
//
//  Created by apple on 17/7/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillViewController.h"
#import "SkillsDetailViewController.h"
#import "WebViewController.h"
#import "MineChatViewController.h"
#import "PostSkillViewController.h"
#import "RealNameNewViewController.h"

#import "JGHTTPClient+Skill.h"
#import "JGHTTPClient+Mine.h"
#import "JGHTTPClient+Home.h"

#import "MineIconCell.h"
#import "SkillsCell.h"
#import "SkillExpertCell.h"

#import "CityModel.h"
#import "SchoolModel.h"
#import "SkillListModel.h"
#import "ImagesModel.h"
#import "SkillExpertModel.h"

#import "SDCycleScrollView.h"
#import "DOPDropDownMenu.h"
#import "DismissingAnimator.h"
#import "PresentingAnimator.h"


@interface SkillViewController () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,SkillExpertBoardDelegate,UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmB;
/** 物理仿真器 */
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (nonatomic, strong) DOPDropDownMenu *selectMenu;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *cityArr;
@property (nonatomic,strong) NSMutableArray *schoolArr;
@property (nonatomic,strong) NSMutableArray *imagesScrollArr;
@property (nonatomic,strong) NSMutableArray *expertModelArr;



@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,copy) NSString *schoolId;
@property (nonatomic,strong) NSString *orderType;
@property (nonatomic,strong) NSString *sex;

@end

@implementation SkillViewController


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

            SchoolModel *school = [[SchoolModel alloc] init];
            school.id = @"0";
            school.name = @"全部学校";
            self.schoolArr = [NSMutableArray array];
            [self.schoolArr insertObject:school atIndex:0];
            [self.selectMenu reloadData];
            [SVProgressHUD dismiss];
        }];
        
//        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];
    }
    return self;
}

-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getSkillListWithSchoolId:self.schoolId
                                   cityCode:self.cityCode keywords:nil orderBy:self.orderType type:nil sex:self.sex tagId:nil userId:nil pageCount:count Success:^(id responseObject) {
                                       
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
               [_tableView reloadData];
               
               return;
               
           }else{
               self.dataArr = [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
               
               [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
           }
           
           
           
       } failure:^(NSError *error) {
           [SVProgressHUD dismiss];
           [self.tableView.mj_header endRefreshing];
           [self.tableView.mj_footer endRefreshing];
           [self showAlertViewWithText:NETERROETEXT duration:1];
       
   }];
}

-(void)getSkillExperts
{
    [JGHTTPClient getSkillExpertsListWithCityCode:self.cityCode Success:^(id responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            
            self.expertModelArr = [SkillExpertModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)refreshBanner
{
    [JGHTTPClient getImgsOfScrollviewWithCategory:@"3" Success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[@"code"] integerValue] == 200) {
                NSMutableArray *images = [NSMutableArray array];
                [[ImagesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ImagesModel *model = obj;
                    [images addObject:model.image];
                }];
                self.imagesScrollArr = [ImagesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                self.bannerView.imageURLStringsGroup = images;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)confirmSkillExpert:(UIButton *)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    if (USER.status.intValue == 1){
        [self showAlertViewWithText:@"请您先去实名认证" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            RealNameNewViewController *realNameVC = [[RealNameNewViewController alloc] init];
            realNameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realNameVC animated:YES];
        });
        return;
    }
    PostSkillViewController *postSkillVC = [[PostSkillViewController alloc] init];
    postSkillVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postSkillVC animated:YES];
    
//    WebViewController *webVC = [[WebViewController alloc]init] ;
//    webVC.url = @"https://jinshuju.net/f/BoMqQH";
//    webVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webVC animated:YES];
    
}

-(void)clickPersonIcon:(id)model
{
    SkillExpertModel *_model = model;
    
    MineChatViewController *mineVC = [[MineChatViewController alloc] init];
    mineVC.hidesBottomBarWhenPushed = YES;
    mineVC.userId = [NSString stringWithFormat:@"%ld",_model.uid];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"技能详情";
    
    self.cityCode = @"0";
    self.schoolId = @"0";
    self.sex = @"0";
    self.orderType = @"createTime";
    
    self.tableView.backgroundColor = BACKCOLORGRAY;
    
    [self initMenu];
    
    [self configSDCycleView];
    
    self.headerView.height = SCREEN_W*336/750+10;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        NSString *title = [self.selectMenu titleForRowAtIndexPath:[DOPIndexPath indexPathWithCol:0 row:0]];
        if (title.length==0) {
            self.cityArr = JGKeyedUnarchiver(JGCityArr);
            [self.selectMenu reloadData];
        }
        [self refreshBanner];
        [self getSkillExperts];
        [self requestWithCount:@"1"];
    }];
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
            
            [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
            
        }];
        footer;
    });
    
    [self.tableView.mj_header beginRefreshing];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addDynamicAnimator];
//    });
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.confirmB.hidden = NO;
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

-(void)configSDCycleView
{
    
    self.bannerView.localizationImageNamesGroup = @[@"kobe",@"kobe",@"kobe"];
    
    //设置pageControl位置
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.delegate = self;
    // 自定义分页控件小圆标颜色
    self.bannerView.currentPageDotColor = YELLOWCOLOR;
    self.bannerView.pageDotColor = WHITECOLOR;
    [self.bannerView setShowPageControl:YES];
    self.bannerView.pageControlDotSize = CGSizeMake(100, 20);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 190;
    }
    else
        return 335;
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SkillExpertCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SkillExpertCell class]) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataArr = self.expertModelArr;
        cell.delegate = self;
        
        return cell;
    }
    
    SkillsCell *cell = [SkillsCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row-1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        
        SkillListModel *model = self.dataArr[indexPath.row-1];
        SkillsCell *cell = (SkillsCell *)[tableView cellForRowAtIndexPath:indexPath];
        SkillsDetailViewController *detailVC = [[SkillsDetailViewController alloc] init];
        detailVC.callBack = ^(NSInteger collectionStatus){
            model.isFavourite = collectionStatus;
            [cell.collectionB setBackgroundImage:[UIImage imageNamed:collectionStatus?@"heart":@"stars1"] forState:UIControlStateNormal];
        };
        detailVC.skillId = [NSString stringWithFormat:@"%ld",model.skillId];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
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
        
        [self getSkillExperts];
        
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
            self.orderType = @"createTime";//最新
        }else if (indexPath.row == 1){
            self.orderType = @"viewCount";//最热
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

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        // 创建一个物理仿真器
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.navigationController.view];
        _animator.delegate = self;
    }
    return _animator;
}

-(void)addDynamicAnimator
{
    // 创建重力行为x
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    // magnitude越大，速度增长越快
    gravity.magnitude = 3;
    [gravity addItem:self.confirmB];
    
    
    // 2.创建碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.confirmB];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:
                          CGRectMake(0,0, self.view.frame.size.width, self.navigationController.view.frame.size.height-49-30)];
    [collision addBoundaryWithIdentifier:@"rect" forPath:path];
    
    // 设置碰撞的边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
    
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [animator removeAllBehaviors];
    
}


@end
