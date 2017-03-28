//
//  SelectCollectionCell.m
//  JGBuss
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SelectCollectionCell.h"
#import "LabelJobCell.h"
#import "LimitModel.h"
#import "LabelModel.h"
#import "WelfareModel.h"

#define FontSize 14
static NSString *identifier = @"LabelJobCell";

@interface SelectCollectionCell()<UICollectionViewDataSource , UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout>
{
    UICollectionViewFlowLayout *layout;
    NSMutableArray *limitArr;
    NSMutableArray *welfareArr;
    NSMutableArray *labelArr;
    NSInteger count;
}

@end
@implementation SelectCollectionCell


-(void)layoutSubviews{
    
//    [USERDEFAULTS setFloat:0 forKey:@"collectionHeight"];
    if (IS_IPHONE6||IS_IPHONE6PLUS) {
        if (self.collectionView.contentSize.height+37!=[USERDEFAULTS floatForKey:@"collectionHeight"]&&self.collectionView.contentSize.height!=0) {
            [USERDEFAULTS setFloat:self.collectionView.contentSize.height+37 forKey:@"collectionHeight"];
            CGRect rect = self.collectionView.frame;
            [self.collectionView setFrame:CGRectMake(rect.origin.x, rect.origin.y, self.collectionView.contentSize.width, self.collectionView.contentSize.height)];
            JGLog(@"=======%@",self.collectionView);
            [NotificationCenter postNotificationName:@"contentSizeChanged" object:nil];
        }
    }
    
    JGLog(@"%@",self.collectionView);
    
}

-(void)setDetailModel:(DetailModel *)detailModel
{
    _detailModel = detailModel;
    
//    self.dataArr = [NSMutableArray array];
    /*
    for (NSString *ID in detailModel.label) {
        NSArray *labels = JGKeyedUnarchiver(JGLabelArr);
        [labels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LabelModel *model = obj;

            if (ID.integerValue == model.id.integerValue) {
                [self.dataArr addObject:model.name];
            }

        }];
    }
    
    for (NSString *ID in detailModel.limits) {
        NSArray *labels = JGKeyedUnarchiver(JGLimitArr);
        [labels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LimitModel *model = obj;
            
            if (ID.integerValue == model.id.integerValue) {
                [self.dataArr addObject:model.name];
            }
            
        }];
    }
    
    for (NSString *ID in detailModel.welfare) {
        NSArray *labels = JGKeyedUnarchiver(JGWelfareArr);
        [labels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WelfareModel *model = obj;
            
            if (ID.integerValue == model.id.integerValue) {
                [self.dataArr addObject:model.name];
            }
            
        }];
    }
    */
//    [self.collectionView reloadData];
}



-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    [self.collectionView reloadData];
 
}

- (void)awakeFromNib {
    
    self.dataArr = [NSMutableArray array];
    limitArr = [NSMutableArray array];
    welfareArr = [NSMutableArray array];
    labelArr = [NSMutableArray array];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:identifier];
    
    //添加监听者
    [self.collectionView addObserver: self forKeyPath: @"contentSize" options: NSKeyValueObservingOptionNew context: nil];
    
    
}

/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    if (IS_IPHONE5||IS_IPHONE4) {
//        
        if (self.collectionView.contentSize.height+37!=[USERDEFAULTS floatForKey:@"collectionHeight"]) {
            
            [USERDEFAULTS setFloat:self.collectionView.contentSize.height+37 forKey:@"collectionHeight"];
            CGRect rect = self.collectionView.frame;
            [self.collectionView setFrame:CGRectMake(rect.origin.x, rect.origin.y, self.collectionView.contentSize.width, self.collectionView.contentSize.height)];
            [NotificationCenter postNotificationName:@"contentSizeChanged" object:nil];
            
//        }
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelJobCell *cell = (LabelJobCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.contentL.text = self.dataArr[indexPath.row];
    return cell;
}


#pragma mark collectionView Layout 代理方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    count ++;
    NSString *string = self.dataArr[indexPath.row];
    CGRect rect;
    rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(FontSize),NSForegroundColorAttributeName:[UIColor redColor]} context:nil];
    rect.size.height+=10;
    rect.size.width+=10;
    
    return rect.size;
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 5, 5);
}


-(void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize" ];
}

@end
