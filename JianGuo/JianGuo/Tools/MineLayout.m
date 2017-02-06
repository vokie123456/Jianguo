//
//  MineLayout.m
//  JianGuo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineLayout.h"

@implementation MineLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
}
//
//布局前的准备会调用这个方法
-(void)prepareLayout{
    _attributeAttay = [[NSMutableArray alloc]init];
    [super prepareLayout];
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 5;
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    
}
//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    for (int i=0; i<self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attributeAttay addObject:att];
    }
    return _attributeAttay;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.item == 0) {
        attris.frame = CGRectMake(0, 0, self.collectionView.width*2/3-self.minimumInteritemSpacing, self.collectionView.height*2/3-self.minimumLineSpacing);
    }else if (indexPath.item == 1){
        attris.frame = CGRectMake(self.collectionView.width*2/3, 0, self.collectionView.width/3, self.collectionView.height/3-self.minimumInteritemSpacing);
    }else if (indexPath.item == 2){
        attris.frame = CGRectMake(self.collectionView.width*2/3, self.collectionView.width/3, self.collectionView.width/3, self.collectionView.height/3-self.minimumInteritemSpacing);
    }else if (indexPath.item == 5){
        attris.frame = CGRectMake((indexPath.item-3)*(self.collectionView.height/3), self.collectionView.height*2/3, self.collectionView.height/3, self.collectionView.height/3-self.minimumInteritemSpacing);
    }else{
        attris.frame = CGRectMake((indexPath.item-3)*(self.collectionView.height/3), self.collectionView.height*2/3, self.collectionView.height/3-self.minimumInteritemSpacing, self.collectionView.height/3-self.minimumInteritemSpacing);
    }
    
    return attris;
}

@end
