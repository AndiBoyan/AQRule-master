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

@interface LoginViewController ()
{
    float viewWidth;
    float viewHeight;
}
@property UITextField *nameField;
@property UITextField *pwdField;

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
    navigationBar.backgroundColor = [UIColor greenColor];
    navigationBar.barStyle = UIBarStyleBlack;
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
                 
                 //将string中的\去除（去除转义字符）
                 NSLog(@"%@",[RequestDataParse newJsonStr:str]);
                 
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
                     AuthCode = [RequestDataParse encodeToPercentEscapeString:AuthCode];
                     MainViewController *vc = [[MainViewController alloc]init];
                     vc.selectedIndex = 0;
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

-(NSMutableURLRequest*)initializtionRequest
{
    NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *loginStr = [NSString stringWithFormat:@"Params={\"authCode\":\"login\",\"username\":\"%@\",\"pwd\":\"%@\"}&Command=Login/Login",self.name,self.password];
    
    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
}
@end
