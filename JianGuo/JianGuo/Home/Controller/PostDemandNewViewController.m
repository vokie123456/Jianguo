//
//  PostDemandNewViewController.m
//  JianGuo
//
//  Created by apple on 17/6/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostDemandNewViewController.h"
#import "CitySchoolViewController.h"
#import "PostSuccessViewController.h"
#import "AddMoneyViewController.h"
#import "DemandListViewController.h"

#import "JGHTTPClient+Demand.h"

#import "JianliCell.h"
#import "PostDemandPictureCell.h"
#import "LimitTimeCell.h"
#import "AnonymousCell.h"
#import "BHBPopView.h"
#import "QNUploadManager.h"
#import "QLAlertView.h"

#import "SchoolModel.h"
#import "CityModel.h"

#import "UITextView+placeholder.h"

#define cellHeight  (SCREEN_W-20-15)/4

@interface PostDemandNewViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshCollectionViewSizeDelegate,UIScrollViewDelegate>
{
    CGFloat collectionViewH;
    NSArray *imageArr;
    UIButton *selectAnonyB;
    UITextField *titleTF;
    UITextView *describeTV;
    
    SchoolModel *schoolM;
    CityModel *cityM;
    NSString *title;
    NSString *description;
    NSString *schoolStr;
    NSString *cityId;
    NSString *schoolId;
    NSString *limitTime;
    NSString *demandMoney;
    NSString *images;
    QNUploadManager *manager;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PostDemandNewViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [NotificationCenter addObserver:self selector:@selector(refreshCellHeight:) name:kNotificationRefreshCellHeight object:nil];
    }
    return self;
}

-(void)refreshCellHeight:(NSNotification *)noti
{
    limitTime = noti.object;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    collectionViewH = cellHeight;
    self.navigationItem.title = @"发布";
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 150;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1){
            return 80;
        }else if (indexPath.row == 2){
            return collectionViewH+20;// UICollectoinView的高
        }else
            return 44;
    }else if (indexPath.section == 1){
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 3){
        return 100;
    }else{
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianliCell *cell = [JianliCell cellWithTableView:tableView];
    switch (indexPath.section) {
        case 0:{// section 0
            
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 44)];
                label.textColor = LIGHTGRAYTEXT;
                label.font = FONT(16);
                label.text = @"标题";
                [cell.contentView addSubview:label];
                
                UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 0, SCREEN_W-label.width, 44)];
                textF.font = FONT(15);
                textF.text = title;
                [textF addTarget:self action:@selector(limitWordsNumber:) forControlEvents:UIControlEventEditingChanged];
                textF.placeholder = @"有吸引力的标题能让更多的用户报名哦";
                [cell.contentView addSubview:textF];
                titleTF = textF;
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 43, SCREEN_W, 1)];
                line.backgroundColor = BACKCOLORGRAY;
                [cell.contentView addSubview:line];
                
                return cell;
            }else if (indexPath.row == 1){
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W-30, 80)];
                textV.font = FONT(15);
                textV.placeholder = description.length?nil:@"请详细描述一下你的任务";
                textV.text = description;
                [cell.contentView addSubview:textV];
                describeTV = textV;
