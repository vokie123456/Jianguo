//
//  MineHeaderView.h
//  JianGuo
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineHeaderView;
@protocol MineHeaderDelegate <NSObject>

-(void)clickWalletBtn;
-(void)clickRealnameBtn;
-(void)gotoMyJianLiVC;
-(void)clickIconView;

@end

@interface MineHeaderView : UIImageView
-(void)setSubviews:(MineHeaderView *)headerView;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,weak) id<MineHeaderDelegate> delegate;

+(instancetype) aMineHeaderView;

@end
