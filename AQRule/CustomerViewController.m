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
#import "RequestDataParse.h"
#import "URLApi.h"

@interface CustomerViewController ()

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavigation];
    [self initHTHorizontalView];
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-155)];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self setExtraCellLineHidden:self.customerTable];
    [self.view addSubview:self.customerTable];
    
    
    [self initYiRefreshHeader];
    [self initYiRefreshFooter];
}

#pragma mark 初始化

//初始化数组
-(void)initData
{
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
}

//初始化分段选择器
-(void)initHTHorizontalView
{
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 600, 40)];
    //核心：表示可滑动区域的大小    其实就是scrView中所有内容的总高度  当可滑动区域的高大于scrollView的高时，scrollView 才可以滑动
    [scrView setContentSize:CGSizeMake(0, -200)];
    [self.view addSubview:scrView];
    
    self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, -66, self.view.frame.size.width, 40)];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.selectionList.backgroundColor = [UIColor colorWithRed:232/255.0 green:230/255.0 blue:226/255.0 alpha:1.0f];
    self.selectionList.selectionIndicatorColor = [UIColor colorWithRed:0 green:0.6392 blue:0.9255 alpha:1.0f];
    
    self.carMakes = @[@"已报备",
                      @"已分配",
                      @"已量尺",
                      @"已设计",
                      @"已检查",
                      @"已沟通",
                      @"已复尺",
                      @"已签合同",
                      @"安装完成",
                      @"已回访"];
    
    [scrView addSubview:self.selectionList];
}

#pragma mark 下拉刷新以及上拉加载

//下拉刷新
-(void)initYiRefreshHeader
{
    // YiRefreshHeader  头部刷新按钮的使用
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=self.customerTable;
    [refreshHeader header];
    
    refreshHeader.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (customerType == nil) {
                customerType = @"HaveRegister";
                customerTypeChange = @"HaveRegister";
                [self analyseRequestData:@"HaveRegister" index:1 keyWord:@""];
            }
            else
            {
                [self analyseRequestData:customerType index:indexPage keyWord:@""];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                //[self analyseRequestData];
                [self.customerTable reloadData];
                [refreshHeader endRefreshing];
            });
        });
    };
    // 是否在进入该界面的时候就开始进入刷新状态
    [refreshHeader beginRefreshing];
}

//上拉刷新
-(void)initYiRefreshFooter
{
    // YiRefreshFooter  底部刷新按钮的使用
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=self.customerTable;
    [refreshFooter footer];
    
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //sleep(2);
            // [self analyseRequestData];
            if (customerType == nil) {
                customerType = @"HaveRegister";
                customerTypeChange = @"HaveRegister";
                [self analyseRequestData:@"HaveRegister" index:1 keyWord:@""];
            }
            else
            {
                [self analyseRequestData:customerType index:indexPage keyWord:@""];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.customerTable reloadData];
                [refreshFooter endRefreshing];
            });
        });
    };
}

#pragma mark 绘制界面

//初始化导航栏
-(void)initNavigation
{
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    searchBarButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    addCustomerBarButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCustomerAction:)];
    backButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"cancle.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    donebutton  = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCustomerBarButton,searchBarButton, nil];
}

#pragma mark 搜索功能实现
-(void)searchAction:(id)sender
{
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.font = [UIFont systemFontOfSize:14.0f];
    searchField.placeholder = @"关键字";
    searchField.delegate = self;
    searchField.returnKeyType = UIReturnKeyDone;
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.titleView = searchField;
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = donebutton;
}

