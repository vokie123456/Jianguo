//
//  NoDataView.m
//  JianGuo
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

+(instancetype)aNoDataView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:nil options:nil]lastObject];
    
}

-(void)awakeFromNib
{
    self.frame = CGRectMake(0, 0, SCREEN_W, 280);

}

@end
