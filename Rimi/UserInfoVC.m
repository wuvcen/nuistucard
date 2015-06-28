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
@property (weak, nonatomic) IBOutlet UILabel *yue;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;
@property (weak, nonatomic) IBOutlet UILabel *currentGuo;
@property (weak, nonatomic) IBOutlet UILabel *lastGuo;
@property (weak, nonatomic) IBOutlet UILabel *guaShi;

@property (weak, nonatomic) IBOutlet UILabel *dongJie;
@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manger = [AFHTTPRequestOperationManager manager];
    NSDictionary* postdata = @{@"StuNum":[[DataUtils getAccount]objectForKey:@"account"],@"Password":[[DataUtils getAccount]objectForKey:@"password"]};
    [manger POST:@"http://shenjingstudio.com/ucard/SnoDetail.php" parameters:postdata success:
     ^(AFHTTPRequestOperation* operation,id response){
         if (response != nil && [[response objectForKey:@"status"] isEqualToString:@"OK"]) {
             [hud removeFromSuperview];             
             self.currentGuo.text = [NSString stringWithFormat:@"%@",[response objectForKey:@"当前过度余额"]];
             self.lastGuo.text = [response objectForKey:@"上次过度余额"];
             self.guaShi.text = [NSString stringWithFormat:@"%@",[response objectForKey:@"挂失状态"]];
             self.dongJie.text = [NSString stringWithFormat:@"%@",[response objectForKey:@"冻结状态"]];
             self.yue.text = [response objectForKey:@"校园卡余额"];
             self.bankNum.text = [response objectForKey:@"银行卡号"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
