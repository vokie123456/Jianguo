//
//  JianLiHeaderView.m
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JianLiHeaderView.h"

@implementation JianLiHeaderView

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
    
    JianLiHeaderView *headerView = [[JianLiHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@"img_bg"];
    
//    [headerView setSubviews:headerView];
    
    return headerView;
}

@end
