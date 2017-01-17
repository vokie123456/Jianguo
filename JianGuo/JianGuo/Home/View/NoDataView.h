//
//  NoDataView.h
//  JianGuo
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface NoDataView : UIView

+(instancetype)aNoDataView;

@property (weak, nonatomic) IBOutlet UIButton *ChangeBtn;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
