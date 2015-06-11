//
//  DataUtils.m
//  Rimi
//
//  Created by wangzhilong on 15/6/11.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "DataUtils.h"
@interface DataUtils()

@end
@implementation DataUtils

+ (NSDictionary *)getAccount {
    return [NSDictionary dictionaryWithContentsOfFile:[self getDirectory:@"Account.plist"]];
}

+ (void)saveAccount:(NSDictionary *)dic {
    [dic writeToFile:[self getDirectory:@"Account.plist"] atomically:YES];
}

+ (NSDictionary *)getInfo {
    return [NSDictionary dictionaryWithContentsOfFile:[self getDirectory:@"PersonInfo.plist"]];
}

+ (void)setInfo:(NSDictionary *)info {
    [info writeToFile:[self getDirectory:@"PersonInfo.plist"] atomically:YES];
}

+ (NSString *)codeStringByBase64:(NSString *)stringToCode {
    NSData* data = [stringToCode dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (NSString *)getDirectory:(NSString *)fielName {
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* directory = [path lastObject];
    return [directory stringByAppendingPathComponent:fielName];
}
@end
