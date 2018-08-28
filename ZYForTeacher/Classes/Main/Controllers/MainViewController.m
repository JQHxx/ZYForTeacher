//
//  MainViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MainViewController.h"
#import "MineViewController.h"
#import "MessagesViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenBackBtn = YES;
    
    self.baseTitle = @"首页";
    self.rightImageName = @"ic_msg_tips";
    self.leftImageName = @"ic_m_head";
    
}

#pragma mark -- Event Response
#pragma mark 导航栏左侧按钮
-(void)leftNavigationItemAction{
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

#pragma mark 导航栏右侧按钮
-(void)rightNavigationItemAction{
    MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
    [self.navigationController pushViewController:messagesVC animated:YES];
}

@end
