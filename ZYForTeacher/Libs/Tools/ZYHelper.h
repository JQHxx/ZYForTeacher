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

@property (nonatomic ,assign) BOOL   isUpdateHome;
@property (nonatomic ,assign) BOOL   isUpdateMessageUnread;
@property (nonatomic ,assign) BOOL   isUpdateMessageInfo;
@property (nonatomic ,assign) BOOL   isUpdateUserInfo;
@property (nonatomic ,assign) BOOL   isUpdateBankList;
@property (nonatomic ,assign) BOOL   isUpdateWithdraw;
@property (nonatomic ,assign) BOOL   isUpdateOrderList;

@property (nonatomic , copy ) NSArray  *grades;  //年级
@property (nonatomic , copy ) NSArray  *subjects;  //科目
@property (nonatomic , copy ) NSDictionary  *banksDict;  //银行信息

@property (nonatomic ,assign) BOOL   isCertified;   //是否认证


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

/*
 *@bref 对图片base64加密
 */
- (NSMutableArray *)imageDataProcessingWithImgArray:(NSMutableArray *)imgArray;

/**
 *@bref 将某个时间转化成 时间戳
 */
-(NSNumber *)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format;

/**
 *@bref 时间戳转化为时间
 */
- (NSString *)timeWithTimeIntervalNumber:(NSNumber *)timeNum format:(NSString *)format;

/*
 *将年级字符串数组转为年级id数组
 */
-(NSMutableArray *)setGradeIdsArrayWithGradeStrs:(NSArray *)grades;


/*
 * 根据银行获取银行卡代号
 */
-(NSString *)getBankCodeWithBankName:(NSString *)bankName;

/*
 *计算时间差
 */
-(NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2;

@end
