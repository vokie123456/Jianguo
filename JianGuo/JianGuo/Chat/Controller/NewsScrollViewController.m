//
//  NewsScrollViewController.m
//  JianGuo
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NewsScrollViewController.h"
#import "RemindMsgViewController.h"
#import "LCCKConversationListViewController.h"

#import "ScrollCollectionCell.h"

#import <Masonry.h>
#import <WZLBadgeImport.h>

static NSString *identifier = @"ScrollCollectionCell";

@interface NewsScrollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation NewsScrollViewController
{
    LCCKConversationListViewController *conversationVC;
    RemindMsgViewController *remindVC;
    UIView *lineView;
    UIButton *buttonRight;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [NotificationCenter addObserver:self selector:@selector(getNewNotiNews) name:kNotificationGetNewNotiNews object:nil];
        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];
    }
    return  self;
}

-(void)getNewNotiNews
{
    [USERDEFAULTS setObject:@"NotiNews" forKey:isHaveNewNews];
    [USERDEFAULTS synchronize];
    
    
    if (buttonRight) {//已经创建了信息按钮
        [buttonRight.titleLabel showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    conversationVC = [[LCCKConversationListViewController alloc] init];
    
    remindVC = [[RemindMsgViewController alloc] init];
    
    [self addChildViewController:conversationVC];
    [self addChildViewController:remindVC];
    
    [self customTitleView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.backgroundColor = WHITECOLOR;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ScrollCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    
    self.collectionView.pagingEnabled = YES;
    
    
}

-(void)customTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-100, 44)];
    
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLeft.tag = 100;
    [buttonLeft setTitle:@"果聊" forState:UIControlStateNormal];
    [buttonLeft setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    buttonLeft.frame = CGRectMake(0, 0, titleView.width/2, 42);
    [buttonLeft addTarget:self action:@selector(clickTitleView:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:buttonLeft];
    
    buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.tag = 101;
    [buttonRight setTitle:@"通知" forState:UIControlStateNormal];
    [buttonRight setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    buttonRight.frame = CGRectMake(titleView.width/2, 0, titleView.width/2, 42);
    [buttonRight addTarget:self action:@selector(clickTitleView:) forControlEvents:UIControlEventTouchUpInside];
    UIView *redView = [[UIView alloc] init];
    redView.badgeFrame = CGRectMake(buttonRight.titleLabel.width+40, 0, 18, 18);
    redView.badgeCenterOffset = CGPointMake(buttonRight.titleLabel.width, 0);
    [buttonRight.titleLabel showBadge];
    [titleView addSubview:buttonRight];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, titleView.width/2, 2)];
    lineView.backgroundColor = GreenColor;
    [titleView addSubview:lineView];
    
    self.navigationItem.titleView = titleView;
    
}

-(void)clickTitleView:(UIButton *)sender
{
    if (sender.tag == 100) {//果聊
        
        CGRect frame = lineView.frame;
        frame.origin.x = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            lineView.frame = frame;
            
        } completion:nil];
        
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (sender.tag == 101){//通知
        
        CGRect frame = lineView.frame;
        frame.origin.x = lineView.width;
        [UIView animateWithDuration:0.3 animations:^{
            lineView.frame = frame;
        } completion:nil];
        
        [self.collectionView setContentOffset:CGPointMake(SCREEN_W, 0) animated:YES];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        
        cell.controller = conversationVC;
        [cell.contentView addSubview:conversationVC.view];
//        conversationVC.view.frame = CGRectMake(0, 0, SCREEN_W, self.collectionView.height);
        
        [conversationVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(cell.contentView.mas_leading);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.trailing.equalTo(cell.contentView.mas_trailing);
            make.top.equalTo(cell.contentView.mas_top);
            
        }];
        
    }else if (indexPath.item == 1){
        
        cell.controller = remindVC;
        [cell.contentView addSubview:remindVC.view];
        
        [remindVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(cell.contentView.mas_leading);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.trailing.equalTo(cell.contentView.mas_trailing);
            make.top.equalTo(cell.contentView.mas_top);
            
        }];
        
    }
//    cell.contentView.clipsToBounds = YES;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    remindVC.view.frame = CGRectMake(0, 0, SCREEN_W, self.collectionView.height);
    return self.collectionView.size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        if (self.collectionView.contentOffset.x<SCREEN_W/2) {
            
            CGRect frame = lineView.frame;
            frame.origin.x = 0;
            [UIView animateWithDuration:0.3 animations:^{
                lineView.frame = frame;
            } completion:nil];
            
        }else if (self.collectionView.contentOffset.x > SCREEN_W/2){
            
            CGRect frame = lineView.frame;
            frame.origin.x = lineView.width;
            [UIView animateWithDuration:0.3 animations:^{
                lineView.frame = frame;
            } completion:nil];
            
        }
        
    }
}


@end
