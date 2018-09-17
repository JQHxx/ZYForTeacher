//
//  InputNameViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "InputNameViewController.h"

@interface InputNameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong ) UITextField *inputText;

@end

@implementation InputNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = [self getMyTitleWithType:self.type];
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    self.leftTitleName = @"取消";
    self.rigthTitleName = @"保存";
    self.isRightBtnEnable = !kIsEmptyString(self.myText);
    
    [self.view addSubview:self.inputText];
}

#pragma mark -- Event Responese
#pragma mark 保存
-(void)rightNavigationItemAction{
    [self dismissViewControllerAnimated:YES completion:^{
        self.backBlock(self.inputText.text);
    }];
}

-(void)leftNavigationItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- delegate
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.inputText resignFirstResponder];
    return YES;
}

#pragma mark 监听输入变化
-(void)textFieldDidChange:(UITextField *)textField{
    if(textField == self.inputText){
        if (kIsEmptyString(self.inputText.text)) {
            self.isRightBtnEnable = NO;
        }else{
            self.isRightBtnEnable = YES;
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if (self.inputText==textField) {
        if ([textField.text length]<18) {
            return YES;
        }
    }
    
    return NO;
}

-(NSString *)getMyTitleWithType:(CertificationType)type{
    NSString *myTitle = nil;
    if (type==CertificationTypeActualName) {
        myTitle = @"真实姓名";
    }else if (type==CertificationTypeIdentificationNumber){
        myTitle = @"身份证号";
    }
    return myTitle;
}

#pragma mark -- Getters
#pragma mark 输入框
-(UITextField *)inputText{
    if (!_inputText) {
        _inputText = [[UITextField alloc] initWithFrame:CGRectMake(0, kNavHeight+20, kScreenWidth, 40)];
        _inputText.text = kIsEmptyString(self.myText)?@"":self.myText;
        _inputText.backgroundColor = [UIColor whiteColor];
        _inputText.placeholder = self.type==0?@"请输入真实姓名":@"请输入身份证号";
        _inputText.font = kFontWithSize(14);
        _inputText.delegate = self;
        _inputText.keyboardType = self.type==0?UIKeyboardTypeDefault:UIKeyboardTypeNumbersAndPunctuation;
        _inputText.returnKeyType = UIReturnKeyDone;
        _inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        for (NSInteger i=0; i<2; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,i*39, kScreenWidth, 0.5)];
            lab.backgroundColor = kLineColor;
            [_inputText addSubview:lab];
        }
    }
    return _inputText;
}

@end
