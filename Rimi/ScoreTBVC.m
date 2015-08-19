//
//  ScoreTBVC.m
//  Rimi
//
//  Created by 王志龙 on 15/6/27.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "ScoreTBVC.h"
#import "ScoreCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataUtils.h"
#import "UIScrollView+EmptyDataSet.h"
@interface ScoreTBVC () <DZNEmptyDataSetSource>
@property (strong, nonatomic) NSArray *cjArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) UIBarButtonItem *hud;
@end

@implementation ScoreTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    [self getData:self.pageIndex];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(nextPage)];
    self.navigationItem.rightBarButtonItem = right;
    self.tableView.emptyDataSetSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)nextPage {
    [self getData:++self.pageIndex];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.cjArray != nil) {
        return self.cjArray.count;

    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scorecell"];
    cell.kcmc.text = [self.cjArray[indexPath.row] objectForKey:@"KCMC"];
    cell.xf.text = [self.cjArray[indexPath.row] objectForKey:@"XF"];
    cell.cj.text = [self.cjArray[indexPath.row] objectForKey:@"CJ"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.cjArray.count == 0 || self.cjArray == nil) {
        return @"";
    }else {
        NSString *str = [NSString stringWithFormat:@"%@年 第%@学期",[self.cjArray[0] objectForKey:@"XN"],[self.cjArray[0] objectForKey:@"XQ"]];
        return str;
    }
}



- (void)getData:(NSInteger)pageIndex {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *account = [DataUtils getAccount];
    NSDictionary *postdata = @{@"StuNum":[account objectForKey:@"account"],@"Password":[account objectForKey:@"password"],@"pageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex]};

    
    __weak ScoreTBVC *wself = self;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [manager POST:@"http://shenjingstudio.com/ucard/SnoScore.php" parameters:postdata success:^(AFHTTPRequestOperation *operation,id response){
        [hud removeFromSuperview];
        [wself.navigationItem.rightBarButtonItem setEnabled:YES];
        if (response != nil) {
            NSString *msg = [response objectForKey:@"msg"];
            if ([msg isEqual:[NSNull null]]) {
                wself.cjArray = [response objectForKey:@"obj"];
                [wself.tableView reloadData];
            }
        }
    
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [hud removeFromSuperview];
        [wself.navigationItem.rightBarButtonItem setEnabled:YES];
    }];
}

#pragma mark DZEmptyDataSet datasource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:@"没有数据" attributes:attributes];
}
@end
