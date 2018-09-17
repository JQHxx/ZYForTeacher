//
//  OrderModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic ,assign) NSInteger   type;          //辅导类型
@property (nonatomic ,strong) NSArray     *images;       //作业图片数组
@property (nonatomic , copy ) NSString    *grade;        //年级
@property (nonatomic , copy ) NSString    *subject;      //科目
@property (nonatomic ,assign) double      perPrice;      //作业辅导 （元/分钟）
@property (nonatomic , copy )  NSString   *video_cover;    //视频封面图片
@property (nonatomic , copy )  NSString   *video_url;      //视频地址
@property (nonatomic ,assign) double      check_price;     //作业检查价格
@property (nonatomic , copy ) NSString    *create_time;   //发布时间
@property (nonatomic ,assign) NSInteger   time_type;      //0、实时 1、预约
@property (nonatomic , copy ) NSString    *order_time;    //预约时间
@property (nonatomic ,assign) NSInteger    state;           //0、待接单 1、已接单
@property (nonatomic ,assign) NSInteger    received_state;     //0、等待去辅导 1、预约时间
@property (nonatomic , copy ) NSString    *head_image;      //老师头像
@property (nonatomic , copy ) NSString    *name;            //老师姓名

@property (nonatomic , assign) NSInteger  duration;         //辅导时长
@property (nonatomic , assign) double     pay_price;        //支付金额

@property (nonatomic , copy ) NSString    *order_sn;   //订单号
@property (nonatomic ,assign) NSInteger   payway;   //支付方式
@property (nonatomic , copy ) NSString    *payTime;   //支付时间


@property (nonatomic ,assign) double      payPrice;

@end
