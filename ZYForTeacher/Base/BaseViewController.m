//
//  BaseViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    UIView        *navView;
    UIButton      *backBtn;
    UILabel       *titleLabel;
    UIButton      *rightBtn;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self customNavBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark -- Event response
#pragma mark 左侧返回方法
-(void)leftNavigationItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏右侧按钮事件
-(void)rightNavigationItemAction{
    
}


#pragma mark --Private Methods
#pragma mark 自定义导航栏
-(void)customNavBar{
    navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    navView.backgroundColor=kSystemColor;
    [self.view addSubview:navView];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
    [backBtn setImage:[UIImage drawImageWithName:@"back"size:CGSizeMake(12, 19)] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
    [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight, 180, 44)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45, KStatusHeight+2, 40, 40)];
    [rightBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
    
}


#pragma mark -- setters and getters
#pragma mark 设置是否隐藏导航栏
-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar{
    _isHiddenNavBar = isHiddenNavBar;
    navView.hidden = isHiddenNavBar;
}

#pragma mark 设置是否隐藏返回按钮
-(void)setIsHiddenBackBtn:(BOOL)isHiddenBackBtn{
    _isHiddenBackBtn = isHiddenBackBtn;
    backBtn.hidden = isHiddenBackBtn;
}

#pragma makr 设置导航栏左侧按钮图片
-(void)setLeftImageName:(NSString *)leftImageName{
    _leftImageName=leftImageName;
    if (_leftImageName) {
        backBtn.hidden=NO;
        [backBtn setImage:[UIImage drawImageWithName:_leftImageName size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsZero];
    }
}
#pragma mark 设置导航栏左侧按钮文字
- (void)setLeftTitleName:(NSString *)leftTitleName{
    _leftTitleName = leftTitleName;
    [backBtn setTitle:leftTitleName forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    backBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

#pragma mark 设置导航栏右侧按钮图片
-(void)setRightImageName:(NSString *)rightImageName{
    _rightImageName=rightImageName;
    [rightBtn setImage:[UIImage drawImageWithName:rightImageName size:CGSizeMake(24, 24)] forState:UIControlStateNormal];
}

#pragma mark 设置导航栏右侧按钮文字
-(void)setRigthTitleName:(NSString *)rigthTitleName{
    _rigthTitleName=rigthTitleName;
    [rightBtn setTitle:rigthTitleName forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (rigthTitleName.length>=4) {
        CGSize size = [rigthTitleName sizeWithLabelWidth:kScreenWidth font:[UIFont systemFontOfSize:16]];
        rightBtn.frame = CGRectMake(kScreenWidth-size.width-5,KStatusHeight +2, size.width, 40);
    }
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    rightBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
}

#pragma mark 设置标题
-(void)setBaseTitle:(NSString *)baseTitle{
    _baseTitle=baseTitle;
    titleLabel.text=baseTitle;
}

-(void)dealloc {
    MyLog(@"dealloc--%@",NSStringFromClass([self class]));
}


@end
