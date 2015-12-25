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
}
@end
@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky.jpg"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"loginOrnot" object:nil];
    
    [self creatTableView];
}
- (void)getNotification:(NSNotification *)sender {
    NSLog(@"%@",sender.object);
    if ([sender.object isEqualToString:@"OK"]) {
        NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
        [userdefults setObject:@"登录" forKey:@"states"];
    }
    [self loadData];
    [maintableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}
- (void)loadData {
    arrayM = [[NSMutableArray alloc] init];
    NSArray *arrayBack = [NSArray array];
    //对plist文件进行解析，保存在字典之中
     NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoginOrUnlogin" ofType:@"plist" ]];
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    if ([userdefults objectForKey:@"states"] == nil) {
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
    }
}
#pragma mark-创建tableView
- (void)creatTableView {
    maintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCR_H / 7, (SCR_W / 3) * 2, (SCR_H / 7) * 5) style:UITableViewStylePlain];
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
