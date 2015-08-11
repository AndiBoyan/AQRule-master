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
@end
