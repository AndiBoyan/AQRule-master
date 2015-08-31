//
//  userSingletion.h
//  AQRule
//
//  Created by 3Vjia on 15/8/31.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userSingletion : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;

+(userSingletion*)inituserSingletion;

@end
