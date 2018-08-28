//
//  NSDate+Extension.m
//  JinAnSecurity
//
//  Created by AllenKwok on 15/10/17.
//  Copyright © 2015年 JinAn. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+(NSString *)currentDate{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    return [format stringFromDate:[NSDate date]];
}

+(NSString *)currentTime{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"HH:mm"];
    
    return [format stringFromDate:[NSDate date]];
}

+(NSString *)currentFullDate{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    return [format stringFromDate:[NSDate date]];
}

+ (NSString *)getHourFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    long hour = [comps hour];
    
    return [NSString stringWithFormat:@"%02ld",hour];
}

+ (NSString *)getMinuteFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    long mim = [comps minute];
    
    return [NSString stringWithFormat:@"%02ld",mim];
}

+ (NSString *)getSecondFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    long second = [comps second];
    
    return [NSString stringWithFormat:@"%02ld",second];
}

//方法，输入参数是NSDate，输出结果是日。
+ (NSNumber *)getDayFromDate:(NSDate *)inputDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:inputDate];
    NSInteger day = [dateComponent day];
    return @(day);
}

//方法，输入参数是NSDate，输出结果是月。
+ (NSNumber *)getMonthFromDate:(NSDate *)inputDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:inputDate];
    NSInteger month = [dateComponent month];
    return @(month);
}

//方法，输入参数是NSDate，输出结果是年。
+ (NSNumber *)getYearFromDate:(NSDate *)inputDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:inputDate];
    NSInteger year = [dateComponent year];
    return @(year);
}

//方法，根据输入的时分秒，返回nsdate
+ (NSDate *)getDateWithYear:(int )year andMonth:(int )month andDay:(int )day andHour:(int )hour andMinute:(int )minute andSecond:(int )second
{
    NSString *dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",year,month,day,hour,minute,second];
    //格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[dateFormatter dateFromString:dateStr];
    
    NSLog(@"fromdate=%@",fromdate);
    
    return fromdate;
}
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday
{
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
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
