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
#import "CommentUser.h"
#import "TTTAttributedLabel.h"
#import "JGHTTPClient+Demand.h"
#import "QLAlertView.h"
#import "NSObject+HudView.h"
#import "UIColor+Hex.h"

@interface DemandListCell()<UITextFieldDelegate,TTTAttributedLabelDelegate>
{
    NSMutableArray *colorArr;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *genderView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *commentCountL;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigBtn;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountL;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *finishView;



@end
@implementation DemandListCell

-(void)prepareForReuse
{
    self.finishView.hidden = YES;
    [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
}

-(void)setModel:(DemandModel *)model
{
    _model = model;
    if (model.enroll_status.integerValue == 0&&model.d_status.integerValue==1) {
        [self.signBtn setTitle:@"报名" forState:UIControlStateNormal];
    }else{
        
        [self.signBtn setTitle:@"已报名" forState:UIControlStateNormal];
    }
    if (model.like_status.integerValue == 1) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.anonymous.integerValue==1?@"匿名":(model.nickname?model.nickname:@"未填写");
    self.genderView.image = [UIImage imageNamed:model.sex.integerValue==2?@"man":@"girl"];
    self.titleL.text = model.title;
    self.moneyL.text = [NSString stringWithFormat:@"%@元",model.money];
    self.contentL.text = model.d_describe;
    NSArray *array = @[@"学习",@"代办",@"求助",@"娱乐",@"情感",@"生活"];
    [self.typeBtn setTitle:[[@"  " stringByAppendingString:array[model.d_type.integerValue-1]] stringByAppendingString:@"  "] forState:UIControlStateNormal];
    self.typeBtn.layer.borderColor = [colorArr[model.d_type.integerValue-1] CGColor];
    [self.typeBtn setTitleColor:colorArr[model.d_type.integerValue-1] forState:UIControlStateNormal];
    [self.schoolBtn setTitle:[[@"  " stringByAppendingString:model.school_name] stringByAppendingString:@"  "] forState:UIControlStateNormal];
    self.timeL.text = [@"发布于" stringByAppendingString:[[DateOrTimeTool getDateStringBytimeStamp:model.create_time.floatValue] substringFromIndex:5]];
    self.commentCountL.text = [NSString stringWithFormat:@"%@",model.comment_count];
    self.praiseCountL.text = model.like_count;
    
    if (model.d_status.integerValue >= 4) {
        self.finishView.hidden = NO;
    }
    
//    self.firstCommentL.text = self.secondCommentL.text = self.thirdCommentL.text = nil;
//    if (model.commentEntitys.count == 1){
//        
//        CommentModel *commentModel1 = model.commentEntitys.firstObject;
//
//        [self getStrToLabel:self.firstCommentL WithCommentModel:commentModel1];
//        
//    }else if (model.commentEntitys.count==2){
//        
//        CommentModel *commentModel1 = model.commentEntitys.firstObject;
//        [self getStrToLabel:self.firstCommentL WithCommentModel:commentModel1];
//        
//        CommentModel *commentModel2 = model.commentEntitys.lastObject;
//        [self getStrToLabel:self.secondCommentL WithCommentModel:commentModel2];
//    
//    }else if (model.commentEntitys.count==3){
//        
//        CommentModel *commentModel1 = model.commentEntitys.firstObject;
//        [self getStrToLabel:self.firstCommentL WithCommentModel:commentModel1];
//        
//        CommentModel *commentModel2 =  [model.commentEntitys objectAtIndex:1];
//        [self getStrToLabel:self.secondCommentL WithCommentModel:commentModel2];
//        
//        CommentModel *commentModel3 = model.commentEntitys.lastObject;
//        [self getStrToLabel:self.thirdCommentL WithCommentModel:commentModel3];
    
//    }
    
}
- (IBAction)sign:(id)sender {
    if (_model.enroll_status.integerValue!=0) {
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(signDemand:)]) {
        if (USER.tel.length!=11) {
            [self.delegate signDemand:sender];
            return;
        }
    }
    
    JGSVPROGRESSLOAD(@"正在报名...")
    [JGHTTPClient signDemandWithDemandId:_model.id userId:USER.login_id status:@"1"
                                  reason:nil Success:^(id responseObject) {
                                      [SVProgressHUD dismiss];
                                      
                                      [self showAlertViewWithText:responseObject[@"message"] duration:1];
                                      if ([responseObject[@"code"]integerValue]==200) {
//                                          [sender setBackgroundColor:[UIColor lightGrayColor]];
                                          [sender setTitle:@"已报名" forState:UIControlStateNormal];
                                      }
                                      
                                      
                                  } failure:^(NSError *error) {
                                      [SVProgressHUD dismiss];
                                      [self showAlertViewWithText:NETERROETEXT duration:1];
                                      
                                  }];
    
}


-(void)getStrToLabel:(TTTAttributedLabel *)label WithCommentModel:(CommentModel *)model
{
    
    CommentModel *commentModel1 = model;
    
    CommentUser *commentUser1 = commentModel1.users.firstObject;
    
    BOOL bo1 = commentModel1.user_id.integerValue==commentUser1.userId.integerValue;
    BOOL bo2 = commentModel1.users.count==2;
    
    if (bo2) {
        NSString *str;
        CommentUser *commentUser2 = commentModel1.users.lastObject;
        if (bo1) {
            if (_model.b_user_id.integerValue == commentUser2.userId.integerValue) {
                str = [NSString stringWithFormat:@"%@ :",commentUser1.nickname];
            }else
            str = [NSString stringWithFormat:@"%@ 回复 %@ :",commentUser1.nickname,commentUser2.nickname];
        }else{
            if (_model.b_user_id.integerValue == commentUser1.userId.integerValue) {
                str = [NSString stringWithFormat:@"%@ :",commentUser2.nickname];
            }else
            str = [NSString stringWithFormat:@"%@ 回复 %@ :",commentUser2.nickname,commentUser1.nickname];
        }
        NSString *attStr = [str stringByAppendingString:commentModel1.content];
        
        [label setText:attStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            //        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, mutableAttributedString.length)];//这个设置方式不起作用
            
            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
            
            return mutableAttributedString;
        }];
        UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        //添加点击事件
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        
        label.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        CFRelease(font);

        
        NSRange range1 = [attStr rangeOfString:commentUser1.nickname];
        NSRange range2 = [attStr rangeOfString:commentUser2.nickname];
        NSURL *url1 = [NSURL URLWithString:commentUser1.userId];
        NSURL *url2 = [NSURL URLWithString:commentUser2.userId];
        [label addLinkToURL:url1 withRange:range1];
        [label addLinkToURL:url2 withRange:range2];
        
    }else{
        NSString *attStr = [NSString stringWithFormat:@"%@ : %@",commentUser1.nickname,commentModel1.content];
        
        [label setText:attStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            //        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, mutableAttributedString.length)];//这个设置方式不起作用
            
            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
            
            return mutableAttributedString;
        }];
        UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        //添加点击事件
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        
        label.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        CFRelease(font);
        
        
        NSRange range1 = [attStr rangeOfString:commentUser1.nickname];

