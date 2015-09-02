//
//  AddSpaceViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/27.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "EditSpaceViewController.h"
#import "QRadioButton.h"
#import "RequestDataParse.h"
#import "NSAlertView.h"
#import "QCheckBox.h"
#import "NSAlertView.h"
#import "URLApi.h"
#import "EditImageViewController.h"

@interface  EditSpaceViewController()<UITableViewDataSource,UITableViewDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,
QRadioButtonDelegate,QCheckBoxDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int typeOfTime;//判断是测量时间还是结束时间
    BOOL isReflash;

    NSString *upDatasSring;
    
    //图片查看器
    UIScrollView *scrView;
    NSMutableArray *_images;//图片数组
    

    
    NSString *uptadaData;
    NSString *SpaceId;
    
    //addingSpaceTable
    UITableView *addingSpaceTable;//新增空间table
    
    UITableView *spaceModelTable;//空间模型table
    
    
    NSMutableArray *spaceModelAllData;//新增空间模型所有数据
    NSMutableArray *spaceModelAllDataCount;//新增空间模型每个列表的数据总数
    
    NSMutableArray *spaceModelFormats;//新增空间模型所有类型数据
    NSMutableArray *spaceModelFormat;//新增空间模型列表类型数据
    
    NSMutableArray *spaceModelDatas;//需要上传的空间模型table所有数据
    NSMutableArray *spaceModelData;//需要上传的空间模型table当前数据
    
    NSMutableArray *spaceModelIDs;//新增模型中的所有ID数据
    NSMutableArray *spaceModelID;//空间模型table中的id数据
    
    NSMutableDictionary *modelDic;//记录空间类型与modelId对应的字典
    
    UIView *spaceView;
    
    UIView *spaceRadioView;
    
    NSMutableArray *spaceMutableAry;
    NSInteger spaceIndex;
}
@property NSArray *addSpaceAry1;
@property NSArray *addSpaceAry2;
@property NSArray *addSpaceDateAry;
@property NSArray *addSpaceHourAry;
@property NSArray *addSpaceMinAry;
@property NSMutableArray *spaceModel;
@property UIPickerView *picker;
@property UIView *dateView;

@end

@implementation EditSpaceViewController

- (void)viewDidLoad {
    _images = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addingSpaceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:UITableViewStyleGrouped];
    addingSpaceTable.delegate = self;
    addingSpaceTable.dataSource = self;
    [self.view addSubview:addingSpaceTable];
    
    
    [self initNavigation];
    
    self.addSpaceAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间", nil];
    self.addSpaceAry2 = [[NSArray alloc]initWithObjects:@"空间",@"风格",@"面积(m2)",@"材料",@"布局",@"预购产品线", nil];
    self.addSpaceDateAry = [RequestDataParse weekAry1];
    self.addSpaceHourAry = [RequestDataParse hourAry];
    self.addSpaceMinAry = [RequestDataParse minAry];
    
    self.dateView = [[UIView alloc]init];
    self.dateView.backgroundColor = [UIColor colorWithRed:0.5294 green:0.8078 blue:0.9803 alpha:1.0f];
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.dateView.frame.size.width, self.dateView.frame.size.height-20)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.picker selectRow:self.addSpaceDateAry.count*40 inComponent:0 animated:NO];
    [self.picker selectRow:self.addSpaceHourAry.count*40+4 inComponent:1 animated:NO];
    [self.picker selectRow:self.addSpaceMinAry.count*40 inComponent:2 animated:NO];
    [self.dateView addSubview:self.picker];
    
    spaceMutableAry = [[NSMutableArray alloc]init];
    float offWidth;
    offWidth = 30*(self.view.frame.size.width)/320;
    NSLog(@"%f",offWidth);
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(offWidth, 5, 40, 30);
    btn1.tag = 1001;
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(self.view.frame.size.width-40-offWidth, 5, 40, 30);
    btn2.tag = 1002;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:btn2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 导航条操作

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"编辑空间"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    rightButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [self.view addSubview:navigationBar];
}

#pragma mark 返回上一层

-(void)back
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 2001;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2001) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark 保存数据

