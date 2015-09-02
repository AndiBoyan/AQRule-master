//
//  AddNewCustomerViewController.h
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
#import "QRadioButton.h"

@interface AddNewCustomerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
                                                           HZAreaPickerDelegate,UITextFieldDelegate,
                                                           QRadioButtonDelegate>

@property UITableView *customerTable;
@property NSArray *customerAry1;
@property NSArray *customerAry2;
@property UILabel *areaLab;
@property UITextField *nameField;
@property UITextField *phoneField;
@property UITextField *addrField;
@property UITextField *markField;
@property UIView *AreaView;
@property NSString *customerName;
@property NSString *customerPhone;
@property NSString *customerProvice;
@property NSString *customerCity;
@property NSString *customerArea;
@property NSString *customerAddr;
@property NSString *customerNote;
@property int sex;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@end
