//
//  AboutUsViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UILabel+Extend.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel     *versionLabel;    //版本号
@property (nonatomic, strong) UILabel  *introLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"关于我们";
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.introLabel];
}

#pragma mark 公司logo
-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2.0, kNavHeight+20,120, 120)];
        _logoImageView.image = [UIImage imageNamed:@"logo180"];
    }
    return _logoImageView;
}

#pragma mark 版本号
-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,self.logoImageView.bottom+10, kScreenWidth-60, 30)];
        _versionLabel.text = [NSString stringWithFormat:@"版本号：V%@",APP_VERSION];
        _versionLabel.textAlignment =NSTextAlignmentCenter;
        _versionLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        _versionLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }
    return _versionLabel;
}

#pragma mark 公司介绍
-(UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introLabel.numberOfLines = 0 ;
        _introLabel.font = kFontWithSize(14);
        _introLabel.textColor = [UIColor blackColor];
        _introLabel.text = @"\t作业101是一款帮助中小学生进行作业检查和作业辅导的APP应用，分为教师端和学生端。\n\t学生使用学生端发布辅导需求，或者查找对应的老师进行连线请求。老师在教师端找到学生发布的需求，然后连线学生，对学生进行辅导，或者检查学生发布的作业。\n\t辅导形式采用实时音频通话及在线教学白板方式，辅导全程在手机上操作，老师可以利用空闲时间随时接单和教学。辅导完成后，学生支付老师辅导费用。";
        CGFloat height = [_introLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:_introLabel.font].height;
        _introLabel.frame = CGRectMake(20, self.versionLabel.bottom+10, kScreenWidth-40, height+10);
        [UILabel changeSpaceForLabel:_introLabel withLineSpace:3 WordSpace:1];
    }
    return _introLabel;
}

@end
