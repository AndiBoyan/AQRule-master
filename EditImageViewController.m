//
//  EditImageViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/8/30.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "EditImageViewController.h"

@interface EditImageViewController ()
{
    UIImageView *imageView;
    float beginPointX;
    float beginPointY;
    float endPointX;
    float endPointY;
    int touchCount;
    BOOL isDrawLine;
}

@end

@implementation EditImageViewController

- (void)viewDidLoad {
    touchCount = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:view];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initNavigation];
    [self initEditView];
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
    [navigationItem setTitle:self.navTitle];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"editDelete"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(editDelete:)];
    rightButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
   navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [self.view addSubview:navigationBar];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    float w = self.image.size.width;
    float h = self.image.size.height*(self.view.frame.size.width-80)/w;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (self.view.frame.size.height-65-h)/2, self.view.frame.size.width-80, h)];
    imageView.image = self.image;
    [self.view addSubview:imageView];
}
-(void)initEditView
{
    UIView *editView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    editView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(15, 20, 60, 20);
    [btn1 setTitle:@"撤销" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(self.view.frame.size.width-85, 15, 60, 30);
    [btn2 setTitle:@"编辑" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor colorWithRed:103/255.0 green:149/255.0 blue:221/255.0 alpha:1.0];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(toEdit) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:btn2];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:btn2.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = btn2.bounds;
    maskLayer1.path = maskPath1.CGPath;
    btn2.layer.mask = maskLayer1;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake((self.view.frame.size.width/2)-55, 12.5, 35, 35);
    [btn3 setImage:[[UIImage imageNamed:@"editrule"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [editView addSubview:btn3];
    
    [btn3 addTarget:self action:@selector(drawLine) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn4.frame = CGRectMake((self.view.frame.size.width/2)+20, 12.5, 35, 35);
    [btn4 setImage:[[UIImage imageNamed:@"editText"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [btn4 addTarget:self action:@selector(addText) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:btn4];
}
-(void)toBack
{
    
}
-(void)toEdit
{
    
}
-(void)drawLine
{

    isDrawLine = YES;
    
}
-(void)addText
{
    /*UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    view.backgroundColor = [UIColor redColor];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
    [imageView addSubview:view];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    lab.text = @"1m";
    lab.font = [UIFont systemFontOfSize:14.0f];
   

    [view addSubview:lab];*/
}
-(void)editDelete:(id)sender
{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:imageView];
    //touchPoint.x ，touchPoint.y 就是触点的坐标。
    
    if ((touchPoint.x<0)||(touchPoint.x>imageView.frame.size.width)
        ||(touchPoint.y<0)||(touchPoint.y>imageView.frame.size.height))
    {
        return;
    }
    if (!isDrawLine) {
        return;
    }
    NSLog(@"%f%f",touchPoint.x,touchPoint.y);
    if (touchCount%2 == 0) {
        beginPointX = touchPoint.x;
        beginPointY = touchPoint.y;
        touchCount++;
    }
    else
    {
        endPointX = touchPoint.x;
        endPointY = touchPoint.y;
        UIGraphicsBeginImageContext(imageView.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);  //线宽
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), beginPointX, beginPointY);  //起点坐标
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPointX, endPointY);   //终点坐标
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        touchCount++;
        isDrawLine = NO;
    }
    
}
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
@end
