//
//  UserinfoViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "UserinfoViewController.h"
#import "LoginViewController.h"

@interface UserinfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property UITableView *userInfoTable;
@property NSArray *userInfoAry1;
@property NSArray *userInfoAry2;

@end

@implementation UserinfoViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userInfoTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.userInfoTable.delegate = self;
    self.userInfoTable.dataSource = self;
    [self.view addSubview:self.userInfoTable];
    
    self.userInfoAry1 = [[NSArray alloc]initWithObjects:@"姓名",@"手机号", nil];
    self.userInfoAry2 = [[NSArray alloc]initWithObjects:@"余大妞",@"15466667777", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
        return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.userInfoAry1 objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.userInfoAry2 objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = @"版本号";
            cell.detailTextLabel.text = @"V1.0";
        }
        if (indexPath.section == 2) {
            cell.textLabel.text = @"退出登录";
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 2)&&(indexPath.row == 0)) {
        //退出登录
   
        LoginViewController *VC = [[LoginViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
    }
}
@end
