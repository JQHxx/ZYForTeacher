//
//  AppDelegate.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/24.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "UIDevice+Extend.h"
#import "SSKeychain.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import <AVFoundation/AVFoundation.h>
#import "MyConnecttingViewController.h"
#import "HomeworkModel.h"
#import "YYModel.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainViewController.h"
#import "MineViewController.h"
#import "IQKeyboardManager.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMShare/UMShare.h>
#import <UMPush/UMessage.h>
#import "BaseWebViewController.h"
#import "OrderDetailsViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "GuidanceViewController.h"
#import "NTESAVNotifier.h"
#import "UserModel.h"

@interface AppDelegate ()<NIMNetCallManagerDelegate,UNUserNotificationCenterDelegate,NIMLoginManagerDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setAppSystemConfigWithOptions:launchOptions];
    //申请通知权限
    [self replyPushNotificationAuthorization:application];
    [self loadInitializeData];
    
    [NSUserDefaultsInfos removeObjectForKey:kCallingForID];
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    BOOL hasShowGuidance=[[NSUserDefaultsInfos getValueforKey:kShowGuidance] boolValue];
    if (!hasShowGuidance) {
        GuidanceViewController *guidanceVC=[[GuidanceViewController alloc] init];
        self.window.rootViewController=guidanceVC;
    }else{
        BOOL isLogin=[[NSUserDefaultsInfos getValueforKey:kIsLogin] boolValue];
        NSString *account = [NSUserDefaultsInfos getValueforKey:kUserThirdID];
        NSString *token = [NSUserDefaultsInfos getValueforKey:kUserThirdToken];
        if (isLogin&&!kIsEmptyString(account)&&!kIsEmptyString(token)) {
            NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
            loginData.account = account;
            loginData.token = token;
            [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
            
            [self setMyRootViewController];
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            self.window.rootViewController = nav;
        }
    }
    
    //检查是否从通知启动
    if(launchOptions){
        NSDictionary* remoteNotification=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleRecerceNotificationData:remoteNotification];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    MyLog(@"applicationWillResignActive");
    //app退到后台
    [self loadDataStatisticsWithIndex:2];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    MyLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    MyLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    MyLog(@"applicationDidBecomeActive");
    //app打开
    [self loadDataStatisticsWithIndex:1];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [NSUserDefaultsInfos removeObjectForKey:kCallingForID];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 接收通知
#pragma mark iOS10使用这个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    MyLog(@"didReceiveRemoteNotification ---------------------- 在后台收到通知,userinfo:%@",userInfo);
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    [self handleRecerceNotificationData:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark 获取设备的DeviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    [UMessage registerDeviceToken:deviceToken];
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    MyLog(@"didRegisterForRemoteNotificationsWithDeviceToken,deviceToken:%@",deviceTokenStr);
}


#pragma mark - UNUserNotificationCenterDelegate
#pragma mark iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler{
    //收到推送的内容
    UNNotificationContent *content = notification.request.content;
    //收到用户的基本信息
    NSDictionary * userInfo = content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
         MyLog(@"iOS10 前台收到远程通知:%@",userInfo);
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self handleRecerceNotificationData:userInfo];
        
    }else{
        // 判断为本地通知
        MyLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",content.body,content.title,content.subtitle,content.badge,content.sound,userInfo);
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

#pragma mark iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler{
    //收到推送的内容
    UNNotificationContent *content = response.notification.request.content;
    //收到用户的基本信息
    NSDictionary * userInfo = content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
         MyLog(@"iOS10 点击收到远程通知:%@",userInfo);
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSString *type = [userInfo valueForKey:@"cate"];
        if (!kIsEmptyString(type)) {
            NSNumber *mid = [userInfo valueForKey:@"mid"];
            if (kIsEmptyObject(mid)||[mid integerValue]>0) {
                [self setMessageReadWithMid:mid type:type];
            }
            
            BaseNavigationController *nav = (BaseNavigationController *)self.drawerController.centerViewController;
            if ([type isEqualToString:@"sys"]) {
                BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
                webVC.urlStr = userInfo[@"oid"];
                webVC.webTitle = @"消息详情";
                [nav pushViewController:webVC animated:YES];
            }else if ([type isEqualToString:@"pay"]||[type isEqualToString:@"comment"]||[type isEqualToString:@"complain"]){
                OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc] init];
                orderDetailsVC.orderId = userInfo[@"oid"];
                orderDetailsVC.isNotifyIn = YES;
                [nav pushViewController:orderDetailsVC animated:YES];
            }else if ([type isEqualToString:@"receiveCheck"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kCheckRecieveNotification object:nil userInfo:userInfo];
            }else if ([type isEqualToString:@"receiveGuide"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGuideRecieveNotification object:nil userInfo:userInfo];
            }
        }
    }else{
        // 判断为本地通知
        MyLog(@"iOS10 点击本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",content.body,content.title,content.subtitle,content.badge,content.sound,userInfo);
    }
    completionHandler();
}

