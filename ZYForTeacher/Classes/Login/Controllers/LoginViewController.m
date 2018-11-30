//
//  LoginViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "UserAgreementViewController.h"
#import "GetCodeViewController.h"
#import "AppDelegate.h"
#import "CustomTextView.h"
#import "UserAgreementView.h"
#import "UserModel.h"
#import "SSKeychain.h"
#import "UIDevice+Extend.h"
#import "IdentitySettingViewController.h"
#import <NIMSDK/NIMSDK.h>
#import <UMPush/UMessage.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) CustomTextView     *phoneTextView;       //手机号
@property (nonatomic, strong) CustomTextView     *passwordTextView;    //密码
@property (nonatomic, strong) UIButton           *visibleButton;       //密码可见或不可见
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
    
    NSString *phoneStr = self.phoneTextView.myText.text;
    NSString *passwordStr = [self.passwordTextView.myText.text MD5];
    NSString *retrieveuuid=[SSKeychain passwordForService:kDeviceIDFV account:@"useridfv"];
    NSString *uuid=nil;
    if (kIsEmptyObject(retrieveuuid)) {
        uuid=[UIDevice getIDFV];
        [SSKeychain setPassword:uuid forService:kDeviceIDFV account:@"useridfv"];
    }else{
        uuid=retrieveuuid;
    }
    
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"mobile=%@&password=%@&platform=iOS&deviceId=%@",phoneStr,passwordStr,uuid];
    [TCHttpRequest postMethodWithURL:kLoginAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        UserModel *model = [[UserModel alloc] init];
        [model setValues:data];
        
        [NSUserDefaultsInfos putKey:kUserID andValue:model.tid];
        [NSUserDefaultsInfos putKey:kUserToken andValue:model.token];
        [NSUserDefaultsInfos putKey:kLoginPhone andValue:phoneStr];
        [NSUserDefaultsInfos putKey:kIsOnline andValue:model.online];
        [NSUserDefaultsInfos putKey:kUserThirdID andValue:model.third_id];
        [NSUserDefaultsInfos putKey:kUserThirdToken andValue:model.third_token];
        [NSUserDefaultsInfos putKey:kLogID andValue:model.logid];
        [NSUserDefaultsInfos putKey:kAuthIdentidy andValue:model.auth_id];   //实名认证
        [NSUserDefaultsInfos putKey:kAuthEducation andValue:model.auth_edu];  //学历认证
        
        if (!kIsEmptyString(model.trait)&&!kIsEmptyString(model.tch_name)&!kIsEmptyString(model.subject)) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:model.tid,@"tch_id",model.trait,@"trait",model.tch_name,@"tch_name",model.grade,@"grade",model.subject,@"subject",model.score,@"score",model.guide_price,@"guide_price",model.guide_time,@"guide_time",model.check_num,@"check_num",nil];
            [NSUserDefaultsInfos putKey:kUserInfo anddict:userDict];
        }
        
        //登录网易云
        [[[NIMSDK sharedSDK] loginManager] login:model.third_id token:model.third_token completion:^(NSError * _Nullable error) {
            if (error) {
                MyLog(@"NIMSDK login--error:%@",error.localizedDescription);
            }else{
                MyLog(@"网易云登录成功");
                NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:model.third_id];
                MyLog(@"user--nickName:%@,avatar:%@",user.userInfo.nickName,user.userInfo.thumbAvatarUrl);
                if (kIsEmptyString(user.userInfo.nickName)||kIsEmptyString(user.userInfo.thumbAvatarUrl)) {
                    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagNick):model.tch_name,@(NIMUserInfoUpdateTagAvatar):model.trait} completion:^(NSError * _Nullable error) {
                        if (error) {
                            MyLog(@"用户信息托管失败,error:%@",error.localizedDescription);
                        }else{
                            MyLog(@"用户信息托管成功");
                        }
                    }];
                }
            }
        }];
        
        //绑定友盟推送别名
        NSString *tempStr=isTrueEnvironment?@"zs":@"cs";
        NSString *aliasStr=[NSString stringWithFormat:@"%@%@",tempStr,model.tid];
        [UMessage setAlias:aliasStr type:kUMAlaisType response:^(id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                MyLog(@"绑定别名失败，error:%@",error.localizedDescription);
            }else{
                MyLog(@"绑定别名成功,result:%@",responseObject);
            }
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([model.tch_label integerValue]==0||kIsEmptyString(model.trait)||kIsEmptyString(model.tch_name)||[model.edu_stage integerValue]==0||model.grade.count==0||kIsEmptyString(model.subject)) {
                IdentitySettingViewController *identitySettingVC = [[IdentitySettingViewController alloc] init];
                identitySettingVC.model = model;
                [weakSelf.navigationController pushViewController:identitySettingVC animated:YES];
            }else{
                [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:YES]];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate setMyRootViewController];
            }
       });
    }];
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
    imgView.image =  [UIImage imageNamed:isIPhoneX?@"login_background_x":@"login_background"];
    [self.view addSubview:imgView];
    
    [self.view addSubview:self.phoneTextView];
    NSString *phoneStr = [NSUserDefaultsInfos getValueforKey:kLoginPhone];
    if (!kIsEmptyString(phoneStr)) {
        self.phoneTextView.myText.text = phoneStr;
    }
    
    [self.view addSubview:self.passwordTextView];
    [self.view addSubview:self.visibleButton];
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
        CGFloat originX = kScreenWidth<375?kScreenHeight-330:kScreenHeight-382;
        _phoneTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(48, originX, kScreenWidth-95, 42) placeholder:@"请输入手机号码" icon:@"login_phone" isNumber:YES];
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


#pragma mark 登录
-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-280)/2.0, self.passwordTextView.bottom+20, 280, 60)];
        [_loginButton setImage:[UIImage imageNamed:@"button_login"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}




@end
