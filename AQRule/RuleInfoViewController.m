//
//  RuleInfoViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/25.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "RuleInfoViewController.h"
#import "EditSpaceViewController.h"

@interface RuleInfoViewController ()
{
    int imageCount;
    int point_h;
}
@end

@implementation RuleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageCount = 6;
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
    [navigationItem setTitle:@"量尺详情"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(updata)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
}
-(void)initView
{
    NSArray *tagAry1 = [[NSArray alloc]initWithObjects:@"量尺类型",@"量尺时间",@"预计完成时间",@"空间",@"风格",@"面积(m²)",@"预购产品线", nil];
    NSArray *tagAry2 = [[NSArray alloc]initWithObjects:@"地砖颜色",@"墙砖颜色",@"购买意向",@"备注", nil];
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 700)];
    [scrView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
    [self.view addSubview:scrView];
    
    for (int i = 0 ; i < 7; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 25+40*i, 150, 30)];
        lab.text = [tagAry1 objectAtIndex:i];
        [scrView addSubview:lab];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 320, self.view.frame.size.width-30, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [scrView addSubview:lineView];
    
    UILabel *imageLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 350, 40, 30)];
    imageLab.text = @"附件:";
    [scrView addSubview:imageLab];
    for (int i=0; i<imageCount; i++) {
        int row = i/3;//行
        int col = i%3;//列
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(70+col*85, 350+row*85, 75, 75)];
        img.backgroundColor = [UIColor redColor];
        [scrView addSubview:img];
        point_h = 435+row*85;
    }
    for(int i = 0;i < 4; i++)
    {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, point_h+i*40, 100, 40)];
        lab.text = [tagAry2 objectAtIndex:i];
        [scrView addSubview:lab];
    }
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updata
{
    EditSpaceViewController *vc = [[EditSpaceViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
