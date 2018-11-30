//
//  ConnecttingViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ConnecttingViewController.h"


@interface ConnecttingViewController ()

@property (nonatomic ,strong) UIImageView   *bgImageView;     //背景
@property (nonatomic ,strong) UIView        *navBarView;     //导航栏
@property (nonatomic ,strong) UIView        *rootView;
@property (nonatomic ,strong) UIImageView   *headImageView;     //头像
@property (nonatomic ,strong) UILabel       *nameLabel;         //姓名
@property (nonatomic ,strong) UILabel       *gradeLabel;        //年级

@property (nonatomic ,strong) UIImageView   *animationImageView;  //呼叫动画
@property (nonatomic ,strong) UIButton      *cancelBtn;   //取消连线


@end


@implementation ConnecttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self initConnecttingView];
    [self.animationImageView startAnimating];
}


#pragma mark -- Event Response
#pragma mark 取消连线
-(void)cancelConnecttingAction{
    [self.animationImageView stopAnimating];
    self.animationImageView.image = [UIImage imageNamed:@"effect1"];
    [self.view makeToast:@"你取消了与对方的语音通话请求" duration:1.0 position:CSToastPositionCenter];
    [self hangUp];
}

#pragma mark -- Private Methods
#pragma mark 初始化
- (void)initConnecttingView{
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.rootView];
    
    UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2.0, 100, 120, 120)];
    bgHeadImageView.image = [UIImage imageNamed:@"connection_head_image_white"];
    [self.view addSubview:bgHeadImageView];
    [self.view addSubview:self.headImageView];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.gradeLabel];
    [self.view addSubview:self.animationImageView];
    [self.view addSubview:self.cancelBtn];
}

#pragma mark -- gettters and setters
#pragma mark 头部背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:@"background1"];
    }
    return _bgImageView;
}

#pragma mark 导航栏
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        
//        UIButton *leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
//        [leftBtn setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
//        [leftBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
//        [_navBarView addSubview:leftBtn];
        
        UILabel  *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight, 180, 44)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"连线学生";
        [_navBarView addSubview:titleLabel];
    }
    return _navBarView;
}

#pragma mark
-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 160.0, kScreenWidth, kScreenHeight-160.0)];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView drawBorderRadisuWithType:BoderRadiusTypeTop boderRadius:8.0];
    }
    return _rootView;
}

#pragma mark 头像
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 110)/2.0,105, 110, 110)];
        _headImageView.boderRadius = 55.0;
        if (kIsEmptyString(self.homework.trait)) {
            _headImageView.image = [UIImage imageNamed:@"default_head_image"];
        }else{
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.homework.trait] placeholderImage:[UIImage imageNamed:@""]];
        }
    }
    return _headImageView;
}

#pragma mark 姓名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.headImageView.bottom+21, kScreenWidth-80, 25)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        _nameLabel.text = self.homework.username;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }
    return _nameLabel;
}

#pragma mark 年级/科目
-(UILabel *)gradeLabel{
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.nameLabel.bottom, kScreenWidth-80, 25)];
        _gradeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        _gradeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _gradeLabel.textAlignment = NSTextAlignmentCenter;
        _gradeLabel.text = self.homework.grade;
    }
    return _gradeLabel;
}

#pragma mark 呼叫动画
-(UIImageView *)animationImageView{
    if (!_animationImageView) {
        CGRect viewRect = kScreenWidth<375.0?CGRectMake((kScreenWidth-120.0)/2, self.gradeLabel.bottom+40, 120,120):CGRectMake((kScreenWidth-180.0)/2, self.gradeLabel.bottom+40, 180,180);
        _animationImageView = [[UIImageView alloc] initWithFrame:viewRect];
        NSMutableArray *imgesArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"effect%ld",i+1]];
            [imgesArr addObject:image];
        }
        _animationImageView.animationImages = imgesArr;
        _animationImageView.animationDuration =2.0;
        _animationImageView.animationRepeatCount = 0;
    }
    return _animationImageView;
}

#pragma mark 取消连线
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-280)/2.0,kScreenHeight-80,280,60)];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消连线" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        [_cancelBtn addTarget:self action:@selector(cancelConnecttingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
