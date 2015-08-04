//
//  MainViewController.m
//  AQRule
//
//  Created by 3Vjia on 15/8/1.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "MainViewController.h"
#import "CustomerViewController.h"
#import "GalleryViewController.h"
#import "UserinfoViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomerViewController *customerVC = [[CustomerViewController alloc]init];
    GalleryViewController *galleryVC = [[GalleryViewController alloc]init];
    UserinfoViewController *userinfoVC = [[UserinfoViewController alloc]init];
    
    customerVC.title = @"我的客户";
    galleryVC.title = @"图库";
    userinfoVC.title = @"我";
    
    UINavigationController *customerNav = [[UINavigationController alloc]initWithRootViewController:customerVC];
    UINavigationController *galleryNav = [[UINavigationController alloc]initWithRootViewController:galleryVC];
    UINavigationController *userinfoNav = [[UINavigationController alloc]initWithRootViewController:userinfoVC];
    
    self.viewControllers = [NSArray arrayWithObjects:customerNav,galleryNav,userinfoNav,nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
