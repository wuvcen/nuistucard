//
//  UserInfoVC.m
//  Rimi
//
//  Created by 王志龙 on 15/6/11.
//  Copyright © 2015年 wangzhilong. All rights reserved.
//

#import "UserInfoVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataUtils.h"
@interface UserInfoVC ()

@property (strong, nonatomic) NSDictionary *data;
@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manger = [AFHTTPRequestOperationManager manager];
    NSDictionary* postdata = @{@"StuNum":[[DataUtils getAccount]objectForKey:@"account"],@"Password":[[DataUtils getAccount]objectForKey:@"password"]};
    __weak UserInfoVC *wself = self;
    [manger POST:@"http://shenjingstudio.com/ucard/SnoDetail.php" parameters:postdata success:
     ^(AFHTTPRequestOperation* operation,id response){
         if (response != nil && [[response objectForKey:@"status"] isEqualToString:@"OK"]) {
             [hud removeFromSuperview];
             wself.data = (NSDictionary *)response;

             [wself.tableView reloadData];
         }else{
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
         }
    } failure:^(AFHTTPRequestOperation* operation,NSError* error){
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"获取失败";
        [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
    }];
    
//    [self getiPlanet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getiPlanet {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manger = [AFHTTPRequestOperationManager manager];
    NSDictionary* postdata = @{@"StuNum":[[DataUtils getAccount]objectForKey:@"account"],@"Password":[[DataUtils getAccount]objectForKey:@"password"]};
    __weak UserInfoVC *wself = self;
    
    [manger POST:@"http://shenjingstudio.com/ucard/SnoiPlanet.php" parameters:postdata success:
     ^(AFHTTPRequestOperation* operation,id response){
         if (response != nil) {
             [hud removeFromSuperview];
             NSLog(@"%@",[response objectForKey:@"msg"]);
             [wself getPhoto:[response objectForKey:@"msg"]];
         }else{
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
         }
     } failure:^(AFHTTPRequestOperation* operation,NSError* error){
         hud.mode = MBProgressHUDModeText;
         hud.labelText = @"获取失败";
         [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
     }];
    
}

- (void)getPhoto:(NSString *)iplanet {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    AFHTTPRequestOperationManager* manger = [AFHTTPRequestOperationManager manager];
    NSDictionary* postdata = @{@"iPlanetDirectoryPro":iplanet,@"sno":[[DataUtils getAccount]objectForKey:@"account"]};
    
    [manger POST:@"http://ucard.nuist.edu.cn:8070/Api/Card/GetMyPhoto" parameters:postdata success:
     ^(AFHTTPRequestOperation* operation,id response){
         NSLog(@"%@",response);
         if (response != nil) {
             [hud removeFromSuperview];
             NSLog(@"%@",response);
         }else{
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
         }
     } failure:^(AFHTTPRequestOperation* operation,NSError* error){
         hud.mode = MBProgressHUDModeText;
         hud.labelText = @"获取失败";
         [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
     }];
}
- (NSString *)get:(NSString *)key {
    if (self.data == nil) {
        return @"";
    }else{
        return [self.data objectForKey:key];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data == nil) {
        return 0;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfocell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"余额";
            cell.detailTextLabel.text = [self get:@"校园卡余额"];
            break;
            case 1:
            cell.textLabel.text = @"银行卡号";
            cell.detailTextLabel.text = [self get:@"银行卡号"];
            break;
            case 2:
            cell.textLabel.text = @"当前过度余额";
            cell.detailTextLabel.text = [self get:@"当前过度余额"];
            break;
            case 3:
            cell.textLabel.text = @"上次过度余额";
            cell.detailTextLabel.text = [self get:@"上次过度余额"];
            break;
            case 4:
            cell.textLabel.text = @"挂失状态";
            cell.detailTextLabel.text = [self get:@"挂失状态"];
            break;
            case 5:
            cell.textLabel.text = @"冻结状态";
            cell.detailTextLabel.text = [self get:@"冻结状态"];
            break;
        default:
            break;
    }
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
