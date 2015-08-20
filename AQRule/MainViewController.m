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
    /*
     CustomerViewController : 我的客户
     GalleryViewController  : 图库
     UserinfoViewController : 我
     */
    CustomerViewController *customerVC = [[CustomerViewController alloc]init];
    GalleryViewController *galleryVC = [[GalleryViewController alloc]init];
    UserinfoViewController *userinfoVC = [[UserinfoViewController alloc]init];
    
    customerVC.title = @"我的客户";
    galleryVC.title = @"图库";
    userinfoVC.title = @"我";
    
    UINavigationController *customerNav = [[UINavigationController alloc]initWithRootViewController:customerVC];
    UINavigationController *galleryNav = [[UINavigationController alloc]initWithRootViewController:galleryVC];
    UINavigationController *userinfoNav = [[UINavigationController alloc]initWithRootViewController:userinfoVC];
    
    customerNav.tabBarItem.image = [[UIImage imageNamed:@"first_normal@2x"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    customerNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"first_selected@2x"]
                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    galleryNav.tabBarItem.image = [[UIImage imageNamed:@"second_normal@2x"]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    galleryNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"second_selected@2x"]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    userinfoNav.tabBarItem.image = [[UIImage imageNamed:@"third_normal@2x"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userinfoNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"third_selected@2x"]
                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = [NSArray arrayWithObjects:customerNav,galleryNav,userinfoNav,nil];

    //self.tabBar.tintColor = [UIColor blackColor];
    //UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    //bgView.backgroundColor = [UIColor colorWithRed:0.2f green:0.6 blue:0.2f alpha:1.0f];
    //[self.tabBar insertSubview:bgView atIndex:0];
    //self.tabBar.opaque = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
