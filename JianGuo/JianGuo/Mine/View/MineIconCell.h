//
//  MineIconCell.h
//  JianGuo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteCellDelegate <NSObject>

-(void)deleteCell:(UIButton *)sender;

@end

@interface MineIconCell : UICollectionViewCell


@property (nonatomic,weak) id <DeleteCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *deleteB;

@end
