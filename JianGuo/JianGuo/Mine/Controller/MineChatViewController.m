//
//  MineChatViewController.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineChatViewController.h"
#import "MineChatCell.h"
#import "JGHTTPClient+Mine.h"
#import "JianliAccount.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"

#define HeaderImageHeight 747/3
#define iconWidth 90

@interface MineChatViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIButton *ageBtn;
@property (nonatomic,strong) UILabel *starL;
@property (nonatomic,strong) JianliAccount *account;

@end

@implementation MineChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人页";
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self addInsetScaleImageView];
    
    [self request];
}


- (IBAction)contact:(id)sender {
}

-(void)request
{
    JGSVPROGRESSLOAD(@"正在拼命加载中...");
    [JGHTTPClient getJianliInfoByloginId:[JGUser user].login_id Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if (responseObject) {
            
            self.account = [JianliAccount mj_objectWithKeyValues:responseObject[@"data"]];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.account.head_img_url] placeholderImage:[UIImage imageNamed:@"myicon"]];
            NSString *timeNow = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSInteger age = [timeNow substringToIndex:4].integerValue - [self.account.birth_date substringToIndex:4].integerValue;
            [self.ageBtn setTitle:[NSString stringWithFormat:@"%ld",age] forState:UIControlStateNormal];
            if (self.account.sex.integerValue == 1) {//女
                [self.ageBtn setImage:[UIImage imageNamed:@"girlclear"] forState:UIControlStateNormal];
            }else{
                [self.ageBtn setImage:[UIImage imageNamed:@"boyclear"] forState:UIControlStateNormal];
            }
//            NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
            self.starL.text = [DateOrTimeTool getConstellation:self.account.birth_date]?[DateOrTimeTool getConstellation:self.account.birth_date]:@"未填写";
            self.nameL.text = self.account.nickname;
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.account.is_student? 4:3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineChatCell *cell = [MineChatCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.leftL.text = @"身高:";
        cell.contentL.text = self.account.height.integerValue == 0?@"未填写":self.account.height;
    }else if (indexPath.row == 1){
        cell.leftL.text = @"学校:";
        cell.contentL.text = self.account.school_name;
        if (!self.account.is_student) {
            cell.leftL.text = @"地址:";
            cell.contentL.text = self.account.school_name;
        }
    }else if (indexPath.row == 2){
        cell.leftL.text = @"入学时间:";
        cell.contentL.text = self.account.intoschool_date;
        
        if (!self.account.is_student) {
            cell.leftL.text = @"我的特长:";
            cell.contentL.text = self.account.introduce;
        }
    }else if (indexPath.row == 3){
        cell.leftL.text = @"我的特长:";
        cell.contentL.text = self.account.introduce;
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -HeaderImageHeight) {
        self.tableView.contentInset = UIEdgeInsetsMake(HeaderImageHeight, 0, 0, 0);
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
        
        CGRect rect2 = self.iconView.frame;
        rect2.origin.y = rect.size.height-100-iconWidth;
        self.iconView.frame = rect2;
        
        CGRect rect3 = self.nameL.frame;
        rect3.origin.y = rect.size.height-90;
        self.nameL.frame = rect3;
        
        CGRect rect4 = self.ageBtn.frame;
        rect4.origin.y = rect.size.height-55;
        self.ageBtn.frame = rect4;
        
        CGRect rect5 = self.starL.frame;
        rect5.origin.y = rect.size.height-55;
        self.starL.frame = rect5;
    }
}
-(void)addInsetScaleImageView
{
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -HeaderImageHeight, SCREEN_W, HeaderImageHeight)];
    //    self.demandView = imageView;
    imageView.image = [UIImage imageNamed:@"chart2"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 101;
    
    
    [self.tableView addSubview:imageView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-iconWidth)/2, imageView.height-iconWidth-100, iconWidth, iconWidth)];
    iconView.layer.cornerRadius = iconWidth/2;
    iconView.layer.masksToBounds = YES;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.image = [UIImage imageNamed:@"kobe"];
    
    [imageView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.height-90, SCREEN_W, 25)];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.textColor = WHITECOLOR;
    nameL.text = @"科比";
    nameL.font = [UIFont boldSystemFontOfSize:18];
    
    [imageView addSubview:nameL];
    self.nameL = nameL;
    
    UIButton *ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ageBtn.frame = CGRectMake(SCREEN_W/2-40, imageView.height-55, 35, 15);
    ageBtn.backgroundColor = RGBCOLOR(235, 105, 72);
    [ageBtn setTitle:@"26" forState:UIControlStateNormal];
    ageBtn.titleLabel.font = FONT(10);
    ageBtn.layer.cornerRadius = 2;
    [imageView addSubview:ageBtn];
    ageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    self.ageBtn = ageBtn;
    
    UILabel *starL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2+5, imageView.height-55, 40, 15)];
    starL.layer.cornerRadius = 2;
    starL.layer.masksToBounds = YES;
    starL.textAlignment = NSTextAlignmentCenter;
    starL.textColor = WHITECOLOR;
    starL.backgroundColor = RGBCOLOR(37, 180, 176);
    starL.text = @"天蝎座";
    starL.font = FONT(10);
    [imageView addSubview:starL];
    self.starL = starL;
    
    self.tableView.contentInset = UIEdgeInsetsMake(HeaderImageHeight, 0, 0, 0);
    //    self.tableView.tableHeaderView = imageView;
    
}

@end
