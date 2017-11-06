//
//  DraftViewController.m
//  JianGuo
//
//  Created by apple on 17/9/15.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DraftViewController.h"
#import "PostSkillViewController.h"

#import "JGHTTPClient+Skill.h"

@interface DraftModel : NSObject

/** skillId */
@property (nonatomic,copy) NSString *skillId;
/** createTime */
@property (nonatomic,copy) NSString *createTime;
/** title */
@property (nonatomic,copy) NSString *title;
/** createTimeStr */
@property (nonatomic,copy) NSString *createTimeStr;

@end

@implementation DraftModel


@end

@interface DraftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation DraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"草稿箱";
    
    self.tableView.rowHeight = 60;
    
    self.tableView.tableFooterView = [UIView new];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
    }];
    
    self.tableView.mj_footer = ({
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
            
            [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
            
        }];
        
        footer;
    });
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMySkillDraftWithPageNum:count Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[DraftModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DraftModel *model in [DraftModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_tableView reloadData];
            
            return;
            
        }else{
            self.dataArr = [DraftModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            bgView.hidden = self.dataArr.count;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DraftCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    DraftModel *model = self.dataArr[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"\n保存时间: %@",model.createTimeStr];
    cell.textLabel.textColor = LIGHTGRAYTEXT;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.textColor = RGBCOLOR(210, 210, 210);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DraftModel *model = self.dataArr[indexPath.row];
    PostSkillViewController *postSkillVC = [[PostSkillViewController alloc] init];
    postSkillVC.hidesBottomBarWhenPushed = YES;
    postSkillVC.isFromDraftVC = YES;
    [self.navigationController pushViewController:postSkillVC animated:YES];
    postSkillVC.draftId = model.skillId;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DraftModel *model = self.dataArr[indexPath.row];
        
        [JGHTTPClient deleteSkillDraftWithDraftId:model.skillId Success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [self.dataArr removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
            }else{
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
            }
            
        } failure:^(NSError *error) {
            [self showAlertViewWithText:NETERROETEXT duration:2];
        }];
        
    }
}

@end
