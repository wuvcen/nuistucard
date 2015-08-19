//
//  TransferVC.m
//  Rimi
//
//  Created by 王志龙 on 15/6/11.
//  Copyright © 2015年 wangzhilong. All rights reserved.
//

#import "TransferVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataUtils.h"
@interface TransferVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtSum;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transferBtnTopConstant;
@end

@implementation TransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transferBtn.layer.cornerRadius = 4;
    self.transferBtn.layer.borderColor = self.navigationController.navigationBar.barTintColor.CGColor;
    self.transferBtn.layer.borderWidth = 1;
    self.transferBtn.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hidePwdView {
    self.passwordView.hidden = YES;
    self.transferBtnTopConstant.constant -= 52;
    [self.transferBtn layoutIfNeeded];
}

- (void)showPwdView {
    self.passwordView.hidden = NO;
    self.transferBtnTopConstant.constant = 32;
    [self.transferBtn layoutIfNeeded];
}

- (IBAction)btnClick:(id)sender {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.txtSum resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    NSString* amount = self.txtSum.text;
    NSString* qpwd = self.txtPwd.text;
    NSDictionary* postdic = @{@"StuNum":[[DataUtils getAccount]objectForKey:@"account"],@"Password":[[DataUtils getAccount] objectForKey:@"password"],@"QueryPwd":[DataUtils codeStringByBase64:qpwd],@"Amount":amount};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://shenjingstudio.com/ucard/SnoTransfer.php" parameters:postdic success:^(AFHTTPRequestOperation* operation,id response){
        if (response != nil) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [response objectForKey:@"msg"];
            [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"交易失败";
            [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
        }
    } failure:^(AFHTTPRequestOperation* operation,NSError* error){
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"交易失败";
        [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];

    }];
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
