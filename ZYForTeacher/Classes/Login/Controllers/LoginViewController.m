//
//  LoginViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserAgreementViewController.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"

#import "NumberTextView.h"
#import "CustomTextView.h"
#import "LoginButton.h"
#import "UserAgreementView.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NumberTextView     *phoneTextView;       //手机号
@property (nonatomic, strong) CustomTextView     *passwordTextView;    //密码
@property (nonatomic, strong) LoginButton        *loginButton;         //登录
@property (nonatomic, strong) UserAgreementView  *agreementView;       //用户协议

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    [self initLoginView];
}


#pragma mark -- Event reponse
#pragma mark 登录
-(void)loginAction{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController *mainVC = [[MainViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:mainVC];
    appDelegate.window.rootViewController = nav;
}

#pragma mark 去注册
-(void)btnClickAction:(UIButton *)sender{
    if (sender.tag==100) {  //注册
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else{  //忘记密码
        
    }
}

#pragma mark 查看用户协议
-(void)viewUserAgreement{
    
}

#pragma mark 监听输入变化
-(void)textFieldDidChange:(UITextField *)textField{
    if(textField == self.phoneTextView.myText || textField == self.passwordTextView.myText){
        if (self.phoneTextView.myText.text.length>=11&&self.passwordTextView.myText.text.length>=6) {
            self.loginButton.clickable = YES;
        }else{
            self.loginButton.clickable = NO;
        }
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
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-90)/2, 84, 90, 90)];
    imgView.image=[UIImage imageNamed:@"ic_tangshi_logo"];
    [self.view addSubview:imgView];
    
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.passwordTextView];
    [self.view addSubview:self.loginButton];
    
    NSArray *btnTitles = @[@"立即注册",@"忘记密码"];
    for (NSInteger i=0; i<btnTitles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-100+120*i,self.loginButton.bottom + 24, 80, 20)];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kFontWithSize(15);
        btn.tag = i+100;
        [btn setTitleColor:i==0?[UIColor redColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, self.loginButton.bottom+24, 1, 20)];
    line.backgroundColor = kLineColor;
    [self.view addSubview:line];
    
    [self.view addSubview:self.agreementView];
}

#pragma mark -- Getters
#pragma mark 手机号
-(NumberTextView *)phoneTextView{
    if (!_phoneTextView) {
        _phoneTextView = [[NumberTextView alloc] initWithFrame:CGRectMake(20, 150, kScreenWidth-40, 55) placeholder:@"请输入手机号码" icon:@"ic_login_num"];
        _phoneTextView.myText.delegate = self;
        [_phoneTextView.myText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextView;
}

#pragma mark 密码
-(CustomTextView *)passwordTextView{
    if (!_passwordTextView) {
        _passwordTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(20, self.phoneTextView.bottom+15, kScreenWidth - 40, 55) placeholder:@"请输入密码" icon:@"ic_login_code" ];
        _passwordTextView.myText.delegate = self;
        _passwordTextView.myText.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextView.myText.secureTextEntry = YES;
        [_passwordTextView.myText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextView;
}

#pragma mark 登录
-(LoginButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[LoginButton alloc] initWithFrame:CGRectMake(20, self.passwordTextView.bottom+30, kScreenWidth-40, 45) title:@"登录"];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.clickable = NO;
    }
    return _loginButton;
}

#pragma mark 用户协议
-(UserAgreementView *)agreementView{
    if (!_agreementView) {
        NSString * tempStr = @"点击登录，即表示您同意《作业101用户协议》";
        CGFloat labW = [tempStr boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:kFontWithSize(12)].width;
        _agreementView = [[UserAgreementView alloc] initWithFrame:CGRectMake((kScreenWidth-labW)/2, kScreenHeight-40, labW, 20) string:tempStr];
        kSelfWeak;
        _agreementView.clickAction = ^{
            UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
            [weakSelf.navigationController pushViewController:userAgreementVC animated:YES];
        };
    }
    return _agreementView;
}




@end
