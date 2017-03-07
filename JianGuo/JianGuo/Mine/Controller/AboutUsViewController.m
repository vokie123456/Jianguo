//
//  AboutUsViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "AboutUsViewController.h"
#import "OpinionsViewController.h"
#import "AboutCell.h"
#import "WebViewController.h"

#define LOGOWIDTHEQUELHEIGHT  (SCREEN_W==320?50:70)

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AboutUsViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        _tableView.rowHeight = 45;
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于兼果";
    self.view.backgroundColor = BACKCOLORGRAY;
    
//    [self setUI];
    
    [self.view addSubview:self.tableView];
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2-LOGOWIDTHEQUELHEIGHT/2, LOGOWIDTHEQUELHEIGHT, LOGOWIDTHEQUELHEIGHT, LOGOWIDTHEQUELHEIGHT)];
    logoView.image = [UIImage imageNamed:@"logogreen"];
    
    [bgView1 addSubview:logoView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.bottom, SCREEN_W, 20)];
    versionLabel.font = FONT(14);
    versionLabel.text = [@"兼果:V" stringByAppendingString:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = LIGHTGRAYTEXT;
    
    [bgView1 addSubview:versionLabel];
    
    self.tableView.tableHeaderView = bgView1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, SCREEN_W, 30)];
    label.text = @"兼果在手,兼职我有";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(14);
    label.textColor = LIGHTGRAYTEXT;
    [self.tableView addSubview:label];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:nil options:nil]lastObject];
    cell.contentView.backgroundColor = WHITECOLOR;
    cell.backgroundColor = WHITECOLOR;
    if (indexPath.row == 0) {
        cell.topViewLine.hidden = NO;
        cell.leftL.text = @"去评分";
    }else if (indexPath.row == 1){
        cell.leftL.text = @"兼果用户协议";
    }else if (indexPath.row == 2){
        cell.leftL.text = @"商务合作";
        cell.rightL.text = @"010-53350021";
    }else if (indexPath.row == 3){
        cell.leftL.text = @"兼果官网";
        cell.rightL.text = @"www.jianguojob.com";
        cell.rightView.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//去评分
        //跳转到 appstore 的链接 ,id 不是开发账号里的AppId ,而是综合信息里的 Apple ID
        NSString * urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1067634315"];
        NSURL * url = [NSURL URLWithString:urlStr];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            NSLog(@"can not open");
        }
    }else if (indexPath.row == 1){
        
        WebViewController *webVC = [[WebViewController alloc] init];
//        webVC.title = @"用户协议";
        webVC.url = @"http://101.200.205.243:8080/user_agreement.jsp";
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"呼叫" message:@"010-53350021" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:@"010-53350021"]]];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if (indexPath.row == 3){

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



-(void)setUI
{
    //logo和版本号label
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-LOGOWIDTHEQUELHEIGHT/2, SCREEN_W ==320?50: 100, LOGOWIDTHEQUELHEIGHT, LOGOWIDTHEQUELHEIGHT+20)];
    [self.view addSubview:bgView1];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LOGOWIDTHEQUELHEIGHT, LOGOWIDTHEQUELHEIGHT)];
    logoView.image = [UIImage imageNamed:@"img_logo"];
    
    [bgView1 addSubview:logoView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(-40, logoView.bottom, LOGOWIDTHEQUELHEIGHT+80, 20)];
    versionLabel.font = FONT(12);
    versionLabel.text = [@"兼果:V" stringByAppendingString:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = LIGHTGRAYTEXT;
    
    [bgView1 addSubview:versionLabel];
    
    //点个赞  &   吐个槽
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgView1.bottom+20, SCREEN_W, 120)];
    bgView2.backgroundColor = WHITECOLOR;
    [self.view addSubview:bgView2];
    
    UIImageView *linView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView2.center.x-0.5, 0, 1, 120)];
    linView.image = [UIImage imageNamed:@"icon_xian"];
    [bgView2 addSubview:linView];
    
    //左边
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView2.center.x-(SCREEN_W/4)-28, 20, 55, 55)];
    leftView.userInteractionEnabled = YES;
    leftView.image = [UIImage imageNamed:@"icon_smile"];
    [bgView2 addSubview:leftView];
    
    UIButton *heightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    heightBtn.frame = leftView.bounds;
    heightBtn.tag = 1101;
    heightBtn.backgroundColor = [UIColor clearColor];
    [heightBtn addTarget:self action:@selector(toJudgeOrLow:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:heightBtn];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftView.left, leftView.bottom+5, leftView.width, 20)];
    leftLabel.font = FONT(14);
    leftLabel.text = @"点个赞";
    leftLabel.textColor = LIGHTGRAYTEXT;
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [bgView2 addSubview:leftLabel];
    
    //右边
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView2.center.x+(SCREEN_W/4)-28, 20, 55, 55)];
    rightView.userInteractionEnabled = YES;
    rightView.image = [UIImage imageNamed:@"icon_anger"];
    [bgView2 addSubview:rightView];
    
    UIButton *lowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lowBtn.frame = rightView.bounds;
    lowBtn.tag = 1100;
    lowBtn.backgroundColor = [UIColor clearColor];
    [lowBtn addTarget:self action:@selector(toJudgeOrLow:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:lowBtn];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightView.left, rightView.bottom+5, rightView.width, 20)];
    rightLabel.font = FONT(14);
    rightLabel.text = @"吐个槽";
    rightLabel.textColor = LIGHTGRAYTEXT;
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [bgView2 addSubview:rightLabel];
    
    
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, bgView2.bottom+20, SCREEN_W, 90)];
    bgView3.backgroundColor = WHITECOLOR;
    [self.view addSubview:bgView3];
    
    UILabel *leftL = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
    leftL.text = @"商务合作";
    leftL.font = FONT(14);
    [bgView3 addSubview:leftL];
    
    UIButton *rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_W-150, 2, 130, 40);
    [rightBtn setTitle:@"0898-88557707" forState:UIControlStateNormal];
    [rightBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(14);
    rightBtn.tag = 1000;
    [rightBtn addTarget:self action:@selector(CallAphone:) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:rightBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 45, SCREEN_W-20, 1)];
    lineView.backgroundColor = BACKCOLORGRAY;
    [bgView3 addSubview:lineView];
    
    UILabel *leftLBottom = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 100, 20)];
    leftLBottom.text = @"官方网站";
    leftLBottom.font = FONT(14);
    [bgView3 addSubview:leftLBottom];
    
    UIButton *rightBtnBottom = [UIButton buttonWithType: UIButtonTypeCustom];
    rightBtnBottom.frame = CGRectMake(SCREEN_W-170, 45, 150, 40);
    [rightBtnBottom setTitle:@"www.jianguojob.com" forState:UIControlStateNormal];
    [rightBtnBottom setTitleColor:GreenColor forState:UIControlStateNormal];
    rightBtnBottom.titleLabel.font = FONT(14);
    rightBtnBottom.tag = 1001;
    [rightBtnBottom addTarget:self action:@selector(CallAphone:) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:rightBtnBottom];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView3.bottom+50, SCREEN_W, 30)];
    label.text = @"兼果在手,兼职我有";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(14);
    label.textColor = LIGHTGRAYTEXT;
    [self.view addSubview:label];
    
}
/**
 *  打电话或者去官网
 *
 *  @param btn
 */
-(void)CallAphone:(UIButton *)btn
{
    if (btn.tag == 1000) {//打电话
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"呼叫" message:btn.titleLabel.text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:btn.titleLabel.text]]];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if (btn.tag == 1001){//官网
        
    }
}

/**
 *  好评或吐槽
 */
-(void)toJudgeOrLow:(UIButton *)btn
{
    if (btn.tag == 1101) {//点赞
        //跳转到 appstore 的链接 ,id 不是开发账号里的AppId ,而是综合信息里的 Apple ID
        NSString * urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1067634315"];
        NSURL * url = [NSURL URLWithString:urlStr];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
        }
    }else if (btn.tag == 1100){//吐槽
        OpinionsViewController *opinionVC = [[OpinionsViewController alloc] init];
        [self.navigationController pushViewController:opinionVC animated:YES];
    }
}

@end
