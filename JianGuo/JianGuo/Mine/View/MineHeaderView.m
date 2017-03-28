//
//  MineHeaderView.m
//  JianGuo
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MineHeaderView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#define TOTopInstance 80
#define LabelToiconView iconView.right+5

@implementation MineHeaderView


+(instancetype) aMineHeaderView
{
    CGFloat height;
    if (SCREEN_W == 320) {
        height = 203*(SCREEN_W/375)+35;
    }else if (SCREEN_W == 375){
        height = 203*(SCREEN_W/375);
    }else if (SCREEN_W == 414){
        height = 203*(SCREEN_W/375)-20;
    }
    height+=45;
    
    MineHeaderView *headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    headerView.userInteractionEnabled = YES;
//    headerView.image = [UIImage imageNamed:@"img_bg"];
    
    [headerView setSubviews:headerView];
    
    return headerView;
}

-(void)setSubviews:(MineHeaderView *)headerView
{
    CGFloat height;
    if (SCREEN_W == 320) {
        height = 203*(SCREEN_W/375)+35;
    }else if (SCREEN_W == 375){
        height = 203*(SCREEN_W/375);
    }else if (SCREEN_W == 414){
        height = 203*(SCREEN_W/375)-20;
    }
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    bgView.image = [UIImage imageNamed:@"mineBgImg"];
    [headerView addSubview:bgView];
    
    UIImageView *iconView = [[UIImageView alloc ]init];
    iconView.frame = CGRectMake((SCREEN_W-65)/2, TOTopInstance, 65, 65);
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 32.5;
    iconView.userInteractionEnabled = YES;
    [iconView sd_setImageWithURL:[NSURL URLWithString:[JGUser user].iconUrl] placeholderImage:[UIImage imageNamed:@"myicon"]];
    [headerView addSubview:iconView];
    self.iconView = iconView;
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = iconView.bounds;
    iconBtn.tag = 102;
    [iconBtn addTarget:self action:@selector(clickWalletOrRealName:) forControlEvents:UIControlEventTouchUpInside];
    [iconView addSubview:iconBtn];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.bottom+5, SCREEN_W, 20)];
    if ([[[JGUser user] tel] length] == 11) {
        nameLabel.text = [JGUser user].nickname.length != 0&&[[JGUser user] nickname]?[JGUser user].nickname:@"未填写";
    }else{
        nameLabel.text = @"登录/注册";
    }
    nameLabel.textColor = WHITECOLOR;
    nameLabel.font = FONT(16);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLabel];
//
//    UIButton *creditView = [UIButton buttonWithType:UIButtonTypeCustom];
//    creditView.frame = CGRectMake(nameLabel.right, TOTopInstance+2, 50, 15);
//    creditView.layer.cornerRadius = 8;
//    creditView.layer.masksToBounds = YES;
//    creditView.backgroundColor = YELLOWCOLOR;
//    [creditView setTitle:@"信用优秀" forState:UIControlStateNormal];
//    creditView.titleLabel.font = FONT(10);
//    [creditView setBackgroundImage:nil forState:UIControlStateNormal];
////    [headerView addSubview:creditView];
//    
//    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelToiconView, nameLabel.bottom+5, 180, 20)];
//    schoolLabel.text = [JGUser user].school.length != 0?[JGUser user].school:@"未填写";
//    schoolLabel.font = FONT(12);
//    schoolLabel.textColor = WHITECOLOR;
//    [headerView addSubview:schoolLabel];
//    
//    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelToiconView, schoolLabel.bottom+5, 100, 20)];
//    phoneLabel.text = [[JGUser user].tel intValue]!=0?[JGUser user].tel:@"未绑定";
//    phoneLabel.textColor = WHITECOLOR;
//    phoneLabel.font = FONT(12);
//    [headerView addSubview:phoneLabel];
//    
//    UIButton *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    accountBtn.frame = CGRectMake(SCREEN_W-80, 130, 80, 30);
//    accountBtn.titleLabel.font = FONT(12);
//    [accountBtn setTitle:@"账户管理 >" forState:UIControlStateNormal];
//    [accountBtn setBackgroundColor:[UIColor clearColor]];
    
//    [headerView addSubview:accountBtn];
    
//    UIImageView *jiantouView = [[UIImageView alloc] initWithFrame:CGRectMake(accountBtn.right, 130, 9, 13)];
//    jiantouView.image = [UIImage imageNamed:@"yjiantou"];
//    [headerView addSubview:jiantouView];
    
    //下边的两个大按钮
    UIButton *walletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    walletBtn.tag = 100;
    walletBtn.frame = CGRectMake(0, bgView.bottom,( SCREEN_W-2)/2, 45);
    [walletBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [walletBtn setTitle:@"我的钱包" forState:UIControlStateNormal];
    [walletBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [walletBtn setImage:[UIImage imageNamed:@"icon_money-2"] forState:UIControlStateNormal];
    [walletBtn addTarget:self action:@selector(clickWalletOrRealName:) forControlEvents:UIControlEventTouchUpInside];
    walletBtn.titleLabel.font = FONT(14);
    [walletBtn setBackgroundColor:WHITECOLOR];
    [headerView addSubview:walletBtn];
    
    
    UIButton *realNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    realNameBtn.tag = 101;
    realNameBtn.frame = CGRectMake(SCREEN_W-( SCREEN_W-2)/2, bgView.bottom,( SCREEN_W-2)/2, 45);
    [realNameBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [realNameBtn setTitle:@"实名认证" forState:UIControlStateNormal];
    [realNameBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [realNameBtn addTarget:self action:@selector(clickWalletOrRealName:) forControlEvents:UIControlEventTouchUpInside];
    realNameBtn.titleLabel.font = FONT(14);
    [realNameBtn setImage:[UIImage imageNamed:@"icon_shenfenzheng"] forState:UIControlStateNormal];
    [realNameBtn setBackgroundColor:WHITECOLOR];
    [headerView addSubview:realNameBtn];
    
//    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    bgButton.backgroundColor = [UIColor clearColor];
//    [bgButton addTarget:self action:@selector(gotoMyCV:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:bgButton];
//    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(iconView.mas_top);
//        make.left.equalTo(headerView.mas_left);
//        make.bottom.equalTo(iconView.mas_bottom);
//        make.right.equalTo(headerView.mas_right);
//    }];
    
}

-(void)clickWalletOrRealName:(UIButton *)btn
{
    if (btn.tag == 100) {
        if ([self.delegate respondsToSelector:@selector(clickWalletBtn)]) {
            [self.delegate clickWalletBtn];
        }
    }else if (btn.tag == 101){
        if ([self.delegate respondsToSelector:@selector(clickRealnameBtn)]) {
            [self.delegate clickRealnameBtn];
        }
    }else if (btn.tag == 102){
        if ([self.delegate respondsToSelector:@selector(clickRealnameBtn)]) {
            [self.delegate clickIconView];
            
        }
        
    }
}

-(void)gotoMyCV:(UIButton *)btn
{
//    if ([self.delegate respondsToSelector:@selector(gotoMyJianLiVC)]) {
//        [self.delegate gotoMyJianLiVC];
//    }
}

@end
