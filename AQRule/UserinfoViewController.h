//
//  UserinfoViewController.h
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserinfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property UITableView *userInfoTable;
@property NSArray *userInfoAry1;
@property NSArray *userInfoAry2;

@end
