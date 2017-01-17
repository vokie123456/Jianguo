//
//  CustomLayout.m
//  JianGuo
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "CustomLayout.h"

#define leftOrRightInsetSpace 0
#define SCALE 0.8

@interface CustomLayout()

@property (nonatomic,assign) NSInteger cellCount;//cell个数
@property (nonatomic,assign) CGFloat columnSpace;//列间距
@property (nonatomic,assign) UIEdgeInsets itemInsets;//列间距
@property (nonatomic,assign) CGFloat contentX;//collectionview最左边 X 坐标
@property (nonatomic,assign) CGSize itemSize;

@end
@implementation CustomLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.columnSpace = 10;
    self.itemInsets = UIEdgeInsetsMake(0, leftOrRightInsetSpace, 0, leftOrRightInsetSpace);
    self.contentX = self.itemInsets.left;
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width*SCALE, self.collectionView.frame.size.height*SCALE);
    
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(SCREEN_W+(self.itemSize.width+self.collectionView.frame.size.width*(1-SCALE)/20)*(self.cellCount-1), 0);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *atttibutes = [NSMutableArray array];
    
    CGRect visiableRect = {CGPointMake(self.collectionView.contentOffset.x, 0),self.collectionView.bounds.size};
    
    CGFloat centerX = self.collectionView.contentOffset.x+SCREEN_W/2;
    
    
    for (int i=0; i<self.cellCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        [atttibutes addObject:att];
        if (CGRectIntersectsRect(att.frame, visiableRect) == YES) {
            CGFloat offsetX = fabs(centerX-att.center.x);
            CGFloat scale = ABS(1-0.08*offsetX/(SCREEN_W/2));
            att.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    return atttibutes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    CGFloat w = self.collectionView.frame.size.width*SCALE;
    CGFloat h = w*915/587;
    CGFloat x;
    if (indexPath.item==0) {
        x = self.collectionView.frame.size.width*(1-SCALE)/2;
    }else{
        x = self.collectionView.frame.size.width*(1-SCALE)/2+(w+self.collectionView.frame.size.width*(1-SCALE)/20)*indexPath.item;
    }
//    CGFloat x = self.itemInsets.left+(self.itemInsets.right+w)*indexPath.item;
    CGFloat y = self.collectionView.frame.size.height*0.06;
    
    att.frame = CGRectMake(x, y, w, h);
    
    return att;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{

    CGFloat itemIndex = roundf(proposedContentOffset.x/(self.collectionView.frame.size.width*(1-SCALE)/20+self.itemSize.width));
//    CGFloat offsetX = itemIndex*(self.itemInsets.right+self.itemSize.width);
//    CGFloat offsetX_1 = (itemIndex+1)*(self.itemInsets.right+self.itemSize.width);
//    if (fabs(proposedContentOffset.x-offsetX)>fabs(proposedContentOffset.x-offsetX_1)) {
//        self.sendIndexBlock(itemIndex+1);
//        return CGPointMake(offsetX_1, 0);
//    }
    self.sendIndexBlock(itemIndex);
    return CGPointMake(itemIndex*(self.itemSize.width+(1-SCALE)*self.collectionView.frame.size.width/20), 0);
}


@end
