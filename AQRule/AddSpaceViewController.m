//
//  AddSpaceViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/27.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "AddSpaceViewController.h"
#import "QRadioButton.h"
#import "RequestDataParse.h"
#import "NSAlertView.h"
#import "QCheckBox.h"
#import "NSAlertView.h"
#import "URLApi.h"

@interface AddSpaceViewController ()<UITableViewDataSource,UITableViewDelegate,
                                    UIPickerViewDataSource,UIPickerViewDelegate,
                                    QRadioButtonDelegate,QCheckBoxDelegate,UITextFieldDelegate>
{
    int typeOfTime;//判断是测量时间还是结束时间
    NSString *measure;//量尺时间
    NSString *finish;//结束时间
    NSString *upDatasSring;
    
    //图片查看器
    UIScrollView *scrView;
    NSMutableArray *_images;//图片数组
    
    int MeasureType;//量尺类型
    NSString *modelType;
    NSString *uptadaData;
    
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
}

@property NSArray *addSpaceAry1;
@property NSArray *addSpaceAry2;
@property NSArray *addSpaceDateAry;
@property NSArray *addSpaceHourAry;
@property NSArray *addSpaceMinAry;
@property NSMutableArray *spaceModel;
@property UIPickerView *picker;
@property UIView *dateView;

@property UILabel *measureLab;//测量时间
@property UILabel *finishLab;//完成时间

@end

@implementation AddSpaceViewController

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addingSpaceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:UITableViewStyleGrouped];
    addingSpaceTable.delegate = self;
    addingSpaceTable.dataSource = self;
    [self.view addSubview:addingSpaceTable];
    
    
    [self initNavigation];
    
    self.addSpaceAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间", nil];
    self.addSpaceAry2 = [[NSArray alloc]initWithObjects:@"空间",@"风格",@"面积(m2)",@"预购产品线", nil];
    self.addSpaceDateAry = [RequestDataParse weekAry];
    self.addSpaceHourAry = [RequestDataParse hourAry];
    self.addSpaceMinAry = [RequestDataParse minAry];
    
    self.dateView = [[UIView alloc]init];
    self.dateView.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.5 alpha:0.8f];
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.dateView.frame.size.width, self.dateView.frame.size.height-20)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.picker selectRow:self.addSpaceDateAry.count*40 inComponent:0 animated:NO];
    [self.picker selectRow:self.addSpaceHourAry.count*40+4 inComponent:1 animated:NO];
    [self.picker selectRow:self.addSpaceMinAry.count*40 inComponent:2 animated:NO];
    [self.dateView addSubview:self.picker];
    
    float offWidth;
    offWidth = 30*(self.view.frame.size.width)/320;
    NSLog(@"%f",offWidth);
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(offWidth, 5, 40, 30);
    btn1.tag = 1001;
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(self.view.frame.size.width-40-offWidth, 5, 40, 30);
    btn2.tag = 1002;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
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
    [navigationItem setTitle:@"新增空间"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.backgroundColor = [UIColor greenColor];
    navigationBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:navigationBar];
    
    
}

#pragma mark 返回上一层

-(void)back
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃添加" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
    [self analyseUpdataCustomer];//updataCustomer
}

