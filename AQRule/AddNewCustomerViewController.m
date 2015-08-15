//
//  AddNewCustomerViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "AddNewCustomerViewController.h"
#import "HZAreaPickerView.h"
#import "QRadioButton.h"
#import "RequestDataParse.h"

@interface AddNewCustomerViewController ()<UITableViewDataSource,UITableViewDelegate,
                                          HZAreaPickerDelegate,UITextFieldDelegate,
                                          QRadioButtonDelegate>

@property UITableView *customerTable;
@property NSArray *customerAry1;
@property NSArray *customerAry2;
@property UILabel *areaLab;
@property UITextField *addrField;
@property UITextField *markField;
@property UIView *AreaView;
@property NSString *customerName;
@property NSString *customerPhone;
@property NSString *customerProvice;
@property NSString *customerCity;
@property NSString *customerArea;
@property NSString *customerAddr;
@property NSString *customerNote;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation AddNewCustomerViewController
/*
 http://oppein.3weijia.com/oppein.axds?Params={"authCode":"pdBcFCMd%2FhDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC%2BomUKBlk5av4c8qgvFa1za%2FQ3HB02gJhEPmjA%3D","CustomerName":"明珠","Sex":"1","Mobile":"13698752635","Province":"广东省","City":"广州市","CArea":"天河区","Adress":"软件路15号"}&Command=Customer/CreateCustomer
 2015-08-06 09:36:15.690 AQRule[554:15622] {"Status":200,"JSON":"null","ErrorMessage":"","InfoMessage":""}
 */
-(NSMutableURLRequest*)initializtionRequest
{
    NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = @"pdBcFCMd/hDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC+omUKBlk5av4c8qgvFa1za/Q3HB02gJhEPmjA=";
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"CustomerName\":\"明珠\",\"Sex\":\"1\",\"Mobile\":\"13265559888\",\"Province\":\"广东省\",\"City\":\"广州市\",\"CArea\":\"天河区\",\"Adress\":\"软件路15号\"}&Command=Customer/CreateCustomer",code];
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
             NSLog(@"%@",[RequestDataParse newJsonStr:str]);
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"%@",dic);
             NSString *ErrorMessage = [dic objectForKey:@"ErrorMessage"];
             if ([ErrorMessage isEqualToString:@""]) {
                 NSLog(@"添加客户成功");
             }
             else
             {
                 NSLog(@"手机号码已存在");
             }
            }];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self analyseRequestData];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    self.AreaView = [[UIView alloc]init];
    self.AreaView.backgroundColor = [UIColor redColor];
    
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    self.locatePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.customerAry1 = [[NSArray alloc]initWithObjects:@"姓名",@"手机号", nil];
    self.customerAry2 = [[NSArray alloc]initWithObjects:@"所在区域",@"详细地址",@"备注", nil];
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
    [navigationItem setTitle:@"新增客户"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(updata)];
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
    //[self dismissViewControllerAnimated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否放弃上传客户信息" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续填写", nil];
    alert.tag = 1000;
    [alert show];
}

-(void)updata
{
    if ((self.customerName.length <= 0)||(self.customerPhone.length <= 0)||(self.customerProvice.length <= 0)||
        (self.customerCity.length <= 0)||(self.customerArea.length <= 0)||(self.customerAddr.length <= 0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传的信息不完整，请完善后重新上传" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    [self analyseRequestData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1000)&&(buttonIndex == 0)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.customerAry1.count;
    }
    else
        return self.customerAry2.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.customerAry1 objectAtIndex:indexPath.row];
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(80, 6, 120, 30)];
            field.borderStyle = UITextBorderStyleNone;
            field.tag = 1000+indexPath.row;
            field.returnKeyType = UIReturnKeyDone;
            field.delegate = self;
            [cell.contentView addSubview:field];
            if (indexPath.row == 0) {
                QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio1.frame =CGRectMake(self.view.frame.size.width-100, 5, 50, 30);
                [_radio1 setTitle:@"先生" forState:UIControlStateNormal];
                [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio1];
                
                
                QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio2.frame = CGRectMake(self.view.frame.size.width-50, 5, 50, 30);
                [_radio2 setTitle:@"女士" forState:UIControlStateNormal];
                [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio2];
                [_radio1 setChecked:YES];

            }
        }
        else
        {
            cell.textLabel.text = [self.customerAry2 objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                self.areaLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 200, 20)];
                self.areaLab.font = [UIFont systemFontOfSize:12.0f];
                self.areaLab.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:self.areaLab];
            }
            else if (indexPath.row == 1)
            {
                self.addrField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-220, 5, 200, 30)];
                self.addrField.borderStyle = UITextBorderStyleNone;
                self.addrField.delegate = self;
                [cell.contentView addSubview:self.addrField];
            }
            else
            {
                self.markField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-220, 5, 200, 30)];
                self.markField.borderStyle = UITextBorderStyleNone;
                self.markField.delegate = self;
                [cell.contentView addSubview:self.markField];
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1)&&(indexPath.row == 0)) {
       // [self cancelLocatePicker];

       // [self.locatePicker showInView:self.view];
        [self showView:self.view];
    }
    if ((indexPath.section == 1)&&(indexPath.row == 1)) {
        
    }
}

#pragma mark textFieldDelegate


#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        self.areaLab.text = str;
    } else{
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}
#pragma mark - animation

- (void)showView:(UIView *) view
{
    self.AreaView.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.locatePicker.frame.size.height);
    [self.AreaView addSubview:self.locatePicker];
    self.AreaView.backgroundColor = [UIColor whiteColor];
    self.locatePicker.frame = CGRectMake(0, 40, self.view.frame.size.width, self.AreaView.frame.size.height);
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(30, 5, 40, 30);
    btn1.tag = 1001;
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(areaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.AreaView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(self.view.frame.size.width-70, 5, 40, 30);
    btn2.tag = 1002;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(areaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.AreaView addSubview:btn2];
    
    [view addSubview:self.AreaView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AreaView.frame = CGRectMake(0, view.frame.size.height - self.AreaView.frame.size.height, self.AreaView.frame.size.width, self.AreaView.frame.size.height);
    }];
    
}

- (void)cancelAreaView
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.AreaView.frame = CGRectMake(0, self.AreaView.frame.origin.y+self.AreaView.frame.size.height, self.AreaView.frame.size.width, self.AreaView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.AreaView removeFromSuperview];
                         
                     }];
    
}
-(void)areaAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1001) {
        [self cancelAreaView];
        self.areaLab.text = @"";
    }
    else
    {
        [self cancelAreaView];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    //[self cancelLocatePicker];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
