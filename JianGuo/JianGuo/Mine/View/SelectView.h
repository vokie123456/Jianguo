//
//  SelectView.h
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectView : UIView


@property (nonatomic,copy) void(^rightBtnBlock)();
@property (nonatomic,copy) void(^leftBtnBlock)();

+(instancetype)aSelectView;

@end