-(void)save
{
    if ((spaceMutableAry.count<=0)||(self.finish.length<=0)
        ||(self.spaceLab.text.length <= 0)||(self.measure.length<=0)
        ||(self.areaLab.text.length<=0)||(self.styleLab.text.length<=0)
        ||(self.materialLab.text.length<=0)||(self.layoutLab.text.length<=0)) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您提交的信息不完整，请完善后再上传空间信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *string = @"";
    for (int i = 0; i < spaceMutableAry.count; i++) {
        string = [NSString stringWithFormat:@"%@%@",string,[spaceMutableAry objectAtIndex:i]];
    }
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    NSString *str = [NSString stringWithFormat:@"Params={\"authCode\": \"%@\",\"MeasureInfo\":{\"MeasureType\":%d,\"ContrlContentList\":{%@},\"RoomType\":\"两房一厅\",\"FinishTime\":\"%@\",\"SpaceName\":\"%@\",\"MeasureTime\": \"%@\",\"BuyWill\": \"Bedding\",\"Area\": \"%@\",\"Style\":\"%@\",\"ServiceId\":\"%@\",\"UserId\": \"%@\",\"SpaceId\":\"%@\",\"Budget\":58899,\"Material\":\"%@\",\"Layout\":\"%@\"}}&Command=MeasureSpace/EditMeasureInfo",code,self.MeasureType,string,self.finish,self.spaceLab.text,self.areaLab.text,self.styleLab.text,self.measure,self.ServiceId,self.UserId,self.MeasureId,self.materialLab.text,self.layoutLab.text];
    str = [str stringByReplacingOccurrencesOfString:@"{," withString:@"{"];
    
    NSLog(@"%@",str);
    uptadaData = str;
    [self analyseUpdataCustomer];//updataCustomer
}
-(void)sureSpaceInfo1:(id)sender
{
    [spaceView removeFromSuperview];
    spaceModelTable.delegate = nil;
    spaceModelTable.dataSource = nil;
}
-(void)sureSpaceInfo:(id)sender
{
    upDatasSring = @"";
    for (int i = 0; i < spaceModelFormat.count; i++) {
        if ([[spaceModelDatas objectAtIndex:i]isEqualToString:@"text;"]) {
            upDatasSring = [NSString stringWithFormat:@"%@,\"txt_%@\":\"%@\"",upDatasSring,[spaceModelID objectAtIndex:i],[spaceModelData objectAtIndex:i]];
        }
        else
        {
            upDatasSring = [NSString stringWithFormat:@"%@,\"rdo_%@\":\"%@\"",upDatasSring,[spaceModelID objectAtIndex:i],[spaceModelData objectAtIndex:i]];
        }
        
    }
    [spaceMutableAry replaceObjectAtIndex:spaceIndex withObject:upDatasSring ];
    
    [spaceView removeFromSuperview];
    spaceModelTable.delegate = nil;
    spaceModelTable.dataSource = nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [spaceModelData replaceObjectAtIndex:textField.tag withObject:textField.text];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if([groupId isEqualToString:@"CustomName"])
    {
        self.modelType = radio.titleLabel.text;
    }
    //@"Style"
    else if ([groupId isEqualToString:@"Style"])
    {
        self.styleLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"array"])
    {
        self.areaLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"Materials"])
    {
        self.materialLab.text = radio.titleLabel.text;
        return;
    }
    else if ([groupId isEqualToString:@"Layouts"])
    {
        self.layoutLab.text = radio.titleLabel.text;
        return;
    }
    else if (radio.tag == 1001) {
        if ([radio.titleLabel.text isEqualToString:@"单尺"]) {
            self.MeasureType = 0;
        }
        else
        {
            self.MeasureType = 1;
        }
        return;
    }
    
    else if (radio.tag == 1002) {
        
        return;
    }
    [spaceModelData replaceObjectAtIndex:radio.tag withObject:radio.titleLabel.text];
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checkbox.tag == 2000) {
        if (self.procutLab.text==nil) {
            self.procutLab.text = @"";
        }
        NSString *str = self.procutLab.text;
        if (checked) {
            if (![str isEqualToString:@""]) {
                str = [NSString stringWithFormat:@"%@;%@",str,checkbox.titleLabel.text];
            }
            else
                str = [NSString stringWithFormat:@"%@",checkbox.titleLabel.text];
        }
        else
        {
            str = [str stringByReplacingOccurrencesOfString:checkbox.titleLabel.text withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@";;" withString:@""];
        }
        self.procutLab.text = str;
        return;
    }
    else
    {
        if(checked == YES)
        {
            NSString *str = [spaceModelData objectAtIndex:checkbox.tag];
            if ([str isEqualToString:@""]) {
                str = [NSString stringWithFormat:@"%@",checkbox.titleLabel.text];
            }
            else{
                str = [NSString stringWithFormat:@"%@;%@",str,checkbox.titleLabel.text];
            }
            [spaceModelData replaceObjectAtIndex:checkbox.tag withObject:str];
        }
        else
        {
            NSString *str = [spaceModelData objectAtIndex:checkbox.tag];
            str = [str stringByReplacingOccurrencesOfString:checkbox.titleLabel.text withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@";;" withString:@";"];
            if ((str.length > 0)&&[[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@";"]) {
                str = [str substringFromIndex:1];
            }
            if ((str.length > 0)&&[[str substringWithRange:NSMakeRange(str.length-1, 1)] isEqualToString:@";"]) {
                str = [str substringToIndex:str.length-1];
            }
            
            [spaceModelData replaceObjectAtIndex:checkbox.tag withObject:str];
        }
    }
}


