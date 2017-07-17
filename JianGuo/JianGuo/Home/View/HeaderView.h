//
//  HeaderView.h
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHomeHeaderDelegate <NSObject>

@optional
-(void)clickScollViewforUrl:(NSString *)url;
-(void)clickMore:(UIButton *)moreBtn;
-(void)clickOneOfFourBtns:(NSString *)str;

@end

@interface HeaderView : UIView
+(instancetype) aHeaderView;


@property (nonatomic,copy) void(^sendCityArrBlock)(NSMutableArray *);

@property (nonatomic,weak) id <JGHomeHeaderDelegate> delegate;

@end
