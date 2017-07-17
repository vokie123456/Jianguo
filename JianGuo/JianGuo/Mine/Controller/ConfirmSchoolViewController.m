//
//  ConfirmSchoolViewController.m
//  JianGuo
//
//  Created by apple on 17/6/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ConfirmSchoolViewController.h"
#import "SearchSchoolViewController.h"

#import "SchoolModel.h"

#import "TextFieldCell.h"

static CGFloat const imageB_Left = 100*2;

@interface ConfirmSchoolViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *schoolId;


@end

@implementation ConfirmSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"学校认证";
    
    UIButton *sureB = [UIButton buttonWithType:UIButtonTypeCustom];
    sureB.frame = CGRectMake(30, self.view.bottom-80, SCREEN_W-60, 40);
    
    [sureB setTitle:@"确认提交" forState:UIControlStateNormal];
    [sureB setBackgroundColor:GreenColor];
    sureB.layer.cornerRadius = 3;
    
    [sureB addTarget:self action:@selector(sureConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureB];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    sectionHeaderView.backgroundColor = WHITECOLOR;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W-20, 50-1)];
    label.textColor = LIGHTGRAYTEXT;
    label.text = @"已认证学校";
    label.font = [UIFont boldSystemFontOfSize:16.f];
    [sectionHeaderView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderView.height-1, SCREEN_W, 1)];
    line.backgroundColor = BACKCOLORGRAY;
    [sectionHeaderView addSubview:line];
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 50+(SCREEN_W-imageB_Left)+20;
    }else if (indexPath.row == 3){
        return 100;
    }else{
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCell *cell = [TextFieldCell  aTextFieldCell];
    
    
    cell.txfName.delegate = self;
    cell.lblText.textColor = LIGHTGRAYTEXT;
    cell.txfName.borderStyle = UITextBorderStyleNone;
    cell.txfName.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.row == 0) {
        
        cell.iconView.image = [UIImage imageNamed:@"icon_card"];
        cell.lblText.text = @"学校全称";
        cell.txfName.placeholder = @"已认证";
        cell.txfName.enabled = NO;
    }else if (indexPath.row == 1){
        
        cell.iconView.image = [UIImage imageNamed:@"icon_card"];
        cell.lblText.text = @"学号";
        cell.txfName.placeholder = @"已认证";
    }else if (indexPath.row == 2){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *leftL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        leftL.text = @"学生证";
        leftL.textColor = LIGHTGRAYTEXT;
        
        UIButton *imageB = [UIButton buttonWithType:UIButtonTypeCustom];
        imageB.frame = CGRectMake(0, 0, SCREEN_W-imageB_Left, SCREEN_W-imageB_Left);
        imageB.center = CGPointMake(SCREEN_W/2, (SCREEN_W-imageB_Left)/2+leftL.bottom+15);
        [imageB setBackgroundImage:[UIImage imageNamed:@"studentidcard"] forState:UIControlStateNormal];
        
        [imageB addTarget:self action:@selector(pickAimage:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:leftL];
        [cell.contentView addSubview:imageB];
        
        return cell;
        
    }else if (indexPath.row == 3){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIButton *sureB = [UIButton buttonWithType:UIButtonTypeCustom];
        sureB.frame = CGRectMake(30, 60, SCREEN_W-60, 40);

        [sureB setTitle:@"确认认证" forState:UIControlStateNormal];
        [sureB setBackgroundColor:GreenColor];
        sureB.layer.cornerRadius = 3;
        
        [sureB addTarget:self action:@selector(sureConfirm:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:sureB];
        
        return cell;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        TextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
        searchVC.hidesBottomBarWhenPushed = YES;
        searchVC.seletSchoolBlock = ^(SchoolModel *school){
            cell.txfName.text = school.name;
            self.schoolId = school.id;
        };
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }
    
}

//选一张图片
-(void)pickAimage:(UIButton *)sender
{
    
}
//确认提交
-(void)sureConfirm:(UIButton *)sender
{
    
}




@end
