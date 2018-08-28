//
//  ZYHelper.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ZYHelper.h"


@implementation ZYHelper

singleton_implementation(ZYHelper)

#pragma mark 天
-(NSArray *)daysArray{
    return @[@"今天", @"明天"];
}

#pragma mark 小时
-(NSArray *)hoursArray{
    return @[@"0点", @"1点", @"2点", @"3点", @"4点", @"5点", @"6点", @"7点", @"8点", @"9点", @"10点", @"11点", @"12点", @"13点", @"14点", @"15点", @"16点", @"17点", @"18点", @"19点", @"20点", @"21点", @"22点", @"23点"];
}

#pragma mark 分钟
-(NSArray *)minutesArray{
    return @[@"0分", @"10分", @"20分", @"30分", @"40分", @"50分"];
}

#pragma mark 根据年级获取科目
-(NSArray *)getCourseForGrade:(NSString *)grade{
    NSArray *arr =nil;
    if ([grade isEqualToString:@"初一"]) {
        arr = @[@"语文",@"数学",@"英语",@"政治",@"历史",@"地理",@"生物"];
    }else if ([grade isEqualToString:@"初二"]){
        arr = @[@"语文",@"数学",@"英语",@"政治",@"历史",@"地理",@"化学",@"生物"];
    }else if ([grade isEqualToString:@"初三"]){
        arr = @[@"语文",@"数学",@"英语",@"政治",@"历史",@"地理",@"物理",@"化学",@"生物"];
    }else{
        arr = @[@"语文",@"数学",@"英语"];
    }
    return arr;
}

#pragma mark -- 辅导订单相关
#pragma mark 获取订单状态
-(NSString *)getStateStringWithIndex:(NSInteger)index{
    NSString *state = @"";
    if (index == 0) {
        state = @"待接单";
    }else if (index == 1){
        state = @"已接单待辅导";
    }else if (index == 2){
        state = @"辅导中";
    }else if (index == 3){
        state = @"待付款";
    }else if (index == 4){
        state = @"已完成";
    }else if (index == 5){
        state = @"已取消";
    }
    return state;
}




@end
