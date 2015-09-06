//
//  客户列表类
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//
//客户信息管理

#import <UIKit/UIKit.h>
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"
#import "HTHorizontalSelectionList.h"

@interface CustomerViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,
                                    UITableViewDataSource,UITableViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource,UIActionSheetDelegate>
{
    UIBarButtonItem *searchBarButton;//搜索客户按钮
    UIBarButtonItem *addCustomerBarButton;//添加客户按钮
    UIBarButtonItem *backButton;//取消客户搜索
    UIBarButtonItem *donebutton;//确定搜索数据
    
    UILabel *customerIsNullLab;//用户信息是否为空
    UITextField *searchField;//搜索框
    
    YiRefreshHeader *refreshHeader;//下拉刷新
    YiRefreshFooter *refreshFooter;//上拉加载
    
    NSString *customerType;//客户类型
    NSString *customerTypeChange;//客户类型是否改变
    
    int indexPage;//页码
    NSInteger deleteIndex;
}

@property UITableView *customerTable;
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) NSArray *carMakes;
@property NSMutableArray *nameAry;
@property NSMutableArray *phoneAry;
@property NSMutableArray *addrAry;
@property NSMutableArray *customerNameAry;
@property NSMutableArray *customerPhoneAry;
@property NSMutableArray *customerAddrAry;
@property NSMutableArray *CustomerId;
@property NSMutableArray *ServiceId;
@property NSMutableArray *UserId;
@property NSMutableArray *indexAry;

@end
