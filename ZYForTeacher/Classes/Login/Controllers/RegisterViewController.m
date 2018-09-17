//
//  RegisterViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "RegisterViewController.h"
#import "IdentitySettingViewController.h"

#import "LoginTextView.h"
#import "LoginButton.h"
#import "UserAgreementView.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) LoginTextView      *phoneTextView;              //手机号
@property (nonatomic, strong) UIButton           *getCodeButton;              //获取验证码
@property (nonatomic, strong) LoginTextView      *securityCodeTextView;       //验证码
@property (nonatomic, strong) LoginTextView      *passwordTextView;           //密码
@property (nonatomic, strong) LoginTextView      *confirmPwdTextView;         //确认密码
@property (nonatomic, strong) LoginButton        *registerButton;             //注册



@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenShaw = YES;
    
    [self initRegisterView];
}

#pragma mark -- Event response
#pragma mark 注册
-(void)registerAction{
    /*
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
    
    if (self.passwordTextView.myText.text.length<6||self.confirmPwdTextView.myText.text.length<6) {
        [self.view makeToast:@"密码不能少于6位" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (![self.passwordTextView.myText.text isEqualToString:self.confirmPwdTextView.myText.text]) {
        [self.view makeToast:@"两次输入的密码不相同" duration:1.0 position:CSToastPositionCenter];
        return;
    }
     */
    
    IdentitySettingViewController *setUserInfoVC = [[IdentitySettingViewController alloc] init];
    [self.navigationController pushViewController:setUserInfoVC animated:YES];
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
    
    [self.view makeToast:@"验证码已发送" duration:1.0 position:CSToastPositionCenter];
}

#pragma mark 密码是否可见
-(void)setPasswordVisibleAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.tag==0) {
        self.passwordTextView.myText.secureTextEntry=!sender.selected;
    }else{
        self.confirmPwdTextView.myText.secureTextEntry=!sender.selected;
    }
}

#pragma mark -- delegate
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneTextView.myText resignFirstResponder];
    [self.securityCodeTextView.myText resignFirstResponder];
    [self.passwordTextView.myText resignFirstResponder];
    [self.confirmPwdTextView.myText resignFirstResponder];
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
    
    if (self.passwordTextView.myText == textField || self.confirmPwdTextView.myText == textField) {
        if ([textField.text length]<14) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -- Pravite Methods
#pragma mark 初始化界面
-(void)initRegisterView{
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.securityCodeTextView];
    [self.view addSubview:self.getCodeButton];
    
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.securityCodeTextView.right,self.securityCodeTextView.bottom,kScreenWidth-25.0-self.securityCodeTextView.right, 0.5)];
    lineLbl.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.view addSubview:lineLbl];
    
    [self.view addSubview:self.passwordTextView];
    [self.view addSubview:self.confirmPwdTextView];
    
    for (NSInteger i=0; i<2; i++) {
        UIButton *visibleButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-52,self.passwordTextView.top+16+i*62, 27, 16)];
        [visibleButton setImage:[UIImage imageNamed:@"register_password_hide"] forState:UIControlStateNormal];
        [visibleButton setImage:[UIImage imageNamed:@"register_password_show"] forState:UIControlStateSelected];
        visibleButton.tag = i;
        [visibleButton addTarget:self action:@selector(setPasswordVisibleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:visibleButton];
    }
    
    
    [self.view addSubview:self.registerButton];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, kNavHeight+15, 120, 28)];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _titleLabel.text = @"手机号注册";
    }
    return _titleLabel;
}

#pragma mark 手机号
-(LoginTextView *)phoneTextView{
    if (!_phoneTextView) {
        _phoneTextView = [[LoginTextView alloc] initWithFrame:CGRectMake(26.0,self.titleLabel.bottom+30.0, kScreenWidth-51.0, 52) placeholder:@"请输入手机号码" icon:@"register_phone" isNumber:YES];
        _phoneTextView.myText.delegate = self;
    }
    return _phoneTextView;
}

#pragma mark 验证码
-(LoginTextView *)securityCodeTextView{
    if (!_securityCodeTextView) {
        _securityCodeTextView = [[LoginTextView alloc] initWithFrame:CGRectMake(26.0, self.phoneTextView.bottom+10,kScreenWidth-175, 52.0) placeholder:@"请输入验证码" icon:@"register_message" isNumber:YES];
        _securityCodeTextView.myText.delegate = self;
    }
    return _securityCodeTextView;
}

#pragma mark 获取验证码
-(UIButton *)getCodeButton{
    if (!_getCodeButton) {
        _getCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-143.0, self.phoneTextView.bottom+20,112.0, 33)];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeButton.layer.cornerRadius = 4;
        _getCodeButton.layer.borderColor = [UIColor colorWithHexString:@"#FF7568"].CGColor;
        _getCodeButton.layer.borderWidth = 1.0;
        _getCodeButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        [_getCodeButton setTitleColor:[UIColor colorWithHexString:@"#FF7568"] forState:UIControlStateNormal];
        [_getCodeButton addTarget:self action:@selector(getSecurityCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeButton;
}

#pragma mark 密码
-(LoginTextView *)passwordTextView{
    if (!_passwordTextView) {
        _passwordTextView = [[LoginTextView alloc] initWithFrame:CGRectMake(26.0, self.securityCodeTextView.bottom+10, kScreenWidth - 51.0, 52.0) placeholder:@"请输入6-14位字母数字组合密码" icon:@"register_password" isNumber:NO];
        _passwordTextView.myText.delegate = self;
        _passwordTextView.myText.secureTextEntry = YES;
        _passwordTextView.myText.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordTextView;
}

#pragma mark 确认密码
-(LoginTextView *)confirmPwdTextView{
    if (!_confirmPwdTextView) {
        _confirmPwdTextView = [[LoginTextView alloc] initWithFrame:CGRectMake(26, self.passwordTextView.bottom+10, kScreenWidth - 51, 52) placeholder:@"请重新输入密码" icon:@"register_password" isNumber:NO];
        _confirmPwdTextView.myText.delegate = self;
        _confirmPwdTextView.myText.secureTextEntry = YES;
        _confirmPwdTextView.myText.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _confirmPwdTextView;
}


#pragma mark 注册
-(LoginButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [[LoginButton alloc] initWithFrame:CGRectMake(48.0, self.confirmPwdTextView.bottom+37.0, kScreenWidth-95.0, (kScreenWidth-95.0)*(128.0/588.0)) title:@"注册"];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

@end
