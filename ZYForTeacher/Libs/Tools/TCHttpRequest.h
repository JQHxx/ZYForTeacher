//
//  TCHttpRequest.h
//  TonzeCloud
//
//  Created by vision on 16/10/9.
//  Copyright © 2016年 tonze. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccess)(id json);//请求成功后的回调
typedef void (^HttpFailure)(NSString *errorStr);//请求失败后的回调

@interface TCHttpRequest : NSObject

singleton_interface(TCHttpRequest)

/**
 *网络请求判断
 *
 */
-(BOOL)isConnectedToNet;

/*
 *通用网络请求 get方法
 *
 */
+(void)getMethodWithURL:(NSString *)urlStr success:(HttpSuccess)success;

/*
 *通用网络请求 get方法 (不带加载器)
 *
 */
+(void)getMethodWithoutLoadingForURL:(NSString *)urlStr success:(HttpSuccess)success;

/*
 *通用网络请求 post方法
 *
 */
+(void)postMethodWithURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success;

/*
 *通用网络请求 post方法 (不带加载器)
 *
 */
+(void)postMethodWithoutLoadingForURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success;


-(void)requstMethod:(NSString *)method url:(NSString *)urlStr body:(NSString *)body isLoading:(BOOL)isLoading success:(HttpSuccess)success failure:(HttpFailure)failure;


+(NSString *)getValueWithParams:(id)params;

/*
 *退出登录
 */
+(void)signOut;


@end
