//
//  LoginAndRigisterViewController.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/22.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "LoginAndRigisterViewController.h"
#import "InputText.h"
#import "PrefixHeader.pch"
#import "GetDataFromServer.h"
#import "CallbackDelegate.h"


@interface LoginAndRigisterViewController ()<UITextFieldDelegate,CallbackDelegate>

@property UILabel *label;

@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;

@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;
@property (nonatomic, weak)UIButton *loginBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation LoginAndRigisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btn_touch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   [self setupInputRectangle];
    
    
    
    
}
- (void)btn_touch {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setupInputRectangle
{
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    
    self.userText = userText;
    self.userText.tag = 100;
    [userText setReturnKeyType:UIReturnKeyNext];
    
    [userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userText];
    UILabel *userTextName = [self setupTextName:@"电话号码\\邮箱" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    

    
    CGFloat passwordY = CGRectGetMaxY(userTextName.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    self.passwordText.tag = 101;
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.width = 200;
    loginBtn.height = 30;
    loginBtn.centerX = self.view.width * 0.5;
    loginBtn.y = CGRectGetMaxY(passwordText.frame) + 30;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor orangeColor]];
    loginBtn.enabled = NO;
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}
- (void)loginBtnClick
{
    if (_label) {
        [_label removeFromSuperview];
    }
    [GetDataFromServer loginUserWithPhoneNumber:_userText.text Password:_passwordText.text CallBackDelegate:self];
    NSLog(@"%@===%@====",self.userText.text,self.passwordText.text);
    NSLog(@"登录中...");
    
    
}
#pragma mark 数据返回，delegate的方法
- (void)callbackData:(id)data RequestCode:(NSInteger)requestCode {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSLog(@"%@",data);
}
- (void)callbackError:(id)error {
//    [self addLabel];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width) / 3, 20, ([UIScreen mainScreen].bounds.size.width) / 3, 30)];
    _label.backgroundColor = [UIColor orangeColor];
    _label.text = @"登录失败";
    [self.view addSubview:_label];
    NSLog(@"%@",error);
}
- (void)addLabel {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width) / 3, 20, ([UIScreen mainScreen].bounds.size.width) / 3, 30)];
    _label.backgroundColor = [UIColor orangeColor];
    _label.text = @"登录失败";
    [self.view addSubview:_label];
    
//    [self.view performSelector:@selector(remove_label) withObject:nil afterDelay:3];
}
//- (void)remove_label {
//    [label removeFromSuperview];
//}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
//        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    }  else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
//        [self restoreTextName:self.emailTextName textField:self.emailText];
    }
//    else if (textField == self.emailText) {
//        [self diminishTextName:self.emailTextName];
//        [self restoreTextName:self.userTextName textField:self.userText];
//        [self restoreTextName:self.passwordTextName textField:self.passwordText];
//    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn==========");
    if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    }else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}
- (void)textFieldDidChange
{
    if (self.userText.text.length != 0 && self.passwordText.text.length != 0) {
//        NSLog(@"%@",self.userText.text);
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_passwordText.text.length!=0 && _userText.text.length!= 0) {
        NSLog(@"%@========%@======",_userText.text,_passwordText.text);
    }
}
#pragma mark 密码判断
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
#pragma mark 手机号码判断
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}



@end
