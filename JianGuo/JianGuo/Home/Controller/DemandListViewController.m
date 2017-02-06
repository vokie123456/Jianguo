//
//  DemandListViewController.m
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandListViewController.h"
#import "DemandListCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <IQKeyboardManager.h>
#import "DemandDetailController.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "YYFPSLabel.h"
#import "CommentInputView.h"

static NSString *identifier = @"DemandListCell";

@interface DemandListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ClickLikeBtnDelegate,FinishEditDelegate>{
    
    UIView *inputView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *emojiBtn;
@property (nonatomic,strong) UITextView *commentTV;
@property (nonatomic,weak) CommentInputView *commentView;
@property (nonatomic,strong) DemandModel *currentModel;

@end

@implementation DemandListViewController

- (IBAction)clickEmoji:(UIButton *)sender {
    
    
    
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YYFPSLabel *fps = [YYFPSLabel new];
    fps.center = CGPointMake(60, self.view.bottom-100);
    [self.view addSubview:fps];
    
    self.navigationItem.title = @"需求大厅";
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    self.tableView.estimatedRowHeight = 240;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    
    [self requestWithCount:1];
    
}

-(void)customCommentKeyboard
{
    CommentInputView *view = [CommentInputView aReplyCommentView:nil];
    self.commentView = view;
    self.commentTV = view.commentTV;
    view.delegate = self;
    [APPLICATION.keyWindow addSubview:view];
    [APPLICATION.keyWindow bringSubviewToFront:view];
    
    
    if (self.commentView.commentTV.text.length) {
        CGRect rect = [self.commentView.commentTV.text boundingRectWithSize:CGSizeMake(self.commentView.commentTV.size.width,   MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.commentView.commentTV.font} context:nil];
        self.commentView.frame = CGRectMake(0, 0, SCREEN_W, rect.size.height+10);
    }else{
        self.commentView.frame = CGRectMake(0, 0, SCREEN_W, 40);
    }
    
    self.commentView.center = CGPointMake(SCREEN_W/2,self.view.bottom+100);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [self customCommentKeyboard];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.commentView removeFromSuperview];//从父视图上删除并没有把对象置空
    self.commentView = nil;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)requestWithCount:(NSInteger)pageCount
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getDemandListWithSchoolId:@"1" type:@"2" sex:@"1" userId:USER.login_id pageCount:[NSString stringWithFormat:@"%ld",pageCount] Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DemandModel *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    cell.delegate = self;
    
    IMP_BLOCK_SELF(DemandListViewController);
    cell.sendCellIndex = ^(id object){
        JGLog(@"%@",model);
        block_self.currentModel = model;
    };
    
    return cell;
}

-(void)clickLike:(DemandModel *)model
{
    NSString *status = model.like_status.integerValue==1?@"1":@"0";
    
    [JGHTTPClient praiseForDemandWithDemandId:model.id likeStatus:status Success:^(id responseObject) {
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandDetailController *detailVC = [DemandDetailController new];
    detailVC.demandId = [(DemandModel *)self.dataArr[indexPath.row] id];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)keyboardWillAppear:(NSNotification *)noti
{
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
          self.commentView.frame = CGRectMake(0, SCREEN_H-rect.size.height-self.commentView.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
        [self.commentTV becomeFirstResponder];
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
//        self.commentView.transform = CGAffineTransformIdentity;
        self.commentView.frame = CGRectMake(0, rect.origin.y+rect.size.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {//拦截点击retrun按钮时间,并不影响换行按钮事件
        if (self.commentTV.text.length == 0) {
            [self showAlertViewWithText:@"评论点儿东西吧" duration:1];
            return NO;
        }
        JGLog(@"%@ ––––––> %@",self.currentModel.title,self.currentModel.id);
        
        [JGHTTPClient postAcommentWithDemandId:self.currentModel.id content:self.commentView.commentTV.text userId:USER.login_id toUserId:self.currentModel.b_user_id Success:^(id responseObject) {
            
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            
        } failure:^(NSError *error) {
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
        
        [textView resignFirstResponder];
        textView.text = nil;
        return NO;
    }
    return YES;
}

-(void)finishEdit
{
    if (self.commentTV.text.length == 0) {
        [APPLICATION.keyWindow endEditing:YES];
        [self showAlertViewWithText:@"评论点儿东西吧" duration:1];
        return;
    }
    [JGHTTPClient postAcommentWithDemandId:self.currentModel.id content:self.commentView.commentTV.text userId:USER.login_id toUserId:self.currentModel.b_user_id Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
    [self.commentTV resignFirstResponder];
    self.commentTV.text = nil;
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}



@end
