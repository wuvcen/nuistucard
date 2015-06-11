//
//  MyInfoVC.m
//  Rimi
//
//  Created by wangzhilong on 15/6/11.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "MyInfoVC.h"
#import "DataUtils.h"
@interface MyInfoVC ()

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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
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
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"selections"];
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"转账充值";
                    break;
                case 1:
                    cell.textLabel.text = @"流水查询";
                    break;
                case 2:
                    cell.textLabel.text = @"成绩查询";
                    break;
                default:
                    break;
            }
            break;
        case 2:
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
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"login" sender:nil];
            }
            break;
            
        default:
            break;
    }

}

@end
