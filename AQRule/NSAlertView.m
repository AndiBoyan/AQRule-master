//
//  NSAlertView.m
//  AQRule
//
//  Created by 3Vjia on 15/8/10.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "NSAlertView.h"

@implementation NSAlertView

+(void)alert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

+(void)initLabelView:(UIView*)insertView
               frame:(CGRect)frame
                text:(NSString*)string
                font:(float)font
           alignment:(NSTextAlignment)alignment
           isNumLine:(BOOL)numLine
{
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:font];
    lab.textAlignment = alignment;
    if (numLine) {
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
    }
    [insertView addSubview:lab];
}
+(void)addAnimation:(UIView*)view push:(BOOL)push
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 1.0f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    if (push) {
        transition.subtype = kCAGravityTopRight;
    }
    else
    {
        transition.subtype = kCAGravityTopLeft;
    }
        
    
    
    [view.layer addAnimation:transition forKey:nil];
}
@end