#pragma mark 消息设为已读
-(void)setMessageReadWithMid:(NSNumber *)mid type:(NSString *)type{
    NSString *body = [NSString stringWithFormat:@"token=%@&cate=%@&mid=%@",kUserTokenValue,type,mid];
    [TCHttpRequest postMethodWithoutLoadingForURL:kMessageReadAPI body:body success:^(id json) {
        
    }];
}


#pragma mark -- NIMNetCallManagerDelegate
#pragma mark 被叫收到呼叫
-(void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallMediaType)type message:(NSString *)extendMessage{
    NSNumber *callingID =  [NSUserDefaultsInfos getValueforKey:kCallingForID];
    if (!kIsEmptyObject(callingID)||[callingID unsignedLongLongValue]>0) {
        [[NIMAVChatSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
    }else{
        NSDictionary *dic =(NSDictionary*)extendMessage;
        HomeworkModel *model = [HomeworkModel yy_modelWithJSON:dic];
        
        //震动
        [[NTESAVNotifier sharedNTESAVNotifier] startVibrate];
        
        MyLog(@"被叫收到呼叫---caller:%@,type:%zd,extendMessage--%@,",caller,type,dic);
        BaseNavigationController *nav = (BaseNavigationController *)self.drawerController.centerViewController;
        MyConnecttingViewController *connecttingVC = [[MyConnecttingViewController alloc] initWithCaller:caller callId:callID];
        connecttingVC.homework = model;
        [nav pushViewController:connecttingVC animated:NO];
        //当我们push成功之后，关闭我们的抽屉
        [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
}

#pragma mark -- NIMLoginManagerDelegate
#pragma mark 登录网易云回调
-(void)onLogin:(NIMLoginStep)step{
    MyLog(@"登录成功");
}

-(void)onAutoLoginFailed:(NSError *)error{
    MyLog(@"自动登录失败 onAutoLoginFailed %zd,error:%@",error.code,error.localizedDescription);
}

#pragma mark 加载初始数据
-(void)loadInitializeData{
    //获取年级
    NSArray *grades = [ZYHelper sharedZYHelper].grades;
    if (!kIsArray(grades)||grades.count==0) {
        [TCHttpRequest postMethodWithoutLoadingForURL:kGetGradeAPI body:nil success:^(id json) {
            NSArray *data = [json objectForKey:@"data"];
            [ZYHelper sharedZYHelper].grades = data;
        }];
    }
    
    //获取科目
    NSArray *subjects = [ZYHelper sharedZYHelper].subjects;
    if (!kIsArray(subjects)||subjects.count==0) {
        [TCHttpRequest postMethodWithoutLoadingForURL:kGetSubjectAPI body:nil success:^(id json) {
            NSArray *data = [json objectForKey:@"data"];
            [ZYHelper sharedZYHelper].subjects = data;
        }];
    }
    
 
    //上传设备信息
    NSString *retrieveuuid=[SSKeychain passwordForService:kDeviceIDFV account:@"useridfv"];
    NSString *uuid=nil;
    if (kIsEmptyObject(retrieveuuid)) {
        uuid=[UIDevice getIDFV];
        [SSKeychain setPassword:uuid forService:kDeviceIDFV account:@"useridfv"];
    }else{
        uuid=retrieveuuid;
    }

    NSString *body = [NSString stringWithFormat:@"version=%@&channel=appstore&deviceType=%@&deviceId=%@&sysVer=%@&platform=iOS&nation=%@&language=%@&wifi=%@",[UIDevice getSoftwareVer],[UIDevice getSystemName],uuid,[UIDevice getSystemVersion],[UIDevice getCountry],[UIDevice getLanguage],[NSNumber numberWithBool:[UIDevice isWifi]]];
    [TCHttpRequest postMethodWithoutLoadingForURL:kUploadDeviceInfoAPI body:body success:^(id json) {

    }];
}

#pragma mark 数据统计
-(void)loadDataStatisticsWithIndex:(NSInteger)index{
    NSString *token = kUserTokenValue;
    if (!kIsEmptyString(token)) {
        NSNumber *logid = [NSUserDefaultsInfos getValueforKey:kLogID];
        NSString *body = [NSString stringWithFormat:@"token=%@&label=%ld&logid=%@",token,index,logid];
        [TCHttpRequest postMethodWithoutLoadingForURL:kDataStatisticsAPI body:body success:^(id json) {
            
        }];
    }
}

#pragma mark 设置根控制器
-(void)setMyRootViewController{
    MainViewController  *mainVC = [[MainViewController alloc] init];
    BaseNavigationController *centerNav = [[BaseNavigationController alloc] initWithRootViewController:mainVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationController *leftNav = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
    [self.drawerController setShowsShadow:NO];
    self.drawerController.maximumLeftDrawerWidth = IS_IPAD?445:240;
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    self.window.rootViewController = self.drawerController;
}


#pragma mark
- (void)setAppSystemConfigWithOptions:(NSDictionary *)launchOptions{
    //键盘管理
    IQKeyboardManager *keyboardManager= [IQKeyboardManager sharedManager];   // 获取类库的单例变量
    keyboardManager.enable = YES;   // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    //网易云
    NSString *appKey        = kNIMSDKAppKey;
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = kNIMApnsCername;
    option.pkCername        = kNIMApnsCername;
    [[NIMSDK sharedSDK] registerWithOption:option];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    MyLog(@"App Started SDK Version %@\n SDK Info: %@",[[NIMSDK sharedSDK] sdkVersion],[NIMSDKConfig sharedConfig]);
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    
    //友盟
    //统计
    [UMCommonLogManager setUpUMCommonLogManager]; //开启日志系统
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:kUMAppKey channel:@"App Store"]; //初始化
    
    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
    MyLog(@"集成测试的deviceID:%@",deviceID);
    
    //分享
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppKey appSecret:kWechatAppSecret redirectURL:nil];
    //设置分享到QQ互联的appID
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppKey appSecret:nil redirectURL:nil];
    
    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSinaAppKey appSecret:kSinaAppSecret redirectURL:@""];
    
    //推送
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            MyLog(@"友盟推送 --- 用户选择了接收push消息");
        }else{
            MyLog(@"友盟推送 --- 用户选择了拒绝接收push消息");
        }
    }];
}