-(void)radioView:(NSArray *)radioAry groupID:(NSString*)groupID title:(NSString*)title
{
    spaceRadioView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    spaceRadioView.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceRadioView];
    
    UIScrollView *radioView;
    
    
    radioView = [[UIScrollView alloc]initWithFrame:CGRectMake(45, (spaceRadioView.frame.size.height-(radioAry.count+2)*15)/2, spaceRadioView.frame.size.width-90, (radioAry.count+5)*15)];
    
    radioView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    
    
    radioView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [spaceRadioView addSubview:radioView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:radioView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = radioView.bounds;
    maskLayer.path = maskPath.CGPath;
    radioView.layer.mask = maskLayer;
    
    float fristH = 1/2*(spaceRadioView.frame.size.height)-1/2*(radioAry.count)*30+25;
    
    for (int i = 0; i < radioAry.count; i++) {
        int row = i/2;
        int col = i%2;
        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:groupID];
        _radio1.frame =CGRectMake(100*col+15, fristH+30*row, 100, 30);
        _radio1.tag = 1002;
        [_radio1 setTitle:[radioAry objectAtIndex:i] forState:UIControlStateNormal];
        [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_radio1.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [radioView addSubview:_radio1];
        if (i == 0) {
            [_radio1 setChecked:YES];
        }
    }
    float buttonH = fristH+15*(radioAry.count)-10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, buttonH+25, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(radioViewCancel1:) forControlEvents:UIControlEventTouchUpInside];
    [radioView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(radioView.frame.size.width-80, buttonH+25, 60, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [radioView addSubview:button1];
}

-(void)checkView:(NSArray *)checkAry tag:(int)tag
{
    spaceRadioView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    spaceRadioView.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceRadioView];
    
    UIView *checkView = [[UIView alloc]initWithFrame:CGRectMake(45, (spaceRadioView.frame.size.height-(checkAry.count+2)*30)/2, spaceRadioView.frame.size.width-90, (checkAry.count+2)*30)];
    
    checkView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [spaceRadioView addSubview:checkView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:checkView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = checkView.bounds;
    maskLayer.path = maskPath.CGPath;
    checkView.layer.mask = maskLayer;
    
    float fristH = 1/2*(spaceRadioView.frame.size.height)-1/2*(checkAry.count)*30+25;
    
    for (int i = 0; i < checkAry.count; i++) {
        
        QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
        _check1.tag = tag;
        _check1.frame = CGRectMake(35, fristH+30*i, 200, 30);
        [_check1 setTitle:[checkAry objectAtIndex:i] forState:UIControlStateNormal];
        [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_check1.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [checkView addSubview:_check1];
    }
    float buttonH = fristH+30*(checkAry.count)-10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, buttonH+10, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(radioViewCancel1:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(checkView.frame.size.width-80, buttonH+10, 60, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:button1];
    
}
-(void)radioViewCancel1:(id)sender
{
    [spaceRadioView removeFromSuperview];
}
-(void)radioViewCancel:(id)sender
{
    if (isReflash == NO) {
        [spaceRadioView removeFromSuperview];
        return;
    }
    NSInteger count = [modelDic allKeys].count;
    id key;
    id value;
    self.spaceLab.text = self.modelType;
    for (int i = 0; i < count; i++) {
        key = [[modelDic allKeys]objectAtIndex:i];
        if ([key isEqualToString:self.modelType]) {
            value = [modelDic objectForKey:key];
            SpaceId = value;
            [self analyseModelData:value];
        }
    }
    [spaceRadioView removeFromSuperview];
    isReflash = NO;
}
#pragma mark 空间模板绘制

-(void)drawModel:(NSInteger)row
{
    spaceView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                        65,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height-65)];
    
    spaceView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceView];
    
    spaceModelFormat = [[NSMutableArray alloc]init];
    
    spaceModelDatas = [[NSMutableArray alloc]init];
    spaceModelID = [[NSMutableArray alloc]init];
    
    int count = 0;
    int index = 0;
    
    for (int i = 0; i <= row-1; i++) {
        NSString *countStr= [spaceModelAllDataCount objectAtIndex:i];
        index = count;
        count += countStr.intValue;
    }
    
    for (int i = index; i <  count; i++) {
        
        [spaceModelFormat addObject:[spaceModelFormats objectAtIndex:i]];
        [spaceModelDatas addObject:[spaceModelAllData objectAtIndex:i]];
        [spaceModelID addObject:[spaceModelIDs objectAtIndex:i]];
        
    }
    NSLog(@"%@",spaceModelID);
    if (spaceMutableAry.count <= 0) {
        for (int i = index; i <  count; i++) {
            [spaceMutableAry addObject:@""];
        }
    }
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(20,
                                                        (self.view.frame.size.height-65-40*(spaceModelDatas.count+1))/2,
                                                        spaceView.frame.size.width-40,
                                                        40*(spaceModelDatas.count+1))];
    [spaceView addSubview:v];
    
    spaceModelTable = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   v.frame.size.width,
                                                                   v.frame.size.height)];
    spaceModelTable.delegate = self;
    spaceModelTable.dataSource = self;
    spaceModelTable.scrollEnabled = NO;
    spaceModelTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    spaceModelTable.backgroundColor = [UIColor clearColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:v.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = v.bounds;
    maskLayer.path = maskPath.CGPath;
    v.layer.mask = maskLayer;
    
    [self setExtraCellLineHidden:spaceModelTable];
    [v addSubview:spaceModelTable];
}
#pragma mark tableViewDeledate

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addingSpaceTable) {
        if ((indexPath.section == 2)&&(indexPath.row == 0)) {
            return 100;
        }
        else if(indexPath.section == 3)
        {
            return 60;
        }
        else
            return 40;
    }
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == addingSpaceTable) {
        return 3;
    }
    else
        return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == addingSpaceTable) {
        if (section == 0) {
            return self.addSpaceAry1.count;
        }
        if (section == 1) {
            return self.addSpaceAry2.count;
        }
        if (section == 2) {
            return self.spaceModel.count+1;
        }
        else
            return 1;
    }
    else
        return spaceModelFormat.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addingSpaceTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            if (indexPath.section == 0) {
                cell.textLabel.text = [self.addSpaceAry1 objectAtIndex:indexPath.row];
                if(indexPath.row == 0)
                {
                    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                    _radio1.frame =CGRectMake(self.view.frame.size.width-60, 5, 50, 30);
                    _radio1.tag = 1001;
                    [_radio1 setTitle:@"复尺" forState:UIControlStateNormal];
                    [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                    [cell.contentView addSubview:_radio1];
                    
                    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                    _radio2.frame = CGRectMake(self.view.frame.size.width-120, 5, 50, 30);
                    _radio2.tag = 1001;
                    [_radio2 setTitle:@"单尺" forState:UIControlStateNormal];
                    [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                    [cell.contentView addSubview:_radio2];
                    [_radio1 setChecked:YES];
                    
                }
                else if(indexPath.row == 1)
                {
                    self.measureLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                    if (self.measure == nil) {
                        self.measureLab.text = @"未设置";
                    }
                    else
                    {
                        self.measureLab.text = self.measure;
                    }
                    self.measureLab.font = [UIFont systemFontOfSize:14.0f];
                    self.measureLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.measureLab];
                }
                else if (indexPath.row == 2)
                {
                    self.finishLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                    if(self.finish == nil)
                    {
                        self.finishLab.text = @"未设置";
                    }
                    else
                    {
                        self.finishLab.text = self.finish;
                    }
                    self.finishLab.font = [UIFont systemFontOfSize:14.0f];
                    self.finishLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.finishLab];
                }
            }
            else if (indexPath.section == 1) {
                cell.textLabel.text = [self.addSpaceAry2 objectAtIndex:indexPath.row];
                
                if (indexPath.row == 0) {
                    self.spaceLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.spaceLab.textAlignment = NSTextAlignmentRight;
                    self.spaceLab.font = [UIFont systemFontOfSize:14.0f];
                    self.spaceLab.text = self.modelType;
                    [cell.contentView addSubview:self.spaceLab];
                }
                else if (indexPath.row == 1)
                {
                    self.styleLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.styleLab.textAlignment = NSTextAlignmentRight;
                    self.styleLab.font = [UIFont systemFontOfSize:14.0f];
                    self.styleLab.text = self.styleLabStr;
                    [cell.contentView addSubview:self.styleLab];
                }
                else if (indexPath.row == 2)
                {
                    self.areaLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.areaLab.textAlignment = NSTextAlignmentRight;
                    self.areaLab.font = [UIFont systemFontOfSize:14.0f];
                    self.areaLab.text = self.areaLabStr;
                    [cell.contentView addSubview:self.areaLab];
                }
                else if (indexPath.row == 3)
                {
                    self.materialLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.materialLab.textAlignment = NSTextAlignmentRight;
                    self.materialLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.materialLab];
                }
                else if (indexPath.row == 4)
                {
                    self.layoutLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.layoutLab.textAlignment = NSTextAlignmentRight;
                    self.layoutLab.font = [UIFont systemFontOfSize:14.0f];
                    [cell.contentView addSubview:self.layoutLab];
                }
                else if (indexPath.row == 5)
                {
                    self.procutLab  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 180, 20)];
                    self.procutLab.textAlignment = NSTextAlignmentRight;
                    self.procutLab.font = [UIFont systemFontOfSize:14.0f];
                    self.procutLab.text = self.procutLabStr;
                    [cell.contentView addSubview:self.procutLab];
                }
            }
            else if(indexPath.section == 2)
            {
                if (indexPath.row == 0) {
                    [NSAlertView initLabelView:cell.contentView
                                         frame:CGRectMake(15, 5, 60, 15)
                                          text:@"附件"
                                          font:14
                                     alignment:NSTextAlignmentLeft
                                     isNumLine:NO];
                    
                    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 2*self.view.frame.size.width, 80)];
                    
                    [self imageShow:_images inView:scrView];
                    [cell.contentView addSubview:scrView];
                }
                else
                {
                    cell.textLabel.text = [self.spaceModel objectAtIndex:indexPath.row-1];
                }
            }
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            
            for (int i = 0; i < spaceModelFormat.count; i++) {
                if (i == indexPath.row) {
                    [NSAlertView initLabelView:cell.contentView frame:CGRectMake(15, 5, 100, 30) text:[spaceModelFormat objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
                }
                
                if (indexPath.row == i) {
                    if ([[spaceModelDatas objectAtIndex:indexPath.row] isEqualToString:@"text;"]) {
                        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-190, 7.5, 145, 25)];
                        field.tag = indexPath.row;
                        field.delegate = self;
                        field.borderStyle = UITextBorderStyleRoundedRect;
                        [cell.contentView addSubview:field];
                    }
                    else if ([[[spaceModelDatas objectAtIndex:indexPath.row]substringToIndex:8] isEqualToString:@"checkbox"])
                    {
                        NSString *string = [[spaceModelDatas objectAtIndex:indexPath.row]substringFromIndex:9];
                        NSLog(@"%@",string);
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        NSInteger length = string.length;
                        int j = 0;
                        for (int i = 0; i < length; i++) {
                            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
                            if ([str isEqualToString:@";"]) {
                                [ary addObject:[string substringWithRange:NSMakeRange(j, i-j)]];
                                j = i+1;
                            }
                        }
                        [ary addObject:[string substringFromIndex:j]];
                        NSInteger count = ary.count;
                        
                        for (int i = 0; i < count; i++) {
                            QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
                            _check1.tag = indexPath.row;
                            _check1.frame = CGRectMake(self.view.frame.size.width-80-50*i, 5, 50, 30);
                            [_check1 setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
                            [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                            [cell.contentView addSubview:_check1];
                        }
                    }
                    else
                    {
                        NSString *string = [[spaceModelDatas objectAtIndex:indexPath.row]substringFromIndex:6];
                        
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        NSInteger length = string.length;
                        int j = 0;
                        for (int i = 0; i < length; i++) {
                            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
                            if ([str isEqualToString:@";"]) {
                                [ary addObject:[string substringWithRange:NSMakeRange(j, i-j)]];
                                j = i+1;
                            }
                        }
                        [ary addObject:[string substringFromIndex:j]];
                        NSString *group = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                        for (int i = 0; i < ary.count; i++) {
                            
                            QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:group];
                            _radio1.tag = indexPath.row;
                            _radio1.frame =CGRectMake(self.view.frame.size.width-85-45*i, 5, 45, 30);
                            [_radio1 setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
                            [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                            [cell.contentView addSubview:_radio1];
                            if (i == 0) {
                                [_radio1 setChecked:YES];
                            }
                        }
                    }
                }
            }
            if (indexPath.row == spaceModelFormat.count)
            {
                UIButton *button =[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(15, 5, 40, 30);
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(sureSpaceInfo1:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UIButton *button1 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button1.frame = CGRectMake(self.view.frame.size.width-95, 5, 40, 30);
                [button1 setTitle:@"确定" forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(sureSpaceInfo:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button1];
            }
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == addingSpaceTable) {
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                typeOfTime = 1;
            }
            else if (indexPath.row == 2)
            {
                typeOfTime = 2;
            }
            [self showView:self.view];
        }
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0) {
                //空间
                isReflash = YES;
                //[self analyseModelListData];
            }
            else if (indexPath.row == 1)
            {
                //风格
                [self analyseRoomStyleData];
            }
            else if (indexPath.row == 2)
            {
                //面积
                [self analyseRoomAreasData];
            }
            else if (indexPath.row == 3)
            {
                //材料
                [self analyseRoomMaterialsData];
            }
            else if (indexPath.row == 4)
            {
                //布局
                [self analyseRoomLayoutsData];
            }
            else if (indexPath.row == 5)
            {
                //预购产品线
                [self analyseProductLineData];
            }
        }
        if(indexPath.section == 2)
        {
            if (indexPath.row != 0) {
                spaceIndex = indexPath.row - 1;
                [self drawModel:indexPath.row];
                spaceModelData =[[NSMutableArray alloc]init];
                for (int i = 0 ; i < spaceModelFormat.count; i++) {
                    [spaceModelData addObject:@""];
                }
            }
        }
    }
    else
    {
        
    }
}


