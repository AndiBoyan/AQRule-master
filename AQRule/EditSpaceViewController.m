//
//  EditSpaceViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/25.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "EditSpaceViewController.h"

@interface EditSpaceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *editSpaceTable;
@property NSArray *editSpaceAry1;
@property NSArray *editSpaceAry2;
@property NSArray *editSpaceAry3;
@property int imgCount;
@end

@implementation EditSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editSpaceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65) style:UITableViewStyleGrouped];
    self.editSpaceTable.delegate = self;
    self.editSpaceTable.dataSource = self;
    [self.view addSubview:self.editSpaceTable];
    [self initNavigation];
    self.editSpaceAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间", nil];
    self.editSpaceAry2 = [[NSArray alloc]initWithObjects:@"空间",@"风格",@"面积(m²)",@"预购产品线", nil];
    self.editSpaceAry3 = [[NSArray alloc]initWithObjects:@"附件",@"地砖颜色",@"墙砖颜色",@"购买意向", nil];
    self.imgCount = 5;
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
    [navigationItem setTitle:@"量尺详情"];
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否放弃保存空间" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续编辑", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)save
{
    
}

#pragma mark tabledelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.editSpaceAry1.count;
    }
    else if (section == 1) {
        return self.editSpaceAry2.count;
    }
    else if (section == 2) {
        return self.editSpaceAry3.count;
    }
    else
        return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.editSpaceAry1 objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = [self.editSpaceAry2 objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 2) {
            cell.textLabel.text = [self.editSpaceAry3 objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 3) {
            cell.textLabel.text = @"备注";
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 2)&&(indexPath.row == 0)) {
        return 65*(1+self.imgCount/4);
    }
    else
        return 40;
}
@end
