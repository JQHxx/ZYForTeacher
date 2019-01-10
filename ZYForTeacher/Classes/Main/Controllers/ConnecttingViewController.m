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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"连线学生"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"连线学生"];
}

#pragma mark -- Event Response
#pragma mark 取消连线
-(void)cancelConnecttingAction{
    [self.animationImageView stopAnimating];
    self.animationImageView.image = IS_IPAD?[UIImage imageNamed:@"ipad_effect1"]:[UIImage imageNamed:@"effect1"];
    [self connectStudentForStaticsWithIndex:3];
    [self.view makeToast:@"你取消了与对方的语音通话请求" duration:1.0 position:CSToastPositionCenter];
    [self hangUp];
}

#pragma mark -- Private Methods
#pragma mark 初始化
- (void)initConnecttingView{
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.rootView];
    
    UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake((kScreenWidth-184.0)/2.0, 153, 184, 184):CGRectMake((kScreenWidth-130)/2.0, 95, 130, 130)];
    bgHeadImageView.image = IS_IPAD?[UIImage imageNamed:@"head_portrait_ipad"]:[UIImage imageNamed:@"connection_head_image_white"];
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
        _rootView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(0, 245, kScreenWidth, kScreenHeight-245):CGRectMake(0, 160.0, kScreenWidth, kScreenHeight-160.0)];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView drawBorderRadisuWithType:BoderRadiusTypeTop boderRadius:8.0];
    }
    return _rootView;
}

#pragma mark 头像
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake((kScreenWidth-158.0)/2.0,163, 158, 158):CGRectMake((kScreenWidth - 110)/2.0,105, 110, 110)];
        _headImageView.boderRadius =IS_IPAD?79.0:55.0;
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
        _nameLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, self.headImageView.bottom+24, kScreenWidth-80, 40):CGRectMake(40, self.headImageView.bottom+21, kScreenWidth-80, 25)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?28:18];
        _nameLabel.text = self.homework.username;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }
    return _nameLabel;
}

#pragma mark 年级/科目
-(UILabel *)gradeLabel{
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.nameLabel.bottom, kScreenWidth-80, 25)];
        _gradeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        _gradeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _gradeLabel.textAlignment = NSTextAlignmentCenter;
        _gradeLabel.text = self.homework.grade;
    }
    return _gradeLabel;
}

#pragma mark 呼叫动画
-(UIImageView *)animationImageView{
    if (!_animationImageView) {
        CGRect viewRect;
        if (IS_IPAD) {
            viewRect = CGRectMake((kScreenWidth-310.0)/2, self.gradeLabel.bottom+70, 310,310);
        }else{
            if (isXDevice) {
                viewRect = CGRectMake((kScreenWidth-180.0)/2, self.gradeLabel.bottom+60, 180,180);
            }else{
                viewRect = kScreenWidth<375.0?CGRectMake((kScreenWidth-120.0)/2, self.gradeLabel.bottom+20, 120,120):CGRectMake((kScreenWidth-180.0)/2, self.gradeLabel.bottom+40, 180,180);
            }
        }
        
        _animationImageView = [[UIImageView alloc] initWithFrame:viewRect];
        NSMutableArray *imgesArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<3; i++) {
            UIImage *image = IS_IPAD?[UIImage imageNamed:[NSString stringWithFormat:@"ipad_effect%ld",i+1]]:[UIImage imageNamed:[NSString stringWithFormat:@"effect%ld",i+1]];
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
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,kScreenHeight-85,515, 75):CGRectMake(48,kScreenHeight-75,kScreenWidth-96, 60);
        _cancelBtn = [[UIButton alloc] initWithFrame:btnFrame];
        [_cancelBtn setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消连线" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        [_cancelBtn addTarget:self action:@selector(cancelConnecttingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
