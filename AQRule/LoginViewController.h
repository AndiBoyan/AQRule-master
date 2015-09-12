//
//  LoginViewController.h
//  AQRule
//
//  Created by 3Vjia on 15/7/30.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    float viewWidth;
    float viewHeight;
    BOOL isSecure;
    
    UIImageView *logoImgView;
    UILabel *logoLab;
    UIView *phoneview;
    UIView *psdview;
    UIButton *button;
}
@property UITextField *nameField;
@property UITextField *pwdField;

@property NSString *name;
@property NSString *password;
@end
