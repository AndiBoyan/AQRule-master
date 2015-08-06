//
//  RequestDataParse.m
//  AQRule
//
//  Created by 3Vjia on 15/8/6.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "RequestDataParse.h"

@implementation RequestDataParse

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString*)newJsonStr:(NSString*)string
{
    int start = 0;
    int end = 0;
    for (int i = 0; i < string.length-20; i++) {
        if ([[string substringWithRange:NSMakeRange(i , 7)]isEqualToString:@"\"JSON\":"]) {
            start = i + 6;
        }
        else if([[string substringWithRange:NSMakeRange(i, 15)]isEqualToString:@",\"ErrorMessage\""])
        {
            end = i - 1;
        }
    }
    NSString *str1 = [string substringToIndex:start+1];
    NSString *str2 = [string substringWithRange:NSMakeRange(start+2, end-start-2)];
    NSString *str3 = [string substringFromIndex:end+1];
    return [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
}

@end
