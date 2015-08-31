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
#import "OpinionViewController.h"
#import "RequestDataParse.h"
#import "URLApi.h"

@interface CustomerInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *infoLab;
    UIButton *infoBtn;
}

@property NSArray *customerAry1;
@property NSMutableArray *customerAry2;
@property NSMutableArray *customerAry3;
@property NSMutableArray *customerAry4;
@property NSMutableArray *isUpdataAry;
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
   // self.customerAry2 = [[NSMutableArray alloc]initWithObjects:@"AAAAAA",@"BBBBBBB",@"CCCCCCC", nil];

    [self initNavigation];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height-80, 80, 80);
    [button setTitle:@"建议" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(opinion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)opinion
{
    OpinionViewController *vc =[[OpinionViewController alloc]init];
    vc.ServiceId = self.ServiceId;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self analyseRequestData];
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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addRoom)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
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
-(void)addRoom
{
    AddSpaceViewController *VC = [[AddSpaceViewController alloc]init];
    VC.ServiceId = self.ServiceId;
    VC.UserId = self.UserId;
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
                    btn.frame = CGRectMake(self.view.frame.size.width-50-i*60, 20, 40, 30);
                    btn.tag = 2000+i;
                    [btn setImage:[[UIImage imageNamed:(i == 0)?@"phone":@"message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    
                    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                }
            }
           else if(indexPath.row ==1)
           {
               UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 18)];
               img.image = [UIImage imageNamed:@"location.png"];
               [cell.contentView addSubview:img];
               
               UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 150, 20)];
               lab.text = [self.customerAry1 objectAtIndex:indexPath.row-1];
               lab.font = [UIFont systemFontOfSize:14.0f];
               lab.textAlignment = NSTextAlignmentLeft;
               [cell.contentView addSubview:lab];
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
            timeLab.text = [self.customerAry2 objectAtIndex:indexPath.row];
            timeLab.textAlignment = NSTextAlignmentLeft;
            timeLab.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:timeLab];
            
            UILabel *typeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 200, 20)];
            typeLab.text = [self.customerAry3 objectAtIndex:indexPath.row];
            typeLab.font = [UIFont systemFontOfSize:15.0f];
            typeLab.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:typeLab];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(self.view.frame.size.width-80, 15, 50, 30);
            
            if ([[self.isUpdataAry objectAtIndex:indexPath.row]integerValue] == 0) {
                
                [btn setTitle:@"未上传" forState:UIControlStateNormal];
                
                //[btn addTarget:self action:@selector(updataRoomInfo:) forControlEvents:UIControlEventTouchUpInside];
            }
           else
           {
              [btn setTitle:@"已上传" forState:UIControlStateNormal];
           }
            [cell.contentView addSubview:btn];
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
        vc.CustomerId = self.CustomerId;
        vc.ServiceId = self.ServiceId;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        RuleInfoViewController *ruleInfoVC = [[RuleInfoViewController alloc]init];
        ruleInfoVC.MeasureId =[self.customerAry4 objectAtIndex:indexPath.row];
        ruleInfoVC.ServiceId = self.ServiceId;
        ruleInfoVC.UserId = self.UserId;
        [self presentViewController:ruleInfoVC animated:YES completion:nil];
    }
}
-(void)sendMessage:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 2000) {
        //电话
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定拨打电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
    else
    {
        //短信
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择短信模板" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        alert.tag = 1001;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",self.phone];
    NSString *smsStr = [NSString stringWithFormat:@"sms://%@",self.phone];
    if((alertView.tag == 1000)&&(buttonIndex == 1))
    {
        //拨打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
    else if ((alertView.tag == 1001)&&(buttonIndex == 1))
    {
        //发送短信
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:smsStr]];
    }

}

-(NSMutableURLRequest*)initializtionRequest
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];

    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"serviceId\":\"%@\"}&Command=MeasureSpace/GetMeasureList",code,self.ServiceId];
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
}
-(void)analyseRequestData
{
    self.customerAry2 = [[NSMutableArray alloc]init];
    self.customerAry3 = [[NSMutableArray alloc]init];
    self.customerAry4 = [[NSMutableArray alloc]init];
    self.isUpdataAry = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self initializtionRequest];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",[RequestDataParse newJsonStr:str]);
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];

             NSArray *JSON = [dic objectForKey:@"JSON"];
             for (id relist in JSON) {
                 NSString *CreateDate = [relist objectForKey:@"MeasureTime"];
                 NSString *HouseType = [relist objectForKey:@"SpaceName"];
                 NSString *Style = [relist objectForKey:@"Style"];
                 NSString *MeasureId = [relist objectForKey:@"MeasureId"];
                 NSNumber *ISUpload = [relist objectForKey:@"ISUpload"];
                 //NSLog(@"%d",[ISUpload integerValue]);
                 NSString *str = [NSString stringWithFormat:@"%@-%@",HouseType,Style];
                 [self.customerAry2 addObject:CreateDate];
                 [self.customerAry3 addObject:str];
                 [self.customerAry4 addObject:MeasureId];
                 [self.isUpdataAry addObject:ISUpload];
             }
             if(self.customerAry2.count <= 0)
             {
                 infoLab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 240, 200, 40)];
                 infoLab.textAlignment = NSTextAlignmentCenter;
                 infoLab.font = [UIFont systemFontOfSize:15.0f];
                 infoLab.text = @"暂无量尺信息";
                 [self.customerTable addSubview:infoLab];
                 
                 infoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                 infoBtn.frame = CGRectMake((self.view.frame.size.width-60)/2, 270, 60, 40);
                 [infoBtn setTitle:@"添加空间" forState:UIControlStateNormal];
                 [infoBtn addTarget:self action:@selector(addRoom) forControlEvents:UIControlEventTouchUpInside];
                 [self.customerTable addSubview:infoBtn];
                 
                 return;
             }
             [infoLab removeFromSuperview];
             [infoBtn removeFromSuperview];
             [self.customerTable reloadData];
         }];
        
    });
    
    
}

@end
