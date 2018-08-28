

//
//  UIDevice+Extend.m
//  ThumbLocker
//
//  Created by Magic on 16/3/29.
//  Copyright © 2016年 VisionChina. All rights reserved.
//

#import "UIDevice+Extend.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AdSupport/AdSupport.h>
#import <dlfcn.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <mach/mach_host.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "Reachability.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (Extend)

+(NSString *)getSoftwareVer{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

//手机系统 iPhone OS
+(NSString *)getSystemName{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return@"iPhone2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return@"iPhone3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return@"iPhone3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return@"iPhone4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return@"iPhone6Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return@"iPhone6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return@"iPhone6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return@"iPhone6sPlus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return@"iPhoneSE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return@"iPhone7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return@"iPhone7Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone8Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone8Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhoneX";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhoneX";
    
    if([platform isEqualToString:@"iPod1,1"]) return@"iPodTouch1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return@"iPodTouch2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return@"iPodTouch3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return@"iPodTouch4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return@"iPodTouch5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return@"iPad1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,2"]) return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,3"]) return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,4"]) return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,5"]) return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,2"]) return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,3"]) return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,4"]) return@"iPad4";
    
    if([platform isEqualToString:@"iPad3,5"]) return@"iPad4";
    
    if([platform isEqualToString:@"iPad3,6"]) return@"iPad4";
    
    if([platform isEqualToString:@"iPad4,1"]) return@"iPadAir";

    if([platform isEqualToString:@"iPad4,2"]) return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,3"]) return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,4"]) return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad4,8"]) return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad4,9"]) return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad5,1"]) return@"iPadMini4";
    
    if([platform isEqualToString:@"iPad5,2"]) return@"iPadMini4";
    
    if([platform isEqualToString:@"iPad5,3"]) return@"iPadAir2";
    
    if([platform isEqualToString:@"iPad5,4"]) return@"iPadAir2";
    
    if([platform isEqualToString:@"iPad6,3"]) return@"iPadPro9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return@"iPadPro9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return@"iPadPro12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return@"iPadPro12.9";
    
    if([platform isEqualToString:@"i386"]) return@"iPhoneSimulator";
    
    if([platform isEqualToString:@"x86_64"]) return@"iPhoneSimulator";
    
    return platform;
}

//系统版本  10.2
+(NSString *)getSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString *)getPhoneModel{
    return [UIDevice currentDevice].model;
}

+(NSString *)getLanguage{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+(NSString *)getCountry{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+(NSString *)getIDFA{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *) getSysInfoByName:(char *)typeSpecifier{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+(BOOL)isCharging{
    UIDeviceBatteryState deviceBatteryState = [UIDevice currentDevice].batteryState;
    if (deviceBatteryState == UIDeviceBatteryStateCharging || deviceBatteryState == UIDeviceBatteryStateFull) {
        return YES;
    }
    return NO;
}

+(float)screenLight{
    return  [UIScreen mainScreen].brightness;
}

+(float)diskTotalSpace{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
 #pragma clang diagnostic pop
    NSString *diskTotalSize = [systemAttributes objectForKey:@"NSFileSystemSize"];
    return [diskTotalSize floatValue];
}

+(float)diskFreeSpace
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
#pragma clang diagnostic pop
    NSString *diskFreeSize = [systemAttributes objectForKey:@"NSFileSystemFreeSize"];
    return [diskFreeSize floatValue];
}

+(double)getUpTime{
    [NSDate dateWithTimeIntervalSinceNow:[[NSProcessInfo processInfo] systemUptime]];
    return  [[NSProcessInfo processInfo] systemUptime];
}


+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";

    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}


+(NSString *)getIDFV{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


+ (NSString *)generateUUID{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    return uuidStr;
}


+(NSString *)getNetworkType{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    NSString *netType=nil;
    switch([reach currentReachabilityStatus])
    {
        case NotReachable:      //未连接
            netType=@"";
            break;
        case ReachableViaWiFi:  //通过wifi连接
            netType=@"wifi";
            break;
        case ReachableViaWWAN:  //通过GPRS连接
            netType=@"GPRS";
            break;
        default:
            break;    
    }
    return netType;
}

#pragma mark 获取手机运营商
+(NSString *)getCarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    MyLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}

#pragma mark  获取手机分辨率
+(NSString *)getScreenResolution{
   // 1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    // 2、获得scale：
    CGFloat scale_screen = [UIScreen mainScreen].scale;
   // 3、获取分辨率
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    return [NSString stringWithFormat:@"%ld*%ld",(NSInteger)width,(NSInteger)height];
}

+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //NSString *platform = [NSStringstringWithUTF8String:machine];二者等效
    free(machine);
    return platform;
}

@end
