//
//  Config.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#ifndef Config_h
#define Config_h


#endif /* Config_h */

/********************常用宏定义*****************/
//ios系统版本号
#define kIOSVersion    ([UIDevice currentDevice].systemVersion.floatValue)
// appDelegate
#define kAppDelegate   (AppDelegate *)[[UIApplication  sharedApplication] delegate]
//iPhone x判断
#define isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height==2436 : NO)
//block weakself
#define kSelfWeak __weak typeof(self) weakSelf = self

//屏幕尺寸
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kTabHeight        (isIPhoneX ? (49+ 34) : 49)
#define kNavHeight        (isIPhoneX ? 88 : 64)
#define KStatusHeight     (isIPhoneX ? 44 : 20)


//颜色
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0  green:(g)/255.0 blue:(b)/255.0  alpha:1]
#define kSystemColor          [UIColor colorWithHexString:@"#05d380"]
#define kbgView               [UIColor colorWithHexString:@"#f0f0f0"]
#define kBackgroundColor      kRGBColor(238,241,241)  // 灰色主题背景色
#define kLineColor            kRGBColor(200, 199, 204)

//字体
#define kFontWithSize(size)      [UIFont systemFontOfSize:size]
#define kBoldFontWithSize(size)  [UIFont boldSystemFontOfSize:size]

#pragma mark --Judge
//字符串为空判断
#define kIsEmptyString(s)       (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))
//对象为空判断
#define kIsEmptyObject(obj)     (obj == nil || [obj isKindOfClass:[NSNull class]])
//字典类型判断
#define kIsDictionary(objDict)  (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])
//数组类型判断
#define kIsArray(objArray)      (objArray != nil && [objArray isKindOfClass:[NSArray class]])


//调试
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif


/*****************第三方平台APPKEY***************/


/********************通知中心**********************/


#import "Singleton.h"
#import "UIView+Extension.h"
#import "UIView+Toast.h"
#import "UIImage+Extend.h"
#import "UIColor+Extend.h"
#import "NSString+Extend.h"
#import "ZYHelper.h"
#import "Interface.h"
