//
//  DataUtils.h
//  Rimi
//
//  Created by wangzhilong on 15/6/11.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject
//使用沙盒存取账户信息
//{
//  name:
//  password:
//}
+ (NSDictionary *)getAccount;
+ (void)saveAccount:(NSDictionary *)dic;
+ (void)deleteAccount;
//个人信息
+ (NSDictionary *)getInfo;
+ (void)setInfo:(NSDictionary *)info;
+ (void)deleteInfo;
//Base64编码工具
+ (NSString *)codeStringByBase64:(NSString *)stringToCode;

+ (NSString *)getDirectory:(NSString *)fielName;
@end
