//
//  LoginViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/30.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    float viewWidth;
    float viewHeight;
}
@property NSString *name;
@property NSString *password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    // Do any additional setup after loading the view.
    [self initView];
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
    [navigationItem setTitle:@"登录"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
}


-(void)initView
{
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-40+viewWidth/2, 120, 80, 80)];
    logoImgView.backgroundColor = [UIColor greenColor];
    logoImgView.image = [UIImage imageNamed:@""];
    [self.view addSubview:logoImgView];
    
    UILabel *logoLab = [[UILabel alloc]initWithFrame:CGRectMake(-40+viewWidth/2, 220, 80, 40)];
    logoLab.text = @"易量尺";
    logoLab.textAlignment = NSTextAlignmentCenter;
    logoLab.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:logoLab];
    
    UIView *phoneview = [[UIView alloc]initWithFrame:CGRectMake(0, 320, viewWidth, 50)];
    phoneview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneview];
    
    UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 40)];
    phoneLab.text = @"手机号";
    phoneLab.textAlignment = NSTextAlignmentLeft;
    phoneLab.font = [UIFont systemFontOfSize:17.0f];
    [phoneview addSubview:phoneLab];
    
    UIView *psdview = [[UIView alloc]initWithFrame:CGRectMake(0, 371, viewWidth, 50)];
    psdview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:psdview];
    
    UILabel *psdLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 40)];
    psdLab.text = @"密码";
    psdLab.textAlignment = NSTextAlignmentLeft;
    psdLab.font = [UIFont systemFontOfSize:17.0f];
    [psdview addSubview:psdLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, 470, viewWidth-50, 50);
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)login
{
    //http://oppein.3weijia.com/oppein.axds?Params={"authCode":"login","username":"oppeinadmin","pwd":"hegii@2014"}&Command=Login/Login
    /*NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    //Params={"authCode":"login","username":"oppeinadmin","pwd":"hegii@2014"}
    NSString *str0 = @"Params={\"authCode\":\"login\",\"username\":\"oppeinadmin\",\"pwd\":\"hegii@2014\"}";//设置参数
    
    NSData *data0 = [str0 dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data0];

    NSString *str = @"&Command=Login/Login";//设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    NSLog(@"%@",request);
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"%@",str1);*/
    /* NSString *loginString = @"http://oppein.3weijia.com/oppein.axds?Params={\"authCode\":\"login\",\"username\":\"oppeinadmin\",\"pwd\":\"hegii@2014\"}&Command=Login/Login";
    NSURL *loginUrl = [NSURL URLWithString:loginString];
    NSString *loginJson = [NSString stringWithContentsOfURL:loginUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *loginData = [loginJson dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",loginData);
    //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:loginData options:NSJSONReadingMutableContainers error:nil];*/
    // 1.创建请求
         NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
         request.HTTPMethod = @"POST";
    NSString *test = @"Params={\"authCode\":\"login\",\"username\":\"oppeinadmin\",\"pwd\":\"hegii@2014\"}&Command=Login/Login";
        NSData *data1 = [test dataUsingEncoding:NSUTF8StringEncoding];

 
    [request setHTTPBody:data1];
        NSLog(@"%@",request);
         // 4.发送请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] );
        }];
}
 @end
