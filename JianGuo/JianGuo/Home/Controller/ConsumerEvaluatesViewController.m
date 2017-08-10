//
//  ConsumerEvaluatesViewController.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ConsumerEvaluatesViewController.h"
#import "ConsumerCell.h"

@interface ConsumerEvaluatesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *evaluateCountL;

@end

@implementation ConsumerEvaluatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户评价";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count+10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumerCell *cell = [ConsumerCell cellWithTableView:tableView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
