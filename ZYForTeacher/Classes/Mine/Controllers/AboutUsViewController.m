//
//  AboutUsViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel  *introLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"关于我们";
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.introLabel];
}

#pragma mark 公司logo
-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, kNavHeight+20, kScreenWidth-40, 240)];
        _logoImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _logoImageView;
}

#pragma mark 公司介绍
-(UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introLabel.numberOfLines = 0 ;
        _introLabel.font = kFontWithSize(14);
        _introLabel.textColor = [UIColor blackColor];
        _introLabel.text = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它。如果你无法简洁的表达你的想法，那只说明你还不够了解它。如果你无法简洁的表达你的想法，那只说明你还不够了解它。如果你无法简洁的表达你的想法，那只说明你还不够了解它。如果你无法简洁的表达你的想法，那只说明你还不够了解它。";
        CGFloat height = [_introLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:_introLabel.font].height;
        _introLabel.frame = CGRectMake(20, self.logoImageView.bottom+20, kScreenWidth-40, height+10);
    }
    return _introLabel;
}

@end
