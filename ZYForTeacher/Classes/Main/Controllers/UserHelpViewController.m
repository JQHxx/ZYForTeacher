//
//  UserHelpViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/26.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "UserHelpViewController.h"

@interface UserHelpViewController ()

@property (nonatomic,strong)UIScrollView *rootScrollView;

@end

@implementation UserHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"新手指引";
    
    [self.view addSubview:self.rootScrollView];
}

#pragma mark 根视图
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight+6, kScreenWidth, kScreenHeight-kNavHeight-6)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*(6962.0/1242.0))];
        imageView.image = [UIImage imageNamed:@"UserGuide"];
        [_rootScrollView addSubview:imageView];
        _rootScrollView.contentSize =CGSizeMake(kScreenWidth, kScreenWidth*(6962.0/1242.0));
    }
    return _rootScrollView;
}

@end
