//
//  SetPasswordViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "CustomTextView.h"
#import "LoginButton.h"

#import "AppDelegate.h"

@interface SetPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) CustomTextView     *passwordTextView;    //密码
@property (nonatomic, strong) CustomTextView     *confirmPwdTextView;  //确认密码
@property (nonatomic, strong) LoginButton        *completeButton;  //确认密码



@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"设置密码";
    
    [self initRegisterSuccessView];
}

#pragma mark -- Event response
#pragma mark 完成设置
-(void)completeSetupAction{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController *mainVC = [[MainViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:mainVC];
    appDelegate.window.rootViewController = nav;
}

#pragma mark 监听输入变化
-(void)textFieldDidChange:(UITextField *)textField{
    if(textField == self.passwordTextView.myText || textField == self.confirmPwdTextView.myText){
        self.completeButton.clickable = self.passwordTextView.myText.text.length>=6&&self.confirmPwdTextView.myText.text.length>=6;
    }
}

#pragma mark -- delegate
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.passwordTextView.myText resignFirstResponder];
    [self.confirmPwdTextView.myText resignFirstResponder];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if (self.passwordTextView.myText==textField) {
        if ([textField.text length]<14) {
            return YES;
        }
    }
    if (self.confirmPwdTextView.myText==textField) {
        if ([textField.text length]<14) {
            return YES;
        }
    }
    return NO;
}


#pragma mark -- private methods
#pragma mark 初始化界面
-(void)initRegisterSuccessView{
    
    UIImageView *successImageView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-89)/2, kNavHeight +26, 89, 89)];
    successImageView.image=[UIImage imageNamed:@"pub_ic_device_right"];
    [self.view addSubview:successImageView];
    
    UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake(20, successImageView.bottom+20, kScreenWidth-40, 20)];
    lab1.text=@"注册成功！请设置密码以便更好使用";
    lab1.font=[UIFont boldSystemFontOfSize:16];
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.textColor=kSystemColor;
    [self.view addSubview:lab1];
   
    [self.view addSubview:self.passwordTextView];
    [self.view addSubview:self.confirmPwdTextView];
    [self.view addSubview:self.completeButton];
}

#pragma mark -- Getters and Setters
#pragma mark 密码
-(CustomTextView *)passwordTextView{
    if (!_passwordTextView) {
        _passwordTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(20, kNavHeight+180, kScreenWidth - 40, 55) placeholder:@"请输入6-14位密码" icon:@"ic_login_code" ];
        _passwordTextView.myText.delegate = self;
        _passwordTextView.myText.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextView.myText.secureTextEntry = YES;
        [_passwordTextView.myText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextView;
}

#pragma mark 确认密码
-(CustomTextView *)confirmPwdTextView{
    if (!_confirmPwdTextView) {
        _confirmPwdTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(20, self.passwordTextView.bottom, kScreenWidth-40, 55) placeholder:@"确认密码" icon:@"ic_login_code"];
        _confirmPwdTextView.myText.delegate = self;
        _confirmPwdTextView.myText.keyboardType = UIKeyboardTypeASCIICapable;
        _confirmPwdTextView.myText.secureTextEntry = YES;
        [_confirmPwdTextView.myText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _confirmPwdTextView;
}

#pragma mark 登录
-(LoginButton *)completeButton{
    if (!_completeButton) {
        _completeButton = [[LoginButton alloc] initWithFrame:CGRectMake(20, self.confirmPwdTextView.bottom+30, kScreenWidth-40, 45) title:@"完成"];
        [_completeButton addTarget:self action:@selector(completeSetupAction) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.clickable = NO;
    }
    return _completeButton;
}


@end
