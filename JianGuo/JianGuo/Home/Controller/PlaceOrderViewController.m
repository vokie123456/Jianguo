//
//  PlaceOrderViewController.m
//  JianGuo
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PlaceOrderViewController.h"

#import "OrderTitleCell.h"
#import "OrderCountCell.h"

#import "UITextView+placeholder.h"

@interface PlaceOrderViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation PlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    
}
- (IBAction)surePlaceOrder:(UIButton *)sender {
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0.1:10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else{
        if (indexPath.row == 0) {
            return 80;
        }else if (indexPath.row == 1){
            return 44;
        }else if (indexPath.row == 2){
            return 115;
        }else
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?2:3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
            CGPoint center = CGPointMake(15+label.width/2, cell.contentView.center.y);
            label.center = center;
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"服务方式:";
            label.textColor = LIGHTGRAYTEXT;
            [cell.contentView addSubview:label];
            
            UILabel *textL =[[UILabel alloc] initWithFrame:CGRectMake(label.right+10, 0, 150, 44)];
            textL.font = [UIFont systemFontOfSize:16];
            textL.text = @"上门";
            textL.textColor = LIGHTGRAYTEXT;
            [cell.contentView addSubview:textL];
            
            UIView *line = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.height-1, SCREEN_W, 1)];
                view.backgroundColor = BACKCOLORGRAY;
                view;
            });
            [cell.contentView addSubview:line];
            
            
        }else if (indexPath.row == 1){
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
            CGPoint center = CGPointMake(15+label.width/2, cell.contentView.center.y);
            label.center = center;
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"我的地址:";
            label.textColor = LIGHTGRAYTEXT;
            [cell.contentView addSubview:label];
            
            UILabel *textL =[[UILabel alloc] initWithFrame:CGRectMake(label.right+10, 0, 150, 44)];
            textL.font = [UIFont systemFontOfSize:16];
            textL.text = @"点击添加地址";
            textL.textColor = LIGHTGRAYTEXT;
            [cell.contentView addSubview:textL];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    }else{
        if (indexPath.row == 0) {
            OrderTitleCell *cell = [OrderTitleCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            OrderCountCell *cell = [OrderCountCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
//            CGPoint center = CGPointMake(15+label.width/2, cell.contentView.center.y);
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"买家留言";
            label.textColor = LIGHTGRAYTEXT;
            [cell.contentView addSubview:label];
            
            UITextView *textV = ({
                UITextView *view = [[UITextView alloc] initWithFrame:CGRectMake(label.right, 15, SCREEN_W-label.right-20-10, 80)];
                view.font = FONT(14);
                view.backgroundColor = BACKCOLORGRAY;
                view.placeholder = @"请输入您的留言...";
                view;
            });
            [cell.contentView addSubview:textV];
            return cell;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
