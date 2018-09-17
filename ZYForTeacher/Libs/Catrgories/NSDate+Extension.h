//
//  NSDate+Extension.h
//  JinAnSecurity
//
//  Created by AllenKwok on 15/10/17.
//  Copyright © 2015年 JinAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  @return 当前年
 */
+ (NSInteger )currentYear;

/**
 *  @return 当前日期
 */
+ (NSString *)currentDate;

/**
 *  @return 当前时间
 */
+ (NSString *)currentTime;

/**
 *  @return 当前日期时间
 */
+(NSString *)currentFullDate;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

/*
 *获取年份时间（年月日）
 */
+(NSString *)getLastYearDate:(NSInteger)page;

/*
 * 获取本月前几个月份
 * @param numberMonth 几个月
 * @param fromDate    开始时间
 * @return  月份数组
 */
+(NSMutableArray *)getDatesForNumberMonth:(NSInteger)numberMonth WithFromDate:(NSDate *)fromDate;

@end
