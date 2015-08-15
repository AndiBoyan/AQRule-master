//
//  CustomerInfoViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "CustomerLocationViewController.h"
#import "CustomerInfoListViewController.h"
#import "RuleInfoViewController.h"
#import "AddSpaceViewController.h"
#import "RequestDataParse.h"

@interface CustomerInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property NSArray *customerAry1;
@property NSMutableArray *customerAry2;
@property UITableView *customerTable;

@end

@implementation CustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    self.customerAry1 = [[NSArray alloc]initWithObjects:self.address,@"查看客户详情", nil];
    self.customerAry2 = [[NSMutableArray alloc]initWithObjects:@"AAAAAA",@"BBBBBBB",@"CCCCCCC", nil];
    
    
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
    [navigationItem setTitle:@"量尺空间"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"first_normal@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"first_normal@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addRoom)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.backgroundColor = [UIColor greenColor];
    navigationBar.barStyle = UIBarStyleBlack;
    
    [self.view addSubview:navigationBar];
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addRoom
{
    AddSpaceViewController *VC = [[AddSpaceViewController alloc]init];
    [self presentViewController:VC animated:YES completion:nil];
}
#pragma mark uitabledelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.customerAry1.count+1;
    }
    else
        return self.customerAry2.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.customerAry2.count <= 0)
    {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 240, 200, 40)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15.0f];
        lab.text = @"暂无量尺信息";
        [self.customerTable addSubview:lab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake((self.view.frame.size.width-60)/2, 270, 60, 40);
        [btn setTitle:@"添加空间" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addRoom) forControlEvents:UIControlEventTouchUpInside];
        [self.customerTable addSubview:btn];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
                nameLab.textAlignment = NSTextAlignmentLeft;
                nameLab.font = [UIFont systemFontOfSize:15.0f];
                nameLab.text = self.name;
                [cell.contentView addSubview:nameLab];
                UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, 150, 20)];
                phoneLab.textAlignment = NSTextAlignmentLeft;
                phoneLab.font = [UIFont systemFontOfSize:12.0f];
                phoneLab.text = self.phone;
                [cell.contentView addSubview:phoneLab];
                for (int i = 0; i < 2; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    btn.frame = CGRectMake(self.view.frame.size.width-50-i*60, 20, 40, 30);
                    btn.tag = 2000+i;
                    [btn setImage:[[UIImage imageNamed:(i == 0)?@"first_normal@2x":@"second_normal@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    
                    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                }
            }
           else
           {
               cell.textLabel.text = [self.customerAry1 objectAtIndex:indexPath.row-1];
               cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
           }
        }
        else
        {
            UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 15)];
            timeLab.text = @"6月24日(周三)  12:00";
            timeLab.textAlignment = NSTextAlignmentLeft;
            timeLab.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:timeLab];
            
            UILabel *typeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 200, 20)];
            typeLab.text = @"厨房 - 复尺";
            typeLab.font = [UIFont systemFontOfSize:15.0f];
            typeLab.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:typeLab];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(self.view.frame.size.width-50, 15, 40, 30);

            [btn setImage:[[UIImage imageNamed:@"second_normal@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(updataRoomInfo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn1.frame = CGRectMake(self.view.frame.size.width-110, 15, 40, 30);
            
            [btn1 setImage:[[UIImage imageNamed:@"second_normal@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            
            [btn1 addTarget:self action:@selector(deleteRoomInfo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];

            
        }
    }
    return cell;
}
-(void)deleteRoomInfo:(id)sender
{
    
}
-(void)updataRoomInfo:(id)sender
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if((indexPath.section == 0)&&(indexPath.row == 0))
   {
       return 80;
   }
    if (indexPath.section == 1) {
        return 60;
    }
   else
       return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
        
    }
    else if ((indexPath.section == 0)&&(indexPath.row == 1)) {
        //地图
        CustomerLocationViewController *vc = [[CustomerLocationViewController alloc]init];
        vc.navTitle = [self.customerAry1 objectAtIndex:0];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if ((indexPath.section == 0)&&(indexPath.row == 2)) {
        //详情
        CustomerInfoListViewController *vc = [[CustomerInfoListViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        RuleInfoViewController *ruleInfoVC = [[RuleInfoViewController alloc]init];
        [self presentViewController:ruleInfoVC animated:YES completion:nil];
    }
}
-(void)sendMessage:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 2000) {
        //电话
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定拨打电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
    else
    {
        //短信
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择短信模板" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        alert.tag = 1001;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if((alertView.tag == 1000)&&(buttonIndex == 1))
    {
        //拨打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
    }
    else if ((alertView.tag == 1001)&&(buttonIndex == 1))
    {
        //发送短信
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://800888"]];
    }

}

-(NSMutableURLRequest*)initializtionRequest//:(NSString*)index customerType:(NSString*)customerType
{
    NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = @"pdBcFCMd/hDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC+omUKBlk5av4c8qgvFa1za/Q3HB02gJhEPmjA=";
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"customerId\":\"00000005\",\"serviceId\":\"00000044\"}&Command=Customer/GetCustomerInfo",code];
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
}
-(void)analyseRequestData
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self initializtionRequest];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSString *InfoMessage = [dic objectForKey:@"InfoMessage"];
             if (InfoMessage.length <= 0) {
                 return ;
             }
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *ReList = [JSON objectForKey:@"ReList"];
             for (id relist in ReList) {
                 //customerId  serviceId
                 NSString *CustomerName = [relist objectForKey:@"CustomerName"];
                 NSString *Mobile = [relist objectForKey:@"Mobile"];
                 NSString *Address = [relist objectForKey:@"Address"];

             }
         }];
    });
}

@end
