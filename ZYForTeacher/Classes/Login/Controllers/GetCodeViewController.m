//
//  GetCodeViewController.m
//  ZuoYe
//
//  Created by vision on 2018/9/10.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "GetCodeViewController.h"
#import "LoginTextView.h"
#import "SetPasswordViewController.h"
#import "LoginButton.h"

@interface GetCodeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) LoginTextView      *phoneTextView;              //手机号
@property (nonatomic, strong) UIButton           *getCodeButton;              //获取验证码
@property (nonatomic, strong) LoginTextView      *securityCodeTextView;       //验证码
@property (nonatomic, strong) LoginButton        *nextStepButton;             //下一步

@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenShaw = YES;
    
    [self initGetCodeView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"忘记密码"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"忘记密码"];
}

#pragma mark -- Event response
#pragma mark 下一步
-(void)getCodeForNextStepAction{
    if (kIsEmptyString(self.phoneTextView.myText.text)) {
        [self.view makeToast:@"手机号不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    BOOL isPhoneNumber = [self.phoneTextView.myText.text isPhoneNumber];
    if (!isPhoneNumber) {
        [self.view makeToast:@"您输入的手机号码有误,请重新输入" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.securityCodeTextView.myText.text)) {
        [self.view makeToast:@"验证码不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *phoneStr = self.phoneTextView.myText.text;
    NSString *codeStr = self.securityCodeTextView.myText.text;
   
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"mobile=%@&code=%@",phoneStr,codeStr];
    [TCHttpRequest postMethodWithURL:kCheckCodeAPI body:body success:^(id json) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SetPasswordViewController *setpwdVC = [[SetPasswordViewController alloc] init];
            setpwdVC.phone = phoneStr;
            setpwdVC.code = codeStr;
            [weakSelf.navigationController pushViewController:setpwdVC animated:YES];
        });
    }];
}

#pragma mark 获取验证码
-(void)getSecurityCodeAction:(UIButton *)sender{
    if (kIsEmptyString(self.phoneTextView.myText.text)) {
        [self.view makeToast:@"手机号不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    BOOL isPhoneNumber = [self.phoneTextView.myText.text isPhoneNumber];
    if (!isPhoneNumber) {
        [self.view makeToast:@"您输入的手机号码有误,请重新输入" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"mobile=%@&cate=findPwd",self.phoneTextView.myText.text];
    [TCHttpRequest postMethodWithURL:kGetCodeSign body:body success:^(id json) {
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [self.getCodeButton setTitleColor:[UIColor colorWithHexString:@"#FF7568"] forState:UIControlStateNormal];
                    self.getCodeButton.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 61;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    self.getCodeButton.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.phoneTextView.myText resignFirstResponder];
            [weakSelf.securityCodeTextView.myText becomeFirstResponder];
            [weakSelf.view makeToast:[json objectForKey:@"msg"] duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 是否已阅读
-(void)chooseForDidReadUserAgreement:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark -- delegate
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneTextView.myText resignFirstResponder];
    [self.securityCodeTextView.myText resignFirstResponder];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if (self.phoneTextView.myText==textField) {
        if ([textField.text length]<11) {
            return YES;
        }
    }
    if (self.securityCodeTextView.myText==textField) {
        if ([textField.text length]<6) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -- Pravite Methods
#pragma mark 初始化界面
-(void)initGetCodeView{
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.securityCodeTextView];
    [self.view addSubview:self.getCodeButton];
    
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.securityCodeTextView.right,self.securityCodeTextView.bottom,kScreenWidth-25.0-self.securityCodeTextView.right, 0.5)];
    lineLbl.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.view addSubview:lineLbl];
    
    [self.view addSubview:self.nextStepButton];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(78, kNavHeight+24, 200, 42):CGRectMake(44, kNavHeight+15, 120, 28)];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?30:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _titleLabel.text = @"忘记密码";
    }
    return _titleLabel;
}

#pragma mark 手机号
-(LoginTextView *)phoneTextView{
    if (!_phoneTextView) {
        _phoneTextView = [[LoginTextView alloc] initWithFrame:IS_IPAD?CGRectMake(50, self.titleLabel.bottom+25, kScreenWidth-100, 85):CGRectMake(26.0,self.titleLabel.bottom+30.0, kScreenWidth-51.0, 52) placeholder:@"请输入手机号码" icon:@"register_phone" isNumber:YES];
        _phoneTextView.myText.delegate = self;
    }
    return _phoneTextView;
}

#pragma mark 验证码
-(LoginTextView *)securityCodeTextView{
    if (!_securityCodeTextView) {
        _securityCodeTextView = [[LoginTextView alloc] initWithFrame:IS_IPAD?CGRectMake(50, self.phoneTextView.bottom, kScreenWidth-100, 85):CGRectMake(26.0, self.phoneTextView.bottom+10,kScreenWidth-155, 52.0) placeholder:@"请输入验证码" icon:@"register_message" isNumber:NO];
        _securityCodeTextView.myText.delegate = self;
    }
    return _securityCodeTextView;
}

#pragma mark 获取验证码
-(UIButton *)getCodeButton{
    if (!_getCodeButton) {
        _getCodeButton = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-190,self.phoneTextView.bottom+17, 140, 50):CGRectMake(kScreenWidth-120.0, self.phoneTextView.bottom+20,100.0, 33)];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeButton.layer.cornerRadius = 4;
        _getCodeButton.layer.borderColor = [UIColor colorWithHexString:@"#FF7568"].CGColor;
        _getCodeButton.layer.borderWidth = 1.0;
        CGFloat fontSize = kScreenWidth<375.0?14:16;
        _getCodeButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:fontSize];
        [_getCodeButton setTitleColor:[UIColor colorWithHexString:@"#FF7568"] forState:UIControlStateNormal];
        [_getCodeButton addTarget:self action:@selector(getSecurityCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getCodeButton;
}

#pragma mark 注册
-(LoginButton *)nextStepButton{
    if (!_nextStepButton) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0, self.securityCodeTextView.bottom+60.0,515, 75):CGRectMake(48,  self.securityCodeTextView.bottom+37.0,kScreenWidth-96, 60);
        _nextStepButton = [[LoginButton alloc] initWithFrame:btnFrame title:@"下一步"];
        [_nextStepButton addTarget:self action:@selector(getCodeForNextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}

@end
