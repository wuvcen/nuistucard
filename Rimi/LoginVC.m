//
//  LoginVC.m
//  Rimi
//
//  Created by wangzhilong on 15/6/11.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "LoginVC.h"
#import "AFNetworking.h"
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
    [self.txtNum resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    
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
