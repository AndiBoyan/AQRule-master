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
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0.2f green:0.6 blue:0.2f alpha:1.0f];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)newJsonStr:(NSString*)string
{
    int start = 0;
    int end = 0;
    for (int i = 0; i < string.length-20; i++) {
        if ([[string substringWithRange:NSMakeRange(i , 7)]isEqualToString:@"\"JSON\":"]) {
            start = i + 6;
        }
        else if([[string substringWithRange:NSMakeRange(i, 15)]isEqualToString:@",\"ErrorMessage\""])
        {
            end = i - 1;
        }
    }
    NSString *str1 = [string substringToIndex:start+1];
    NSString *str2 = [string substringWithRange:NSMakeRange(start+2, end-start-2)];
    NSString *str3 = [string substringFromIndex:end+1];
    return [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
}

@end
