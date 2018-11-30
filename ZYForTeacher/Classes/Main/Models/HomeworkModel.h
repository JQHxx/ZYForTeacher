//
//  HomeworkModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeworkModel : NSObject

@property (nonatomic ,strong) NSNumber    *job_id;       //作业id
@property (nonatomic , copy ) NSString    *grade;        //年级
@property (nonatomic , copy ) NSString    *subject;       //科目
@property (nonatomic ,strong) NSArray     *job_pic;       //作业图片数组
@property (nonatomic ,strong) NSNumber    *label;        //作业类型 1检查 2，3辅导
@property (nonatomic ,strong) NSNumber    *price;        //价格
@property (nonatomic ,strong) NSNumber    *stu_id;        //学生ID
@property (nonatomic ,strong) NSNumber    *is_receive;      //是否接单
@property (nonatomic ,strong) NSNumber    *create_time;     //发布时间
@property (nonatomic ,strong) NSNumber    *start_time;      //预约时间
@property (nonatomic , copy ) NSString    *username;        //学生姓名
@property (nonatomic , copy ) NSString    *trait;           //学生头像
@property (nonatomic ,strong) NSNumber    *job_price;       //作业价格

@property (nonatomic , copy )  NSString   *third_id;         //通信ID
@property (nonatomic , copy )  NSString   *orderId;         //订单id

@end
