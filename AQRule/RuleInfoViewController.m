//
//  RuleInfoViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/7/25.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "RuleInfoViewController.h"
#import "EditSpaceViewController.h"
#import "ImageExamine.h"

@interface RuleInfoViewController ()
{
    int point_h;
    NSMutableArray *_images;
    UIScrollView *scrView;
    UIScrollView *scrollView;
}
@end

@implementation RuleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+100);
    [self.view addSubview:scrollView];
    
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
    [navigationItem setTitle:@"量尺详情"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(updata)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.backgroundColor = [UIColor greenColor];
    navigationBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:navigationBar];
}
-(void)initView
{
    NSArray *tagAry1 = [[NSArray alloc]initWithObjects:@"量尺类型 :",@"量尺时间:",@"预计完成时间:",@"空间:",@"风格:",@"面积(m²):",@"预购产品线:", nil];
    NSArray *tagAry2 = [[NSArray alloc]initWithObjects:@"地砖颜色 :",@"墙砖颜色 : ",@"购买意向 : ",@"备注 : ", nil];
    
    NSArray *tagAry3 = [[NSArray alloc]initWithObjects:@"复尺",@"6月24日 (周三) 12:00",@"6月24日 (周三) 12:00",@"客餐厅",@"地中海",@"9-12",@"寝室/家具/衣柜/鞋柜", nil];
    NSArray *tagAry4 = [[NSArray alloc]initWithObjects:@"无 (毛坯)",@"无 (毛坯)",@"冰箱/灶台/净水器/净化器",@"家里有两条狗，希望东西耐用，防止被狗抓咬", nil];
    for (int i = 0 ; i < 7; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 35+40*i, 300, 30)];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.text = [NSString stringWithFormat:@"%@ %@",[tagAry1 objectAtIndex:i],[tagAry3 objectAtIndex:i]];//[tagAry1 objectAtIndex:i];
        [scrollView addSubview:lab];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 315, self.view.frame.size.width-30, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [scrollView addSubview:lineView];
    
    UILabel *imageLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 320, 40, 30)];
    imageLab.text = @"附件:";
    imageLab.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:imageLab];
     scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 340, 2*self.view.frame.size.width, 80)];
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
    [scrollView addSubview:scrView];
    for(int i = 0;i < 4; i++)
    {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 420+i*40, 305, 40)];
        lab.text = [NSString stringWithFormat:@"%@ %@",[tagAry2 objectAtIndex:i],[tagAry4 objectAtIndex:i]];//[tagAry2 objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
        [scrollView addSubview:lab];
    }
}
-(void)imageShow:(NSMutableArray*)imageAry inView:(UIScrollView*)scrolView
{
    int contentSize = 300;
    for (int i = 0; i < imageAry.count; i++) {
        contentSize += 95;
        [scrolView setContentSize:CGSizeMake(contentSize, -200)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15+80*i, 5, 70, 70)];
        [scrolView addSubview:view];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        img.tag = 1001+i;
        img.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [img addGestureRecognizer:singleTap];
        img.image = [imageAry objectAtIndex:i];
        [view addSubview:img];
    }
}

-(void)onClickImage:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *img=(UIImageView*)recognizer.view;
    ImageExamine *imageExamine = [[ImageExamine alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imageExamine];
    imageExamine.image = img.image;
    imageExamine.imageWidth = img.image.size.width;
    imageExamine.imageHeigth = img.image.size.height;
    
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