#pragma mark 网络请求以及数据解析

#pragma mark 获取空间模板列表
/*
 方法描述：获取空间模板列表 空间名称，空间编号
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；
 */
//网络请求

-(NSMutableURLRequest*)getCustomerModelList
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetCustomModelList",code];
    
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}

//数据解析

-(void)analyseModelListData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getCustomerModelList];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data
                                                  encoding:NSUTF8StringEncoding];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
             
             NSArray *JSON = [dic objectForKey:@"JSON"];
             NSMutableArray *radioAry = [[NSMutableArray alloc]init];
             modelDic = [[NSMutableDictionary alloc]init];
             
             for (id relist in JSON) {
                 NSString *CustomName = [relist objectForKey:@"CustomName"];
                 NSString *ModelId = [relist objectForKey:@"ModelId"];
                 
                 [radioAry addObject:CustomName];
                 [modelDic setObject:ModelId forKey:CustomName];
             }
             [self radioView:radioAry groupID:@"CustomName" title:@"空间模板"];
         }];
    });
}

#pragma mark 预购产品线
/*
 方法描述：预购产品线
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；
 */
//网络请求

-(NSMutableURLRequest*)getProductLine
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetProductLine",code];
    
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseProductLineData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getProductLine];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSArray *JSON = [dic objectForKey:@"JSON"];
             NSMutableArray *itemAry = [[NSMutableArray alloc]init];
             
             for (id relist in JSON) {
                 NSString *ItemName = [relist objectForKey:@"ItemName"];
                 [itemAry addObject:ItemName];
             }
             [self checkView:itemAry tag:2000];
         }];
    });
}