-(void)cancelAction:(id)sender
{
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
    indexPage = 1;
    [self analyseRequestData:customerType index:indexPage keyWord:@""];
    [searchField resignFirstResponder];
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"我的客户";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCustomerBarButton,searchBarButton, nil];
}
-(void)doneAction:(id)sender
{
    [searchField resignFirstResponder];
    if (searchField.text.length <= 0) {
        return;
    }
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
    [self analyseRequestData:customerType index:1 keyWord:searchField.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//添加用户信息
-(void)addCustomerAction:(id)sender
{
    AddNewCustomerViewController *addNewCustomerVC = [[AddNewCustomerViewController alloc]init];
    [self presentViewController:addNewCustomerVC animated:YES completion:nil];
}

#pragma mark - 分段选择器方法实现

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.carMakes.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.carMakes[index];
}

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    [searchField resignFirstResponder];
    /*已报备:HaveRegister  已分配:HaveDistribution 已量尺:HaveMeasure 已设计:HaveDesign
      已检查:HaveChecked   已沟通:HaveCommunicate  已复尺:HaveCheckScale  已签合同:HaveContract
      安装完成:HaveFinish   已回访:HaveVisiting
     */
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
    indexPage = 1;
    if ([self.carMakes[index]isEqualToString:@"已报备"]) {
        
        customerType  = @"HaveRegister";
        [self analyseRequestData:@"HaveRegister" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已分配"]) {
        customerType  = @"HaveDistribution";
        [self analyseRequestData:@"HaveDistribution" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已量尺"]) {
        customerType  = @"HaveMeasure";
        [self analyseRequestData:@"HaveMeasure" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已设计"]) {
        customerType  = @"HaveDesign";
        [self analyseRequestData:@"HaveDesign" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已检查"]) {
        customerType  = @"HaveChecked";
        [self analyseRequestData:@"HaveChecked" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已沟通"]) {
        customerType  = @"HaveCommunicate";
        [self analyseRequestData:@"HaveCommunicate" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已复尺"]) {
        customerType  = @"HaveCheckScale";
        [self analyseRequestData:@"HaveCheckScale" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已签合同"]) {
        customerType  = @"HaveContract";
        [self analyseRequestData:@"HaveContract" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"安装完成"]) {
        customerType  = @"HaveFinish";
        [self analyseRequestData:@"HaveFinish" index:indexPage keyWord:@""];
    }
    else if ([self.carMakes[index]isEqualToString:@"已回访"]) {
        customerType  = @"HaveVisiting";
        [self analyseRequestData:@"HaveVisiting" index:indexPage keyWord:@""];
    }
}

#pragma mark uitabledelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customerNameAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 65, 20)];
        nameLab.text = [self.customerNameAry objectAtIndex:indexPath.row];
        nameLab.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:17.0f];
        [cell.contentView addSubview:nameLab];
        
        UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 200, 20)];
        phoneLab.text = [self.customerPhoneAry objectAtIndex:indexPath.row];
        phoneLab.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
        phoneLab.textAlignment = NSTextAlignmentLeft;
        phoneLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:phoneLab];
        
        UILabel *adrLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 300, 20)];
        adrLab.text =[self.customerAddrAry objectAtIndex:indexPath.row];
        adrLab.textAlignment = NSTextAlignmentLeft;
        adrLab.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:137/255.0 alpha:1.0];
        adrLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:adrLab];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        
        longPressGR.minimumPressDuration = 1;
        
        [self.view addGestureRecognizer:longPressGR];
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
    
    customerInfoVC.name = [self.customerNameAry objectAtIndex:indexPath.row];
    customerInfoVC.phone = [self.customerPhoneAry objectAtIndex:indexPath.row];
    customerInfoVC.address = [self.customerAddrAry objectAtIndex:indexPath.row];
    customerInfoVC.CustomerId = [self.CustomerId objectAtIndex:indexPath.row];
    customerInfoVC.ServiceId = [self.ServiceId objectAtIndex:indexPath.row];
    customerInfoVC.UserId = [self.UserId objectAtIndex:indexPath.row];
    
    [self presentViewController:customerInfoVC animated:YES completion:nil];
}

//tableView 优化
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

//长按响应
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.customerTable];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.customerTable indexPathForRowAtPoint:tmpPointTouch];
        deleteIndex = indexPath.row;
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"删除客户" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [sheet showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self analyseDeleteRequestData:[self.CustomerId objectAtIndex:deleteIndex]];
    }
}
#pragma mark 数据请求

