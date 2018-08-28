//
//  ZYHelper.h
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHelper : NSObject

singleton_interface(ZYHelper)

@property (nonatomic ,assign) BOOL isLogin;

@property (nonatomic ,strong) NSArray *daysArray;
@property (nonatomic ,strong) NSArray *hoursArray;       //小时
@property (nonatomic ,strong) NSArray *minutesArray;     //分钟

/*
 *根据年级获取科目
 *
 * @param grade 年级
 * @return 科目数组
 *
 */
-(NSArray *)getCourseForGrade:(NSString *)grade;

/*
 *获取订单状态
 *
 * @param index 
 * @return 订单状态
 *
 */
-(NSString *)getStateStringWithIndex:(NSInteger)index;


@end
