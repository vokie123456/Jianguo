//
//  DemandListCell.m
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandListCell.h"
#import <UIImageView+WebCache.h>
#import "DemandModel.h"
#import "DateOrTimeTool.h"
#import "CommentModel.h"
#import "TTTAttributedLabel.h"
#import "JGHTTPClient+Demand.h"
#import "QLAlertView.h"
#import "NSObject+HudView.h"
#import "UIColor+Hex.h"
#import "DemandTypeModel.h"
#import "MineIconCell.h"

#import "LoginNew2ViewController.h"

#import "XLPhotoBrowser.h"

@interface DemandListCell()<UITextFieldDelegate,TTTAttributedLabelDelegate,UICollectionViewDataSource,UICollectionViewDelegate,XLPhotoBrowserDatasource,XLPhotoBrowserDelegate>
{
    NSMutableArray *colorArr;
    NSArray *imageArr;
    __weak IBOutlet NSLayoutConstraint *collectionViewCons;
    __weak IBOutlet NSLayoutConstraint *collectionViewtrailingCons;
}

@property (weak, nonatomic) IBOutlet UILabel *enrollCountL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *genderView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *commentCountL;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *followB;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountL;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;

@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *finishView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end
@implementation DemandListCell

-(void)prepareForReuse
{
    self.finishView.hidden = YES;
    [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"fabulous"] forState:UIControlStateNormal];
    self.coverView.hidden = YES;
    collectionViewCons.constant = (SCREEN_W-25-5*2)/3;
    _model = nil;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


-(void)setModel:(DemandModel *)model
{
    _model = model;

    self.followB.hidden = _model.isFollow.boolValue;

    if (model.enroll_status.integerValue == 0&&model.d_status.integerValue==1) {
        [self.signBtn setTitle:@"报名" forState:UIControlStateNormal];
        [self.signBtn setBackgroundColor:GreenColor];
    }else{
        
        [self.signBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [self.signBtn setBackgroundColor:LIGHTGRAY1];
    }
    if (model.like_status.integerValue == 1) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"fabulous"] forState:UIControlStateNormal];
    }
    self.enrollCountL.text = [NSString stringWithFormat:@"已报名 %@ 人",_model.enrollCount];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.nickname.length?model.nickname:@"未填写";
    self.genderView.image = [UIImage imageNamed:model.sex.integerValue==2?@"boy":@"girlsex"];
    self.titleL.text = model.title;
    if ([model.money containsString:@"."]) {
        self.moneyL.text = [NSString stringWithFormat:@"%.2f元",model.money.floatValue];
    }else{
        self.moneyL.text = [NSString stringWithFormat:@"%@元",model.money];
    }
    self.contentL.text = model.demandDesc;
    
