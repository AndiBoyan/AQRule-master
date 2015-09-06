//
//  CustomerInfoListViewController.h
//  AQRule
//
//  Created by icePhoenix on 15/7/24.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString *name;
    NSString *phone1;
    NSString *phone2;
    NSString *email;
    NSString *qq;
    NSString *addr;
    NSString *note;
    
    NSString *customerSource;
    NSString *customerType;
    NSString *shoppingGuide;
    NSString *designer;
    NSString *decDesigner;
    NSString *salesman;
    NSString *budgetCoust;
    NSString *budgetTime;
    NSString *budgetProducts;
    
    NSString *roomType;
    NSString *roomApart;
    NSString *price;
    NSString *deliveryTime;
    NSString *property;
}

@property NSString* CustomerId;
@property NSString* ServiceId;
@property UITableView *customerInfoListTable;
@property NSArray *customerBaseAry;
@property NSArray *customerIntentionAry;
@property NSArray *customerRoomAry;

@property NSMutableArray *baseAry;
@property NSMutableArray *intentionAry;
@property NSMutableArray *roomAry;

@end
