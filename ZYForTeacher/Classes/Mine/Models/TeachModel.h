//
//  TeachModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachModel : NSObject

@property (nonatomic , copy ) NSString  *teach;         //教学经验
@property (nonatomic , copy ) NSString  *teach_stage;       //教授阶段 小学 初中
@property (nonatomic , copy ) NSString  *grade;         //授课年级 多个年级用
@property (nonatomic , copy ) NSString  *subject;      //科目

@end