#pragma mark 获取空间模板
/*
 方法描述：获取空间模板
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；@ModelId:空间模板编号
 */
//网络请求

-(NSMutableURLRequest*)getCustomModel:(NSString*)model
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\",\"ModelId\":\"%@\"}&Command=MeasureSpace/GetCustomModel",code,model];
    
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}

//数据解析

-(void)analyseModelData:(NSString*)model
{
    self.spaceModel = [[NSMutableArray alloc]init];
    spaceModelAllData = [[NSMutableArray alloc]init];
    spaceModelAllDataCount = [[NSMutableArray alloc]init];
    spaceModelIDs = [[NSMutableArray alloc]init];
    spaceModelFormats = [[NSMutableArray alloc]init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getCustomModel:model];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *ContrlInfos = [JSON objectForKey:@"ContrlInfos"];
             int count;
             for (id ContrlInfo in ContrlInfos) {
                 count = 0;
                 NSString *GroupName = [ContrlInfo objectForKey:@"GroupName"];
                 [self.spaceModel addObject:GroupName];
                 NSArray *ContrlContainers = [ContrlInfo objectForKey:@"ContrlContainer"];
                 for (id ContrlContainer in ContrlContainers) {
                     NSString *Text = [ContrlContainer objectForKey:@"Text"];
                     NSString *ControlType = [ContrlContainer objectForKey:@"ControlType"];
                     NSString *DefaultValue = [ContrlContainer objectForKey:@"DefaultValue"];
                     NSString *Id = [ContrlContainer objectForKey:@"Id"];
                     [spaceModelFormats addObject:Text];
                     [spaceModelIDs addObject:Id];
                     [spaceModelAllData addObject:[NSString stringWithFormat:@"%@;%@",ControlType,DefaultValue]];
                     count++;
                 }
                 [spaceModelAllDataCount addObject:[NSString stringWithFormat:@"%d",count]];
             }
             [addingSpaceTable reloadData];
         }];
    });
    
}

