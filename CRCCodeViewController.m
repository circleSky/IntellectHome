//
//  CRCCodeViewController.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/25.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "CRCCodeViewController.h"
#import <UIImageView+WebCache.h>

#define SCR_H [UIScreen mainScreen].bounds.size.height
#define SCR_W [UIScreen mainScreen].bounds.size.width

@interface CRCCodeViewController ()

@end

@implementation CRCCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismisBtn_touch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self creatImageView];
}

- (void)dismisBtn_touch {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)creatImageView {
    
    
    UIImageView *crcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, SCR_H / 4, SCR_W - 60, SCR_W - 60)];
    NSUserDefaults *userdefults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userdefults objectForKey:@"USER_INFO"];
    
    
    [crcImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://10.5.155.200%@",[dict[@"Data"] objectForKey:@"CRCodeImage"]]]];
    
    [self.view addSubview:crcImageView];
    
}
@end
