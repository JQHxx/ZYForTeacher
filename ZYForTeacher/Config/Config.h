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
//iPhoneX判断
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneXr判断
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneXs判断
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneXs Max判断
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//iPad 判断
#define IS_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

//block weakself
#define kSelfWeak __weak typeof(self) weakSelf = self

//屏幕尺寸
#define isXDevice         (IS_IPHONE_X==YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES)
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width

#define kNavHeight       (IS_IPAD?88:((isXDevice ? 88 : 64)))
#define KStatusHeight    (isXDevice ? 44 : 20)

//颜色
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0  green:(g)/255.0 blue:(b)/255.0  alpha:1]
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

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


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
#define kCheckRecieveNotification @"kCheckRecieveNotification"
#define kGuideRecieveNotification @"kGuideRecieveNotification"
#define kAuthUpdateNotification   @"kAuthUpdateNotification"
#define kGuideCancelNotification   @"kGuideCancelNotification"
#define kOrderCancelNotification   @"kOrderCancelNotification"

#define kShowGuidance              @"kShowGuidance"

#define kCallingForID              @"kCallingForID"

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



/*
 iPhone 5S 640x1136
 iPhone 5C 640x1136
 iPhone 6 750x1334
 iPhone 6 Plus 1080x1920（开发应按照1242x2208适配）
 iPhone 6S 750x1334
 iPhone 6S Plus 1080x1920（开发应按照1242x2208适配）
 iPhone SE 640x1136
 iPhone 7 750x1334
 iPhone 7 Plus 1080x1920（开发应按照1242x2208适配）
 Phone XS 1125x2436（375*812pt*）
 iPhone XR 828x1792（414*896pt*）
 iPhone XS Max 1242x2688（414*896pt*）
 
 iPad 1 1024x768
 iPad 2 1024x768
 The New iPad 2048x1536
 iPad mini  1024x768
 iPad 4  2048x1536
 iPad Air 2048x1536
 iPad mini 2  2048x1536
 iPad Air 2  2048x1536
 iPad mini 3  2048x1536
 iPad mini 4  2048x1536
 iPad Pro  2732x2048

 
 */
