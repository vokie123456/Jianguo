//
//  MyBuySkillChildViewController.m
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyBuySkillChildViewController.h"
#import "MySkillManageCell.h"

@interface MyBuySkillChildViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MyBuySkillChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 300;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        //        [self requestList:@"1"];
        
    }];
    
    
    self.tableView.mj_footer = ({
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{//上拉加载
            //            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            //            [self requestList:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
        //        footer.automaticallyHidden = YES;
        footer;
        
    });
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySkillManageCell *cell = [MySkillManageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
