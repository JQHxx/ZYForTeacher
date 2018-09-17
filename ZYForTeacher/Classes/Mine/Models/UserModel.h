//
//  UserModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/28.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic ,strong) UIImage   *headImage;
@property (nonatomic , copy ) NSString  *head_url;   //头像
@property (nonatomic , copy ) NSString  *nick_name;  //昵称
@property (nonatomic ,assign) NSInteger sex;         //性别
@property (nonatomic , copy ) NSString  *birth_date;  //出生年月
@property (nonatomic , copy ) NSString  *area;       //所在地区
@property (nonatomic , copy ) NSString  *intro;      //个人简介





@end
