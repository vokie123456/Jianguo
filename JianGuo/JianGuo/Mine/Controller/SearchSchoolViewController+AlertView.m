//
//  SearchSchoolViewController+AlertView.m
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SearchSchoolViewController+AlertView.h"
#import "DMAlertView.h"

@implementation SearchSchoolViewController (AlertView)

- (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud showText:text duration:duration];
}

@end
