//
//  MineNewViewController.h
//  JianGuo
//
//  Created by apple on 17/6/19.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

//枚举
typedef NS_ENUM(NSUInteger,ABCType)
{
    ABCType1 = 1,
    ABCType2 = 2,
    ABCType3 = 3
};


enum ABC {
    ABC_1,
    ABC_2
};

@interface MineNewViewController : NavigatinViewController

{
    ABCType a;
    enum ABC b;
}

@end
