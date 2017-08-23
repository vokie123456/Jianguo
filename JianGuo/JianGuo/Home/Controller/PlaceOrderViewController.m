//
//  PlaceOrderViewController.m
//  JianGuo
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PlaceOrderViewController.h"
#import "AddressListViewController.h"
#import "MyBuySkillDetailViewController.h"

#import "JGHTTPClient+Skill.h"

#import "OrderTitleCell.h"
#import "OrderCountCell.h"
#import "AddressListCell.h"

#import "AddressModel.h"

#import "UITextView+placeholder.h"
#import "UIimageView+WebCache.h"

@interface PlaceOrderViewController () <UITableViewDataSource,UITableViewDelegate,OrderCountCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (strong, nonatomic) UILabel *serviceL;
/** titleL */
@property (nonatomic,strong) UILabel *titleL;
/** skillView */
@property (nonatomic,strong) UIImageView *iconView;
@property (strong, nonatomic) UITextField *countTF;
@property (strong, nonatomic) UITextView *noteTV;

@property (nonatomic,strong) AddressModel *addressModel;

@property (nonatomic,strong) AddressListCell *cell;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation PlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    self.moneyL.text = self.price;
    
}

-(void)countChanged:(NSString *)count
{

    NSString *sumMoney = [NSString stringWithFormat:@"￥ %.2f",count.integerValue*([[[self.price componentsSeparatedByString:@" "] lastObject] floatValue])];
    self.moneyL.text = sumMoney;
}

- (IBAction)surePlaceOrder:(UIButton *)sender {
    
    if (self.serviceMode != 2&&self.serviceMode!=1) {
        
        if (!self.addressModel) {
            [self showAlertViewWithText:@"请选择联系地址!" duration:2];
            return;
        }
    }
    
    JGSVPROGRESSLOAD(@"正在下单...")
    [JGHTTPClient placeOrderWithSkillId:self.skillId price:[[self.moneyL.text componentsSeparatedByString:@" "] lastObject] skillCount:self.countTF.text addressId:self.addressModel.id orderMessage:self.noteTV.text Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            MyBuySkillDetailViewController *detailVC = [[MyBuySkillDetailViewController alloc] init];
            detailVC.orderNo = responseObject[@"data"][@"orderNo"];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1.5f];
    }];
    
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
        if (self.addressModel&&indexPath.row==1) {
            return  self.cell.height-30; // 自适应单元格高度
        }
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
    if (section == 0) {
        if (self.serviceMode!=2&&self.serviceMode!=1) {
            return 2;
        }else
            return 1;
    }else{
        return 3;
    }
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
            textL.text = self.serviceModeStr;
            textL.textColor = LIGHTGRAYTEXT;
            [cell.contentView addSubview:textL];
            self.serviceL = textL;
            
            UIView *line = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.height-1, SCREEN_W, 1)];
                view.backgroundColor = BACKCOLORGRAY;
                view;
            });
            [cell.contentView addSubview:line];
            
            
        }else if (indexPath.row == 1){
            
            if (self.addressModel) {
                self.cell.model = self.addressModel;
                return self.cell;
            }
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
            cell.titleL.text = self.skillTitle;
            cell.moneyL.text = self.price;
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.coverImg]] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            OrderCountCell *cell = [OrderCountCell cellWithTableView:tableView];
            self.countTF = cell.countTF;
            cell.delegate = self;
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
                self.noteTV = view;
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
    if (indexPath.row == 1&&indexPath.section == 0) {
        
        AddressListViewController *adListVC = [[AddressListViewController alloc] init];
        adListVC.isFromPlaceOrderVC = YES;
        IMP_BLOCK_SELF(PlaceOrderViewController);
        adListVC.selectAddressBlock = ^(AddressModel *model,AddressListCell *cell){
            
            block_self.addressModel = model;
            block_self.cell = cell;
            cell.bottomCons.constant = 0;
            cell.defaultAddressB.hidden = YES;
            cell.editB.hidden = YES;
            cell.deleteB.hidden = YES;
            [block_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
        
        [self.navigationController pushViewController:adListVC animated:YES];
    }
}


@end
