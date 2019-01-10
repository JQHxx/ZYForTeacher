//
//  GuidanceViewController.m
//  Tianjiyun
//
//  Created by vision on 16/9/20.
//  Copyright © 2016年 vision. All rights reserved.
//

#import "GuidanceViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

@interface GuidanceViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
}
@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initGuidanceView];
}
#pragma mark --Private methods
#pragma mark 初始化引导页
-(void)initGuidanceView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 5,kScreenHeight);
    
    for (int i = 0; i < 5; i++) {
        UIImage *image;
        if (IS_IPAD) {
            image= [UIImage imageNamed:[NSString stringWithFormat:@"ipad_guide0%d", i+1]];
        }else{
            image = IS_IPHONE_Xr?[UIImage imageNamed:[NSString stringWithFormat:@"xr_guide0%ld",i+1]]:[UIImage imageNamed:[NSString stringWithFormat:@"iosguide0%d", i+1]];
        }
        UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0,kScreenWidth, kScreenHeight)];
        [contentView setImage:image];
        [_scrollView addSubview:contentView];
        
        if (i == 4) {
            UIImage *image = IS_IPAD?[UIImage drawImageWithName:@"ipad_start" size:CGSizeMake(240, 60)]:[UIImage imageNamed:@"start"];
            CGRect btnFrame;
            if (IS_IPAD) {
                btnFrame = CGRectMake(kScreenWidth*4+(kScreenWidth-240)/2, kScreenHeight-90, 240, 55);
            }else{
                btnFrame = kScreenWidth<375.0?CGRectMake(kScreenWidth*4+(kScreenWidth-180)/2, kScreenHeight-60, 180, 40):CGRectMake(kScreenWidth*4+(kScreenWidth-180)/2, kScreenHeight-70, 180, 40);
            }
            UIButton *button = [[UIButton alloc] initWithFrame:btnFrame];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startUse:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
        }
    }
}
#pragma mark --Response Methods
#pragma mark 进入app
- (void)startUse:(id)sender{
    
    [NSUserDefaultsInfos putKey:kShowGuidance andValue:[NSNumber numberWithBool:YES]];
    
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:loginVC];
    AppDelegate *appDelegate=kAppDelegate;
    appDelegate.window.rootViewController=nav;
    
}
#pragma mark 切换图片
- (void)pageChanged:(UIPageControl *)pageControl{
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * pageControl.currentPage, 0, _scrollView.width, _scrollView.height) animated:YES];
}

@end
