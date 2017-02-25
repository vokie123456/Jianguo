//
//  UIView+Autolayout.m
//  CarPrice
//
//  Created by jun on 10/26/14.
//  Copyright (c) 2014 ATHM. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

+(id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
