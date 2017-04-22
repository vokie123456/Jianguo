//
//  GetCashProgressViewController.m
//  JianGuo
//
//  Created by apple on 17/4/11.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "GetCashProgressViewController.h"
#import "GetCashProgressCell.h"
#import "MoneyRecordModel.h"
#import "DemandStatusModel.h"

@interface GetCashProgressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation GetCashProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[].mutableCopy;
    
    self.navigationItem.title = @"提现进度";
    
    self.tableView.backgroundColor = BACKCOLORGRAY;
    
    [self customHeaderView];
    
    [self createStateArr];
    
    [self.tableView reloadData];
    
}

-(void)createStateArr
{
    NSInteger status = self.model.status.integerValue;
//    if (status==1) {//刚提交提现申请
//        NSTimeInterval timeNowStamp = [[NSDate date] timeIntervalSince1970];
//        CGFloat timeToCreateTime = timeNowStamp-self.model.createTime.floatValue;
//        
//        
//        DemandStatusModel *model = [[DemandStatusModel alloc] init];
//        model.content = @"已提交";
//        model.time = self.model.createTime;
//        [self.dataArr addObject:model];
//        
//        if (timeToCreateTime >3600*0.5) {//半小时以后,2小时以内
//            
//            DemandStatusModel *model2 = [[DemandStatusModel alloc] init];
//            model2.content = @"兼果已受理";
//            model2.time = [NSString stringWithFormat:@"%ld",(NSInteger)(self.model.createTime.floatValue+3600*0.5)];
//            [self.dataArr addObject:model2];
//            if (timeToCreateTime>=3600*2) {
//                DemandStatusModel *model3 = [[DemandStatusModel alloc] init];
//                model3.content = @"银行处理中";
//                model3.time = [NSString stringWithFormat:@"%ld",(NSInteger)(self.model.createTime.floatValue+3600*2)];
//                [self.dataArr addObject:model3];
//            }
//            
//        }
//
//    }else if (status == 2){//已到账
    
//        for (int i=0; i<4; i++) {
//            DemandStatusModel *model = [[DemandStatusModel alloc] init];
//            switch (i) {
//                case 0:{
//                    
//                    model.content = @"已提交";
//                    model.time = self.model.createTime;
//                    
//                    break;
//                } case 1:{
//                    
//                    model.content = @"兼果已受理";
////                    model.time = self.model.createTime;
//                    
//                    break;
//                } case 2:{
//                    
//                    model.content = @"银行处理中";
////                    model.time = self.model.createTime;
//                    
//                    break;
//                } case 3:{
//                    
//                    model.content = @"到账成功,请注意查收!";
//                    NSString *endtime = self.model.endTime.integerValue?self.model.endTime:[NSString stringWithFormat:@"%ld",(NSInteger)(self.model.createTime.floatValue+3600*24)];
//                    model.time = endtime;
//                    
//                    break;
//                }
//                default:
//                    break;
////            }
//
//            [self.dataArr addObject:model];
//        }
    
    if (self.model.status.integerValue == 3){
        DemandStatusModel *model = [[DemandStatusModel alloc] init];
        model.content = @"已提交";
        model.time = self.model.createTime;
        [self.dataArr addObject:model];
        
        DemandStatusModel *model2 = [[DemandStatusModel alloc] init];
        model2.content = @"提现申请被驳回";
        model2.time = self.model.endTime;
        [self.dataArr addObject:model2];
    }else{
        NSTimeInterval timeNowStamp = [[NSDate date] timeIntervalSince1970];
        CGFloat timeToCreateTime = timeNowStamp-self.model.createTime.floatValue;
        
        for (int i=0; i<4; i++) {
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            switch (i) {
                case 0:{
                    
                    model.content = @"已提交";
                    model.time = self.model.createTime;
                    model.isFinished = YES;
                    
                    break;
                } case 1:{
                    
                    model.content = @"兼果已受理";
                    //                    model.time = self.model.createTime;
                    if (timeToCreateTime >3600*0.5) {//半小时以后,2小时以内
                        
                        model.time = [NSString stringWithFormat:@"%ld",(NSInteger)(self.model.createTime.floatValue+3600*0.5)];
                        model.isFinished = YES;
                        
                    }
                    
                    break;
                } case 2:{
                    
                    model.content = @"银行处理中";
                    //                    model.time = self.model.createTime;
                    
                    if (timeToCreateTime>=3600*2) {
                        model.time = [NSString stringWithFormat:@"%ld",(NSInteger)(self.model.createTime.floatValue+3600*2)];
                        model.isFinished = YES;
                    }
                    
                    break;
                } case 3:{
                    
                    model.content = @"到账成功,请注意查收!";
                    if (self.model.status.integerValue == 2) {//成功
                        
                        NSString *endtime = self.model.endTime.integerValue?self.model.endTime:[NSString stringWithFormat:@"%ld",(NSInteger)(self.model.createTime.floatValue+3600*24)];
                        model.time = endtime;
                        model.isFinished = YES;
                        
                    }
                    
                    
                    break;
                }
            }
            
            [self.dataArr addObject:model];
        }
    }
    
}

