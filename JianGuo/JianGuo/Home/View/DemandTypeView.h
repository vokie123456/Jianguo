//
//  DemandTypeView.h
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandTypeView : UIView

@property (nonatomic,strong) NSArray *titleArr;
+(instancetype)demandTypeViewselectBlock:(void(^)(NSInteger index,NSString *title))complectionBlock;

@end
