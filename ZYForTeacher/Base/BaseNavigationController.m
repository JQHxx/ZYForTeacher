//
//  BaseNavigationController.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景
    UIImage *img=[UIImage imageWithColor:kSystemColor size:CGSizeMake([UIScreen mainScreen].bounds.size.width, kNavHeight)];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.tintColor=[UIColor whiteColor];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    }
}



@end
