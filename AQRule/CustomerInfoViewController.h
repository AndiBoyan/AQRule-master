//
//  客户信息类
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CustomerInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
                                                         MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
{
    UILabel *infoLab;
    UIButton *infoBtn;
}

@property NSArray *customerAry1;
@property NSMutableArray *customerAry2;
@property NSMutableArray *customerAry3;
@property NSMutableArray *customerAry4;
@property NSMutableArray *customerAry5;
@property NSMutableArray *isUpdataAry;
@property UITableView *customerTable;

@property NSString *name;
@property NSString *phone;
@property NSString *address;

@property NSString *CustomerId;
@property NSString *ServiceId;
@property NSString *UserId;

@end