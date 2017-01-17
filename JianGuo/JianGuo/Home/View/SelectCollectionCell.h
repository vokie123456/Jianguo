//
//  SelectCollectionCell.h
//  JGBuss
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface SelectCollectionCell : UITableViewCell

@property (nonatomic,copy) void(^selectBlock)(NSString *jsonArr);

@property (nonatomic,strong) DetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger modelType;
@end