        NSURL *url1 = [NSURL URLWithString:commentUser1.userId];

        [label addLinkToURL:url1 withRange:range1];

    }
}

- (void)awakeFromNib {
    
    NSArray *array = @[@"#e29c45",@"#815463",@"#65318e",@"#f8b500",@"#b7282e",@"#006e54"];
    colorArr = [NSMutableArray array];
    for (NSString *colorStr in array) {
        [colorArr addObject:[UIColor colorWithHexString:colorStr]];
    }
    
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    self.commentTF.leftViewMode = UITextFieldViewModeAlways;
//    self.commentTF.leftView = leftView;
//    self.commentTF.layer.cornerRadius = 5;
//    self.commentTF.delegate = self;

    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
//    self.selfIconView.layer.cornerRadius = self.selfIconView.width/2;
//    self.selfIconView.layer.masksToBounds = YES;
//    self.firstCommentL.delegate = self;
//    self.secondCommentL.delegate = self;
//    self.thirdCommentL.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)];
    [self.iconView addGestureRecognizer:tap];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    CGRect frame = {CGPointZero,CGSizeMake(40, 40)};
    likeBtn.frame = frame;
    [likeBtn addTarget:self action:@selector(likeTheDemand:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.center = CGPointMake(self.praiseBtn.width/2, self.praiseBtn.height/2);
    [self.praiseBtn addSubview:likeBtn];
    self.bigBtn=likeBtn;
    
//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//    [self.commentTF addSubview:editBtn];
//    self.editBtn = editBtn;
    
//    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.commentTF.mas_leading);
//        make.trailing.equalTo(self.commentTF.mas_trailing);
//        make.top.equalTo(self.commentTF.mas_top);
//        make.bottom.equalTo(self.commentTF.mas_bottom);
//    }];
    
    
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

-(void)clickIcon//点击头像
{
    if ([self.delegate respondsToSelector:@selector(clickIcon:)]) {
        [self.delegate clickIcon:_model.b_user_id];
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


@end