#pragma mark 获取空间风格
/*
 方法描述：获取空间模板
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码；@ModelId:空间模板编号
 */
//网络请求

-(NSMutableURLRequest*)getRoomStyle
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetRoomInfo",code];
    
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseRoomStyleData
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getRoomStyle];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *Style = [JSON objectForKey:@"Style"];
             NSLog(@"%@",Style);
             [self radioView:Style groupID:@"Style" title:@"风格"];
         }];
    });
}

#pragma mark 获取空间面积
/*
 方法描述：获取空间面积
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 */
//网络请求

-(NSMutableURLRequest*)getRoomAreas
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetRoomInfo",code];
    
    NSLog(@"%@?%@",[URLApi initURL],string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseRoomAreasData
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getRoomStyle];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *RoomType = [JSON objectForKey:@"RoomType"];
             for (id type in RoomType)
             {
                 if ([[type objectForKey:@"RoomName"]isEqualToString:self.modelType]) {
                     NSArray *array = [type objectForKey:@"Areas"];
                     NSLog(@"%@",array);
                     [self radioView:array groupID:@"array" title:@"面积"];
                 }
             }
         }];
    });
}
#pragma mark 获取空间材料
/*
 方法描述：获取空间材料
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 */
//网络请求

-(NSMutableURLRequest*)getRoomMaterials
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetRoomInfo",code];
    
    NSLog(@"%@?%@",[URLApi initURL],string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseRoomMaterialsData
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getRoomStyle];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *RoomType = [JSON objectForKey:@"RoomType"];
             for (id type in RoomType)
             {
                 if ([[type objectForKey:@"RoomName"]isEqualToString:self.modelType]) {
                     NSArray *array = [type objectForKey:@"Materials"];
                     NSLog(@"%@",array);
                     [self radioView:array groupID:@"Materials" title:@"材料"];
                 }
             }
         }];
    });
}

