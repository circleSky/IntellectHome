//
//  GetDataFromServer.h
//  IntellectHome
//
//  Created by 吴卓 on 15/12/23.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallbackDelegate.h"

@interface GetDataFromServer : NSObject
//注册用户
+ (void)registUserWithPhoneNumber:(NSString *)phoneNumber EmailAddress:(NSString *)emailAddress nickName:(NSString *)alias Gender:(NSInteger)gender Password:(NSString *)password CallBackDelegate:(id<CallbackDelegate>)callBackdelegate;

//用户登录
+ (void)loginUserWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CallBackDelegate:(id<CallbackDelegate>)callBackdelegate;

//获取用户基本信息

@end