#pragma mark - 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    if (IOS10_OR_LATER) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                MyLog(@"申请通知权限--注册成功");
            }else{
                //用户点击不允许
                MyLog(@"申请通知权限--注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            MyLog(@"获取推送权限设置 ========%@",settings);
        }];
    }else if (IOS8_OR_LATER){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

#pragma mark 收到推送处理
-(void)handleRecerceNotificationData:(NSDictionary *)userInfo{
    if (kIsDictionary(userInfo)&&userInfo.count>0) {
        NSString *type = [userInfo valueForKey:@"cate"];
        if (!kIsEmptyString(type)) {
            if ([type isEqualToString:@"authId"]||[type isEqualToString:@"authEdu"]||[type isEqualToString:@"authTeach"]||[type isEqualToString:@"authSkill"]) { //认证推送
                
                NSString *token = kUserTokenValue;
                if (!kIsEmptyString(token)) {
                    NSString *body = [NSString stringWithFormat:@"token=%@",token];
                    [TCHttpRequest postMethodWithoutLoadingForURL:kGetUserInfoAPI body:body success:^(id json) {
                        NSDictionary *data = [json objectForKey:@"data"];
                        UserModel *user = [[UserModel alloc] init];
                        [user setValues:data];
                        
                        [NSUserDefaultsInfos putKey:kAuthIdentidy andValue:user.auth_id];   //实名认证
                        [NSUserDefaultsInfos putKey:kAuthEducation andValue:user.auth_edu];  //学历认证
                        [NSUserDefaultsInfos putKey:kAuthTeach andValue:user.auth_teach];   //教师资质
                        [NSUserDefaultsInfos putKey:kAuthSkill andValue:user.auth_skill];    //技能认证
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAuthUpdateNotification object:nil userInfo:userInfo];
                        
                    }];
                }
            }else if ([type isEqualToString:@"guideCancel"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGuideCancelNotification object:nil userInfo:userInfo];
            }else if ([type isEqualToString:@"cancel"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kOrderCancelNotification object:nil userInfo:userInfo];
            }else if ([type isEqualToString:@"receiveCheck"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kCheckRecieveNotification object:nil userInfo:userInfo];
            }else if ([type isEqualToString:@"receiveGuide"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGuideRecieveNotification object:nil userInfo:userInfo];
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

@end
