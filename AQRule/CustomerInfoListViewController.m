//
//  CustomerInfoListViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/24.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "CustomerInfoListViewController.h"
#import "RequestDataParse.h"
#import "URLApi.h"
#import "NSAlertView.h"

@interface CustomerInfoListViewController ()

@end

@implementation CustomerInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customerBaseAry = [[NSArray alloc]initWithObjects:@"姓名",@"移动手机",@"备用手机",@"电子邮件",@"QQ",@"家庭住址", nil];
   // self.baseAry = [[NSMutableArray alloc]initWithArray:self.customerBaseAry];
    self.customerIntentionAry = [[NSArray alloc]initWithObjects:@"客户来源",@"客户类型",@"导购",@"设计师",@"装企设计师",@"业务员",@"预算金额",@"预约量尺时间",@"预算购买产品", nil];
   // self.intentionAry = [[NSMutableArray alloc]initWithArray:self.customerIntentionAry];
    self.customerRoomAry = [[NSArray alloc]initWithObjects:@"房屋类型",@"房屋户型",@"平方价",@"预估交房时间",@"所属楼盘", nil];
   // self.roomAry = [[NSMutableArray alloc]initWithArray:self.customerRoomAry];
    self.customerInfoListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:UITableViewStyleGrouped];
    self.customerInfoListTable.delegate = self;
    self.customerInfoListTable.dataSource = self;
    [self.view addSubview:self.customerInfoListTable];
    // Do any additional setup after loading the view.

    [self initNavigation];
    [self analyseRequestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化导航栏

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"查看客户详情"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.baseAry.count;
    }
    if (section == 1) {
        return self.intentionAry.count;
    }
    else
        return self.roomAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (indexPath.section == 0) {
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(20, 10, 100, 20) text:[self.customerBaseAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
            
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(150, 10, self.view.frame.size.width-170, 20) text:[self.baseAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentRight isNumLine:NO];
            
        }
        if (indexPath.section == 1) {
            //cell.textLabel.text = [self.customerIntentionAry objectAtIndex:indexPath.row];
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(20, 10, 100, 20) text:[self.customerIntentionAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
            
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(150, 10, self.view.frame.size.width-170, 20) text:[self.intentionAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentRight isNumLine:NO];
        }
        if (indexPath.section ==2) {
            //cell.textLabel.text = [self.customerRoomAry objectAtIndex:indexPath.row];
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(20, 10, 100, 20) text:[self.customerRoomAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
            
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(150, 10, self.view.frame.size.width-170, 20) text:[self.roomAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentRight isNumLine:NO];
        }
    }
    return cell;
}

#pragma mark 客户详细信息数据请求

-(NSMutableURLRequest*)initializtionRequest
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"customerId\":\"%@\",\"serviceId\":\"%@\"}&Command=Customer/GetCustomerInfo",code,self.CustomerId,self.ServiceId];
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    return request;
}

-(void)analyseRequestData
{
    self.baseAry = [[NSMutableArray alloc]init];
    self.intentionAry = [[NSMutableArray alloc]init];
    self.roomAry = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self initializtionRequest];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",[RequestDataParse newJsonStr:str]);
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSDictionary *CustomeInfo = [JSON objectForKey:@"CustomeInfo"];
             name = [CustomeInfo objectForKey:@"CustomerName"];
             NSLog(@"name=%@",name);
             [self.baseAry addObject:name];
             NSLog(@"base = %@",self.baseAry);
             phone1 = [CustomeInfo objectForKey:@"Mobile"];
             [self.baseAry addObject:phone1];
             phone2 = [CustomeInfo objectForKey:@"NMobile"];
             [self.baseAry addObject:phone2];
             
             
             NSDictionary *CustomerService = [JSON objectForKey:@"CustomerService"];
             email = [CustomerService objectForKey:@"Email"];
             [self.baseAry addObject:email];
             qq = [CustomerService objectForKey:@"QQ"];
             [self.baseAry addObject:qq];
             addr = [CustomeInfo objectForKey:@"Address"];
             [self.baseAry addObject:addr];
             
             customerType = [CustomerService objectForKey:@"CustomerType"];
             [self.intentionAry addObject:customerType];
             customerSource = [CustomerService objectForKey:@"CustomerSource"];
             [self.intentionAry addObject:customerSource];
             shoppingGuide = [CustomerService objectForKey:@"FollowPerson"];
             [self.intentionAry addObject:shoppingGuide];
             
             designer = [CustomerService objectForKey:@"Designer"];
             [self.intentionAry addObject:designer];
             decDesigner = [CustomerService objectForKey:@"AllianceDesigner"];
             [self.intentionAry addObject:decDesigner];
             salesman = [CustomerService objectForKey:@"SalesPerson"];
             [self.intentionAry addObject:salesman];
             budgetCoust = @"111";//[CustomerService objectForKey:@"Budget"];
             [self.intentionAry addObject:budgetCoust];
             
             budgetTime = @"";//[CustomerService objectForKey:@"MeasueTime"];
             [self.intentionAry addObject:budgetTime];
             budgetProducts = @"";
             [self.intentionAry addObject:budgetProducts];
             
             roomType = [CustomerService objectForKey:@"HouseType"];
             [self.roomAry addObject:roomType];
             roomApart = [CustomerService objectForKey:@"RoomType"];
             [self.roomAry addObject:roomApart];
             price = @"111";//[CustomerService objectForKey:@"SquarePrice"];
             [self.roomAry addObject:price];
             deliveryTime = @"";//[CustomerService objectForKey:@"HaveContractTime"];
             [self.roomAry addObject:deliveryTime];
             property = [CustomerService objectForKey:@"HousesName"];
             [self.roomAry addObject:property];
             
             NSLog(@"%@%@%@",self.baseAry,self.intentionAry,self.roomAry);
             [self.customerInfoListTable reloadData];
         }];


    });
   
}
@end
