//
//  TCHttpRequest.m
//  TonzeCloud
//
//  Created by vision on 16/10/9.
//  Copyright © 2016年 tonze. All rights reserved.
//

#import "TCHttpRequest.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "BaseNavigationController.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <UMPush/UMessage.h>
#import <NIMSDK/NIMSDK.h>

@interface TCHttpRequest ()<UIAlertViewDelegate,NSURLSessionDelegate>

@end
@implementation TCHttpRequest

singleton_implementation(TCHttpRequest)
#pragma mark - 基本网络请求（GET POST）
-(BOOL)isConnectedToNet{
    BOOL isYes = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isYes = NO;
            break;
        case ReachableViaWiFi:
            isYes = YES;
            break;
        case ReachableViaWWAN:
            isYes = YES;
            
        default:
            break;
    }
    return isYes;
}

#pragma mark 网络请求封装 post
+(void)postMethodWithURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success{
    NSString *urlString=[NSString stringWithFormat:kHostTempURL,urlStr];
    [[TCHttpRequest sharedTCHttpRequest] requstMethod:@"POST" url:urlString body:bodyStr isLoading:YES success:^(id json) {
        success(json);
    } failure:^(NSString *errorStr) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [kKeyWindow makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 网络请求封装 post（不带加载器）
+(void)postMethodWithoutLoadingForURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success{
    NSString *urlString=[NSString stringWithFormat:kHostTempURL,urlStr];
    [[TCHttpRequest sharedTCHttpRequest] requstMethod:@"POST" url:urlString body:bodyStr isLoading:NO success:^(id json) {
        success(json);
    } failure:^(NSString *errorStr) {
        MyLog(@"urlStr：%@， error:%@",urlStr,errorStr);
    }];
}


#pragma mark 网络请求封装 get
+ (void)getMethodWithURL:(NSString *)urlStr success:(HttpSuccess)success{
    NSString *urlString=[NSString stringWithFormat:kHostTempURL,urlStr];
    [[TCHttpRequest sharedTCHttpRequest] requstMethod:@"GET" url:urlString body:nil isLoading:YES success:^(id json) {
        success(json);
    } failure:^(NSString *errorStr) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [kKeyWindow makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 网络请求封装 get （不带加载器）
+ (void)getMethodWithoutLoadingForURL:(NSString *)urlStr success:(HttpSuccess)success{
    NSString *urlString=[NSString stringWithFormat:kHostTempURL,urlStr];
    [[TCHttpRequest sharedTCHttpRequest] requstMethod:@"GET" url:urlString body:nil isLoading:NO success:^(id json) {
        success(json);
    } failure:^(NSString *errorStr) {
        MyLog(@"urlStr：%@， error:%@",urlStr,errorStr);
    }];
}

#pragma mark --其他数据转json数据
+(NSString *)getValueWithParams:(id)params{
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    NSString *value=[writer stringWithObject:params];
    MyLog(@"value:%@",value);
    return value;
}

#pragma mark - NSURLSessionDelegate
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark -- Private Methods
#pragma mark 具体请求方法
-(void)requstMethod:(NSString *)method url:(NSString *)urlStr body:(NSString *)body isLoading:(BOOL)isLoading success:(HttpSuccess)success failure:(HttpFailure)failure{
    if (isLoading) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [SVProgressHUD show];
            });
        });
    }
   
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [request setHTTPMethod:method];
    
    if ([method isEqualToString:@"POST"]) {
        NSData *bodyData=[body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
        MyLog(@"url:%@,bodyStr:%@",urlStr,body);
    }else{
        MyLog(@"url:%@",urlStr);
    }
    
    NSURLSessionDataTask * task = [mySession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (isLoading) {
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
              });
         }
        if (data != nil) {
            MyLog(@"html:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            MyLog(@"url:%@, json:%@",urlStr,json);
            if ([[json objectForKey:@"error"] isKindOfClass:[NSNumber class]]) {
                NSInteger status=[[json objectForKey:@"error"] integerValue];
                NSString *message=[json objectForKey:@"msg"];
                if (status==0) {
                    success(json);
                }else if (status==2||[message isEqualToString:@"用户非法"]){
                    [TCHttpRequest signOut];
                }else{
                    message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                    failure(message);
                }
            }else{
                NSString *message = @"暂时无法访问，请稍后再试";
                failure(message);
            }
        } else if (data == nil && error == nil) {
            MyLog(@"接收到空数据");
        }  else {
            MyLog(@"请求失败－－－－code:%ld,error:%@", (long)error.code,error.localizedDescription);
            if (error.code==-1001) {
                failure(@"请求超时");
            }else{
                failure(error.localizedDescription);
            }
        }
    }];
    [task resume];
}


#pragma mark 请求参数按字母排序
-(NSString *)getSortedStrWithParamsString:(NSString *)paramsStr method:(NSString *)method{
    NSArray *subArray = [paramsStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
    for (int i = 0 ; i < subArray.count; i++){
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[i] componentsSeparatedByString:@"="];
        //给字典加入元素
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }
    MyLog(@"打印参数列表生成的字典：%@", tempDic);
    
    NSArray *keys = [tempDic allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    NSMutableString *contentString  =[NSMutableString string];
    for (NSString *categoryId in sortedArray) {
        [contentString appendFormat:@"%@=%@&", categoryId, [tempDic valueForKey:categoryId]];
    }
    
    return contentString;
}

+(void)signOut{
    NSString *tempStr=isTrueEnvironment?@"zs":@"cs";
    NSString *aliasStr=[NSString stringWithFormat:@"%@%@",tempStr,kUserIDValue];
    [UMessage removeAlias:aliasStr type:kUMAlaisType response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            MyLog(@"移除别名失败，error:%@",error.localizedDescription);
        }else{
            MyLog(@"移除别名成功");
        }
    }];
    
    [NSUserDefaultsInfos removeObjectForKey:kIsLogin];
    [NSUserDefaultsInfos removeObjectForKey:kUserID];
    [NSUserDefaultsInfos removeObjectForKey:kUserToken];
    
    [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
        if (error) {
            MyLog(@"退出网易云失败，error:%@",error.localizedDescription);
        }else{
            MyLog(@"网易云退出登录");
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        AppDelegate *appdelegate = kAppDelegate;
        appdelegate.window.rootViewController = nav;
    });
}

@end
