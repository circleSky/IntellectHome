//
//  RigestrViewController.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/22.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "RigestrViewController.h"
#import "InputText.h"
#import "PrefixHeader.pch"
#import "GetDataFromServer.h"
#import "CallbackDelegate.h"

@interface RigestrViewController ()<UITextFieldDelegate,CallbackDelegate>
@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;
@property (nonatomic, weak)UITextField *emailText;
@property (nonatomic, weak)UILabel *emailTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;

@property (nonatomic, weak)UITextField *passwordTextSure;
@property (nonatomic, weak)UILabel *passwordTextSureName;

@property (nonatomic, weak)UIButton *loginBtn;
@property (nonatomic, assign) BOOL chang;
@end

@implementation RigestrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 50, 20)];
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
    //设置tag值
    self.userText.tag = 100;
    [userText setReturnKeyType:UIReturnKeyNext];
    [userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userText];
    UILabel *userTextName = [self setupTextName:@"昵称" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    
    CGFloat emailY = CGRectGetMaxY(userText.frame) + 30;
    UITextField *emailText = [inputText setupWithIcon:nil textY:emailY centerX:centerX point:nil];
    emailText.keyboardType = UIKeyboardTypeEmailAddress;
    [emailText setReturnKeyType:UIReturnKeyNext];
    emailText.delegate = self;
    self.emailText = emailText;
    //设置tag值
    self.emailText.tag = 101;
    [emailText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:emailText];
    
    UILabel *emailTextName = [self setupTextName:@"邮箱\\电话号码" frame:emailText.frame];
    self.emailTextName = emailTextName;
    [self.view addSubview:emailTextName];
    
    CGFloat passwordY = CGRectGetMaxY(emailText.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    //设置tag值
    self.passwordText.tag = 102;
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    
    
    CGFloat passwordYSure = CGRectGetMaxY(passwordText.frame) + 30;
    UITextField *passwordTextSure = [inputText setupWithIcon:nil textY:passwordYSure centerX:centerX point:nil];
    [passwordTextSure setReturnKeyType:UIReturnKeyDone];
    [passwordTextSure setSecureTextEntry:YES];
    passwordTextSure.delegate = self;
    self.passwordTextSure = passwordTextSure;
    //设置tag值
    self.passwordTextSure.tag = 103;
    [passwordTextSure addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTextSure];
    UILabel *passwordTextSureName = [self setupTextName:@"确认密码" frame:passwordTextSure.frame];
    self.passwordTextSureName = passwordTextSureName;
    [self.view addSubview:passwordTextSureName];
    
    
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.width = 200;
    loginBtn.height = 30;
    loginBtn.centerX = self.view.width * 0.5;
    loginBtn.y = CGRectGetMaxY(passwordTextSure.frame) + 30;
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor orangeColor]];
    loginBtn.enabled = NO;
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

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
#pragma mark 已经结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%ld",textField.tag);
    if (textField.tag == 100) {
        if ([self validateUserName:textField.text]) {
            NSLog(@"%@",textField.text);
            NSLog(@"=================");
            NSLog(@"%@",_userText.text);
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名输入格式不正确" message:@"用户名只能包含数字与字母,且为6到20个字符" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(textField.tag == 101) {//邮箱判断
        if ([self validateEmail:textField.text]) {
            
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"邮箱输入格式不正确" message:@"  eee" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
    else if(textField.tag == 102) {
        if ([self validatePassword:textField.text]) {
            
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码输入格式不正确" message:@"  密码应该大于六位" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(textField.tag == 103) {
        if ([textField.text isEqualToString:_passwordText.text]) {
            NSLog(@"ok");
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"两次密码不一致" message:@" 两次输入的密码应保持一致" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
#pragma mark 用户名判断
- (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
#pragma mark 邮箱判断
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark 密码判断
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        [self restoreTextName:self.passwordTextSureName textField:self.passwordTextSure];
    } else if (textField == self.emailText) {
        [self diminishTextName:self.emailTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        [self restoreTextName:self.passwordTextSureName textField:self.passwordTextSure];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextSureName textField:self.passwordTextSure];
    } else if (textField == self.passwordTextSure) {
        [self diminishTextName:self.passwordTextSureName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"%ld",textField.tag);
    if (textField == self.userText) {
        return [self.emailText becomeFirstResponder];
    } else if (textField == self.emailText){
        return [self.passwordText becomeFirstResponder];
    } else {
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
//    NSLog(@"change");
//    NSLog(@"%@",_usertText);
    
    
    if (self.userText.text.length != 0 && self.emailText.text.length != 0 && self.passwordText.text.length != 0) {
//        if ([_userText.text isEqualToString:@"yy"]) {
//            NSLog(@"OK");
//        }
        
//        NSLog(@"%@",self.userText.text);
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLogu(@"sss");
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.emailTextName textField:self.emailText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
    [self restoreTextName:self.passwordTextSureName textField:self.passwordTextSure];
}
#pragma mark 注册帐号
- (void)loginBtnClick
{
    
    [GetDataFromServer registUserWithPhoneNumber:_emailText.text EmailAddress:_emailText.text nickName:_userText.text Gender:0 Password:_passwordText.text CallBackDelegate:self];
    NSLog(@"%@===%@====%@",self.userText.text,self.passwordText.text,_emailText.text);
    NSLog(@"正在注册...");
}
#pragma mark 数据返回
- (void)callbackData:(id)data RequestCode:(NSInteger)requestCode {
    NSLog(@"%@",data);
}
- (void)callbackError:(id)error {
    NSLog(@"%@",error);
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
