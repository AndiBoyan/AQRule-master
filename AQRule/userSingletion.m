//
//  userSingletion.m
//  AQRule
//
//  Created by 3Vjia on 15/8/31.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "userSingletion.h"

@implementation userSingletion
static userSingletion *instance = nil;

+(userSingletion*)inituserSingletion
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[userSingletion alloc]init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

@end