#pragma mark tableViewDeledate

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
        return 4;
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
                    _radio1.frame =CGRectMake(self.view.frame.size.width-80, 5, 60, 30);
                    _radio1.tag = 1001;
                    [_radio1 setTitle:@"复尺" forState:UIControlStateNormal];
                    [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                    [cell.contentView addSubview:_radio1];
                    
                    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                    _radio2.frame = CGRectMake(self.view.frame.size.width-160, 5, 60, 30);
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
                    if (measure == nil) {
                        self.measureLab.text = @"未设置";
                    }
                    else
                    {
                        self.measureLab.text = measure;
                    }
                    self.measureLab.font = [UIFont systemFontOfSize:14.0f];
                    self.measureLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.measureLab];
                }
                else if (indexPath.row == 2)
                {
                    self.finishLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                    if(finish == nil)
                    {
                        self.finishLab.text = @"未设置";
                    }
                    else
                    {
                        self.finishLab.text = finish;
                    }
                    self.finishLab.font = [UIFont systemFontOfSize:14.0f];
                    self.finishLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.finishLab];
                }
            }
            else if (indexPath.section == 1) {
                cell.textLabel.text = [self.addSpaceAry2 objectAtIndex:indexPath.row];
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
                    _images = [[NSMutableArray alloc] initWithObjects:
                               [UIImage imageNamed:@"0.jpeg"],
                               [UIImage imageNamed:@"1.jpeg"],
                               [UIImage imageNamed:@"2.jpeg"],
                               [UIImage imageNamed:@"3.jpeg"],
                               [UIImage imageNamed:@"4.jpeg"],
                               [UIImage imageNamed:@"5.jpeg"],
                               [UIImage imageNamed:@"6.jpeg"],
                               [UIImage imageNamed:@"7.jpeg"],
                               [UIImage imageNamed:@"8.jpeg"],
                               [UIImage imageNamed:@"9.jpeg"],
                               [UIImage imageNamed:@"10.jpeg"], nil];
                    [self imageShow:_images inView:scrView];
                    [cell.contentView addSubview:scrView];
                }
                else
                {
                    cell.textLabel.text = [self.spaceModel objectAtIndex:indexPath.row-1];
                }
            }
            else if(indexPath.section == 3)
            {
                cell.textLabel.text = @"备注";
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
                        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-190, 7.5, 150, 25)];
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
                        if (count > 5) {
                            count = 5;
                        }
                        for (int i = 0; i < count; i++) {
                            QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
                            _check1.tag = indexPath.row;
                            _check1.frame = CGRectMake(self.view.frame.size.width-80-40*i, 5, 45, 30);
                            [_check1 setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
                            [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:8.0f]];
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
                [button setTitle:@"确定" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(sureSpaceInfo:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
            }
        }
        return cell;
    }
    return nil;
}


