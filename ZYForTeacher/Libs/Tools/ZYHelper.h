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

/*
 *根据年级获取科目
 *
 * @param grade 年级
 * @return 科目数组
 *
 */
-(NSArray *)getCourseForStage:(NSString *)stage;

/*
 *获取订单状态
 *
 * @param index 
 * @return 订单状态
 *
 */
-(NSString *)getStateStringWithIndex:(NSInteger)index;

/***
 * @bref  限制emoji表情输入
 */
-(BOOL)strIsContainEmojiWithStr:(NSString*)str;

/***
 * @bref  限制第三方键盘（常用的是搜狗键盘）的表情
 */
- (BOOL)hasEmoji:(NSString*)string;

/***
 * @bref  判断当前是不是在使用九宫格输入
 */
-(BOOL)isNineKeyBoard:(NSString *)string;


@end
