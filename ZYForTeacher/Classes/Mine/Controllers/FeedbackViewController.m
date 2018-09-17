//
//  FeedbackViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>{
    UILabel    *promptLabel;
    UILabel    *countLabel;
}

@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) UIButton   *submitButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"意见反馈";
    
    [self.view addSubview:self.myTextView];
    [self.view addSubview:self.submitButton];
}

#pragma mark--UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSString *tString = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    countLabel.text = tString;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]!= 0) {
        promptLabel.hidden = YES;
    }else{
        promptLabel.hidden = NO;
        NSString *tString = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        countLabel.text = tString;
    }
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
    
}

#pragma mark -- Getters
#pragma mark 文字输入
-(UITextView *)myTextView{
    if (!_myTextView) {
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, kNavHeight+20, kScreenWidth-20, 256)];
        _myTextView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _myTextView.delegate = self;
        _myTextView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        _myTextView.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_myTextView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:4.0];
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 250, 20)];
        promptLabel.text = @"请简要描述您的问题和意见";
        promptLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        promptLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        [_myTextView addSubview:promptLabel];
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 222, 80, 20)];
        countLabel.text = @"0/200";
        countLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        [_myTextView addSubview:countLabel];
    }
    return _myTextView;
}

#pragma mark 提交
-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(48, self.myTextView.bottom+30, kScreenWidth-95.0,(kScreenWidth-95.0)*(128.0/588.0))];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        [_submitButton addTarget:self action:@selector(submitFeedbackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
