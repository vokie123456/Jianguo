//
//  MineLayout.m
//  JianGuo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineLayout.h"

#define cellHeight 45

@implementation MineLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
    NSInteger firstSectionCount;
    NSInteger secondSectionCount;
}
//
//布局前的准备会调用这个方法
-(void)prepareLayout{
    _attributeAttay = [[NSMutableArray alloc]init];
    [super prepareLayout];
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 5;
    firstSectionCount = [self.collectionView numberOfItemsInSection:0];
    secondSectionCount = [self.collectionView numberOfItemsInSection:1];
    
    self.itemCount = firstSectionCount+secondSectionCount;
    
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.width, self.collectionView.width+60+cellHeight*(secondSectionCount-1)+10);
}

//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    for (int i=0; i<self.itemCount; i++) {
        if (i<firstSectionCount) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
            [_attributeAttay addObject:att];
            
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i-firstSectionCount inSection:1];
            UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
            [_attributeAttay addObject:att];
        }
    }
    return _attributeAttay;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            attris.frame = CGRectMake(0, 0, self.collectionView.width*2/3-self.minimumInteritemSpacing, self.collectionView.width*2/3-self.minimumLineSpacing);
        }else if (indexPath.item == 1){
            attris.frame = CGRectMake(self.collectionView.width*2/3, 0, self.collectionView.width/3, self.collectionView.width/3-self.minimumInteritemSpacing);
        }else if (indexPath.item == 2){
            attris.frame = CGRectMake(self.collectionView.width*2/3, self.collectionView.width/3, self.collectionView.width/3, self.collectionView.width/3-self.minimumInteritemSpacing);
        }else if (indexPath.item == 5){
            attris.frame = CGRectMake((indexPath.item-3)*(self.collectionView.width/3), self.collectionView.width*2/3, self.collectionView.width/3, self.collectionView.width/3-self.minimumInteritemSpacing);
        }else{
            attris.frame = CGRectMake((indexPath.item-3)*(self.collectionView.width/3), self.collectionView.width*2/3, self.collectionView.width/3-self.minimumInteritemSpacing, self.collectionView.width/3-self.minimumInteritemSpacing);
        }
    }else{
        JGLog(@"%ld === %ld",indexPath.section,indexPath.item);
        CGFloat cellY;
        if (indexPath.item == 0) {
            cellY = self.collectionView.width+10;
            attris.frame = CGRectMake(0, cellY, self.collectionView.width, 60);
        }else{
            cellY = self.collectionView.width + 60 + 10 + cellHeight*(indexPath.item-1);
            attris.frame = CGRectMake(0, cellY, self.collectionView.width, cellHeight);
        }
        
    }
    
    return attris;
}

@end
