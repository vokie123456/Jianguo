//
//  TimeCollectionViewCell.h
//  JianGuo
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (nonatomic,copy) NSString *time;

@end
