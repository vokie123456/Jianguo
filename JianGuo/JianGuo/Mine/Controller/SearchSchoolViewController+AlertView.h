//
//  SearchSchoolViewController+AlertView.h
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SearchSchoolViewController.h"

@interface SearchSchoolViewController (AlertView)
/**
 *  显示提示信息
 *
 *  @param text 信息
 */
- (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration;

@end
