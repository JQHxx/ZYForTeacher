//
//  FeedbackViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"
#import "LoginButton.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) LoginButton   *submitButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"意见反馈";
    
    [self.view addSubview:self.myTextView];
    [self.view addSubview:self.submitButton];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView==self.myTextView) {
        if ([textView.text length]+text.length>200) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

#pragma mark -- Event Response
#pragma mark  提交
-(void)submitFeedbackAction:(UIButton *)sender{
    if (kIsEmptyString(self.myTextView.text)) {
        [self.view makeToast:@"您的意见内容不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&content=%@",kUserTokenValue,_myTextView.text];
    [TCHttpRequest postMethodWithURL:kFeedbackAPI body:body success:^(id json) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakSelf.backBlock(nil);
        });
    }];
}

#pragma mark -- Getters
#pragma mark 文字输入
-(UITextView *)myTextView{
    if (!_myTextView) {
        _myTextView = [[UITextView alloc] initWithFrame:IS_IPAD?CGRectMake(20,kNavHeight+20, kScreenWidth-40, 390):CGRectMake(10,kNavHeight+10, kScreenWidth-20, 200)];
        _myTextView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _myTextView.delegate = self;
        _myTextView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        _myTextView.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_myTextView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:4.0];
        _myTextView.zw_placeHolder = @"请简要描述您的问题和意见";
        _myTextView.zw_limitCount = 200;
    }
    return _myTextView;
}

#pragma mark 提交
-(LoginButton *)submitButton{
    if (!_submitButton) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,self.myTextView.bottom+30,515, 75):CGRectMake(48,self.myTextView.bottom+30,kScreenWidth-96, 60);
        _submitButton = [[LoginButton alloc] initWithFrame:btnFrame title:@"提交"];
        [_submitButton addTarget:self action:@selector(submitFeedbackAction:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.timeInterval = 2.0;
    }
    return _submitButton;
}

@end
