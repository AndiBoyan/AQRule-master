//
//  LoginViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/30.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "RequestDataParse.h"
#import "NSAlertView.h"
#import "URLApi.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    float viewWidth;
    float viewHeight;
    BOOL isSecure;
}
@property UITextField *nameField;
@property UITextField *pwdField;

@property NSString *name;
@property NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    isSecure = YES;
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"登录"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

-(void)initView
{
    
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-40+viewWidth/2, 110, 80, 80)];
    logoImgView.backgroundColor = [UIColor greenColor];
    logoImgView.image = [UIImage imageNamed:@""];
    [self.view addSubview:logoImgView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:logoImgView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = logoImgView.bounds;
    maskLayer.path = maskPath.CGPath;
    logoImgView.layer.mask = maskLayer;
    
    UILabel *logoLab = [[UILabel alloc]initWithFrame:CGRectMake(-40+viewWidth/2, 210, 80, 40)];
    logoLab.text = @"易量尺";
    logoLab.textAlignment = NSTextAlignmentCenter;
    logoLab.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:logoLab];
    
    UIView *phoneview = [[UIView alloc]initWithFrame:CGRectMake(0, 290, viewWidth, 40)];
    phoneview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneview];
    
    UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    phoneLab.text = @"手机号";
    phoneLab.textAlignment = NSTextAlignmentLeft;
    phoneLab.font = [UIFont systemFontOfSize:17.0f];
    [phoneview addSubview:phoneLab];
    
    UITextField *phoneField = [[UITextField alloc]initWithFrame:CGRectMake(80, 5, viewWidth-160, 30)];
    phoneField.delegate = self;
    phoneField.tag = 1000;
    phoneField.textAlignment = NSTextAlignmentCenter;
    phoneField.font = [UIFont systemFontOfSize:14.0f];
    [phoneview addSubview:phoneField];
    
    UIView *psdview = [[UIView alloc]initWithFrame:CGRectMake(0, 331, viewWidth, 40)];
    psdview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:psdview];
    
    UILabel *psdLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    psdLab.text = @"密码";
    psdLab.textAlignment = NSTextAlignmentLeft;
    psdLab.font = [UIFont systemFontOfSize:17.0f];
    [psdview addSubview:psdLab];
    
    self.pwdField = [[UITextField alloc]initWithFrame:CGRectMake(80, 5, viewWidth-160, 30)];
    self.pwdField.delegate = self;
    self.pwdField.tag = 1001;
    self.pwdField.secureTextEntry = YES;
    self.pwdField.textAlignment = NSTextAlignmentCenter;
    self.pwdField.font = [UIFont systemFontOfSize:14.0f];
    [psdview addSubview:self.pwdField];
    
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //secureButton.backgroundColor = [UIColor redColor];
    secureButton.frame = CGRectMake(250, 5, 40, 30);
    [secureButton setImage:[[UIImage imageNamed:@"secure.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [secureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [secureButton addTarget:self action:@selector(secureTextEntry) forControlEvents:UIControlEventTouchUpInside];
    [psdview addSubview:secureButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:103/255.0 green:149/255.0 blue:221/255.0 alpha:1.0];
    button.frame = CGRectMake(25, 410, viewWidth-50, 40);
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:button.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = button.bounds;
    maskLayer1.path = maskPath1.CGPath;
    button.layer.mask = maskLayer1;
}

-(void)secureTextEntry
{
    isSecure = !isSecure;
    self.pwdField.secureTextEntry = isSecure;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 用户登录

-(void)login
{
    self.name = @"oppeinadmin";//self.nameField.text;
    self.password = @"op123456";//self.pwdField.text;
    if ((self.name.length <= 0)&&(self.password <= 0)) {
        [NSAlertView alert:@"用户名或者密码为空"];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
            [NSURLConnection sendAsynchronousRequest:[self initializtionRequest]
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 //将得到的NSData数据转换成NSString
                 NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                 
                 //将数据变成标准的json数据
                 
                 NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
                 
                 /*得到json中的key值
                  InfoMessage : 登录是否成功返回
                  JSON        : 登录返回数据
                  AuthCode    : 用户的授权码
                */
                 
                 NSString *InfoMessage = [dic objectForKey:@"InfoMessage"];
                 NSDictionary *JSON = [dic objectForKey:@"JSON"];

                 if (InfoMessage.length > 0) {
                     
                     //登陆成功
                     NSString *AuthCode = [JSON objectForKey:@"AuthCode"];
                     
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setObject:AuthCode forKey:@"AuthCode"];
                     
                     AuthCode = [RequestDataParse encodeToPercentEscapeString:AuthCode];
                     MainViewController *vc = [[MainViewController alloc]init];
                     vc.selectedIndex = 0;
                     [NSAlertView addAnimation:self.view push:YES];
                     [self presentViewController:vc animated:YES completion:nil];
                 }
                 else
                 {
                     //登录失败
                     [NSAlertView alert:@"用户名或密码错误"];
                     return;
                 }
             }];
    });
}
//http://oppein.3weijia.com/oppein.axds?Params={"authCode":"login","username":"oppeinadmin","pwd":"op123456"}&Command=Login/Login
-(NSMutableURLRequest*)initializtionRequest
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *loginStr = [NSString stringWithFormat:@"Params={\"authCode\":\"login\",\"username\":\"%@\",\"pwd\":\"%@\"}&Command=Login/Login",self.name,self.password];
    
    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
}

@end
