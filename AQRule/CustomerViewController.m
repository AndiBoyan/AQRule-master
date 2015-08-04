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
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"

@interface CustomerViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem *searchBarButton;
    UIBarButtonItem *addCustomerBarButton;
    UIBarButtonItem *backButton;
    UIBarButtonItem *donebutton;
    
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
}
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
    scrView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [scrView setContentSize:CGSizeMake(700, -200)];
    [self.view addSubview:scrView];
    
    /*UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -60, 100, 30)];
    lab.text = @"11111";
    [scrView addSubview:lab];*/
    NSArray *ary = [[NSArray alloc]initWithObjects:@"已分配",@"已量尺",@"已设计",@"已沟通",@"已复尺",@"已签合同", nil];
    for (int i = 0; i < 6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(i*70, -60, 70, 30);
        button.tag = 1000+i;
        [button setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrView addSubview:button];
    }
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-155)];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    // YiRefreshHeader  头部刷新按钮的使用
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=self.customerTable;
    [refreshHeader header];
    
    refreshHeader.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.customerTable reloadData];
                [refreshHeader endRefreshing];
            });
            
        });
        
    };
    
    // 是否在进入该界面的时候就开始进入刷新状态
    [refreshHeader beginRefreshing];
    
    // YiRefreshFooter  底部刷新按钮的使用
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=self.customerTable;
    [refreshFooter footer];
    
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.customerTable reloadData];
                [refreshFooter endRefreshing];
            });
        });
    };
}
-(void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    NSLog(@"%ld",btn.tag);
    if (btn.tag == 1000) {
        
    }
    else if(btn.tag == 1001)
    {
        
    }
    else if (btn.tag == 1002)
    {
        
    }
    else if (btn.tag == 1003)
    {
        
    }
    else if(btn.tag == 1004)
    {
        
    }
    else
    {
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化导航栏
-(void)initNavigation
{
    searchBarButton = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    addCustomerBarButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCustomerAction:)];
    backButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    donebutton  = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCustomerBarButton,searchBarButton, nil];
    
   

}
//搜索功能实现
-(void)searchAction:(id)sender
{
    //self.title = @"";
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.titleView = searchField;
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = donebutton;
}

-(void)cancelAction:(id)sender
{
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"我的客户";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCustomerBarButton,searchBarButton, nil];
}
-(void)doneAction:(id)sender
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
        cell.selectionStyle = UITableViewCellAccessoryNone;
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 65, 20)];
        nameLab.text = @"张先生";
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:17.0f];
        [cell.contentView addSubview:nameLab];
        
        UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 200, 20)];
        phoneLab.text = @"15020172880";
        phoneLab.textAlignment = NSTextAlignmentLeft;
        phoneLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:phoneLab];
        
        UILabel *adrLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 300, 20)];
        adrLab.text = @"广州市萝岗区科学城开创大道北锦林山庄";
        adrLab.textAlignment = NSTextAlignmentLeft;
        adrLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:adrLab];
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
