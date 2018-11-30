//
//  MessageModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,strong)NSNumber    *id;
@property (nonatomic, copy )NSString    *oid; //订单号
@property (nonatomic, copy )NSNumber    *create_time; //创建时间
@property (nonatomic, copy )NSString    *myTitle;
@property (nonatomic, copy )NSString    *icon;
@property (nonatomic,strong)NSNumber    *count;
@property (nonatomic, copy )NSString    *username;
@property (nonatomic, copy )NSString    *trait;

//系统消息
@property (nonatomic, copy )NSString    *title;
@property (nonatomic, copy )NSString    *desc;  //系统消息简介
@property (nonatomic, copy )NSString    *cover;  //系统消息简封面
@property (nonatomic, copy )NSString    *url;    //系统消息详情地址
@property (nonatomic, copy )NSString    *sys_msg_id;

//支付信息
@property (nonatomic,strong)NSNumber    *pay_money;  //付款金额
@property (nonatomic,strong)NSNumber    *pay_cate;   //支付方式 1.支付宝 2微信 3余额

//评论信息
@property (nonatomic,strong)NSNumber    *score;    //评分
@property (nonatomic, copy )NSString    *comment;  //评语

//投诉消息
@property (nonatomic, copy )NSString    *complain;  //投诉内容
@property (nonatomic, copy )NSNumber    *label;  //投诉类型 1对老师不满意 2对订单有疑问 3其他

@end
