//
//  NavigatinViewController+Drawer.h
//  JianGuo
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

#define kDrawerOpenX  (70)


@interface NavigatinViewController (Drawer)

/**
 *  配置抽屉
 *
 *  @param content       要放在抽屉里的容器view
 *  @param scrollContent 要放在抽屉里的可滚动scrollView，用于滑动时禁止滚动
 *
 *  @return drawer的引用
 */
- (UIView *) setupDrawerWithContent:(UIView *)content
                       scrollConent:(UIScrollView *)scrollContent;

/**
 *  显示抽屉
 */
- (void)showDrawer;

/**
 *  关闭抽屉
 */
- (void)closeDrawer;

/**
 *  显示和隐藏drawer的loading
 */
- (void)drawerStartLoading;
- (void)drawerStopLoading;

/**
 *  关闭抽屉时会回调的方法，子类可以通过重写来控制关闭后的操作（比如去除cell的选中状态）
 */
- (void) openDrawerCompleted;
- (void) closeDrawerCompleted;


@end
