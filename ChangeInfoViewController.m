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
#import "GetDataFromServer.h"
#import <UIImageView+WebCache.h>
#import "CallbackDelegate.h"

#define SCR_H [UIScreen mainScreen].bounds.size.height
#define SCR_W [UIScreen mainScreen].bounds.size.width

@interface ChangeInfoViewController ()<UITextFieldDelegate,CallbackDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *iconImageView;
    NSData *uploadImageData;
}
@property NSDictionary *data;
@property UITextField *nickTextField;
@property UITextField *emailAddressTextField;
@property UITextField *genderTextField;
@property UITextField *phoneNumberTextField;
@property UITextField *userIdTextField;

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self creatUserIconImageView];
    [self creatDismisBtn];
    [self creatTextField];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
}
- (void)loadData {
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userdefults objectForKey:@"USER_INFO"];
    NSLog(@"%@",dict);
    _data = dict[@"Data"];
}
#pragma mark 创建dismis按钮


- (void)creatDismisBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(dismisBtn_touch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)dismisBtn_touch {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark- 创建头像imageView
- (void)creatUserIconImageView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGester:)];
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCR_W / 5) * 2, 50, SCR_W / 5, SCR_W / 5)];
    iconImageView.layer.borderWidth = 1;
//    iconImageView.layer.masksToBounds = YES;
    iconImageView.clipsToBounds = YES;
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.borderColor = [[UIColor orangeColor] CGColor];
    iconImageView.layer.cornerRadius = SCR_W / 10;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://10.5.155.200%@",_data[@"HeaderImage"]]] placeholderImage:[UIImage imageNamed:@"xiaoren"]];
    
//    iconImageView.image = [UIImage imageNamed:@"xiaoren"];
//    iconImageView.backgroundColor = [UIColor redColor];
    tap.numberOfTapsRequired = 1;
    [iconImageView addGestureRecognizer:tap];
    
    [self.view addSubview:iconImageView];
}
#pragma mark- iconImageView添加的手势
- (void)tapGester:(UITapGestureRecognizer *)sender {
    NSLog(@"====================");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择要上传的图片" message:@"请选择打开的类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOpenFile = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openFile];
    }];
    UIAlertAction *actionTakePhoto = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    [alert addAction:actionOpenFile];
    [alert addAction:actionTakePhoto];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 打开相册
- (void)openFile {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark 打开相机
- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
#pragma mark 当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        uploadImageData = data;
        
      
        iconImageView.image = image;
        //        //图片保存的路径
        //        //这里将图片放在沙盒的documents文件夹中
        //        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //
        //        //文件管理器
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //
        //        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        //        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        //
        //        //得到选择后沙盒中图片的完整路径
        //        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //
        //        //关闭相册界面
        //        [picker dismissModalViewControllerAnimated:YES];
        //
        //        //创建一个选择后图片的小图标放在下方
        //        //类似微薄选择图后的效果
        //        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
        //                                    CGRectMake(50, 120, 40, 40)];
        //
        //        smallimage.image = image;
        //        //加在视图中
        //        [self.view addSubview:smallimage];
        
        [picker dismissViewControllerAnimated:YES completion:^{
                        [self uploadFile];
            
//            [self uploadWithPut];
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)uploadFile {
    // 接收文件上传的地址
    NSString *urlString = @"http://10.5.155.200/UserAction/UploadUserHeaderImageHandler.ashx";
    
    // 服务器端上传表单项的名称，一定与服务器端接收文件的名一致
    // 文件上传时，对于文件参数需要准备的三个数据：
    // 参数名
    NSString *uploadInputFieldName = @"ImageFileUrl";
    // 文件名
    NSString *sourceFileName = @"fileName.jpg";
    // 要上传文件的文件内容
    NSData* data = uploadImageData;
    
    
    
    // 要传递的其他的POST的参数
    NSDictionary *params = @{
                             @"UserId": _data[@"UserId"]                 // 其他要POST传递的参数
                             
                             };
    
    
    
    
    
    /*********************以上按需要修改，下面的代码为固定代码，一般不需要修改*************************/
    
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    
    
    
    
    //要上传的文件
    //    NSString *imageFileName = [params objectForKey:uploadInputFieldName];
    //得到图片的data
    
    
    //[NSData dataWithContentsOfFile:imageFileName];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //        if(![key isEqualToString:uploadInputFieldName])
        //        {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        //        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", uploadInputFieldName, sourceFileName];    // 文件名
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    
    
    /**************************
     
     执行上传，处理上传后返回的内容
     
     **************************/
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        
        
        NSUserDefaults *userdefult = [NSUserDefaults standardUserDefaults];
        
        
        
        [userdefult setObject:dictionary forKey:@"USER_INFO"];
//        [self loadData];
//        [iconImageView reloadInputViews];
        
        
    }];
    [task resume];
}


