//
//  MyWalletHeadView.h
//  JianGuo
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"


@protocol ClickSelectDelegate <NSObject>

-(void)clickCashBtn;

@end

@interface MyWalletHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@property (nonatomic,copy) NSString *money;
@property (nonatomic,strong) WalletModel *model;
@property (nonatomic,weak) id <ClickSelectDelegate> delegate;

+(instancetype)aWalletHeadView;

@end
