//
//  SelectScrollView.h
//  JianGuo
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectScrollView : UIView

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSArray *tittles;
@property (nonatomic,strong) NSArray *selectors;
@property (nonatomic,strong) UIViewController *target;
@property (nonatomic,assign) SEL selector;
@property (nonatomic,strong) UIColor *selecColor;
@property (nonatomic,strong) UIColor *bgColor;

@property (nonatomic,copy) void(^clickSelectBlock)(NSInteger tag);

+(instancetype)aSelectViewWithTittles:(NSArray *)tittles frame:(CGRect )frame;

@end
