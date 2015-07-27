//
//  AddSpaceViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/27.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "AddSpaceViewController.h"

@interface AddSpaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property NSArray *addSpaceAry1;
@property NSArray *addSpaceAry2;

@end

@implementation AddSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *addSpaceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    addSpaceTable.delegate = self;
    addSpaceTable.dataSource = self;
    [self.view addSubview:addSpaceTable];
    
    [self initNavigation];
    
    self.addSpaceAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间", nil];
    self.addSpaceAry2 = [[NSArray alloc]initWithObjects:@"空间",@"风格",@"面积(m2)",@"预购产品线", nil];
    
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
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
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
        return 80;
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
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.addSpaceAry1 objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 1) {
            cell.textLabel.text = [self.addSpaceAry2 objectAtIndex:indexPath.row];
        }
        else if(indexPath.section == 2)
        {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
            lab.text = @"附件：";
            [cell.contentView addSubview:lab];
        }
        else if(indexPath.section == 3)
        {
            cell.textLabel.text = @"备注";
        }
    }
    return cell;
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
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger week = [dateComponent weekday];
    
    for (int i = 0; i < 30; i++) {
        if (week > 7) {
            week = 1;
        }
        NSLog(@"%ld",(long)week);
        
        NSString *weekStr;
        if (week == 1) {
            weekStr = @"周一";
        }
        else if (week == 2) {
            weekStr = @"周二";
        }
        else if (week == 3) {
            weekStr = @"周三";
        }
        else if (week == 4) {
            weekStr = @"周四";
        }
        else if (week == 5) {
            weekStr = @"周五";
        }
        else if (week == 6) {
            weekStr = @"周六";
        }
        else if (week == 7) {
            weekStr = @"周日";
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
        if (i < 10) {
            str = [NSString stringWithFormat:@"0%@",str];
        }
        [ary addObject:str];
    }
    return ary;
}
@end
