//
//  HeaderView.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "HeaderView.h"
#import "SDCycleScrollView.h"
#import "JGHTTPClient+Home.h"
#import "ImagesModel.h"
#import "CityModel.h"

#define Height 290-105

@interface HeaderView()<SDCycleScrollViewDelegate>

{
    NSArray *imgs;
    NSArray *texts;
    NSArray *tittleImgs;
}
@property (nonatomic,strong) NSMutableArray *imageModelArr;
@property (nonatomic,strong) NSMutableArray *cityModelArr;
@property (nonatomic,strong) NSMutableArray *imgsArr;
@property (nonatomic,strong) NSMutableArray *citiesArr;
@end

@implementation HeaderView

-(NSMutableArray *)imgsArr
{
    if (!_imgsArr) {
        _imgsArr = [NSMutableArray array];
    }
    return _imgsArr;
}
-(NSMutableArray *)citiesArr
{
    if (!_citiesArr) {
        _citiesArr = [NSMutableArray array];
    }
    return _citiesArr;
}

+(instancetype) aHeaderView
{
    CGFloat height;
    
    if (SCREEN_W == 320) {
        height = Height*(SCREEN_W/375)-50;
    }else if (SCREEN_W == 375){
        height = Height*(SCREEN_W/375)-3;
    }else if (SCREEN_W == 414){
        height = Height*(SCREEN_W/375)+25;
    }
    
    HeaderView *bgView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    
    bgView.backgroundColor = BACKCOLORGRAY;
    
    
    
    [bgView setSubviews:bgView];
    
    
    return bgView;
}

-(void)setSubviews:(HeaderView *)bgView
{
    imgs = @[@"img_jingpin",@"img_lvyou",@"img_rijie",@"img_my"];
    texts = @[@"优质商家提供",@"穷游世界马上走",@"百元工资当日领取",@"长期兼职来这里"];
    tittleImgs = @[@"icon_jingpin2",@"icon_lvxing",@"icon_rijie",@"icon_my3"];
    
    SDCycleScrollView  *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_W, 168*(SCREEN_W/375)) imageURLStringsGroup:@[@"bg-chahua",@"bg-chahua",@"bg-chahua"]];
    scrollView.localizationImageNamesGroup = @[@"kobe",@"kobe",@"kobe"];
    IMP_BLOCK_SELF(HeaderView)
    [JGHTTPClient getImgsOfScrollviewWithCategory:@"2" Success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[@"code"] integerValue] == 200) {
                
                self.imageModelArr = [ImagesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                for (ImagesModel *model in self.imageModelArr) {
                    [block_self.imgsArr addObject:model.image];
                }
                scrollView.imageURLStringsGroup = self.imgsArr;
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    //设置pageControl位置
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    scrollView.delegate = self;
    // 自定义分页控件小圆标颜色
    scrollView.currentPageDotColor = YELLOWCOLOR;
    scrollView.pageDotColor = WHITECOLOR;
    [scrollView setShowPageControl:YES];
    scrollView.pageControlDotSize = CGSizeMake(100, 20);
    
    [bgView addSubview:scrollView];

//    for (int i = 0; i<4; i++) {
//        [self createFourView:bgView count:i scrollView:scrollView];
//    }
    
    //四个小view中的一个
//    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom+9, (SCREEN_W-6)/2, 50)];
//    firstView.backgroundColor = WHITECOLOR;
    
    //精品兼职 这张图片
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 5, 50, 20)];
//    imgView.image = [UIImage imageNamed:@""];
//    [firstView addSubview:imgView];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.left, imgView.bottom, 80, 30)];
//    label.text = @"优质商家提供";
//    label.textColor = RGBCOLOR(155, 155, 155);
//    label.font = FONT(12);
//    [firstView addSubview:label];
//    
//    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(label.right, 0, 70, 50)];
//    rightImg.image = [UIImage imageNamed:@"img_jingpin"];
//    [firstView addSubview:rightImg];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor clearColor];
//    [btn addTarget:self action:@selector(ClickLittleBtn:) forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = firstView.bounds;
//    
//    [bgView addSubview:firstView];


}

-(void)createFourView:(HeaderView *)bgView count:(int)i scrollView:(SDCycleScrollView *)scrollView
{
    CGRect frame;
    switch (i) {
        case 0:
            frame = CGRectMake(2, scrollView.bottom+9, (SCREEN_W-6)/2, 50);
            break;
        case 1:
            frame = CGRectMake((SCREEN_W-4)/2+3, scrollView.bottom+9, (SCREEN_W-6)/2, 50);
            break;
        case 2:
            frame = CGRectMake(2, scrollView.bottom+62, (SCREEN_W-6)/2, 50);
            break;
        case 3:
            frame = CGRectMake((SCREEN_W-4)/2+3, scrollView.bottom+62, (SCREEN_W-6)/2, 50);
            break;
            
        default:
            break;
    }
    
    
    //四个小view中的一个
    UIView *firstView = [[UIView alloc] initWithFrame:frame];
    firstView.backgroundColor = WHITECOLOR;
    
    //精品兼职 这张图片
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 5, 50, 20)];
//    imgView.image = [UIImage imageNamed:@""];
//    [firstView addSubview:imgView];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 5, 80, 20)];
    imgView.image = [UIImage imageNamed:tittleImgs[i]];
    [firstView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.left, imgView.bottom, 80, 30)];
    label.text = texts[i];
    label.textColor = RGBCOLOR(155, 155, 155);
    label.font = FONT(10);
    [firstView addSubview:label];

    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(firstView.width-(SCREEN_W==320?70:75), 0, 75, 50)];
    rightImg.image = [UIImage imageNamed:imgs[i]];
    [firstView addSubview:rightImg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = 1000+i;
    [btn addTarget:self action:@selector(ClickLittleBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = firstView.bounds;
    [firstView addSubview:btn];
    
    [bgView addSubview:firstView];
}

-(void)ClickLittleBtn:(UIButton *)btn
{
    if (btn.tag == 1000) {//精品兼职
        if ([self.delegate respondsToSelector:@selector(clickOneOfFourBtns:)]) {
            [self.delegate clickOneOfFourBtns:@"1"];
        }
        
    }else if (btn.tag == 1001){//旅行兼职
    
        if ([self.delegate respondsToSelector:@selector(clickOneOfFourBtns:)]) {
            [self.delegate clickOneOfFourBtns:@"2"];
        }
        
    }else if (btn.tag == 1002){//日结兼职
    
        if ([self.delegate respondsToSelector:@selector(clickOneOfFourBtns:)]) {
            [self.delegate clickOneOfFourBtns:@"3"];
        }
        
    }else if (btn.tag == 1003){
    
        if ([self.delegate respondsToSelector:@selector(clickOneOfFourBtns:)]) {
            [self.delegate clickOneOfFourBtns:@"4"];
        }
        
    }
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{//点击轮播图的代理方法
    ImagesModel *model = self.imageModelArr[index];
    if ([self.delegate respondsToSelector:@selector(clickScollViewforUrl:)]) {
        [self.delegate clickScollViewforUrl:model.url];
    }
}

@end

