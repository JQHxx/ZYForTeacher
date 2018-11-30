//
//  OrderModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"

@interface OrderModel : NSObject

@property (nonatomic , copy ) NSString   *oid;             //订单号
@property (nonatomic ,strong) NSNumber   *jobid;           //作业id
@property (nonatomic ,strong) NSNumber   *create_time;     //订单创建时间
@property (nonatomic ,strong) NSNumber   *label;           //辅导类型 1、作业检查 2、作业辅导预约 3、作业辅导实时
@property (nonatomic , copy ) NSString   *grade;            //年级
@property (nonatomic , copy ) NSString   *subject;          //科目
@property (nonatomic ,strong) NSNumber   *price;            //价格
@property (nonatomic ,strong) NSNumber   *status;            //订单状态 0检查中 1待付款 2已完成 3已取消 5已评价
@property (nonatomic ,strong) NSNumber   *userid;            //学生id
@property (nonatomic , copy ) NSString   *trait;             //学生头像
@property (nonatomic , copy ) NSString   *username;          //学生姓名
@property (nonatomic ,strong) NSArray     *job_pic;          //作业图片数组
@property (nonatomic ,strong) NSArray     *pics;              //作业检查结果图片数组
@property (nonatomic , copy ) NSString    *order_time;        //预约时间
@property (nonatomic , copy )  NSString   *cover;             //视频封面图片
@property (nonatomic , copy )  NSString   *video_url;         //视频地址
@property (nonatomic ,strong)  NSNumber   *job_time;          //辅导时长
@property (nonatomic ,strong) NSNumber   *pay_time;           //支付时间
@property (nonatomic ,strong) NSNumber   *pay_money;          //支付金额
@property (nonatomic ,strong) NSNumber   *cate;               //支付方式

@property (nonatomic , copy )  NSString   *third_id;         //通信ID


@end

@interface ComplainModel :NSObject

@property (nonatomic,strong) NSNumber *label;
@property (nonatomic, copy ) NSString *complain;

@end

@interface CommentModel : NSObject

@property (nonatomic,strong) NSNumber *score;
@property (nonatomic, copy ) NSString *comment;

@end
