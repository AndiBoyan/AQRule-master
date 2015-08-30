//
//  NSAlertView.h
//  AQRule
//
//  Created by 3Vjia on 15/8/10.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAlertView : NSObject

+(void)alert:(NSString*)message;

+(void)addAnimation:(UIView*)view push:(BOOL)push;

+(void)initLabelView:(UIView*)insertView
               frame:(CGRect)frame
                text:(NSString*)string
                font:(float)font
           alignment:(NSTextAlignment)alignment
           isNumLine:(BOOL)numLine;
@end
