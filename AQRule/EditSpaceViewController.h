//
//  EditSpaceViewController.h
//  AQRule
//
//  Created by 3Vjia on 15/7/25.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSpaceViewController : UIViewController

@property NSString *ServiceId;
@property NSString *MeasureId;
@property NSString *UserId;
@property NSString *spaceId;
@property NSString *modelType;
@property NSString *styleLabStr;
@property NSString *areaLabStr;
@property NSString *materialStr;
@property NSString *layoutStr;
@property NSString *procutLabStr;
@property NSString *houseLabStr;
@property NSString *budgetLabStr;

@property (nonatomic) int MeasureType;//量尺类型;
@property (nonatomic, strong) NSString *measure;//量尺时间
@property (nonatomic, strong) NSString *finish;//结束时间

@property UILabel *measureLab;//测量时间
@property UILabel *finishLab;//完成时间
@property UILabel *spaceLab;
@property UILabel *styleLab;
@property UILabel *areaLab;
@property UILabel *materialLab;
@property UILabel *layoutLab;
@property UILabel *procutLab;
@property UILabel *houseLab;
@property UILabel *budgetLab;

@end
