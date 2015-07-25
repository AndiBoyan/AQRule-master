//
//  CustomerViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "CustomerViewController.h"
#import "AddNewCustomerViewController.h"
#import "CustomerInfoViewController.h"

@interface CustomerViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property UITableView *customerTable;
@property NSArray *nameAry;
@property NSArray *phoneAry;
@property NSArray *addrAry;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigation];
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 600, 40)];
    //核心：表示可滑动区域的大小    其实就是scrView中所有内容的总高度  当可滑动区域的高大于scrollView的高时，scrollView 才可以滑动
    scrView.backgroundColor = [UIColor redColor];
    [scrView setContentSize:CGSizeMake(650, -200)];
    [self.view addSubview:scrView];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -60, 100, 30)];
    lab.text = @"11111";
    [scrView addSubview:lab];
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-105)];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化导航栏
-(void)initNavigation
{
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    UIBarButtonItem *addCustomerBarButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCustomerAction:)];
    
    self.navigationItem.leftBarButtonItem = searchBarButton;
    self.navigationItem.rightBarButtonItem = addCustomerBarButton;
    
   

}
//搜索功能实现
-(void)searchAction:(id)sender
{
    
}
//添加用户信息
-(void)addCustomerAction:(id)sender
{
    AddNewCustomerViewController *addNewCustomerVC = [[AddNewCustomerViewController alloc]init];
    [self presentViewController:addNewCustomerVC animated:YES completion:nil];
}
#pragma mark uitabledelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.textLabel.text = @"22222";
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerInfoViewController *customerInfoVC = [[CustomerInfoViewController alloc]init];
    [self presentViewController:customerInfoVC animated:YES completion:nil];
}
@end