//    NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
    NSMutableArray *arr = @[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"].mutableCopy;
//    for (DemandTypeModel *model in demandTypeArr) {
//        if (model.type_id.integerValue == 0) {
//            continue;
//        }
//        [arr addObject:model.type_name];
//    }
    
    if (model.type.integerValue-1>=0) {
        
        [self.typeBtn setTitle:arr[model.type.integerValue-1] forState:UIControlStateNormal];
        [self.typeBtn setBackgroundColor:colorArr[model.type.integerValue-1]];
    }

    self.schoolL.text = model.userSchoolName?model.userSchoolName:@"未填写";
    NSString *timeStr;
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    NSInteger createTime = [[model.create_time substringToIndex:10] integerValue];
    if (timeNow-createTime<=60) {
        timeStr = [NSString stringWithFormat:@"刚刚 | %@",model.schoolName.length?model.schoolName:model.cityName];
    }else if (timeNow-createTime<60*60){//一个小时以内
        timeStr = [NSString stringWithFormat:@"%ld分钟前 | %@",(NSInteger)(timeNow-createTime)/60,model.schoolName.length?model.schoolName:model.cityName];
    }else if (timeNow-createTime<24*3600){//24小时以内
        timeStr = [NSString stringWithFormat:@"%ld小时前 | %@",(NSInteger)(timeNow-createTime)/3600,model.schoolName.length?model.schoolName:model.cityName];
    }else{
        timeStr = [NSString stringWithFormat:@"%@ | %@",[[DateOrTimeTool getDateStringBytimeStamp:model.createTime.floatValue] substringToIndex:10],model.schoolName.length?model.schoolName:model.cityName];
    }
    self.timeL.text = timeStr;
    self.commentCountL.text = [NSString stringWithFormat:@"%@",model.commentCount];
    self.praiseCountL.text = model.likeCount;
    
    if (model.d_status.integerValue>1) {
        self.coverView.hidden = NO;
        self.finishView.hidden = NO;
        [self.contentView bringSubviewToFront:self.finishView];
    }
    if (model.images.count ==0) {
        collectionViewCons.constant = 0;
    }
    
    [self.collectionView reloadData];
    
}
- (void)awakeFromNib {
    
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    collectionViewCons.constant = (SCREEN_W-25-5*2)/3;
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"MineIconCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:@"MineIconCell"];
    
    NSArray *array = @[@"#feb369",@"#70a9fc",@"#8e96e9",@"#c9a269",@"#fa7070",@"#71c268"];
    colorArr = [NSMutableArray array];
    for (NSString *colorStr in array) {
        [colorArr addObject:[UIColor colorWithHexString:colorStr]];
    }
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)];
    [self.iconView addGestureRecognizer:tap];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    CGRect frame = {CGPointZero,CGSizeMake(40, 40)};
    likeBtn.frame = frame;
    [likeBtn addTarget:self action:@selector(likeTheDemand:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.center = CGPointMake(self.praiseBtn.width/2, self.praiseBtn.height/2);
    [self.praiseBtn addSubview:likeBtn];
//    self.bigBtn=likeBtn;
    
}


//点赞
-(void)likeTheDemand:(UIButton *)btn
{
    NSString *status = _model.like_status.integerValue==1?@"0":@"1";
    
    btn.userInteractionEnabled = NO;
    [JGHTTPClient praiseForDemandWithDemandId:_model.id likeStatus:status Success:^(id responseObject) {
        btn.userInteractionEnabled = YES;
        if ([responseObject[@"code"]integerValue] == 200) {
            _model.like_status = status;
            [self.praiseBtn setBackgroundImage:[UIImage imageNamed:status.integerValue==1?@"xin":@"heart"] forState:UIControlStateNormal];
            
        }
        
    } failure:^(NSError *error) {
        btn.userInteractionEnabled = YES;
        [QLAlertView showAlertTittle:nil message:NETERROETEXT];
    }];
    
}
- (IBAction)followSomeone:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(signDemand:)]) {
        if (USER.tel.length!=11) {
            
            LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
            
            return;
        }
    }
    //1==关注 , 0==取消
    [JGHTTPClient followUserWithUserId:_model.userId status:@"1" Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showAlertViewWithText:@"关注成功" duration:1];
            [sender setHidden:YES];
            _model.isFollow = @"";
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)clickIcon//点击头像
{
    if ([self.delegate respondsToSelector:@selector(clickIcon:)]) {
        [self.delegate clickIcon:_model.userId];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}


-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *userId = [NSString stringWithFormat:@"%@",url];
    JGLog(@"%@",userId);
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch *touch = touches.anyObject;
//
//    CGPoint point = [touch locationInView:touch.view];
//    CGPoint point1 = [touch.view convertPoint:point toView:self.bigBtn];//获取点击点在按钮上的坐标
//    CGRect rect = self.bigBtn.bounds;
// /* 第一种方式 */
//    if (CGRectContainsPoint(rect, point1)) {//这个方法也可以,但是rect必须是self.bigBtn的bounds,不能是它的frame<下边的方法 pointInside: withEvent: 就是这个道理> 因为bounds才是自己的坐标体系,frame是在父控件的坐标体系
//        
//        [self likeTheDemand:self.bigBtn];
//    }else{
//        [super touchesBegan:touches withEvent:event];
//    }
// /* 第二种方式 */
////    if ([self.bigBtn pointInside:point1 withEvent:nil]) {//这个判断方法好使(判断点是不是在调用者<self.bigBtn>范围内)
////        [self likeTheDemand:self.bigBtn];
////    }else{
////        [super touchesBegan:touches withEvent:event];
////    }
//}
//- (IBAction)edit:(UITextField *)sender {
//
//    if (self.sendCellIndex) {
//        self.sendCellIndex(sender);
//    }
//
//    [self.commentTF becomeFirstResponder];
//    
//}

#pragma mark UICollectionView 的代理函数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = _model.images.count;
//    if (count<3) {
        collectionViewtrailingCons.constant = 8+(3-count)*((SCREEN_W-25-5*2)/3);
//    }
    
    return count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MineIconCell";
    MineIconCell *cell = (MineIconCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!200x200",_model.images[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"zwt"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [XLPhotoBrowser showPhotoBrowserWithImages:_model.images currentImageIndex:indexPath.item];
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.item imageCount:_model.images.count datasource:self];
    [browser setActionSheetWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    
}

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    if (actionSheetindex==0) {
        [browser saveCurrentShowImage];
    }
}

-(NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:_model.images[index]];
}

-(UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"placeholderPic"];
}

#pragma mark collectionView Layout 代理方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-25-5*2)/3, (SCREEN_W-25-15)/3);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}



@end
