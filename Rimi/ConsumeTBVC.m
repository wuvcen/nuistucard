//
//  ConsumeTBVC.m
//  Rimi
//
//  Created by 王志龙 on 15/6/27.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "ConsumeTBVC.h"
#import "ConsumeCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataUtils.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ConsumeTBVC ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (strong, nonatomic) NSArray *currentData;
@property (strong, nonatomic) NSArray *todayData;
@property (strong, nonatomic) NSArray *weekData;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation ConsumeTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.typeSegment addTarget:self action:@selector(chooseSegment:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.currentData == nil) {
        [self pullTorefresh];
        [self getData:@"Today"];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshData {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新"];
    switch (self.typeSegment.selectedSegmentIndex) {
        case 0:
            if ([self isLogin]) {
                [self getData:@"Today"];
            }
            break;
        case 1:
            if ([self isLogin]) {
                [self getData:@"Week"];
            }
            break;
        default:
            break;
    }
}
- (BOOL)isLogin {
    if ([DataUtils getAccount] == nil) {
        return NO;
    }
    return YES;
}


- (void)chooseSegment:(UISegmentedControl *)seg {
    if ([self isLogin]) {
        switch (seg.selectedSegmentIndex) {
            case 0:
                if (self.todayData != nil) {
                    self.currentData = self.todayData;
                    [self.tableView reloadData];
                }else{
                    [self pullTorefresh];
                    [self getData:@"Today"];
                }
                break;
            case 1:
                if (self.weekData != nil) {
                    self.currentData = self.weekData;
                    [self.tableView reloadData];
                }else{
                    [self pullTorefresh];
                    [self getData:@"Week"];
                }
                break;
            default:
                break;
        }
        
    }
}

- (void)showProgressHUD {
    
    if (self.hud == nil) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else{
        [self.view addSubview:self.hud];
    }
    
}

- (void)hideProgressHUD {
    [self.hud removeFromSuperview];
}

- (void)pullTorefresh {
//    self.tableView.contentOffset = CGPointMake(0, 0);
    __weak ConsumeTBVC *wself = self;
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         wself.tableView.contentOffset = CGPointMake(0, wself.tableView.contentOffset.y-wself.refreshControl.frame.size.height);
                     } completion:^(BOOL finished){
                         [wself.refreshControl beginRefreshing];
                         [wself.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                     }];
}

- (void)getData:(NSString *)queryType {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *account = [DataUtils getAccount];
    NSDictionary *postdata = @{@"StuNum":[account objectForKey:@"account"],@"Password":[account objectForKey:@"password"],@"QueryType":queryType};
    __weak ConsumeTBVC *wself = self;
    if ([self isLogin]) {
        [manager POST:@"http://shenjingstudio.com/ucard/SnoTurnover.php" parameters:postdata success:^(AFHTTPRequestOperation *operation,id response){
            if (response != nil) {
                if ([response[@"status"] isEqualToString:@"OK"]) {
                    if ([queryType isEqualToString:@"Today"]) {
                        [wself.typeSegment setSelectedSegmentIndex:0];
                        wself.todayData = response[@"Array"];
                        wself.currentData = wself.todayData;
                    }else {
                        [wself.typeSegment setSelectedSegmentIndex:1];
                        wself.weekData = response[@"Array"];
                        wself.currentData = wself.weekData;
                    }
                    
                    [wself.tableView reloadData];
                    
                }
                [wself.refreshControl endRefreshing];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [wself.refreshControl endRefreshing];
        }];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"consumcell" forIndexPath:indexPath];
    NSDictionary *dic = self.currentData[indexPath.row];
    cell.shijian.text = dic[@"交易时间"];
    cell.shanghu.text = dic[@"商户名称"];
    cell.leixing.text = dic[@"交易名称"];
    cell.jine.text = dic[@"交易金额"];
    cell.yue.text = dic[@"卡余额"];
    return cell;
}


#pragma mark DZEmptyDataSet datasource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:@"没有数据" attributes:attributes];
}
#pragma mark DZEmptyDataSet delegate




@end