#pragma mark 获取空间布局
/*
 方法描述：获取空间布局
 
 请求方式：GET和POST
 
 入参描述：@authCode:授权码
 */
//网络请求

-(NSMutableURLRequest*)getRoomLayouts
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetRoomInfo",code];
    
    NSLog(@"%@?%@",[URLApi initURL],string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseRoomLayoutsData
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self getRoomStyle];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *JSON = [dic objectForKey:@"JSON"];
             NSArray *RoomType = [JSON objectForKey:@"RoomType"];
             for (id type in RoomType)
             {
                 if ([[type objectForKey:@"RoomName"]isEqualToString:self.modelType]) {
                     NSArray *array = [type objectForKey:@"Layouts"];
                     NSLog(@"%@",array);
                     [self radioView:array groupID:@"Layouts" title:@"布局"];
                 }
             }
         }];
    });
}

#pragma mark 上传数据
/*
 方法描述：上传数据
 
 请求方式：GET和POST
 
 入参描述：
 
 */
//网络请求

-(NSMutableURLRequest*)updataCustomer
{
    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSLog(@"%@?%@",[URLApi initURL],uptadaData);
    
    NSData *loginData = [uptadaData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
    
}
//数据解析

-(void)analyseUpdataCustomer
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self updataCustomer];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSLog(@"%@",str);
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSString *JSON = [dic objectForKey:@"JSON"];
             if (JSON != nil) {
                 NSLog(@"上传成功");
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             
         }];
    });
}

#pragma mark 图片查看器

//图片数组绘制

