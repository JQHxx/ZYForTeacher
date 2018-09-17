//
//  AppDelegate+Extension.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/7.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AppDelegate+Extension.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainViewController.h"
#import "MineViewController.h"
#import "BaseNavigationController.h"
#import "IQKeyboardManager.h"

@implementation AppDelegate (Extension)

-(void)setMyRootViewController{
    MainViewController  *mainVC = [[MainViewController alloc] init];
    BaseNavigationController *centerNav = [[BaseNavigationController alloc] initWithRootViewController:mainVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationController *leftNav = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
    [self.drawerController setShowsShadow:NO];
    self.drawerController.maximumLeftDrawerWidth = kScreenWidth-100;
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    self.window.rootViewController = self.drawerController;
}


#pragma mark
- (void)setAppSystemConfig{
    IQKeyboardManager *keyboardManager= [IQKeyboardManager sharedManager];   // 获取类库的单例变量
    keyboardManager.enable = YES;   // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
}

@end
