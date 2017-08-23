//
//  PlaceOrderViewController.h
//  JianGuo
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface PlaceOrderViewController : NavigatinViewController
/** 服务方式 */
@property (nonatomic,copy) NSString *serviceModeStr;
/** 服务方式 int */
@property (nonatomic,assign) NSInteger serviceMode;
/** 价格 */
@property (nonatomic,copy) NSString *price;
/** 技能图片 */
@property (nonatomic,copy) NSString *coverImg;
/** 技能标题 */
@property (nonatomic,copy) NSString *skillTitle;
/** 技能id*/
@property (nonatomic,copy) NSString *skillId;

@end
