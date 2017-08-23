//
//  AddressListCell.h
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;

@protocol AddressCellDelegate <NSObject>

-(void)editAddress:(AddressModel *)model;
-(void)deleteAddress:(AddressModel *)model;

@end

@interface AddressListCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet UIButton *editB;
@property (weak, nonatomic) IBOutlet UIButton *deleteB;


@property (nonatomic,weak) id <AddressCellDelegate> delegate;


/** model */
@property (nonatomic,strong) AddressModel *model;

@end
