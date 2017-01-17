//
//  CollectViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "CollectViewController.h"
#import "SelectView.h"
#import "JianZhiCell.h"
#import "MerchantCell.h"
#import "JianzhiModel.h"
#import "MerchantModel.h"
#import "JGHTTPClient+Mine.h"
#import "JianZhiDetailController.h"
#import "MerChantViewController.h"

//枚举
typedef NS_ENUM(NSUInteger,DATATYPE)
{
    ATTENTIONTYPE = 1,
    COLLECTIONTYPE = 2
};


@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    DATATYPE dataType;
    UIView *bgView;
}
@property (nonatomic,strong) UILabel  *label;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *collectionArr;
@property (nonatomic,strong) NSMutableArray *attentionArr;

@end

@implementation CollectViewController

-(NSMutableArray *)collectionArr
{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray array];
    }
    return _collectionArr;
}

-(NSMutableArray *)attentionArr
{
    if (!_attentionArr) {
        _attentionArr = [NSMutableArray array];
    }
    return _attentionArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKCOLORGRAY;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    self.title = @"我的收藏";
    dataType = COLLECTIONTYPE;
    
    [self requestData];
    
    SelectView *selectView = [SelectView aSelectView];
    selectView.backgroundColor = WHITECOLOR;
    selectView.leftBtnBlock = ^(){
        dataType = COLLECTIONTYPE;
        self.label.text = @"暂时没有任何收藏哦";
        if (self.collectionArr.count == 0&&dataType == COLLECTIONTYPE) {
            bgView.hidden = NO;
            self.label.text = @"暂时没有任何收藏哦";
        }else{
            bgView.hidden = YES;
        }
        [self.tableView reloadData];
    };

    selectView.rightBtnBlock = ^(){
        dataType = ATTENTIONTYPE;
        self.label.text = @"暂时没有任何关注哦";
        if (self.attentionArr.count == 0&&dataType == ATTENTIONTYPE) {
            bgView.hidden = NO;
            self.label.text = @"暂时没有任何关注哦";
        }else{
            bgView.hidden = YES;
        }
        [self.tableView reloadData];
    };
    
    [self showNomerchantCollection];
 
    
//    [self.view addSubview:selectView];
    
    
}

-(void)requestData
{
    JGSVPROGRESSLOAD(@"加载中...")
    IMP_BLOCK_SELF(CollectViewController)
    [JGHTTPClient getcollectionAndAttentionListByloginId:USER.login_id Success:^(id responseObject) {
        
        if ([responseObject[@"code"] intValue] == 200) {
            block_self.collectionArr = [JianzhiModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_job"]];
            if (block_self.collectionArr.count == 0&&dataType == COLLECTIONTYPE) {
                bgView.hidden = NO;
                block_self.label.text = @"暂时没有任何收藏哦";
            }
            block_self.attentionArr = [MerchantModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_merchant"]];
            if (block_self.attentionArr.count == 0&&dataType == ATTENTIONTYPE) {
                bgView.hidden = NO;
                block_self.label.text = @"暂时没有任何关注哦";
            }
        }
        [block_self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataType == COLLECTIONTYPE) {
        return 110;
    }else if (dataType == ATTENTIONTYPE){
        return 60;
    }else{
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataType == COLLECTIONTYPE) {//收藏的兼职
        return self.collectionArr.count;
    }else if (dataType == ATTENTIONTYPE){//关注的商家
        return self.attentionArr.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataType == COLLECTIONTYPE) {//收藏的兼职
        
        static NSString *identifier = @"homecell";
        JianZhiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JianZhiCell" owner:nil options:nil]lastObject];
        }
        JianzhiModel *model = self.collectionArr[indexPath.row];
        cell.model = model;
        
        return cell;
        
    }else if (dataType == ATTENTIONTYPE ){//关注的商家
        
        static NSString *identifier = @"MERCHANTCELL";
        MerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MerchantCell" owner:nil options:nil]lastObject];
        }
        cell.model = self.attentionArr[indexPath.row];
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataType == COLLECTIONTYPE) {
        JianzhiModel *model = self.collectionArr[indexPath.row];
        
        JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
        
        jzdetailVC.hidesBottomBarWhenPushed = YES;
        
        jzdetailVC.jobId = model.id;
        
        jzdetailVC.merchantId = model.merchant_id;
        
        jzdetailVC.jzModel = model;
        
        [self.navigationController pushViewController:jzdetailVC animated:YES];
        // 取消选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if (dataType == ATTENTIONTYPE){
        MerchantModel *model = self.attentionArr[indexPath.row];
        MerChantViewController *merchantVC = [[MerChantViewController alloc] init];
        merchantVC.model = model;
        [self.navigationController pushViewController:merchantVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {IMP_BLOCK_SELF(CollectViewController);
        if (dataType == COLLECTIONTYPE) {
            JianzhiModel *model = self.collectionArr[indexPath.row];
            [JGHTTPClient deleteAcollectionOrattentionByloginId:USER.login_id dataId:model.id type:@"1" Success:^(id responseObject) {

                if ([responseObject[@"code"] integerValue] == 200) {
                    [block_self.collectionArr removeObjectAtIndex:indexPath.row];

                    [block_self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
            } failure:^(NSError *error) {
                [block_self showAlertViewWithText:NETERROETEXT duration:1];
            }];
        }else if (dataType == ATTENTIONTYPE){
            MerchantModel *model = block_self.attentionArr[indexPath.row];
            [JGHTTPClient deleteAcollectionOrattentionByloginId:USER.login_id dataId:model.id type:@"2" Success:^(id responseObject) {
                
                if ([responseObject[@"code"] integerValue] == 200) {
                    [block_self.attentionArr removeObjectAtIndex:indexPath.row];
                    [block_self showAlertViewWithText:@"删除成功" duration:1];
                    [block_self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
            } failure:^(NSError *error) {
                [block_self showAlertViewWithText:NETERROETEXT duration:1];
            }];
        }
    }
}


-(void)showNomerchantCollection
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80+64, SCREEN_W, 250)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-60, 0, 120, 120)];
    imgView.image = [UIImage imageNamed:@"img_renwu1"];
    [bgView addSubview:imgView];
    
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+5, SCREEN_W, 25)];
    labelMiddle.text = @"暂时没有任何关注和收藏哦";
    labelMiddle.font = FONT(16);
    labelMiddle.textColor = LIGHTGRAYTEXT;
    labelMiddle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:labelMiddle];
    self.label = labelMiddle;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看全部兼职" forState:UIControlStateNormal];
    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    btn.frame = CGRectMake(bgView.center.x-50, labelMiddle.bottom, 100, 30);
    [btn addTarget:self action:@selector(gotoPartJobVC:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = FONT(16);
    [bgView addSubview:btn];
    
    [self.view addSubview:bgView];
    bgView.hidden = YES;
}

/**
 *  跳到兼职页
 */
-(void)gotoPartJobVC:(UIButton *)btn
{
    [self.tabBarController setSelectedIndex:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}
@end
