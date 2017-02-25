//
//  BrandCell.h
//  CarPrice
//
//  Created by jun on 5/12/14.
//  Copyright (c) 2014 ATHM. All rights reserved.
//

#import "UITableViewCellEx.h"

#define kBrandCellId     (@"BrandCell")
#define kBrandCellHeight (60)

@class MBrand;

@interface BrandCell : UITableViewCellEx


+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void) resetDataWith:(MBrand *)brand;

@end