//                
//                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, textV.height-1, SCREEN_W, 1)];
//                line.backgroundColor = BACKCOLORGRAY;
//                [cell.contentView addSubview:line];
                
                return cell;
            }else if (indexPath.row == 2){
                
                PostDemandPictureCell *cell = [PostDemandPictureCell cellWithTableView:tableView];
                cell.delegate = self;
                cell.imagesArr = imageArr;
                return cell;
            }else if (indexPath.row == 3){
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.textLabel.text = @"分类";
                cell.textLabel.font = FONT(16);
                cell.detailTextLabel.font = FONT(15);
                cell.textLabel.textColor = LIGHTGRAYTEXT;
                cell.detailTextLabel.text = self.demandTypeStr;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 43, SCREEN_W, 1)];
                line.backgroundColor = BACKCOLORGRAY;
                [cell.contentView addSubview:line];
                
                return cell;
            }else if (indexPath.row == 4){
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.textLabel.text = @"发布到";
                cell.textLabel.font = FONT(16);
                cell.detailTextLabel.font = FONT(15);
                cell.textLabel.textColor = LIGHTGRAYTEXT;
                cell.detailTextLabel.text = @"选择发布到哪个学校";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }
            
            break;
        } case 1:{// section 1
            
            LimitTimeCell *cell = [LimitTimeCell cellWithTableView:tableView];
            cell.timeLimitL.text = limitTime;
            cell.cancelB.hidden = !limitTime.length;
            cell.alertB.hidden = !limitTime.length;
            cell.setB.hidden = limitTime.length;
            cell.moneyTF.text = demandMoney;
            cell.moneyChangedBlock = ^(NSString *money){
                demandMoney = money;
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            break;
        } case 2:{// section 2
            
            AnonymousCell *cell = [AnonymousCell cellWithTableView:tableView];
            selectAnonyB = cell.selectB;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            break;
        } case 3:{// section 3
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.contentView.backgroundColor = BACKCOLORGRAY;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *sureB = [UIButton buttonWithType:UIButtonTypeCustom];
            sureB.frame = CGRectMake(30, 30, SCREEN_W-60, 40);
            sureB.layer.cornerRadius = 5;
            [sureB setBackgroundColor:GreenColor];
            [sureB setTitle:@"支付赏金并发布" forState:UIControlStateNormal];
            [sureB setTitleColor:WHITECOLOR forState:UIControlStateNormal];
            sureB.titleLabel.font = FONT(16);
            [sureB addTarget:self action:@selector(sureToIssue) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sureB];
            return cell;
            
            break;
        }
        default:
            break;
    }

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0&&indexPath.row == 3) {
        
        //添加popview
        [BHBPopView showToView:self.view.window andImages:@[@"study-1",@"run",@"technology-1",@"emotion-1",@"shopping",@"amusement"] andTitles:@[@"学习交流",@"跑腿代劳",@"技能服务",@"情感地带",@"娱乐生活",@"易货求购"] andSelectBlock:^(BHBItem *item) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = item.title;
            self.demandType = [NSString stringWithFormat:@"%ld",item.index.integerValue+1];
            
        }];
        
    }else if (indexPath.section == 0&&indexPath.row == 4){
        
        CitySchoolViewController *searchVC = [[CitySchoolViewController alloc] init];
        searchVC.selectSchoolBlock = ^(SchoolModel *schoolModel,CityModel *cityModel){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (schoolModel) {
                schoolM = schoolModel;
                schoolId = schoolModel.id;
            }
            if (cityModel) {
                cityM = cityModel;
                cityId = cityModel.code;
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",cityM.cityName,schoolM.name];
            
        };
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    description = describeTV.text;
}

-(void)limitWordsNumber:(UITextField *)sender
{
    title = sender.text;
    if (sender.text.length>15) {
        sender.text = [sender.text substringToIndex:15];
        [self showAlertViewWithText:@"超过字数限制" duration:1];
        return;
    }
}



//发布任务
-(void)sureToIssue
{
    description = describeTV.text;
    if (title.length==0) {
        [self showAlertViewWithText:@"请输入任务标题" duration:1];
        return;
    }else if (description.length ==0){
        
        [self showAlertViewWithText:@"请输入任务描述" duration:1];
        return;
    }else if (imageArr.count < 1){
//        [self showAlertViewWithText:@"至少选择一张图片" duration:1];
//        return;
    }else if (schoolId.length==0){
        [self showAlertViewWithText:@"选择发布到哪个学校" duration:1];
        return;
    }else if (demandMoney.length==0){
        [self showAlertViewWithText:@"请输入赏金金额" duration:1];
        return;
    }
    
    if (images.length) {
        [self commitInfoToSelfServer];
        return;
    }
    
    [self uploadImages:0];
}

//上传图片
-(void)uploadImages:(NSInteger)count
{
    
    if (count==imageArr.count-1) {
        return;
    }
    
    if (!manager) {
        manager = [[QNUploadManager alloc] init];
    }
    
    NSData *data = UIImageJPEGRepresentation(imageArr[count], 0.7);
    
    __block NSInteger blockCount = count;
    NSString *loadingStr = [NSString stringWithFormat:@"正在发布第%ld张图片...",count+1];
    JGSVPROGRESSLOAD(loadingStr);
    [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            [SVProgressHUD dismiss];
            return ;
        }else{//上传图片成功后再上传个人资料
            
            NSString *url = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            blockCount++;
            
            images = [NSString stringWithFormat:@"%@%@%@",images?images:@"",(!images?@"":@","),url];
            
            [self uploadImages:blockCount];
            
            if (blockCount == imageArr.count-1) {//图片上传完成,调用自己服务器的接口
                
                [SVProgressHUD dismiss];
                [self commitInfoToSelfServer];
            }
            
            JGLog(@"==== %ld ===== %@ ====",blockCount,url);
        }
        
    } option:nil];
}

-(void)commitInfoToSelfServer
{
    NSString *isAnonymous = selectAnonyB.selected?@"1":@"2";//1是匿名2是实名
    
    JGSVPROGRESSLOAD(@"正在发布...");
    [JGHTTPClient PostDemandWithMoney:demandMoney imageUrl:images title:title description:description type:self.demandType city:cityId area:nil schoolId:schoolId sex:USER.gender limitTime:limitTime anonymous:isAnonymous Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"code"] integerValue] == 603) {
            [QLAlertView showAlertTittle:@"余额不足,是否充值?" message:nil isOnlySureBtn:NO compeletBlock:^{//去充值
                
                AddMoneyViewController *addMoneyVC = [[AddMoneyViewController alloc] init];
                addMoneyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addMoneyVC animated:YES];
                
            }];
        }else{
            //                    [self showAlertViewWithText:responseObject[@"message"] duration:1];
            if ([responseObject[@"code"] integerValue] == 200) {
                DemandListViewController *vc = (DemandListViewController *)self.navigationController.viewControllers.firstObject;
                [self.navigationController popToRootViewControllerAnimated:YES];
                PostSuccessViewController *postVC = [[PostSuccessViewController alloc] init];
                postVC.labelStr = @"Issued";
                postVC.transitioningDelegate = vc;//代理必须遵守这个专场协议
                postVC.modalPresentationStyle = UIModalPresentationCustom;
                [self.navigationController.viewControllers.firstObject presentViewController:postVC animated:YES completion:nil];
            }else{
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
            }
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark Delegate 刷新cell中的 UICollectionView 的大小
-(void)refreshCollectionView:(NSArray*)imageArray
{
    NSInteger count = imageArray.count;
    
    imageArr = imageArray;
    if (count>8) {
        collectionViewH = cellHeight*3+5*2;
    }else if (count>4){
        collectionViewH = cellHeight*2+5;
    }else{
        collectionViewH = cellHeight;
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationRefreshCellHeight object:nil];
}

@end
