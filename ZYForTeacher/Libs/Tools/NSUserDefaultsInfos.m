//
//  NSUserDefaultsInfos.m
//  TonzeCloud
//
//  Created by vision on 17/2/20.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "NSUserDefaultsInfos.h"

@implementation NSUserDefaultsInfos
+(void)putKey:(NSString *)key andValue:(NSObject *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(id )getValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id result= [defaults objectForKey:key];
    if(!result){
        result = nil;
    }
    return result;
}

+(NSDictionary *)getDicValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [defaults objectForKey:key];
    if(!result){
        result = nil;
    }
    return result;
}

+(void)removeObjectForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

+(NSString *)getCurrentDate{
    NSDateFormatter *df= [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    return [df stringFromDate:[NSDate date]];
}

+(NSTimeInterval )getDateIntervalWithHour:(NSInteger )hour Min:(NSInteger )min{
    NSTimeInterval interval;
    
    //生成时间
    NSDateFormatter *df= [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    [df setDateFormat:@"yyyy-MM-dd HH:mm:00"];
    
    NSString *dateStr=[self getCurrentDate];
    dateStr=[[dateStr substringToIndex:11] stringByAppendingString:[NSString stringWithFormat:@"%li:%li:00",(long)hour,(long)min]];
    
    
    NSDate *date=[df dateFromString:dateStr];
    interval=[date timeIntervalSinceDate:[NSDate date]];
    
    //避免一分钟差异
    if (interval>60) {
        interval+=60;
    }
    
    //避免一分钟立刻操作
    if (interval<60 && interval > 0) {
        interval+=60;
    }
    
    //如果比当前时间少则计算到明天
    if (interval<-60) {
        interval+=24*60*60+60;
    }
    
    
    return interval;
}
+(void)putKey:(NSString *)key anddict:(NSObject *)value{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}
@end
