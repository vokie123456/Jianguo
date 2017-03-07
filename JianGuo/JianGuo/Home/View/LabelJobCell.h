//
//  LabelCell.h
//  JGBuss
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelJobCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (nonatomic,assign) BOOL isSelected;
@end
