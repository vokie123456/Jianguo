//
//  HomeNewViewController.m
//  JianGuo
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "HomeNewViewController.h"
#import "HomeViewController.h"
#import "SMPageControl.h"
#import "UIImage+Color.h"
#import "LoginNew2ViewController.h"
#import "CustomCollectionCell.h"
#import "CustomLayout.h"
#import "VerLayout.h"
#import "PostDemandViewController.h"
#import "ProfileViewController.h"
#import "DemandListViewController.h"
#import "MineNewViewController.h"

#define cellCount 2

static NSString *identifier = @"colletionCell";

@interface HomeNewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    SMPageControl *pageControl;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,assign) BOOL isHorLayout;;

@end

@implementation HomeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"找兼职";
    
//    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_r setTitle:@"切换布局" forState:UIControlStateNormal];
//    [btn_r addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
//    btn_r.frame = CGRectMake(0, 0, 60, 30);
//    
//    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
//    
//    self.navigationItem.rightBarButtonItem = rightBtn;

    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    CustomLayout *layout = [[CustomLayout alloc] init];
//    layout.sendIndexBlock = ^(NSInteger index){
//        pageControl.currentPage = index;
//    };
    VerLayout *layout = [[VerLayout alloc] init];
    
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifier];//这个方法只会加载xib上的控件
    
//    [self.collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:identifier];//这个方法不会加载xib上的控件,需要在cell的initWithFrame:里手动添加
    
    [self.collectionView reloadData];
    
    pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    pageControl.userInteractionEnabled = NO;
    pageControl.hidden = YES;
    
    pageControl.numberOfPages = cellCount;
    
    pageControl.indicatorMargin = 10;
    
    pageControl.pageIndicatorImage = [UIImage imageFromContextWithColor:[UIColor lightGrayColor] size:CGSizeMake(10,10)];
    
    pageControl.currentPageIndicatorImage = [UIImage imageFromContextWithColor:GreenColor size:CGSizeMake(10, 10)];
    
    //    pageControl.layer.borderColor = [UIColor brownColor].CGColor;
    //    pageControl.layer.borderWidth = 2.0f;
    
    [self.view addSubview:pageControl];
    
    [self.view bringSubviewToFront:pageControl];
    
}

-(void)changeLayout:(UIButton *)sender
{
    self.isHorLayout = !self.isHorLayout;
    if (self.isHorLayout) {
        CustomLayout *layout = [[CustomLayout alloc] init];
        layout.sendIndexBlock = ^(NSInteger index){
            pageControl.currentPage = index;
        };
        pageControl.hidden = NO;

        [self.collectionView setCollectionViewLayout:layout animated:YES];
        [self.collectionView reloadData ];
    }else{
        pageControl.hidden = YES;
        VerLayout *layout = [[VerLayout alloc] init];
        [self.collectionView setCollectionViewLayout:layout animated:YES];
        [self.collectionView reloadData ];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cellCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.isHorLayout) {
        if (indexPath.item==0) {
            cell.iconView.image = [UIImage imageNamed:@"one"];
        }else if (indexPath.item == 1){
            cell.iconView.image = [UIImage imageNamed:@"two"];
        }else
            cell.iconView.image = [UIImage imageNamed:@"one"];
        
    }else{
        if (indexPath.item==0) {
            cell.iconView.image = [UIImage imageNamed:@"school"];
        }else if (indexPath.item == 1){
            cell.iconView.image = [UIImage imageNamed:@"campus"];
        }else
            cell.iconView.image = [UIImage imageNamed:@"shcool"];
        
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {//去校约模块
        
        DemandListViewController *demandVC = [DemandListViewController new];
        demandVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:demandVC animated:YES];
        
    }else if (indexPath.item == 1){//去兼职模块
        
        HomeViewController *homeVC = [HomeViewController new];
        homeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:homeVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        DemandListViewController *profileVC = [DemandListViewController new];
        profileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profileVC animated:YES];
        
    }else if (indexPath.row == 3){
        
        MineNewViewController *profileVC = [MineNewViewController new];
//        profileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profileVC animated:YES];
        
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 300);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


-(void)viewDidLayoutSubviews
{
    pageControl.frame = CGRectMake(0, self.collectionView.bottom-(SCREEN_W==320?40:60), SCREEN_W, 40);
    
}



@end
