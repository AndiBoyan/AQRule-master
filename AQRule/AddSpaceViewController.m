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

@interface AddSpaceViewController ()<UITableViewDataSource,UITableViewDelegate,
                                    UIPickerViewDataSource,UIPickerViewDelegate,
                                    QRadioButtonDelegate>
{
    int typeOfTime;
    UIScrollView *scrView;
    NSMutableArray *_images;
}

@property NSArray *addSpaceAry1;
@property NSArray *addSpaceAry2;
@property NSArray *addSpaceDateAry;
@property NSArray *addSpaceHourAry;
@property NSArray *addSpaceMinAry;
@property UIPickerView *picker;
@property UIView *dateView;
@property UILabel *measureLab;//测量时间
@property UILabel *finishLab;//完成时间

@end

@implementation AddSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *addSpaceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:UITableViewStyleGrouped];
    addSpaceTable.delegate = self;
    addSpaceTable.dataSource = self;
    [self.view addSubview:addSpaceTable];
    
    [self initNavigation];
    
    self.addSpaceAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间", nil];
    self.addSpaceAry2 = [[NSArray alloc]initWithObjects:@"空间",@"风格",@"面积(m2)",@"预购产品线", nil];
    self.addSpaceDateAry = [self weekAry];
    self.addSpaceHourAry = [self hourAry];
    self.addSpaceMinAry = [self minAry];
    
    self.dateView = [[UIView alloc]init];
    self.dateView.backgroundColor = [UIColor whiteColor];
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
    [btn1 addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(self.view.frame.size.width-40-offWidth, 5, 40, 30);
    btn2.tag = 1002;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:btn2];
    
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
    }
    else if(typeOfTime == 2)
    {
        self.finishLab.text = string;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)save
{
    
}
#pragma mark tablegeledate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 100;
    }
    else if(indexPath.section == 3)
    {
        return 60;
    }
    else
        return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.addSpaceAry1.count;
    }
    if (section == 1) {
        return self.addSpaceAry2.count;
    }
    else
        return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                [_radio1 setTitle:@"复尺" forState:UIControlStateNormal];
                [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio1];
                
    
                QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio2.frame = CGRectMake(self.view.frame.size.width-160, 5, 60, 30);
                [_radio2 setTitle:@"单尺" forState:UIControlStateNormal];
                [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio2];
                [_radio1 setChecked:YES];

            }
            else if(indexPath.row == 1)
            {
                self.measureLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                self.measureLab.text = @"未设置";
                self.measureLab.font = [UIFont systemFontOfSize:14.0f];
                self.measureLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:self.measureLab];
            }
            else if (indexPath.row == 2)
            {
                self.finishLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, -15+self.view.frame.size.width/2, 35)];
                self.finishLab.text = @"未设置";
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
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 15)];
            lab.text = @"附件：";
            lab.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:lab];
            
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
        else if(indexPath.section == 3)
        {
            cell.textLabel.text = @"备注";
        }
    }
    return cell;
}
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

-(void)delectImageAction:(id)sender
{
    for (UIView *subviews in [scrView subviews]) {
        [subviews removeFromSuperview];
    }
    UIButton *btn = (UIButton*)sender;
    [_images removeObjectAtIndex:btn.tag];
    [self imageShow:_images inView:scrView];
}
-(void) addImage:(UITapGestureRecognizer *)recognizer{
    UIImageView *img=(UIImageView*)recognizer.view;
    if (img.tag == 1000) {
        NSLog(@"22");
        
    }
}
-(void)onClickImage:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *img=(UIImageView*)recognizer.view;
    if (img.tag == 1000) {
        NSLog(@"22");
        
    }
    else
    {
        NSLog(@"%ld",img.tag);
    }
    // NSLog(@"图片被点击!");
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
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            typeOfTime = 1;
            [self showView:self.view];
        }
        else if (indexPath.row == 2)
        {
            typeOfTime = 2;
            [self showView:self.view];
        }
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //空间
            //[self showAlertView:self.view];
            [self analyseRequestData];
        }
        else if (indexPath.row == 1)
        {
            //风格
        }
        else if (indexPath.row == 2)
        {
            //面积
        }
        else if (indexPath.row == 3)
        {
            //预购产品线
            [self analyseRequestRequestProductLineData];
        }
    }
}
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
}
#pragma mark 日期
-(NSMutableArray*)weekAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeInterval  interval = 24*60*60*1;
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger week = [dateComponent weekday];
    for (int i = 0; i < 30; i++) {
        if (week > 7) {
            week = 1;
        }
        NSString *weekStr;
        if (week == 1) {
            weekStr = @"周日";
        }
        else if (week == 2) {
            weekStr = @"周一";
        }
        else if (week == 3) {
            weekStr = @"周二";
        }
        else if (week == 4) {
            weekStr = @"周三";
        }
        else if (week == 5) {
            weekStr = @"周四";
        }
        else if (week == 6) {
            weekStr = @"周五";
        }
        else if (week == 7) {
            weekStr = @"周六";
        }
        if(i == 0)
        {
            date = now;
            NSString *str = [NSString stringWithFormat:@"%@(今天)",[dateFormatter stringFromDate:date]];
            [ary addObject:str];
        }
        else if (i == 1) {
            date = [date dateByAddingTimeInterval:+interval];
            NSString *str = [NSString stringWithFormat:@"%@(明天)",[dateFormatter stringFromDate:date]];
            [ary addObject:str];
        }
        else
        {
            date = [date dateByAddingTimeInterval:+interval];
            NSString *str = [NSString stringWithFormat:@"%@(%@)",[dateFormatter stringFromDate:date],weekStr];
            [ary addObject:str];
        }
        week++;
    }
    return ary;
}
//小时
-(NSMutableArray*)hourAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i <= 12; i++) {
        NSString *str = [NSString stringWithFormat:@"%d时",8+i];
        [ary addObject:str];
    }
    return ary;
}
//分钟
-(NSMutableArray*)minAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i < 12; i++) {
        NSString *str = [NSString stringWithFormat:@"%d分",i*5];
        if (i < 2) {
            str = [NSString stringWithFormat:@"0%@",str];
        }
        [ary addObject:str];
    }
    return ary;
}

