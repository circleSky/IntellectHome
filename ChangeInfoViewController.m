//
//  ChangeInfoViewController.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/23.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "InputText.h"
#import "PrefixHeader.pch"

@interface ChangeInfoViewController ()

@property NSDictionary *data;
    
@property UITextField *nickTextField;
@property UILabel *nickTextFieldName;
    
@property UITextField *emailAddressTextField;
@property UILabel *emailAddressTextFieldName;
    
@property UITextField *genderTextField;
@property UILabel *genderTextFieldName;
    
@property UITextField *phoneNumberTextField;
@property UILabel *phoneNumberTextFieldName;
    
@property UITextField *userIdTextField;
@property UILabel *userIdTextFieldName;
    
    
    

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userdefults objectForKey:@"USER_INFO"];
    NSLog(@"%@",dict);
    _data = dict[@"Data"];
    [self creatUI];
    
}
- (void)creatUI {
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *nickName = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    nickName.delegate = self;
    
    _nickTextField = nickName;
    _nickTextField.tag = 100;
    [_nickTextField setReturnKeyType:UIReturnKeyNext];
    
    [nickName addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:nickName];
    
    UILabel *nickTextfieldName = [self setupTextName:@"电话号码\\邮箱" frame:userText.frame];
    self.nickTextFieldName = nickTextfieldName;
    [self.view addSubview:nickTextfieldName];
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