-(void)imageShow:(NSMutableArray*)imageAry inView:(UIScrollView*)scrolView
{
    int contentSize = 300;
    for (int i = 0; i < imageAry.count+1; i++) {
        contentSize += 95;
        [scrolView setContentSize:CGSizeMake(contentSize, -200)];
        if (i == imageAry.count) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15+80*i, 15, 70, 50)];
            img.tag = 1000;
            img.image = [UIImage imageNamed:@"Camera"];
            img.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
            [img addGestureRecognizer:singleTap];
            [scrolView addSubview:img];
            return;
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15+80*i, 5, 70, 70)];
        [scrolView addSubview:view];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        img.tag = 1001+i;
        img.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [img addGestureRecognizer:singleTap];
        img.image = [imageAry objectAtIndex:i];
        [view addSubview:img];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(50, 0, 20, 20);
        button.tag = i;
        [button setImage:[[UIImage imageNamed:@"delete_img.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(delectImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
}
// 图片删除按钮响应

-(void)delectImageAction:(id)sender
{
    for (UIView *subviews in [scrView subviews]) {
        [subviews removeFromSuperview];
    }
    UIButton *btn = (UIButton*)sender;
    [_images removeObjectAtIndex:btn.tag];
    [self imageShow:_images inView:scrView];
}

//添加图片响应

-(void)onClickImage:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *img=(UIImageView*)recognizer.view;
    if (img.tag == 1000) {
        UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"取消", nil];
        [sheet showInView:self.view];
    }
    else
    {
        EditImageViewController *VC = [[EditImageViewController alloc]init];
        NSString *title = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)(img.tag-1000),(unsigned long)_images.count];
        VC.image = img.image;
        VC.navTitle = title;
        [self presentViewController:VC animated:YES completion:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else if (buttonIndex==1){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info  objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
    [self plist];
    
}
-(void)dicPaths
{
    NSMutableArray *specialArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    
    [dic setObject:filePath forKey:@"img"];
    [specialArr addObject:dic];
}
-(void)plist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    ;
    [_images addObject:[UIImage imageWithContentsOfFile:filePath]];
    [self imageShow:_images inView:scrView];
}

#pragma mark 时间选择器

- (void)showAlertView:(UIView *) view
{
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, view.frame.size.width, self.view.frame.size.height-400)];
    newView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [view addSubview:newView];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    v.backgroundColor = [UIColor redColor];
    [newView addSubview:v];
    
    [UIView animateWithDuration:0.3 animations:^{
        newView.frame = CGRectMake(0, view.frame.size.height - newView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
    }];
}
// 列数

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 每一列的数据总数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.addSpaceDateAry.count*100;
    }
    else if (component == 1)
    {
        return self.addSpaceHourAry.count*100;
    }
    else
        return self.addSpaceMinAry.count*100;
}

//显示数据

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return [self.addSpaceDateAry objectAtIndex:row%self.addSpaceDateAry.count];
    }
    else if (component == 1)
    {
        return [self.addSpaceHourAry objectAtIndex:row%self.addSpaceHourAry.count];
    }
    else
        return [self.addSpaceMinAry objectAtIndex:row%self.addSpaceMinAry.count];
    
}

// 字体大小

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

// 每一列的宽度

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 150;
    }
    else if(component == 1)
    {
        return 80;
    }
    else
        return 80;
}
-(void)dateChoose:(id)sender
{
    NSInteger firstRow = [self.picker selectedRowInComponent:0];
    NSInteger subRow = [self.picker selectedRowInComponent:1];
    NSInteger threeRow = [self.picker selectedRowInComponent:2];
    NSString *firstString = [self.addSpaceDateAry objectAtIndex:(firstRow%[self.addSpaceDateAry count])];
    NSString *subString = [self.addSpaceHourAry objectAtIndex:(subRow%[self.addSpaceHourAry count])];
    NSString *thrString = [self.addSpaceMinAry objectAtIndex:(threeRow%[self.addSpaceMinAry count])];

    NSString *str3 = [NSString stringWithFormat:@"%@:%@:00",[subString substringToIndex:2],[thrString substringToIndex:2]];
    NSString *string = [NSString stringWithFormat:@"%@ %@",firstString,str3];
    if (typeOfTime == 1) {
        self.measureLab.text = string;
        self.measure = string;
    }
    else if(typeOfTime == 2)
    {
        self.finishLab.text = string;
        self.finish = string;
    }
    [self cancelView];
}
- (void)showView:(UIView *) view
{
    self.dateView.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.picker.frame.size.height+40);
    [view addSubview:self.dateView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, view.frame.size.height - self.dateView.frame.size.height, self.dateView.frame.size.width, self.dateView.frame.size.height);
    }];
    
}
- (void)cancelView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.dateView.frame = CGRectMake(0, self.dateView.frame.origin.y+self.dateView.frame.size.height, self.dateView.frame.size.width, self.dateView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.dateView removeFromSuperview];
                     }];
}

@end
