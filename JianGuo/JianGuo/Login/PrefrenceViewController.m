//
//  PrefrenceViewController.m
//  JianGuo
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "PrefrenceViewController.h"
#import "TimeCollectionViewCell.h"
#import "JobCollectionViewCell.h"
#import "PartTypeModel.h"
#import "JGHTTPClient+LoginOrRegister.h"

#define InstanceH 1
#define InstanceV 1

#define InstanceH_Job 3
#define InstanceV_job 3

@interface PrefrenceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *weekDayArr;
    NSArray *timeArr;
    NSInteger rowCount;
    UICollectionViewFlowLayout *layout;
    UICollectionViewFlowLayout *layoutJob;
}
@property (strong, nonatomic)  UICollectionView *timeCollectionView;
@property (strong, nonatomic)  UICollectionView *jobCollectionView;

@property (nonatomic,strong) NSMutableArray *jobTypeArr;

@property (nonatomic,strong) NSMutableArray *timeArr;

@property (nonatomic,strong) NSMutableArray *jobArr;

@property (nonatomic,strong) NSMutableArray *jobAllArr;


@end

@implementation PrefrenceViewController

-(NSMutableArray *)jobTypeArr
{
    if (!_jobTypeArr) {
        
        _jobTypeArr = JGKeyedUnarchiver(JGJobTypeArr);
    }
    return _jobTypeArr;
}
-(NSMutableArray *)jobArr
{
    if (!_jobArr) {
        
        _jobArr = [NSMutableArray array];
    }
    return _jobArr;
}
-(NSMutableArray *)timeArr
{
    if (!_timeArr) {
        
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *saveBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 40, 30);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(savePreference:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    rowCount = self.jobTypeArr.count/4+(self.jobTypeArr.count%4?1:0);
    
    self.title = @"求职意向";
    
    weekDayArr = @[@"时间",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"上午",@"",@"",@"",@"",@"",@"",@"",@"下午",@"",@"",@"",@"",@"",@"",@"",@"晚上",@"",@"",@"",@"",@"",@"",@""];
    

    
    self.view.backgroundColor = BACKCOLORGRAY;
    
    
    [self setCollectionView];
    
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getPreferenceLoginId:USER.login_id Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.timeArr addObjectsFromArray:[responseObject[@"data"] objectForKey:@"list_t_hobby_time"]];
        self.jobAllArr = [PartTypeModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_hobby_type"]];

        [self.timeCollectionView reloadData];
        [self.jobCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];
    
}


-(void)setCollectionView
{
    //时间部分的选择
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_W-30, 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = FONT(15);
    label.text = @"时间选择(可多选,不选默认为不限制时间)";
    label.backgroundColor = BACKCOLORGRAY;
    [self.view addSubview:label];
    
    layout = [[UICollectionViewFlowLayout alloc] init];

    self.timeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, label.bottom+5, SCREEN_W-30, 140) collectionViewLayout:layout];
    
    self.timeCollectionView.delegate = self;
    
    self.timeCollectionView.dataSource = self;
    
    
    [self.view addSubview:self.timeCollectionView];
    
     [self.timeCollectionView registerNib:[UINib nibWithNibName:@"TimeCollectionViewCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:@"TimeCollectionViewCell"];

    self.timeCollectionView.backgroundColor = BACKCOLORGRAY;
    
    
    //工作部分的选择
    
    UILabel *labelJob = [[UILabel alloc] initWithFrame:CGRectMake(15, self.timeCollectionView.bottom+15, SCREEN_W-30, 25)];
    labelJob.textAlignment = NSTextAlignmentLeft;
    labelJob.font = FONT(15);
    labelJob.text = @"职业";
    labelJob.backgroundColor = BACKCOLORGRAY;
    [self.view addSubview:labelJob];
    
    layoutJob = [[UICollectionViewFlowLayout alloc] init];
    
    self.jobCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, labelJob.bottom+5, SCREEN_W-30, rowCount*38) collectionViewLayout:layoutJob];
    
    self.jobCollectionView.delegate = self;
    
    self.jobCollectionView.dataSource = self;
    
    [self.view addSubview:self.jobCollectionView];
    
    [self.jobCollectionView registerNib:[UINib nibWithNibName:@"JobCollectionViewCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:@"JobCollectionViewCell"];
    
    self.jobCollectionView.backgroundColor = BACKCOLORGRAY;
 
    
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.timeCollectionView) {
        return 32;
    }else{
        return self.jobAllArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.timeCollectionView) {
        
        static NSString *identifier = @"TimeCollectionViewCell";
        TimeCollectionViewCell *cell = (TimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        cell.contentL.text = weekDayArr[indexPath.item];
        
        if(indexPath.item <= 8||indexPath.item == 16||indexPath.item == 24){
            
            cell.contentL.backgroundColor = RGBCOLOR(231, 231, 231);
        }else{
            for (NSString *item in self.timeArr) {
                if (indexPath.item == 8*(item.intValue/10)+item.intValue%10) {
                    cell.selectView.hidden = NO;
                }
            }
            cell.contentL.backgroundColor = WHITECOLOR;
        }
        return cell;
        
    }else{
        
        PartTypeModel *model = self.jobAllArr[indexPath.item];
        
        static NSString *identifier = @"JobCollectionViewCell";
        JobCollectionViewCell *cell = (JobCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.model = model;
        return cell;
        
    }
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionViewLayout == layout) {
        
        return CGSizeMake((SCREEN_W-30-InstanceH*7)/8, (140-InstanceV*3)/4);
    
    }else{
        
        return CGSizeMake((SCREEN_W-30-InstanceH_Job*3)/4, 35);
    
    }
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionViewLayout == layout) {
        
        return InstanceH;
        
    }else{
        
        return InstanceH_Job;
        
    }
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionViewLayout == layout) {
        
        return InstanceV;
        
    }else{
        //InstanceV_Job
        return InstanceV_job;
        
    }
}

