//
//  LeftViewController.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/21.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginAndRigisterViewController.h"
#import "RigestrViewController.h"
#import <YRSideViewController.h>
#import "AppDelegate.h"

#import <UIImageView+WebCache.h>

//修改个人信息
#import "ChangeInfoViewController.h"
//用户二维码
#import "CRCCodeViewController.h"

#define SCR_W [UIScreen mainScreen].bounds.size.width
#define SCR_H [UIScreen mainScreen].bounds.size.height

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *maintableView;
    NSMutableArray *arrayM;
    UIImageView *headerImageView;
    UIButton *btn2;
}
@end
@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky.jpg"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"loginOrnot" object:nil];
    
    [self creatTableView];
    
    [self addBottomBtn];
}

- (void)addBottomBtn {
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, (SCR_H / 9) * 7, SCR_W / 3, 50)];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SCR_W / 6 - 10, 40)];
    iconImageView.image = [UIImage imageNamed:@"star_full"];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W / 6 + 5, 5, SCR_W / 6, 40)];
    label1.text = @"设置";
    [btn1 addSubview:label1];
    [btn1 addSubview:iconImageView];
    [self.view addSubview:btn1];
    
    
}


- (void)creatHeaderImageView {
    [headerImageView removeFromSuperview];
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userdefults objectForKey:@"USER_INFO"];
    NSDictionary *data = dictionary[@"Data"];
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_W / 10, SCR_H / 9, (SCR_W / 10) * 3, (SCR_W / 10) * 3)];
    headerImageView.layer.cornerRadius = ((SCR_W / 10) * 3)/2;
    headerImageView.layer.borderColor = [[UIColor orangeColor] CGColor];
    headerImageView.layer.borderWidth = 1;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://10.5.155.200%@",data[@"HeaderImage"]]] placeholderImage:[UIImage imageNamed:@"xiaoren"]];
    headerImageView.clipsToBounds = YES;
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImageView.frame), CGRectGetMaxY(headerImageView.frame) - 50, (SCR_W/3)*2 - SCR_W / 10 - (SCR_W / 10) * 3 - 5, 50)];
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textColor = [UIColor whiteColor];
//    [nickLabel sizeToFit];
    nickLabel.text = data[@"Alias"];
    
    [self.view addSubview:nickLabel];
    [self.view addSubview:headerImageView];
}



- (void)getNotification:(NSNotification *)sender {
    NSLog(@"%@",sender.object);
    if ([sender.object isEqualToString:@"OK"]) {
        NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
        [userdefults setObject:@"登录" forKey:@"states"];
        
    }
    [self loadData];
    [self creatHeaderImageView];
    [maintableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
    [self creatHeaderImageView];
    
}
- (void)loadData {
    arrayM = [[NSMutableArray alloc] init];
    NSArray *arrayBack = [NSArray array];
    //对plist文件进行解析，保存在字典之中
     NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoginOrUnlogin" ofType:@"plist" ]];
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    if (![[userdefults objectForKey:@"states"] isEqualToString:@"登录"]) {
        //利用key将字典之中的对应数据取出来
        arrayBack = dict[@"unlogin"];
        [arrayM addObject:[arrayBack[0] objectForKey:@"userRegister"]];
        [arrayM addObject:[arrayBack[1] objectForKey:@"userLogin"]];
        [arrayM addObject:[arrayBack[2] objectForKey:@"findPassword"]];
    }
    else {
        arrayBack = dict[@"login"];
        [arrayM addObject:[arrayBack[0] objectForKey:@"userInfo"]];
        [arrayM addObject:[arrayBack[1] objectForKey:@"myOwnCode"]];
        [arrayM addObject:[arrayBack[2] objectForKey:@"changePassword"]];
        [arrayM addObject:[arrayBack[3] objectForKey:@"notification"]];
        [arrayM addObject:[arrayBack[4] objectForKey:@"shoppingCart"]];
        
        btn2 = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W / 3, (SCR_H / 9) * 7, SCR_W / 3, 50)];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SCR_W / 6 - 10 , 40)];
        imageView2.image = [UIImage imageNamed:@"zhuxiao"];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W / 6 + 5, 5, SCR_W / 6 , 40)];
        label2.text = @"注销";
        [btn2 addTarget:self action:@selector(btn2_touch) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addSubview:label2];
        [btn2 addSubview:imageView2];
        [self.view addSubview:btn2];
    }
}

- (void)btn2_touch {//注销按钮
    
    NSLog(@"==============");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    [userdefults setObject:nil forKey:@"states"];
    [userdefults setObject:nil forKey:@"USER_INFO"];
    [btn2 removeFromSuperview];
    [self loadData];
    [maintableView reloadData];
    [self creatHeaderImageView];
    
    
    
    //    userdefults setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
    
}

#pragma mark-创建tableView
- (void)creatTableView {
    maintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (SCR_H / 7) * 2, (SCR_W / 3) * 2, (SCR_H / 7) * 5) style:UITableViewStylePlain];
    maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    maintableView.delegate = self;
    maintableView.dataSource = self;
    maintableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maintableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEFT_CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LEFT_CELL"];
    }
    cell.imageView.image = [UIImage imageNamed:@"xiaoren"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = arrayM[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    YRSideViewController *side = (YRSideViewController *)(self.parentViewController);
    [side hideSideViewController:YES];
    NSUserDefaults *userdefult = [NSUserDefaults standardUserDefaults];
    if ([userdefult objectForKey:@"states"] == nil) {//说明此时还没有登录成功
        if (indexPath.row == 0) {
            RigestrViewController *regist = [[RigestrViewController alloc] init];
            [self presentViewController:regist animated:YES completion:^{
                NSLog(@"===&&&&&&&&&&========");
            }];
        }
        else if(indexPath.row == 1) {
            LoginAndRigisterViewController *next = [[LoginAndRigisterViewController alloc] init];
            
            [self presentViewController:next animated:YES completion:^{
                NSLog(@"====================");
            }];
        }
    }
    else {
        switch (indexPath.row) {
            case 0: {
                ChangeInfoViewController *changeInfo = [[ChangeInfoViewController alloc] init];
                [self presentViewController:changeInfo animated:YES completion:^{
                    
                }];
            }
                break;
            case 1: {
                CRCCodeViewController *crcCode = [[CRCCodeViewController alloc] init];
                [self presentViewController:crcCode animated:YES completion:^{
                    
                }];
            }
                break;
            case 2: {
                
            }
                break;
            case 3: {
                
            }
                break;
            case 4: {
                
            }
                break;
                
            default:
                break;
        }
    }
}
@end
