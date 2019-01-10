//
//  IntroductionViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "IntroductionViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"

@interface IntroductionViewController ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *introTextView;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"个人介绍";
    
    self.rigthTitleName = @"保存";
    self.isRightBtnEnable = NO;
    
    [self.view addSubview:self.introTextView];
    [self.introTextView becomeFirstResponder];
}

#pragma mark -- Event response
#pragma mark 取消
-(void)leftNavigationItemAction{
    [self.introTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存
-(void)rightNavigationItemAction{
    [self.introTextView resignFirstResponder];
    kSelfWeak;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.getIntroBlock) {
            weakSelf.getIntroBlock(self.introTextView.text);
        }
    }];
}

#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.isRightBtnEnable = textView.text.length>0;
}

#pragma mark -- Getters
-(UITextView *)introTextView{
    if (!_introTextView) {
        _introTextView = [[UITextView alloc] initWithFrame:IS_IPAD?CGRectMake(18,kNavHeight+18, kScreenWidth-36, 460):CGRectMake(10, kNavHeight+10, kScreenWidth-20,kScreenHeight-340-kNavHeight)];
        _introTextView.delegate = self;
        _introTextView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _introTextView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:16];
        _introTextView.zw_placeHolder = @"请简要介绍一下自己，让学生快速了解你";
        _introTextView.zw_limitCount = 500;
        _introTextView.text = kIsEmptyString(self.introStr)?@"":self.introStr;
    }
    return _introTextView;
}



@end
