//
//  PostDemandPictureCell.h
//  JianGuo
//
//  Created by apple on 17/6/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshCollectionViewSizeDelegate <NSObject>

-(void)refreshCollectionView:(NSArray *)imageArray;

@end

@interface PostDemandPictureCell : UITableViewCell


@property (nonatomic,weak) id<RefreshCollectionViewSizeDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign) NSArray *imagesArr;


@end
