//
//  VerLayout.m
//  JianGuo
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "VerLayout.h"

#define leftOrRightInsetSpace 20

@interface VerLayout()

@property (nonatomic,assign) NSInteger cellCount;//cell个数
@property (nonatomic,assign) CGFloat columnSpace;//列间距
@property (nonatomic,assign) UIEdgeInsets itemInsets;//列间距
@property (nonatomic,assign) CGFloat contentX;//collectionview最左边 X 坐标
@property (nonatomic,assign) CGSize itemSize;

@end
@implementation VerLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.columnSpace = 10;
    self.itemInsets = UIEdgeInsetsMake(0, leftOrRightInsetSpace, 0, leftOrRightInsetSpace);
    self.contentX = self.itemInsets.left;
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width-leftOrRightInsetSpace*2, (self.collectionView.frame.size.width-leftOrRightInsetSpace*2)*5/7);
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(SCREEN_W, self.collectionView.height);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *atttibutes = [NSMutableArray array];
    
//    CGRect visiableRect = {CGPointMake(self.collectionView.contentOffset.x, 0),self.collectionView.bounds.size};
    
//    CGFloat centerX = self.collectionView.contentOffset.x+SCREEN_W/2;
    
    
    for (int i=0; i<self.cellCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        [atttibutes addObject:att];
//        if (CGRectIntersectsRect(att.frame, visiableRect) == YES) {
//            CGFloat offsetX = fabs(centerX-att.center.x);
//            CGFloat scale = ABS(1-0.08*offsetX/(SCREEN_W/2));
//            att.transform = CGAffineTransformMakeScale(scale, scale);
//        }
    }
    
    return atttibutes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat w = self.collectionView.width-leftOrRightInsetSpace*2;
    CGFloat h = w*5/7;
    CGFloat x = leftOrRightInsetSpace;
    CGFloat y = ((self.collectionView.height - 2*self.itemSize.height)/3)*(indexPath.item+1)+self.itemSize.height*indexPath.item;
    att.frame = CGRectMake(x, y, w, h);
    
    return att;
    
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
