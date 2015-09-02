//
//  建议或者意见类
//  AQRule
//
//  Created by 3Vjia on 15/8/30.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"

@interface OpinionViewController : UIViewController<QRadioButtonDelegate,UITextViewDelegate>
{
    int CommunicateType;
    UITextView *communicateTextView;
    UILabel *placeholderLab;
}
@property (nonatomic,strong) NSString *ServiceId;
@end
