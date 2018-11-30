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
// keyWindow
#define kKeyWindow     [UIApplication sharedApplication].keyWindow
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
//#define kSystemColor          [UIColor colorWithHexString:@"#05d380"]
#define kSystemColor          [UIColor whiteColor]
#define kbgView               [UIColor colorWithHexString:@"#f0f0f0"]
#define kBackgroundColor      kRGBColor(238,241,241)  // 灰色主题背景色
#define kLineColor            kRGBColor(200, 199, 204)

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

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

///APP版本号
#define APP_VERSION     [[NSBundle mainBundle].infoDictionary      objectForKey:@"CFBundleShortVersionString"]
#define APP_DISPLAY_NAME [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"]

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


//调试
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


/*****************第三方平台APPKEY***************/
//网易云
#define kNIMSDKAppKey       @"a49dbf59c7655156ae304e4c47a6230a"

//友盟
#define kUMAppKey          @"5bd2a5a3f1f55624be0000b9"
#define kWechatAppKey       @"wxfbca5046d34f0304"     //微信APPID
#define kWechatAppSecret    @"bed68665f243f9839d3c5e7167838704"  //微信secret
#define kQQAppKey           @"1107855123"
#define kSinaAppKey         @"2515802034"
#define kSinaAppSecret      @"2c407dcc8079f3845595f810555529ca"

/********************通知中心**********************/

#define kDeviceIDFV               @"kDeviceIDFV"
#define kIsLogin                  @"kIsLogin"
#define kUserID                   @"kUserID"
#define kLogID                    @"kLogID"
#define kUserToken                @"kUserToken"
#define kLoginPhone               @"kLoginPhone"
#define kIsOnline                 @"kIsOnline"
#define kUserThirdID              @"kUserThirdID"
#define kUserThirdToken           @"kUserThirdToken"
#define kUserInfo                 @"kUserInfo"
#define kAuthEducation            @"kAuthEducation"
#define kAuthIdentidy             @"kAuthIdentidy"
#define kAuthSkill                @"kAuthSkill"
#define kAuthTeach                @"kAuthTeach"
#define kAuthUpdateNotification   @"kAuthUpdateNotification"
#define kGuideCancelNotification   @"kGuideCancelNotification"
#define kOrderCancelNotification   @"kOrderCancelNotification"

#define kUserIDValue      [NSUserDefaultsInfos getValueforKey:kUserID]
#define kUserTokenValue   [NSUserDefaultsInfos getValueforKey:kUserToken]

#define kUMAlaisType      @"teacher"


#import "Singleton.h"
#import "UIView+Extension.h"
#import "UIView+Toast.h"
#import "UIImage+Extend.h"
#import "UIColor+Extend.h"
#import "NSString+Extend.h"
#import "UIFont+FontName.h"
#import "ZYHelper.h"
#import "Interface.h"
#import "NSUserDefaultsInfos.h"
#import "TCHttpRequest.h"
#import "NSObject+Extend.h"
#import "UIImageView+WebCache.h"