//点击item的响应方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.timeCollectionView) {
        TimeCollectionViewCell *cell = (TimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.item <= 8||indexPath.item == 16||indexPath.item == 24){
            return;
        }else{
            NSInteger row = indexPath.item/8;
            NSInteger column = indexPath.item%8;
            NSString *timeId = [NSString stringWithFormat:@"%ld%ld",(long)row,column];
            if (cell.selectView.hidden) {//选中当前时间
                [self.timeArr addObject:timeId];
            }else{//去掉当前时间
                [self.timeArr removeObject:timeId];
            }
            cell.selectView.hidden = !cell.selectView.hidden;
        }
    }else{
        JobCollectionViewCell *cell = (JobCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

        if (!cell.isSelected) {
            cell.contentL.backgroundColor = GreenColor;
            cell.contentL.textColor = WHITECOLOR;
        }else{
            cell.contentL.backgroundColor = WHITECOLOR;
            cell.contentL.textColor = [UIColor darkGrayColor];
        }
        
        //反选的逻辑
        if (indexPath.item == 0) {//点击不限
            if (self.jobAllArr.count) {
                for (PartTypeModel *model in self.jobAllArr) {
                    model.is_type = NO;
                }
            }
            PartTypeModel *model = [self.jobAllArr firstObject];
            model.is_type = YES;
            
        }else{//单选一个工作
            PartTypeModel *model = [self.jobAllArr firstObject];
            model.is_type = NO;
            
            PartTypeModel *modelA = self.jobAllArr[indexPath.item];
            modelA.is_type = !modelA.is_type;
            
        }
        cell.isSelected = !cell.isSelected;
        [self.jobCollectionView reloadData];
    }

}

-(void)savePreference:(UIButton *)btn
{
    NSDictionary *dicTime = @{@"list_t_time":self.timeArr};
    
    NSData *jsonTime = [NSJSONSerialization dataWithJSONObject:dicTime options:NSJSONWritingPrettyPrinted error:nil];
    //时间json数组
    NSString *jsonArrTime = [[NSString alloc] initWithData:jsonTime encoding:NSUTF8StringEncoding];
    

    for (PartTypeModel *model in self.jobAllArr) {
        if(model.is_type){
            [self.jobArr addObject:model.id];
        }
    }
    
    NSDictionary *dicJob = @{@"list_t_type":self.jobArr};
    
    NSData *jsonJob = [NSJSONSerialization dataWithJSONObject:dicJob options:NSJSONWritingPrettyPrinted error:nil];
    //时间json数组
    NSString *jsonArrJob = [[NSString alloc] initWithData:jsonJob encoding:NSUTF8StringEncoding];
    
    JGSVPROGRESSLOAD(@"正在提交...");
    [JGHTTPClient setPreferenceLoginId:USER.login_id json_type:jsonArrJob json_time:jsonArrTime Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"] intValue] == 200) {
            JGUser *user = [JGUser user];
            user.hobby = @"1";
            [JGUser saveUser:user WithDictionary:nil loginType:LoginTypeByPhone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

@end
