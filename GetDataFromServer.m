//
//  GetDataFromServer.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/23.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "GetDataFromServer.h"

@implementation GetDataFromServer

#pragma mark 用户注册
+ (void)registUserWithPhoneNumber:(NSString *)phoneNumber EmailAddress:(NSString *)emailAddress nickName:(NSString *)alias Gender:(NSInteger)gender Password:(NSString *)password CallBackDelegate:(id<CallbackDelegate>)callBackdelegate{
    NSString *address = @"http://10.5.155.200/UserAction/RegistUserHandler.ashx";
    
    
    
    
    // 构建参数字符串
    NSString *parameterString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%ld&%@=%@",@"PhoneNumber",phoneNumber,@"EmailAddress",emailAddress,@"Alias",alias,@"Gender",gender,@"Password",password];
    
    //    NSString *parameterString = @"id=1";
    
    // XCode 7以前版本使用
    //    parameterString = [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // XCode 7中使用
    parameterString = [parameterString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    address = [NSString stringWithFormat:@"%@?%@", address, parameterString];
    NSLog(@"Address is : %@", address);
    
    NSURL *url = [NSURL URLWithString:address];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Block Content");
        NSLog(@"%@",error);
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", responseString);
        
    }];
    
    [task resume];
    NSLog(@"Task Resume");
}
#pragma mark 用户登录
+ (void)loginUserWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CallBackDelegate:(id<CallbackDelegate>)callBackdelegate {
    NSString *address = @"http://10.5.155.200/UserAction/UserLoginHandler.ashx";
    
    
    
    
    // 构建参数字符串
    NSString *parameterString = [NSString stringWithFormat:@"%@=%@&%@=%@",@"PhoneNumberOrEmail",phoneNumber,@"Password",password];
    
        // XCode 7中使用
    parameterString = [parameterString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    address = [NSString stringWithFormat:@"%@?%@", address, parameterString];
    NSLog(@"Address is : %@", address);
    
    NSURL *url = [NSURL URLWithString:address];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        
       
        NSLog(@"%@",dict);
        NSLog(@"%@",dict[@"ResultCode"]);
        if ([dict[@"ResultCode"] integerValue] == 0) {//登录成功，需返回数据
            NSDictionary *dic = dict[@"Data"];
            NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
            [userdefults setObject:dict forKey:@"USER_INFO"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOrnot" object:@"OK"];
            [callBackdelegate callbackData:dic RequestCode:0];
        }
        else {//登录失败，直接返回错误信息
            [callBackdelegate callbackError:@"登录失败"];
            
        }
//        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [callBackdelegate callbackData:responseString RequestCode:0];
        
//        NSLog(@"%@", responseString);
        
    }];
    
    [task resume];
    NSLog(@"Task Resume");
}
#pragma mark 邮箱判断
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//修改用户信息
+ (void)updateUserInfoWithUserId:(NSString *)userId PhoneNumber:(NSString *)phoneNumber EmailAddress:(NSString *)email NickName:(NSString *)alias Gender:(NSInteger)gender CallBackDelegate:(id<CallbackDelegate>)callBackdelegate {
    NSString *address = @"http://10.5.155.200/UserAction/UpdateUserInfoHandler.ashx";
    
    // 构建参数字符串
    NSString *parameterString = [NSString stringWithFormat:@"%@=%@&%@=%@&UserId=%@&Alias=%@&Gender=%ld",@"PhoneNumber",phoneNumber,@"EmailAddress",email,userId,alias,gender];
    
    // XCode 7中使用
    parameterString = [parameterString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    address = [NSString stringWithFormat:@"%@?%@", address, parameterString];
    NSLog(@"Address is : %@", address);
    
    NSURL *url = [NSURL URLWithString:address];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        
       
//        NSLog(@"%@",dict);
        NSLog(@"%@",dict[@"Meassage"]);
        if ([dict[@"ResultCode"] integerValue] == 0) {//登录成功，需返回数据
            NSDictionary *dic = dict[@"Data"];
            NSLog(@"%@",dic);
            NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
            [userdefults setObject:dict forKey:@"USER_INFO"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOrnot" object:@"OK"];
            [callBackdelegate callbackData:dic RequestCode:0];
        }
        else {//登录失败，直接返回错误信息
//            [callBackdelegate callbackError:@"登录失败"];
            
        }
        //        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        [callBackdelegate callbackData:responseString RequestCode:0];
        
        //        NSLog(@"%@", responseString);
        
    }];
    
    [task resume];
    NSLog(@"Task Resume");
}

////获取用户基本信息
//+ (void)getUserInfoWithUserId:(NSString *)userId CallBackDelegate:(id<CallbackDelegate>)callBackdelegate {
//    NSString *address = @"http://10.5.155.200/UserAction/GetUserInfoHandler.ashx";
//    
//    
//    
//    
//    // 构建参数字符串
//    NSString *parameterString = [NSString stringWithFormat:@"%@=%@",@"UserId",userId];
//    
//    // XCode 7中使用
//    parameterString = [parameterString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    address = [NSString stringWithFormat:@"%@?%@", address, parameterString];
//    NSLog(@"Address is : %@", address);
//    
//    NSURL *url = [NSURL URLWithString:address];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
//        
//        
//        NSLog(@"%@",dict);
//        NSLog(@"%@",dict[@"ResultCode"]);
//        if ([dict[@"ResultCode"] integerValue] == 0) {//登录成功，需返回数据
//            NSDictionary *dic = dict[@"Data"];
//            
//            NSLog(@"%@",dic[@"HeaderImage"]);
////            [callBackdelegate callbackData:dic RequestCode:0];
//        }
//        else {//登录失败，直接返回错误信息
////            [callBackdelegate callbackError:@"登录失败"];
//            NSLog(@"%@",error);
//        }
//        //        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //        [callBackdelegate callbackData:responseString RequestCode:0];
//        
//        //        NSLog(@"%@", responseString);
//        
//    }];
//    
//    [task resume];
//    NSLog(@"Task Resume");
//}
@end
