//
//  AppDelegate.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "RequestDataParse.h"
#import "userSingletion.h"
#import "URLApi.h"

@interface AppDelegate ()<BMKGeneralDelegate>

{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

       _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"XXG8pSHWP0O34GLaAxY1nuKe" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *mainVc = [[MainViewController alloc]init];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaultes arrayForKey:@"login"];
    if (array.count <= 0) {
        self.window.rootViewController = loginVC;
    }
    else
    {
        self.window.rootViewController = mainVc;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
