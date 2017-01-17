//
//  JobCollectionViewCell.h
//  JianGuo
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PartTypeModel;
@interface JobCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) PartTypeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (nonatomic,assign) BOOL isSelected;
@end
