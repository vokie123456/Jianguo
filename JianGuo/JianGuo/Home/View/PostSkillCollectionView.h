//
//  PostSkillCollectionView.h
//  JianGuo
//
//  Created by apple on 17/9/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostSkillCollectionView : UICollectionView

/** 图片数组 */
@property (nonatomic,strong) NSMutableArray *imageArr;

/** 图片url数组 */
@property (nonatomic,strong) NSMutableArray *imageUrlArr;



@property (nonatomic,assign) NSInteger count;


@end