//查询用户
-(NSMutableURLRequest*)initializtionRequest:(NSString*)customerOfType index:(int)index keyWord:(NSString*)keyWord
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"pageIndex\":\"%d\",\"pageSize\":\"10\",\"keyWord\":\"%@\",\"CustomerSchedule\":\"%@\"}&Command=Customer/GetCustomerList",code,index,keyWord,customerOfType];
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    return request;
}

-(void)analyseRequestData:(NSString*)customerOfType index:(int)index keyWord:(NSString*)keyWord
{
    [customerIsNullLab removeFromSuperview];
    if (![customerType isEqualToString:customerTypeChange]) {
        customerTypeChange = customerType;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [self initializtionRequest:customerOfType index:index keyWord:keyWord];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             NSLog(@"%@",[RequestDataParse newJsonStr:str]);
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSString *InfoMessage = [dic objectForKey:@"InfoMessage"];
             if (![InfoMessage isEqualToString:@"获取列表成功"]) {
                 
                 return ;
             }
             indexPage++;
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *ReList = [JSON objectForKey:@"ReList"];
             
             for (id relist in ReList) {
                 //customerId  serviceId
                 NSString *CustomerName = [relist objectForKey:@"CustomerName"];
                 NSString *Mobile = [relist objectForKey:@"Mobile"];
                 NSString *Province = [relist objectForKey:@"Province"];
                 NSString *City = [relist objectForKey:@"City"];
                 NSString *CArea = [relist objectForKey:@"CArea"];
                 NSString *Address = [relist objectForKey:@"Address"];
                 
                 NSString *userAdr = [NSString stringWithFormat:@"%@%@%@%@",Province,City,CArea,Address];
                 
                 NSString *CustomerId = [relist objectForKey:@"CustomerId"];
                 NSString *ServiceId = [relist objectForKey:@"ServiceId"];
                 NSString *UserId = [relist objectForKey:@"UserId"];
                 for (int i=0 ;i < self.customerNameAry.count;i++)
                 {
                     if ([[self.customerNameAry objectAtIndex:i]isEqualToString:CustomerName]&&[[self.customerPhoneAry objectAtIndex:i]isEqualToString:Mobile]&&[[self.customerAddrAry objectAtIndex:i]isEqualToString:Address]) {
                         return;
                     }
                 }
                 [self.customerNameAry addObject:CustomerName];
                 [self.customerPhoneAry addObject:Mobile];
                 [self.customerAddrAry addObject:userAdr];
                 
                 [self.ServiceId addObject:ServiceId];
                 [self.CustomerId addObject:CustomerId];
                 [self.UserId addObject:UserId];
    
             }
        
             if (self.customerNameAry.count <= 0) {
                 customerIsNullLab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)+15, 200, 30)];
                 customerIsNullLab.text = @"没有客户信息";
                 customerIsNullLab.font = [UIFont systemFontOfSize:17.0f];
                 customerIsNullLab.textAlignment = NSTextAlignmentCenter;
                 [self.view addSubview:customerIsNullLab];
             }
            [self.customerTable reloadData];
         }];
    });
}

//删除用户
-(NSMutableURLRequest*)initializtionDeleteRequest:(NSString*)customerId
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"customerId\":\"%@\"}&Command=Customer/DelteCustomer",code,customerId];
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    return request;
}

-(void)analyseDeleteRequestData:(NSString*)customerId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [self initializtionDeleteRequest:customerId];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             NSLog(@"%@",str);
             
             NSData *newData = [str dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSString *JSON = [dic objectForKey:@"JSON"];
             if ([JSON isEqualToString:@"true"]) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除客户成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 
                 [self.customerNameAry removeObjectAtIndex:deleteIndex];
                 [self.customerPhoneAry removeObjectAtIndex:deleteIndex];
                 [self.customerAddrAry removeObjectAtIndex:deleteIndex];
                 [self.ServiceId removeObjectAtIndex:deleteIndex];
                 [self.CustomerId removeObjectAtIndex:deleteIndex];
                 [self.UserId removeObjectAtIndex:deleteIndex];
                 
                 [self.customerTable reloadData];
             }
         }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
