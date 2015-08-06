//
//  RequestDataParse.h
//  AQRule
//
//  Created by 3Vjia on 15/8/6.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestDataParse : NSObject

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+ (NSString*)newJsonStr:(NSString*)string;

@end