-(void)sureSpaceInfo:(id)sender
{
    if (upDatasSring == nil) {
        upDatasSring = @"";
    }
    for (int i = 0; i < spaceModelFormat.count; i++) {
        if ([[spaceModelDatas objectAtIndex:i]isEqualToString:@"text;"]) {
            upDatasSring = [NSString stringWithFormat:@"%@,\"txt_%@\":\"%@\"",upDatasSring,[spaceModelIDs objectAtIndex:i],[spaceModelData objectAtIndex:i]];
        }
        else
        {
            upDatasSring = [NSString stringWithFormat:@"%@,\"rdo_%@\":\"%@\"",upDatasSring,[spaceModelIDs objectAtIndex:i],[spaceModelData objectAtIndex:i]];
        }
        
    }
    NSString *code = [URLApi initCode];
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    NSString *str = [NSString stringWithFormat:@"Params={\"authCode\": \"%@\",\"MeasureInfo\":{\"MeasureType\": %d,\"ContrlContentList\":{%@},\"RoomType\": \"\",\"FinishTime\":\"2015-08-24 12: 00\",\"SpaceName\": \"书房\",\"MeasureTime\": \"2015-08-24 12: 00\",\"BuyWill\": \"Bedding\",\"Area\": \"9-12\",\"Style\": \"北欧\",\"ServiceId\": \"00000203\",\"UserId\": \"1000025908\",\"SpaceId\": \"00002201\",\"Budget\": \"58899\"}}&Command=MeasureSpace/AddMeasureInfo",code,MeasureType,upDatasSring];
    str = [str stringByReplacingOccurrencesOfString:@"{," withString:@"{"];
    
    NSLog(@"%@",str);
    uptadaData = str;
    
    [spaceView removeFromSuperview];
    spaceModelTable.delegate = nil;
    spaceModelTable.dataSource = nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [spaceModelData replaceObjectAtIndex:textField.tag withObject:textField.text];
    NSLog(@"%@",spaceModelData);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
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
                [self analyseModelListData];
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
                //预购产品线
                [self analyseProductLineData];
            }
        }
        if(indexPath.section == 2)
        {
            if (indexPath.row != 0) {
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
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if([groupId isEqualToString:@"CustomName"])
    {
        modelType = radio.titleLabel.text;
        return;
    }
    if (radio.tag == 1001) {
        if ([radio.titleLabel.text isEqualToString:@"单尺"]) {
            MeasureType = 1;
        }
        else
        {
            MeasureType = 2;
        }
        return;
    }
    
    if (radio.tag == 1002) {
        
        return;
    }
    [spaceModelData replaceObjectAtIndex:radio.tag withObject:radio.titleLabel.text];
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
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


-(void)radioView:(NSArray *)radioAry groupID:(NSString*)groupID title:(NSString*)title
{
    spaceRadioView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    spaceRadioView.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:spaceRadioView];
    
    UIView *radioView = [[UIView alloc]initWithFrame:CGRectMake(45, (spaceRadioView.frame.size.height-(radioAry.count+2)*30)/2, spaceRadioView.frame.size.width-90, (radioAry.count+2)*30)];
    
    radioView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [spaceRadioView addSubview:radioView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:radioView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = radioView.bounds;
    maskLayer.path = maskPath.CGPath;
    radioView.layer.mask = maskLayer;
    
    float fristH = 1/2*(spaceRadioView.frame.size.height)-1/2*(radioAry.count)*30+25;
    
    for (int i = 0; i < radioAry.count; i++) {
        
        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:groupID];
        _radio1.frame =CGRectMake(20, fristH+30*i, 200, 30);
        _radio1.tag = 1002;
        [_radio1 setTitle:[radioAry objectAtIndex:i] forState:UIControlStateNormal];
        [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_radio1.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [radioView addSubview:_radio1];
        if (i == 0) {
            [_radio1 setChecked:YES];
        }
    }
    float buttonH = fristH+30*(radioAry.count)-10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, buttonH+10, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [radioView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(radioView.frame.size.width-80, buttonH+10, 60, 30);
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [radioView addSubview:button1];
    
}

-(void)checkView:(NSArray *)checkAry
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
        _check1.tag = 2000;
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
    [button addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(checkView.frame.size.width-80, buttonH+10, 60, 30);
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(radioViewCancel:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:button1];
    
}

-(void)radioViewCancel:(id)sender
{
    NSInteger count = [modelDic allKeys].count;
    id key;
    id value;
    for (int i = 0; i < count; i++) {
        key = [[modelDic allKeys]objectAtIndex:i];
        if ([key isEqualToString:modelType]) {
            value = [modelDic objectForKey:key];
            
            [self analyseModelData:value];
        }
    }
    [spaceRadioView removeFromSuperview];
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
             [self checkView:itemAry];
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
                 if ([[type objectForKey:@"RoomName"]isEqualToString:modelType]) {
                     NSArray *array = [type objectForKey:@"Areas"];
                     NSLog(@"%@",array);
                     [self radioView:array groupID:@"array" title:@"面积"];
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
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15+80*i, 5, 70, 70)];
            img.tag = 1000;
            img.backgroundColor = [UIColor redColor];
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
        NSLog(@"22");
        
    }
    else
    {
        NSLog(@"%ld",(long)img.tag);
    }
}

#pragma mark 时间选择器

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
    
    NSString *str1 = [firstString substringToIndex:6];
    NSString *str2 = [firstString substringWithRange:NSMakeRange(7, 2)];
    if ([str2 isEqualToString:@"今天"]) {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger week = [dateComponent weekday];
        if (week == 1) {
            str2 = @"周日";
        }
        else if (week == 2) {
            str2 = @"周一";
        }
        else if (week == 3) {
            str2 = @"周二";
        }
        else if (week == 4) {
            str2 = @"周三";
        }
        else if (week == 5) {
            str2 = @"周四";
        }
        else if (week == 6) {
            str2 = @"周五";
        }
        else if (week == 7) {
            str2 = @"周六";
        }
        
    }else if ([str2 isEqualToString:@"明天"])
    {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger week = [dateComponent weekday]+1;
        if (week == 1) {
            str2 = @"周日";
        }
        else if (week == 2) {
            str2 = @"周一";
        }
        else if (week == 3) {
            str2 = @"周二";
        }
        else if (week == 4) {
            str2 = @"周三";
        }
        else if (week == 5) {
            str2 = @"周四";
        }
        else if (week == 6) {
            str2 = @"周五";
        }
        else if (week == 7) {
            str2 = @"周六";
        }
        
    }
    NSString *str3 = [NSString stringWithFormat:@"%@:%@",[subString substringToIndex:2],[thrString substringToIndex:2]];
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@>",str1,str2,str3];
    if (typeOfTime == 1) {
        self.measureLab.text = string;
        measure = string;
    }
    else if(typeOfTime == 2)
    {
        self.finishLab.text = string;
        finish = string;
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
