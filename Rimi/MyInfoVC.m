//
//  MyInfoVC.m
//  Rimi
//
//  Created by wangzhilong on 15/6/11.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "MyInfoVC.h"
#import "DataUtils.h"
@interface MyInfoVC () <UIAlertViewDelegate>

@end

@implementation MyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isLogin {
    if ([DataUtils getAccount] == nil) {
        return NO;
    }
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    switch (indexPath.section) {
        case 0:
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"personal"];
            if ([DataUtils getInfo]!= nil) {
                cell.textLabel.text = [[DataUtils getInfo] objectForKey:@"name"];
                cell.detailTextLabel.text = [[DataUtils getInfo]objectForKey:@"snonum"];
            }else {
                cell.textLabel.text = @"姓名";
                cell.detailTextLabel.text = @"学号";
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"selections"];
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"转账充值";
                    break;
                case 1:
                    cell.textLabel.text = @"成绩查询";
                    break;
                case 2:
                    cell.textLabel.text = @"花销查询";
                default:
                    break;
            }
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"about"];
            break;
        case 3:
            if ([self isLogin]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"settings"];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"login"];
            }
            break;
        default:
            cell = nil;
            break;
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selections"];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0 && ![self isLogin]) {
                [self performSegueWithIdentifier:@"login" sender:nil];
            }else{
                [self performSegueWithIdentifier:@"detailinfo" sender:nil];
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    if ([self isLogin]) {
                        [self performSegueWithIdentifier:@"transfer" sender:nil];
                    }else {
                        [self performSegueWithIdentifier:@"login" sender:nil];
                    }
                    break;
                case 1:
                    if ([self isLogin]) {
                        [self performSegueWithIdentifier:@"queryscore" sender:nil];
                    }else {
                        [self performSegueWithIdentifier:@"login" sender:nil];
                    }

                    break;
                case 2:
                    if ([self isLogin]) {
                        [self performSegueWithIdentifier:@"queryconsume" sender:nil];
                    }else {
                        [self performSegueWithIdentifier:@"login" sender:nil];
                    }

                    break;
                default:
                    break;
            }
            break;
            
            break;
        case 2:
            //跳转到设置
            [self performSegueWithIdentifier:@"showset" sender:nil];
            break;
        case 3:
            if ([self isLogin]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else{
                [self.tableView reloadData];
                [self performSegueWithIdentifier:@"login" sender:nil];
            }
            break;
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = NO;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [DataUtils deleteAccount];
        [DataUtils deleteInfo];
    }
        [self.tableView reloadData];
}
@end