- (void)creatTextField {
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W / 6 , (SCR_H / 10) * 2 - 30, 50, 30)];
    nickLabel.text = @"昵称";
    _nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCR_W / 6, (SCR_H / 10) * 2, (SCR_W / 6) * 3, 50)];
    _nickTextField.text = _data[@"Alias"];
    _nickTextField.textAlignment = NSTextAlignmentCenter;
    _nickTextField.layer.borderColor = [[UIColor blueColor] CGColor];
    _nickTextField.layer.borderWidth = 1;
    _nickTextField.userInteractionEnabled = NO;
    
    UIButton *nickBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W / 6) * 4, (SCR_H / 10) * 2, (SCR_W / 6), 50)];
    nickBtn.backgroundColor = [UIColor redColor];
    nickBtn.tag = 100;
    [nickBtn addTarget:self action:@selector(btn_touch:) forControlEvents:UIControlEventTouchUpInside];
    [nickBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.view addSubview:nickBtn];
    [self.view addSubview:nickLabel];
    [self.view addSubview:_nickTextField];
    
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W / 6 , CGRectGetMaxY(_nickTextField.frame), 50, 30)];
    emailLabel.text = @"邮箱";
    _emailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCR_W / 6, CGRectGetMaxY(emailLabel.frame), (SCR_W / 6) * 3, 50)];
    
    if ([_data[@"EmailAddress"] isEqualToString:@""]) {
        _emailAddressTextField.placeholder = @"该用户暂时未绑定邮箱";
//        _emailAddressTextField.text = @"该用户暂时未绑定邮箱";
    }
    else {
        _emailAddressTextField.text = _data[@"EmailAddress"];
    }
    _emailAddressTextField.textAlignment = NSTextAlignmentCenter;
    _emailAddressTextField.layer.borderColor = [[UIColor blueColor] CGColor];
    _emailAddressTextField.layer.borderWidth = 1;
    _emailAddressTextField.userInteractionEnabled = NO;
    UIButton *emailBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W / 6) * 4, CGRectGetMaxY(emailLabel.frame), (SCR_W / 6), 50)];
    emailBtn.backgroundColor = [UIColor redColor];
    emailBtn.tag = 101;
    [emailBtn addTarget:self action:@selector(btn_touch:) forControlEvents:UIControlEventTouchUpInside];
    [emailBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.view addSubview:emailBtn];
    [self.view addSubview:emailLabel];
    [self.view addSubview:_emailAddressTextField];
    
    
    UILabel *phonelLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W / 6 , CGRectGetMaxY(_emailAddressTextField.frame), 50, 30)];
    phonelLabel.text = @"电话";
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCR_W / 6, CGRectGetMaxY(phonelLabel.frame), (SCR_W / 6) * 3, 50)];
    
    if ([_data[@"PhoneNumber"] isEqualToString:@""]) {
        _phoneNumberTextField.text = @"该用户暂时未绑定邮箱";
    }
    else {
        _phoneNumberTextField.text = _data[@"PhoneNumber"];
    }
    _phoneNumberTextField.textAlignment = NSTextAlignmentCenter;
    _phoneNumberTextField.layer.borderColor = [[UIColor blueColor] CGColor];
    _phoneNumberTextField.layer.borderWidth = 1;
    _phoneNumberTextField.userInteractionEnabled = NO;
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W / 6) * 4, CGRectGetMaxY(phonelLabel.frame), (SCR_W / 6), 50)];
    phoneBtn.backgroundColor = [UIColor redColor];
    phoneBtn.tag = 102;
    [phoneBtn addTarget:self action:@selector(btn_touch:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.view addSubview:phoneBtn];
    [self.view addSubview:phonelLabel];
    [self.view addSubview:_phoneNumberTextField];
    
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W / 3, CGRectGetMaxY(_phoneNumberTextField.frame) + 100, SCR_W / 3, 50)];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtn_touch) forControlEvents:UIControlEventTouchUpInside];
    okBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:okBtn];
    
}
- (void)btn_touch:(UIButton *)sender {

    if (sender.tag == 100) {
        [_nickTextField becomeFirstResponder];
        _nickTextField.userInteractionEnabled = YES;
    }
    if (sender.tag == 101) {
        _emailAddressTextField.userInteractionEnabled = YES;
    }
    if (sender.tag == 102) {
        _phoneNumberTextField.userInteractionEnabled = YES;
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)okBtn_touch {
    
//    [GetDataFromServer getUserInfoWithUserId:_data[@"UserId"] CallBackDelegate:self];
    
    [GetDataFromServer updateUserInfoWithUserId:_data[@"UserId"] PhoneNumber:_phoneNumberTextField.text EmailAddress:_emailAddressTextField.text NickName:_nickTextField.text Gender:_data[@"Gender"] CallBackDelegate:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",_nickTextField.text);
}











@end
