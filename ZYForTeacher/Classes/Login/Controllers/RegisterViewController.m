//
//  RegisterViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "RegisterViewController.h"
#import "SetPasswordViewController.h"
#import "UserAgreementViewController.h"
#import "NumberTextView.h"
#import "LoginButton.h"
#import "UserAgreementView.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NumberTextView     *phoneTextView;              //手机号
@property (nonatomic, strong) UIButton           *getCodeButton;              //获取验证码
@property (nonatomic, strong) NumberTextView     *securityCodeTextView;       //验证码
@property (nonatomic, strong) UserAgreementView  *userAgreementView;          //用户协议
@property (nonatomic, strong) UIButton           *selButton;                  //勾选用户协议
@property (nonatomic, strong) LoginButton        *registerButton;             //注册



@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"注册";
    
    [self initRegisterView];
}

#pragma mark -- Event response
#pragma mark 注册
-(void)registerAction{
    SetPasswordViewController *setPwdVC = [[SetPasswordViewController alloc] init];
    [self.navigationController pushViewController:setPwdVC animated:YES];
}

#pragma mark 获取验证码
-(void)getSecurityCodeAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.getCodeButton.backgroundColor = sender.selected?[UIColor lightGrayColor]:kRGBColor(250, 236, 234);
    [self.getCodeButton setUserInteractionEnabled:!sender.selected];
}

#pragma mark 监听输入变化
-(void)textFieldDidChange:(UITextField *)textField{
    if(textField == self.phoneTextView.myText || textField == self.securityCodeTextView.myText){
        self.registerButton.clickable = self.selButton.selected&&self.phoneTextView.myText.text.length>=11&&self.securityCodeTextView.myText.text.length>=6;
    }
}

#pragma mark 是否已阅读
-(void)chooseForDidReadUserAgreement:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.registerButton.clickable = sender.selected&&self.phoneTextView.myText.text.length>=11&&self.securityCodeTextView.myText.text.length>=6;
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
-(void)initRegisterView{
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-90)/2, 84, 90, 90)];
    imgView.image=[UIImage imageNamed:@"ic_tangshi_logo"];
    [self.view addSubview:imgView];
    
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.getCodeButton];
    
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.phoneTextView.right,199,90, 1)];
    lineLbl.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.view addSubview:lineLbl];
    
    [self.view addSubview:self.securityCodeTextView];
    [self.view addSubview:self.userAgreementView];
    [self.view addSubview:self.selButton];
    [self.view addSubview:self.registerButton];
}

#pragma mark -- Getters
#pragma mark 手机号
-(NumberTextView *)phoneTextView{
    if (!_phoneTextView) {
        _phoneTextView = [[NumberTextView alloc] initWithFrame:CGRectMake(20, 150, kScreenWidth-130, 55) placeholder:@"请输入手机号码" icon:@"ic_login_num"];
        _phoneTextView.myText.delegate = self;
        [_phoneTextView.myText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextView;
}

#pragma mark 获取验证码
-(UIButton *)getCodeButton{
    if (!_getCodeButton) {
        _getCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-120, 155,100, 35)];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeButton.backgroundColor = kRGBColor(250, 236, 234);
        _getCodeButton.layer.cornerRadius = 20;
        _getCodeButton.titleLabel.font = kFontWithSize(13);
        [_getCodeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_getCodeButton addTarget:self action:@selector(getSecurityCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getCodeButton;
}

#pragma mark 密码
-(NumberTextView *)securityCodeTextView{
    if (!_securityCodeTextView) {
        _securityCodeTextView = [[NumberTextView alloc] initWithFrame:CGRectMake(20, self.phoneTextView.bottom+15, kScreenWidth - 40, 55) placeholder:@"请输入验证码" icon:@"ic_login_code" ];
        _securityCodeTextView.myText.delegate = self;
        [_securityCodeTextView.myText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _securityCodeTextView;
}

#pragma mark 用户协议
-(UserAgreementView *)userAgreementView{
    if (!_userAgreementView) {
        NSString * tempStr = @"我已阅读并同意《作业101用户协议》";
        CGFloat labW = [tempStr boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:kFontWithSize(12)].width;
        _userAgreementView = [[UserAgreementView alloc] initWithFrame:CGRectMake((kScreenWidth-labW)/2+25,self.securityCodeTextView.bottom +10, labW, 20) string:tempStr];
        kSelfWeak;
        _userAgreementView.clickAction = ^{
            UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
            [weakSelf.navigationController pushViewController:userAgreementVC animated:YES];
        };
    }
    return _userAgreementView;
}

#pragma mark 选择是否同意
-(UIButton *)selButton{
    if (!_selButton) {
        _selButton = [[UIButton alloc] initWithFrame:CGRectMake(self.userAgreementView.left-30, self.userAgreementView.top-5, 30, 30)];
        [_selButton setImage:[UIImage imageNamed:@"ic_eqment_pick_un"] forState:UIControlStateNormal];
        [_selButton setImage:[UIImage imageNamed:@"ic_eqment_pick_on"] forState:UIControlStateSelected];
        [_selButton addTarget:self action:@selector(chooseForDidReadUserAgreement:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selButton;
}

#pragma mark 注册
-(LoginButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [[LoginButton alloc] initWithFrame:CGRectMake(20, self.userAgreementView.bottom+20, kScreenWidth-40, 45) title:@"注册"];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.clickable = NO;
    }
    return _registerButton;
}

@end