#pragma mark pickerDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
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

-(NSMutableURLRequest*)initializtionRequestModelId
{
    NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = @"pdBcFCMd/hDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC+omUKBlk5av4c8qgvFa1za/Q3HB02gJhEPmjA=";
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    
    NSString *string = [NSString stringWithFormat:
                     @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetCustomModelList",code];
    
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:loginData];
    
    return request;
}

-(void)analyseRequestData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self initializtionRequestModelId];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",[RequestDataParse newJsonStr:str]);
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSArray *JSON = [dic objectForKey:@"JSON"];
             NSMutableArray *radioAry = [[NSMutableArray alloc]init];
             
             for (id relist in JSON) {
                 NSString *CustomName = [relist objectForKey:@"CustomName"];
                 NSString *ModelId = [relist objectForKey:@"ModelId"];
                 NSLog(@"%@,%@",CustomName,ModelId);
                 [radioAry addObject:CustomName];
             }
             [self radioView:radioAry groupID:@"CustomName"];
         }];
    });
}
//http://oppein.3weijia.com/oppein.axds?Params={"authCode":"pdBcFCMd%2FhDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC%2BomUKBlk5av4c8qgvFa1za%2FQ3HB02gJhEPmjA%3D","ModelId":"00002361"}&Command=MeasureSpace/GetCustomModel

-(NSMutableURLRequest*)initializtionRequestProductLine
{
    NSURL *url = [NSURL URLWithString:@"http://oppein.3weijia.com/oppein.axds"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *code = @"pdBcFCMd/hDHg35Ng2rQP0XIPlS41Shj3c43Qspi8DngGEhVFljYARtivajLMruUE9rEu8pmpkY7LbQ6V63Z5C6XaIYvKT1bJ59Qd2ifWogbMAYX6C6NulnW8ed6oF2301prbC+omUKBlk5av4c8qgvFa1za/Q3HB02gJhEPmjA=";
    
    code = [RequestDataParse encodeToPercentEscapeString:code];
    
    NSString *string = [NSString stringWithFormat:
                        @"Params={\"authCode\":\"%@\"}&Command=MeasureSpace/GetProductLine",code];
    
    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",string);
    
    NSData *loginData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:loginData];
    
    return request;
}

-(void)analyseRequestRequestProductLineData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [self initializtionRequestProductLine];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
             
             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSArray *JSON = [dic objectForKey:@"JSON"];
             for (id relist in JSON) {
                 NSString *ItemName = [relist objectForKey:@"ItemName"];
                 NSLog(@"%@",ItemName);
             }
         }];
    });
}

-(void)radioView:(NSArray *)radioAry groupID:(NSString*)groupID
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    view.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.5f];
    [self.view addSubview:view];
    
    UIView *radioView = [[UIView alloc]initWithFrame:CGRectMake(45, 20, view.frame.size.width-90, view.frame.size.height-40)];
    radioView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:1.0f];
    [view addSubview:radioView];
    
    float fristH = 1/2*(view.frame.size.height)-1/2*(radioAry.count)*40+25;

    
    for (int i = 0; i < radioAry.count; i++) {
        
        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:groupID];
        _radio1.frame =CGRectMake(50, fristH+40*i, 200, 30);
        [_radio1 setTitle:[radioAry objectAtIndex:i] forState:UIControlStateNormal];
        [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [radioView addSubview:_radio1];
        if (i == 0) {
             [_radio1 setChecked:YES];
        }
    }
}
@end
