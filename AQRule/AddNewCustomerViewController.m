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

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation AddNewCustomerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    self.AreaView = [[UIView alloc]init];
    self.AreaView.backgroundColor = [UIColor whiteColor];
    
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
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
    [self.view addSubview:navigationBar];

}
-(void)back
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否放弃上传客户信息" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续填写", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)updata
{
    
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
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(80, 6, 150, 30)];
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.delegate = self;
            [cell.contentView addSubview:field];
            if (indexPath.row == 0) {
                QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio1.frame =CGRectMake(self.view.frame.size.width-120, 5, 60, 30);
                [_radio1 setTitle:@"先生" forState:UIControlStateNormal];
                [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio1];
                
                
                QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio2.frame = CGRectMake(self.view.frame.size.width-60, 5, 60, 30);
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
                self.addrField.borderStyle = UITextBorderStyleRoundedRect;
                self.addrField.delegate = self;
                [cell.contentView addSubview:self.addrField];
            }
            else
            {
                self.markField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-220, 5, 200, 30)];
                self.markField.borderStyle = UITextBorderStyleRoundedRect;
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
    self.locatePicker.frame = CGRectMake(0, 0, self.view.frame.size.width, self.AreaView.frame.size.height);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 1)];
    lineView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.AreaView addSubview:lineView];
    
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
@end
