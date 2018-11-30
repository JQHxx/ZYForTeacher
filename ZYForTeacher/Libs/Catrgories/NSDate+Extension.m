//
//  NSDate+Extension.m
//  JinAnSecurity
//
//  Created by AllenKwok on 15/10/17.
//  Copyright © 2015年 JinAn. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

#pragma mark 当前年
+(NSInteger)currentYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
}

#pragma mark 当前年月
+(NSString *)currentYearMonth{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM"];
    return [format stringFromDate:[NSDate date]];
}

#pragma mark 当前日期
+(NSString *)currentDate{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    return [format stringFromDate:[NSDate date]];
}

#pragma mark 当前时间
+(NSString *)currentTime{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"HH:mm"];
    return [format stringFromDate:[NSDate date]];
}

#pragma mark 当前日期时间
+(NSString *)currentFullDate{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    return [format stringFromDate:[NSDate date]];
}

#pragma mark 是否为今年
- (BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

#pragma mark 是否为今天
- (BOOL)isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}

#pragma mark 是否为昨天
- (BOOL)isYesterday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

#pragma mark 获取年份时间（年月日）
+(NSString *)getLastYearDate:(NSInteger)page{
    NSTimeInterval secondsPerDay = -page* 24*60*60*365;
    NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [dateFormatter stringFromDate:curDate];
    return dateStr;
}

#pragma mark 获取本月前几个月份
+(NSMutableArray *)getDatesForNumberMonth:(NSInteger)numberMonth WithFromDate:(NSDate *)fromDate{
    NSMutableArray *tempDateArr = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];//设置时区
    [formatter setTimeZone:timeZone];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeInterval time1970 = [fromDate timeIntervalSince1970];
    
    NSUInteger numberOffDaysInMonth = 0;
    //计算当月的所有的天数
    for (NSInteger i= 0 ; i<numberMonth; i++) {
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time1970-(86400*numberOffDaysInMonth)];
        [formatter stringFromDate:dateTime];
        NSString *string = [NSString stringWithFormat:@"%@",dateTime];
        NSString *year = [string substringToIndex:4];
        NSString *month = [string substringWithRange:NSMakeRange(5, 2)];
        NSString *tempstr = [NSString stringWithFormat:@"%@年%@月",year,month];
        [tempDateArr addObject:tempstr];
        //计算当月的所有的天数
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateTime];
        NSInteger  CuurentNumberOffDaysInMonth = range.length;
        numberOffDaysInMonth += CuurentNumberOffDaysInMonth;
    }
    return tempDateArr;
}

@end
