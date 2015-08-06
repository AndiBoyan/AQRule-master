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
#import "HTHorizontalSelectionList.h"
#import "RequestDataParse.h"

@interface CustomerViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>
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
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) NSArray *carMakes;

@property NSMutableArray *customerNameAry;
@property NSMutableArray *customerPhoneAry;
@property NSMutableArray *customerAddrAry;

@end

@implementation CustomerViewController


/*
 customerType:
 
 Allocated = 已分配,
 measured = 已量尺,
 designed = 已设计,
 Communication = 已沟通,
 checked = 已复尺,
 SignedContract = 已签合同
 
 */

-(void)analyseRequestData//:(NSString*)authCode pageIndex:(NSString*)index pageSize:(NSString*)size keyWord:(NSString*)keyWord customerType:(NSString*)customerType
{
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    
    NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = @"pdBcFCMd/hDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC+omUKBlk5av4c8qgvFa1za/Q3HB02gJhEPmjA=";
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"pageIndex\":\"1\",\"pageSize\":\"20\",\"keyWord\":\"\",\"CustomerSchedule\":\"Allocated\"}&Command=Customer/GetCustomerList",code];
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         
         str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
         NSLog(@"%@",str);
         NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
         NSString *InfoMessage = [dic objectForKey:@"InfoMessage"];
         if (InfoMessage.length <= 0) {
             return ;
         }
         NSDictionary *JSON = [dic objectForKey:@"JSON"];
         NSArray *ReList = [JSON objectForKey:@"ReList"];
         for (id relist in ReList) {
             NSString *CustomerName = [relist objectForKey:@"CustomerName"];
             NSString *Mobile = [relist objectForKey:@"Mobile"];
             NSString *Address = [relist objectForKey:@"Address"];
             
             [self.customerNameAry addObject:CustomerName];
             [self.customerPhoneAry addObject:Mobile];
             [self.customerAddrAry addObject:Address];
         }
     }];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigation];
   
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 600, 40)];
    //核心：表示可滑动区域的大小    其实就是scrView中所有内容的总高度  当可滑动区域的高大于scrollView的高时，scrollView 才可以滑动
    [scrView setContentSize:CGSizeMake(700, -200)];
    [self.view addSubview:scrView];
    
    self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, -65, self.view.frame.size.width, 40)];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.selectionList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectionList.selectionIndicatorColor = [UIColor greenColor];
    self.carMakes = @[@"已分配",
                      @"已量尺",
                      @"已设计",
                      @"已沟通",
                      @"已复尺",
                      @"已签合同"];
    
    [scrView addSubview:self.selectionList];
    
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
            [self analyseRequestData];
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
            //sleep(2);
            //[self analyseRequestData];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.customerTable reloadData];
                [refreshFooter endRefreshing];
            });
        });
    };
}
#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.carMakes.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.carMakes[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for the corresponding index
    NSLog(@"%@",self.carMakes[index]) ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化导航栏
-(void)initNavigation
{
    //self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [rightButton setImage:[UIImage imageNamed:@"search_img.png"]forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(searchAction:)forControlEvents:UIControlEventTouchUpInside];
    
    searchBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
   // searchBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_img@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    addCustomerBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_img@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addCustomerAction:)];
    backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_img@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    donebutton  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_img@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
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
    return self.customerNameAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 65, 20)];
        nameLab.text = [self.customerNameAry objectAtIndex:indexPath.row];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:17.0f];
        [cell.contentView addSubview:nameLab];
        
        UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 200, 20)];
        phoneLab.text = [self.customerPhoneAry objectAtIndex:indexPath.row];
        phoneLab.textAlignment = NSTextAlignmentLeft;
        phoneLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:phoneLab];
        
        UILabel *adrLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 300, 20)];
        adrLab.text =[self.customerAddrAry objectAtIndex:indexPath.row];
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
