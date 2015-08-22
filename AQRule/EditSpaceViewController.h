//
//  EditSpaceViewController.h
//  AQRule
//
//  Created by 3Vjia on 15/7/25.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSpaceViewController : UIViewController

@property(nonatomic, strong) NSArray *addSpaceAry1;
@property(nonatomic, strong) NSArray *addSpaceAry2;
@property(nonatomic, strong) NSMutableArray *addSpaceAry3;
@property(nonatomic, strong) NSMutableArray *addSpaceAry4;
@property(nonatomic, strong) NSArray *addSpaceDateAry;
@property(nonatomic, strong) NSArray *addSpaceHourAry;
@property(nonatomic, strong) NSArray *addSpaceMinAry;
@property(nonatomic, strong) UIPickerView *picker;
@property(nonatomic, strong) UIView *dateView;
@property(nonatomic, strong) UILabel *measureLab;//测量时间
@property(nonatomic, strong) UILabel *finishLab;//完成时间

@property(nonatomic, strong) NSString *ruleType;
@property(nonatomic, strong) NSString *measure;
@property(nonatomic, strong) NSString *finish;
@property(nonatomic, strong) NSString *noteString;

@property NSMutableArray *spaceModel;

@end