-(void)customHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 65)];
    headerView.backgroundColor = WHITECOLOR;
    
    UILabel *typeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 130, 20)];
    typeL.font = FONT(15);
    if (self.model.pay_type.integerValue == 1) {
        typeL.text = @"提现到:  银行卡";
    }else if (self.model.pay_type.integerValue == 2){
        typeL.text = @"提现到:  支付宝";
    }
    [headerView addSubview:typeL];
    
    UILabel *numberL = [[UILabel alloc] initWithFrame:CGRectMake(20, typeL.bottom+3, 100, 20)];
    numberL.font = FONT(12);
    numberL.textColor = LIGHTGRAYTEXT;
    NSString *number = [self.model.number stringByReplacingCharactersInRange:NSMakeRange(self.model.number.length-8, 4) withString:@"****"];
    numberL.text = number;
    CGSize maximumLabelSize = CGSizeMake(200, 30);//labelsize的最大值
    //关键语句
    CGSize expectSize = [numberL sizeThatFits:maximumLabelSize];
    CGRect frame = {numberL.frame.origin,expectSize};
    numberL.frame = frame;
    [headerView addSubview:numberL];
    
    UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-100, 23, 80, 20)];
    moneyL.font = [UIFont boldSystemFontOfSize:15];
    moneyL.text = [NSString stringWithFormat:@"%.2f",self.model.money.floatValue];;
    moneyL.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:moneyL];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, headerView.height-1, SCREEN_W-20, 1)];
    lineView.backgroundColor = BACKCOLORGRAY;
    [headerView addSubview:lineView];
    
    
    self.tableView.tableHeaderView = headerView;
    
}

-(void)call
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"联系兼果客服" message:@"010-53350021" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://010-53350021"]]];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 300;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        
//        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 300)];
//        
//        UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        telBtn.frame=CGRectMake(20, 10, 270, 30);
//        telBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [telBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"提现过程中有任何疑问请致电:010-53350021"];
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:LIGHTGRAYTEXT range:NSMakeRange(0, 14)];
//        [attributeStr addAttributes:@{NSForegroundColorAttributeName:GreenColor,NSFontAttributeName:FONT(15)} range:NSMakeRange(14, 12)];
//        [telBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//        [telBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
//        
//        [footView addSubview:telBtn];
//        
//        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2-40, 50, 80, 64)];
//        iconView.image = [UIImage imageNamed:@"cartoon"];
//        [footView addSubview:iconView];
//        
//        UILabel *bottomL = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.bottom+20, SCREEN_W, 20)];
//        bottomL.textAlignment = NSTextAlignmentCenter;
//        bottomL.textColor = LIGHTGRAYTEXT;
//        bottomL.font = FONT(12);
//        bottomL.text = @"上大学,上兼果校园!让钱包鼓起来吧!";
//        [footView addSubview:bottomL];
//        
//        return footView;
//        
//    }
//    return nil;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArr.count) {
        return 300;
    }
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetCashProgressCell *cell = [GetCashProgressCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.topView.hidden = YES;
//        cell.bottomView.backgroundColor = GreenColor;
//        cell.timeL.textColor = GreenColor;
//        cell.contentL.textColor = GreenColor;
//        cell.iconView.image = [UIImage imageNamed:@"successful"];
//        if (self.dataArr.count == 1) {
//            cell.bottomView.hidden = YES;
//        }
    }else if (indexPath.row == self.dataArr.count-1){
        
        cell.bottomView.hidden = YES;

    }
    if (indexPath.row == self.dataArr.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 300)];
        footView.backgroundColor = BACKCOLORGRAY;
        UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        telBtn.frame=CGRectMake(20, 10, 270, 30);
        telBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [telBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"提现过程中有任何疑问请致电:010-53350021"];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:LIGHTGRAYTEXT range:NSMakeRange(0, 14)];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:GreenColor,NSFontAttributeName:FONT(15)} range:NSMakeRange(14, 12)];
        [telBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [telBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        
        [footView addSubview:telBtn];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2-60, telBtn.bottom+60, 120, 120*4/5)];
        iconView.image = [UIImage imageNamed:@"cartoon"];
        [footView addSubview:iconView];
        
        UILabel *bottomL = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.bottom+10, SCREEN_W, 20)];
        bottomL.textAlignment = NSTextAlignmentCenter;
        bottomL.textColor = LIGHTGRAYTEXT;
        bottomL.font = FONT(12);
        bottomL.text = @"上大学,上兼果校园!让钱包鼓起来吧!";
        [footView addSubview:bottomL];
        
        [cell.contentView addSubview:footView];
        return cell;
        
    }
    
    if (self.dataArr.count>indexPath.row) {
        cell.model = self.dataArr[self.dataArr.count-indexPath.row-1];
    }
    
    return cell;
}



@end
