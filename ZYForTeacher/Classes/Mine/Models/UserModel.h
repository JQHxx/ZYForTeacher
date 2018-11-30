//
//  UserModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/28.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,strong) NSNumber *tid;
@property (nonatomic, copy ) NSString *token;
@property (nonatomic,strong) NSNumber *online;

@property (nonatomic,strong) NSNumber *logid; 
//网易云ID和token
@property (nonatomic, copy ) NSString  *third_id;
@property (nonatomic, copy ) NSString  *third_token;

//身份
@property (nonatomic,strong) NSNumber *tch_label;

//个人信息
@property (nonatomic, copy ) NSString *tch_name;    //昵称
@property (nonatomic, copy ) NSString *trait;       //头像
@property (nonatomic,strong) NSNumber *sex;         //性别
@property (nonatomic,strong) NSNumber *birthday;    //出生日期
@property (nonatomic, copy ) NSString *intro;       //个人简介
@property (nonatomic, copy ) NSString *province;    //省
@property (nonatomic, copy ) NSString *city;        //市
@property (nonatomic, copy ) NSString *country;     //区



//教学信息
@property (nonatomic,strong) NSNumber *edu_exp;    //教学经验
@property (nonatomic,strong) NSNumber *edu_stage;  //教授阶段
@property (nonatomic, copy ) NSArray  *grade;       //授课年级
@property (nonatomic, copy ) NSString *subject;      //科目

//认证信息 0待认证 1待审核 2已认证 3审核未通过
@property (nonatomic,strong) NSNumber *auth_id;
@property (nonatomic,strong) NSNumber *auth_edu;
@property (nonatomic,strong) NSNumber *auth_teach;
@property (nonatomic,strong) NSNumber *auth_skill;


@property (nonatomic , copy ) NSString  *level;
@property (nonatomic ,strong) NSNumber  *score;
@property (nonatomic ,strong) NSNumber  *follower_num;
@property (nonatomic ,strong) NSNumber  *stu_num;
@property (nonatomic ,strong) NSNumber  *check_num;
@property (nonatomic,strong) NSNumber *guide_price;  //辅导价格
@property (nonatomic,strong) NSNumber *guide_time;   //辅导时长
@property (nonatomic,strong) NSNumber *guide_num;    //辅导次数


@end
