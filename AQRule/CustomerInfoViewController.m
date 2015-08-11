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

@interface CustomerInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property NSString *name;
@property NSString *phone;
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
    self.name = @"余大妞";
    self.phone = @"15377772222";
    self.customerAry1 = [[NSArray alloc]initWithObjects:@"天河软件园管委会",@"查看客户详情", nil];
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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"新增空间" style:UIBarButtonItemStylePlain target:self action:@selector(addRoom)];
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
                    btn.frame = CGRectMake(self.view.frame.size.width-55-i*40, 20, 40, 30);
                    btn.tag = 2000+i;
                    
                    [btn setTitle:(i == 0)?@"电话":@"短信" forState:UIControlStateNormal];
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
            
            UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 50, 30)];
            stateLab.text = @"未上传";
            stateLab.font = [UIFont systemFontOfSize:14.0f];
            stateLab.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:stateLab];
            
        }
    }
    return cell;
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
@end
