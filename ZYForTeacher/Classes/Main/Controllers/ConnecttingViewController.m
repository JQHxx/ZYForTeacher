//
//  ConnecttingViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ConnecttingViewController.h"
#import "TutorialViewController.h"

@interface ConnecttingViewController ()

@property (nonatomic ,strong) UIImageView   *headImageView;     //头像
@property (nonatomic ,strong) UILabel       *nameLabel;         //姓名
@property (nonatomic ,strong) UILabel       *gradeLabel;        //年级

@property (nonatomic ,strong) UIImageView   *animationImageView;  //呼叫动画
@property (nonatomic ,strong) UIButton      *cancelBtn;   //取消连线

@end

@implementation ConnecttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"连线老师";
    
    [self initConnecttingView];
}

#pragma mark -- Event Response
#pragma mark 取消连线
-(void)cancelConnecttingAction{
    TutorialViewController *tutoringVC = [[TutorialViewController alloc] init];
    [self.navigationController pushViewController:tutoringVC animated:YES];
}

#pragma mark -- Private Methods
#pragma mark 初始化
- (void)initConnecttingView{
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.gradeLabel];
    [self.view addSubview:self.animationImageView];
    [self.view addSubview:self.cancelBtn];
}

#pragma mark -- gettters and setters
#pragma mark 头像
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/2.0, kNavHeight +20, 80, 80)];
        _headImageView.image = [UIImage imageNamed:@"ic_m_head"];
    }
    return _headImageView;
}

#pragma mark 姓名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.headImageView.bottom+10, kScreenWidth-80, 30)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = kFontWithSize(16);
        _nameLabel.text = @"小明";
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

#pragma mark 年级/科目
-(UILabel *)gradeLabel{
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.nameLabel.bottom, kScreenWidth-80, 30)];
        _gradeLabel.font = kFontWithSize(14);
        _gradeLabel.textColor = [UIColor darkGrayColor];
        _gradeLabel.textAlignment = NSTextAlignmentCenter;
        _gradeLabel.text = @"一年级/数学";
    }
    return _gradeLabel;
}

#pragma mark 呼叫动画
-(UIImageView *)animationImageView{
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, self.gradeLabel.bottom+50, 150, 150)];
        _animationImageView.backgroundColor = [UIColor blueColor];
    }
    return _animationImageView;
}

#pragma mark 取消连线
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth -80)/2, self.animationImageView.bottom+30, 80, 80)];
        [_cancelBtn setTitle:@"取消连线" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _cancelBtn.layer.borderWidth = 1.0;
        _cancelBtn.layer.cornerRadius = 40;
        _cancelBtn.titleLabel.font = kFontWithSize(14);
        [_cancelBtn addTarget:self action:@selector(cancelConnecttingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
