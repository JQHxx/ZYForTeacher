//
//  UIDevice+Extend.h
//  ThumbLocker
//
//  Created by Magic on 16/3/29.
//  Copyright © 2016年 VisionChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extend)


+(NSString *)getSoftwareVer;

+(NSString *)getPhoneModel;

+(NSString *)getLanguage;

+(NSString *)getCountry;

+(NSString *)getIDFA;

+(BOOL)isCharging;

+(float)screenLight;

+(double)getUpTime;

+(float)diskTotalSpace;

+(float)diskFreeSpace;

+ (NSString *)iphoneType;

+ (NSString *)getSystemName;

+ (NSString *)getSystemVersion;

+(NSString *)getIDFV;

+ (NSString *)generateUUID;

+(NSString *)getNetworkType;

/*
 *手机运营商
 */
+(NSString *)getCarrierName;

/*
 *手机分辨率
 */
+(NSString *)getScreenResolution;

/*
 *获取设备型号
 */
+ (NSString*)getDeviceVersion;



@end
