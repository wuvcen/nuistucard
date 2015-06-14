//
//  LoginVC.m
//  Rimi
//
//  Created by wangzhilong on 15/6/11.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "LoginVC.h"
#import "DataUtils.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginBtn:(id)sender {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.txtNum resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* account = self.txtNum.text;
    NSString* password = [DataUtils codeStringByBase64:self.txtPwd.text];
    NSDictionary* postdata = @{@"StuNum":account,@"Password":password};
    [manager POST:@"http://shenjingstudio.com/ucard/SnoDetail.php" parameters:postdata success:^(AFHTTPRequestOperation* operation, id response){
        if (response != nil&&[[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            [hud removeFromSuperview];
            NSDictionary* accountdic = @{@"account":account,@"password":password};
            [DataUtils saveAccount:accountdic];
            NSLog(@"登录成功");
            NSDictionary* info = @{@"name":[response objectForKey:@"姓名"],@"snonum":[response objectForKey:@"学工号"]};
            [DataUtils setInfo:info];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"登陆失败";
            [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
        }
    } failure:^(AFHTTPRequestOperation* operation,NSError* error){
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登陆失败";
        [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
    }];
    
}


@end
