//
//  CustomerInfoListViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/24.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "CustomerInfoListViewController.h"

@interface CustomerInfoListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property UITableView *customerInfoListTable;
@property NSArray *customerBaseAry;
@property NSArray *customerIntentionAry;
@property NSArray *customerRoomAry;

@end

@implementation CustomerInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customerInfoListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    self.customerInfoListTable.delegate = self;
    self.customerInfoListTable.dataSource = self;
    [self.view addSubview:self.customerInfoListTable];
    self.customerBaseAry = [[NSArray alloc]initWithObjects:@"姓名：",@"移动手机",@"备用手机",@"电子邮件",@"QQ",@"家庭住址",@"备注", nil];
    self.customerIntentionAry = [[NSArray alloc]initWithObjects:@"客户来源",@"客户类型",@"导购",@"设计师",@"装企设计师",@"业务员",@"预算金额",@"预约量尺时间",@"预算金额",@"预算购买产品", nil];
    self.customerRoomAry = [[NSArray alloc]initWithObjects:@"房屋类型",@"房屋户型",@"平方价",@"预估交房时间",@"所属楼盘", nil];
    [self initNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"查看客户详情"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.backgroundColor = [UIColor greenColor];
    navigationBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:navigationBar];
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.customerBaseAry.count;
    }
    if (section == 1) {
        return self.customerIntentionAry.count;
    }
    else
        return self.customerRoomAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.customerBaseAry objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = [self.customerIntentionAry objectAtIndex:indexPath.row];
        }
        if (indexPath.section ==2) {
            cell.textLabel.text = [self.customerRoomAry objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

@end
