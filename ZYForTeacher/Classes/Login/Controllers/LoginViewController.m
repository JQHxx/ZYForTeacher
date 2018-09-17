//
//  LoginViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate+Extension.h"
#import "UserAgreementViewController.h"
#import "GetCodeViewController.h"
#import "AppDelegate.h"
#import "CustomTextView.h"
#import "UserAgreementView.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) CustomTextView     *phoneTextView;       //手机号
@property (nonatomic, strong) CustomTextView     *passwordTextView;    //密码
@property (nonatomic, strong) UIButton           *visibleButton;       //密码可见或不可见
@property (nonatomic, strong) UserAgreementView  *agreementView;       //用户协议
@property (nonatomic, strong) UIButton           *selButton;
@property (nonatomic, strong) UIButton           *loginButton;         //登录

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    [self initLoginView];
}

#pragma mark 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Event reponse
#pragma mark 设置密码是否可见
-(void)setPasswordVisibleAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.passwordTextView.myText.secureTextEntry=!sender.selected;
}

#pragma mark 登录
-(void)loginAction{
    if (kIsEmptyString(self.phoneTextView.myText.text)) {
        [self.view makeToast:@"手机号不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    BOOL isPhoneNumber = [self.phoneTextView.myText.text isPhoneNumber];
    if (!isPhoneNumber) {
        [self.view makeToast:@"您输入的手机号码有误,请重新输入" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.passwordTextView.myText.text.length<6) {
        [self.view makeToast:@"密码不能少于6位" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setMyRootViewController];
}

#pragma mark 去注册
-(void)btnClickAction:(UIButton *)sender{
    if (sender.tag==100) {  //注册
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else{  //忘记密码
        GetCodeViewController *getCodeVC = [[GetCodeViewController alloc] init];
        [self.navigationController pushViewController:getCodeVC animated:YES];
    }
}

#pragma mark 是否已阅读
-(void)chooseForDidReadUserAgreement:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if(sender.selected){
        [self.loginButton setImage:[UIImage imageNamed:@"button_login"] forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = YES;
    }else{
        [self.loginButton setImage:[UIImage imageNamed:@"button_login_gray"] forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = NO;
    }
}

#pragma mark -- delegate
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneTextView.myText resignFirstResponder];
    [self.passwordTextView.myText resignFirstResponder];
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
    if (self.passwordTextView.myText==textField) {
        if ([textField.text length]<14) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -- Pravite Methods
#pragma mark 初始化界面
-(void)initLoginView{
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"login_background"];
    [self.view addSubview:imgView];
    
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.passwordTextView];
    [self.view addSubview:self.visibleButton];
    [self.view addSubview:self.agreementView];
    [self.view addSubview:self.selButton];
    [self.view addSubview:self.loginButton];
    
    NSArray *btnTitles = @[@"立即注册",@"忘记密码"];
    for (NSInteger i=0; i<btnTitles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-100+120*i,self.loginButton.bottom + 24, 80, 20)];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        btn.tag = i+100;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, self.loginButton.bottom+24, 1, 20)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
}

#pragma mark -- Getters
#pragma mark 手机号
-(CustomTextView *)phoneTextView{
    if (!_phoneTextView) {
        _phoneTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(48, 290, kScreenWidth-95, 42) placeholder:@"请输入手机号码" icon:@"login_phone" isNumber:YES];
        _phoneTextView.myText.delegate = self;
    }
    return _phoneTextView;
}

#pragma mark 密码
-(CustomTextView *)passwordTextView{
    if (!_passwordTextView) {
        _passwordTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(48, self.phoneTextView.bottom+37, kScreenWidth - 95, 42) placeholder:@"请输入密码" icon:@"login_password"  isNumber:NO];
        _passwordTextView.myText.delegate = self;
        _passwordTextView.myText.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextView.myText.secureTextEntry = YES;
    }
    return _passwordTextView;
}

#pragma mark 设置可见
-(UIButton *)visibleButton{
    if (!_visibleButton) {
        _visibleButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-82,self.passwordTextView.top+13, 27, 16)];
        [_visibleButton setImage:[UIImage imageNamed:@"login_password_hide"] forState:UIControlStateNormal];
        [_visibleButton setImage:[UIImage imageNamed:@"login_password_show"] forState:UIControlStateSelected];
        [_visibleButton addTarget:self action:@selector(setPasswordVisibleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visibleButton;
}

#pragma mark 选择是否同意
-(UIButton *)selButton{
    if (!_selButton) {
        _selButton = [[UIButton alloc] initWithFrame:CGRectMake(79.0, self.passwordTextView.bottom+40.0, 16, 16)];
        [_selButton setImage:[UIImage imageNamed:@"login_agreement"] forState:UIControlStateNormal];
        [_selButton setImage:[UIImage imageNamed:@"login_agreement_agree"] forState:UIControlStateSelected];
        [_selButton addTarget:self action:@selector(chooseForDidReadUserAgreement:) forControlEvents:UIControlEventTouchUpInside];
        _selButton.selected = YES;
    }
    return _selButton;
}

#pragma mark 用户协议
-(UserAgreementView *)agreementView{
    if (!_agreementView) {
        NSString * tempStr = @"我已阅读并同意《作业101用户协议》";
        CGFloat labW = [tempStr boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:kFontWithSize(12)].width;
        _agreementView = [[UserAgreementView alloc] initWithFrame:CGRectMake(self.selButton.right+5,self.passwordTextView.bottom +38, labW+40, 20) string:tempStr];
        kSelfWeak;
        _agreementView.clickAction = ^{
            UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
            [weakSelf.navigationController pushViewController:userAgreementVC animated:YES];
        };
    }
    return _agreementView;
}

#pragma mark 登录
-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(48, self.agreementView.bottom+13, kScreenWidth-95.0, (kScreenWidth-95.0)*(128.0/588.0))];
        [_loginButton setImage:[UIImage imageNamed:@"button_login"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}




@end
