//
//  StudentModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

@property (nonatomic , copy ) NSString    *head_image;    //头像
@property (nonatomic , copy ) NSString    *name;          //姓名
@property (nonatomic , copy ) NSString    *grade;         //年级
@property (nonatomic , copy ) NSString    *subject;       //科目
@property (nonatomic ,assign) double      price;        //辅导价格

@end
