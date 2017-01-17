//
//  CustomLayout.h
//  JianGuo
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLayout : UICollectionViewLayout


@property (nonatomic,copy) void (^sendIndexBlock)(NSInteger index);

@end
