//
//  SkillExpertCell.m
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillExpertCell.h"

#import "MineIconCell.h"
#import "SkillsExpertBoardCell.h"

#import "SkillExpertModel.h"

#define sizeWidth 90

@interface SkillExpertCell() <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SkillExpertCell

- (void)awakeFromNib {
    self.collectionView.bounces = NO;
    [self configCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    [self.collectionView reloadData];
}


#pragma mark 设置头部滑动的标题 <UICollectionView>
-(void)configCollectionView
{
    self.collectionView.backgroundColor = WHITECOLOR;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SkillsExpertBoardCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SkillsExpertBoardCell class])];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count?_dataArr.count:5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SkillsExpertBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SkillsExpertBoardCell class]) forIndexPath:indexPath];
    
    if (_dataArr.count) {
        cell.model = _dataArr[indexPath.item];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(sizeWidth, 125);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGLog(@"%ld",indexPath.item);
    if ([self.delegate respondsToSelector:@selector(clickPersonIcon:)]) {
        if (_dataArr.count) {
            SkillExpertModel * model = _dataArr[indexPath.item];
            [self.delegate clickPersonIcon:model];
        }
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGLog(@"%ld",indexPath.item);
}

@end
