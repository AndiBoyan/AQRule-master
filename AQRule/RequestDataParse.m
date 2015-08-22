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
    string = [string stringByReplacingOccurrencesOfString:@"\"JSON\":\"" withString:@"\"JSON\":"];
    string = [string stringByReplacingOccurrencesOfString:@"}\"," withString:@"},"];
    string = [string stringByReplacingOccurrencesOfString:@"]\"," withString:@"],"];
    string = [string stringByReplacingOccurrencesOfString:@"\"JSON\":\"\\\"\\\"\"" withString:@"\"JSON\":\"\""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\"JSON\":\"\"" withString:@"\"JSON\":\""];
    string = [string stringByReplacingOccurrencesOfString:@"\"\",\"ErrorMessage\"" withString:@"\",\"ErrorMessage\""];
    return string;
}
#pragma mark 日期
+(NSMutableArray*)weekAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeInterval  interval = 24*60*60*1;
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger week = [dateComponent weekday];
    for (int i = 0; i < 30; i++) {
        if (week > 7) {
            week = 1;
        }
        NSString *weekStr;
        if (week == 1) {
            weekStr = @"周日";
        }
        else if (week == 2) {
            weekStr = @"周一";
        }
        else if (week == 3) {
            weekStr = @"周二";
        }
        else if (week == 4) {
            weekStr = @"周三";
        }
        else if (week == 5) {
            weekStr = @"周四";
        }
        else if (week == 6) {
            weekStr = @"周五";
        }
        else if (week == 7) {
            weekStr = @"周六";
        }
        if(i == 0)
        {
            date = now;
            NSString *str = [NSString stringWithFormat:@"%@(今天)",[dateFormatter stringFromDate:date]];
            [ary addObject:str];
        }
        else if (i == 1) {
            date = [date dateByAddingTimeInterval:+interval];
            NSString *str = [NSString stringWithFormat:@"%@(明天)",[dateFormatter stringFromDate:date]];
            [ary addObject:str];
        }
        else
        {
            date = [date dateByAddingTimeInterval:+interval];
            NSString *str = [NSString stringWithFormat:@"%@(%@)",[dateFormatter stringFromDate:date],weekStr];
            [ary addObject:str];
        }
        week++;
    }
    return ary;
}
//小时
+(NSMutableArray*)hourAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i <= 12; i++) {
        NSString *str = [NSString stringWithFormat:@"%d时",8+i];
        [ary addObject:str];
    }
    return ary;
}
//分钟
+(NSMutableArray*)minAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i < 12; i++) {
        NSString *str = [NSString stringWithFormat:@"%d分",i*5];
        if (i < 2) {
            str = [NSString stringWithFormat:@"0%@",str];
        }
        [ary addObject:str];
    }
    return ary;
}

@end
