//
//  UserGuideViewController.m
//  WinterGame
//
//  Created by XQL on 15/12/25.
//  Copyright © 2015年 XQL. All rights reserved.
//

#import "UserGuideViewController.h"
#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import "MyTabBarController.h"

#define IMGCOUNT 3

@interface UserGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_W*IMGCOUNT, SCREEN_H);
    self.scrollView.delegate = self;
    for (int i=0; i<IMGCOUNT; i++) {
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W*i, 0, SCREEN_W, SCREEN_H)];
        guideView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [self.scrollView addSubview:guideView];
        
        if (i==IMGCOUNT-1) {
            guideView.userInteractionEnabled = YES;
            UIButton *goinBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            [goinBtn setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];
//            goinBtn.layer.cornerRadius = 5;
//            goinBtn.layer.masksToBounds = YES;
            [goinBtn addTarget:self action:@selector(goinApp) forControlEvents:UIControlEventTouchUpInside];
            [guideView addSubview:goinBtn];
            [goinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerX.mas_equalTo(guideView.mas_centerX);
                make.bottom.mas_equalTo(guideView.mas_bottom).offset(-45);
                make.size.mas_equalTo(CGSizeMake(100, 35));
                
            }];
        }
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_W/2-50-(SCREEN_W-320)/2, SCREEN_H-50, 100, 50)];
    self.pageControl.numberOfPages = IMGCOUNT;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = RGBCOLOR(224, 224, 224);
    self.pageControl.currentPageIndicatorTintColor = BLUECOLOR;
    [self.view addSubview:self.pageControl];
}

#pragma mark =====  scrollView 的代理方法  =====

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_W;
}
-(void)goinApp
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MyTabBarController alloc] init];
}

@end
