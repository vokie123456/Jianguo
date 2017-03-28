//
//  BusinessCell.h
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailModel;
@protocol ClickCallPhoneDelegate <NSObject>

-(void)callPhoneNum:(NSString *)phoneNo;

@end

@interface BusinessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *renzhengView;
@property (nonatomic,strong) DetailModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *beingCountL;
@property (nonatomic,weak) id<ClickCallPhoneDelegate>delegate;
@end
