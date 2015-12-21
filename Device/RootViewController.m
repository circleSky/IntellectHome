//
//  RootViewController.m
//  IntellectHome
//
//  Created by 吴卓 on 15/12/21.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import "RootViewController.h"
#import "DeviceTableViewCell.h"

//群组选择小界面
#import "GroupOptionViewController.h"
#import "DeviceOptionViewController.h"
@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
{
    UITableView *maintableView;
    UIButton *titleBtn;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTableView];
    
}
#pragma mark-用titleBtn添加到titleView
- (void)viewWillAppear:(BOOL)animated {
    [self creatTitleBtn];
    [self creatRightBarbutton];
}

#pragma markcreatTitleBtn
- (void)creatTitleBtn {
    titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleBtn setTitle:@"当前群组▽" forState:UIControlStateNormal];
    [titleBtn setBackgroundColor:[UIColor redColor]];
    
    [titleBtn addTarget:self action:@selector(titleBtn_touch) forControlEvents:UIControlEventTouchUpInside];
    self.parentViewController.navigationItem.titleView = titleBtn;
    
}
- (void)titleBtn_touch {
    [titleBtn setTitle:@"当前群组△" forState:UIControlStateNormal];
    GroupOptionViewController *target = [[GroupOptionViewController alloc] init];
    target.modalPresentationStyle = UIModalPresentationPopover;
    target.preferredContentSize = CGSizeMake(200, 300);
    
    UIPopoverPresentationController *pop = target.popoverPresentationController;
    
    pop.sourceRect = self.parentViewController.navigationItem.titleView.frame;
    pop.sourceView = self.parentViewController.navigationItem.titleView;
    
    pop.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
    pop.delegate = self;
    
    
    [self presentViewController:target animated:YES completion:nil];
    
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
#pragma mark creatRightBarbutton
- (void)creatRightBarbutton {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"≡" style:UIBarButtonItemStylePlain target:self action:@selector(rightbarButton_touch)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)rightbarButton_touch {
    DeviceOptionViewController *target = [[DeviceOptionViewController alloc] init];
    target.modalPresentationStyle = UIModalPresentationPopover;
    target.preferredContentSize = CGSizeMake(200, 300);
    
    UIPopoverPresentationController *pop = target.popoverPresentationController;
    
    pop.sourceRect = self.parentViewController.navigationItem.titleView.frame;
    pop.sourceView = self.parentViewController.navigationItem.titleView;
    
    pop.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
    pop.delegate = self;
    
    
    [self presentViewController:target animated:YES completion:nil];
}

#pragma mark-创建tableView
- (void)creatTableView {
    maintableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    maintableView.delegate = self;
    maintableView.dataSource = self;
    
    [maintableView registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DEVICE_CELL"];
    [self.view addSubview:maintableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DEVICE_CELL" forIndexPath:indexPath];
    
        
        
    return cell;
}






























@end