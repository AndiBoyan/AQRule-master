//
//  URLApi.m
//  AQRule
//
//  Created by 3Vjia on 15/8/21.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "URLApi.h"

@implementation URLApi

+(NSString *)initURL
{
    return @"http://oppein.3weijia.com/oppein.axds";
}

+(NSString*)initCode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return [userDefaultes stringForKey:@"AuthCode"];
}
@end
