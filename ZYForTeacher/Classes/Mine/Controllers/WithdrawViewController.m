//
//  WithdrawViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WithdrawViewController.h"
#import "BankCardListViewController.h"
#import "AddBankCardViewController.h"
#import "NonBankCardView.h"
#import "BankCardView.h"
#import "BankModel.h"
#import "LoginButton.h"

@interface WithdrawViewController ()<UITextFieldDelegate>{
    UITextField    *withdrawTextField;
    UILabel        *balanceLabel;
    LoginButton    *confirmButton;
    BankModel      *myBank;
}

@property (nonatomic, strong) NonBankCardView  *nonCardView;
@property (nonatomic, strong) BankCardView     *cardView;
@property (nonatomic, strong) UIView           *withdrawView;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"提现";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    myBank = [[BankModel alloc] init];
    
    
    [self.view addSubview:self.nonCardView];
    [self.view addSubview:self.cardView];
    
    [self.view addSubview:self.withdrawView];
    self.cardView.hidden = self.nonCardView.hidden = self.withdrawView.hidden = YES;
    
    [self loadWithdrawData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([ZYHelper sharedZYHelper].isUpdateWithdraw){
        [self loadWithdrawData];
        [ZYHelper sharedZYHelper].isUpdateWithdraw = NO;
    }
}

#pragma mark -- event response
#pragma mark 确定
-(void)confirmWithrawAction{
    if (kIsEmptyString(myBank.bankName)||kIsEmptyString(myBank.bankNum)) {
        [self.view makeToast:@"请先添加银行卡" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    double money = [withdrawTextField.text doubleValue];
    if (kIsEmptyString(withdrawTextField.text)||money==0) {
        [self.view makeToast:@"请输入提现金额" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (money>self.amount) {
        [self.view makeToast:@"提现金额不能超过可提现余额" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&card=%@&money=%.2f",kUserTokenValue,myBank.bankNum,money];
    [TCHttpRequest postMethodWithURL:kWalletExtractAPI body:body success:^(id json) {
         dispatch_sync(dispatch_get_main_queue(), ^{
             [weakSelf.view makeToast:@"您的提现申请已提交,请等待审核" duration:1.0 position:CSToastPositionCenter];
         });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark 选择银行卡
-(void)selectBankCardAction{
    BankCardListViewController *bankCardListVC = [[BankCardListViewController alloc] init];
    kSelfWeak;
    bankCardListVC.backBlock = ^(id object) {
        weakSelf.cardView.bank = (BankModel *)object;
    };
    [self.navigationController pushViewController:bankCardListVC animated:YES];
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]invertedSet];
    // allow backspace
    if (range.length > 0 && [string length] == 0) {
        return YES;
    }
    // do not allow . at the beggining
    if (range.location == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    
    NSString *currentText = textField.text;  //当前确定的那个输入框
    if ([string isEqualToString:@"."]&&[currentText rangeOfString:@"." options:NSBackwardsSearch].length == 0) {
        
    }else if([string isEqualToString:@"."]&&[currentText rangeOfString:@"." options:NSBackwardsSearch].length== 1) {
        string = @"";
        //alreay has a decimal point
    }
    if ([currentText containsString:@"."]) {
        NSInteger pointLo = [textField.text rangeOfString:@"."].location;
        if (currentText.length-pointLo>2) {
            string = @"";
        }
    }
    // set the text field value manually
    NSString *newValue = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    newValue = [[newValue componentsSeparatedByCharactersInSet:nonNumberSet]componentsJoinedByString:@""];
    textField.text = newValue;
    return NO;
}

#pragma mark -- Private Methods
#pragma mark 加载提现信息
-(void)loadWithdrawData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@",kUserTokenValue];
    [TCHttpRequest postMethodWithURL:kWalletExtractPageAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        NSDictionary *bank = [data valueForKey:@"bank"];
        if (bank.count>0) {
            myBank.bankName = bank[@"bank"];
            myBank.bankNum = bank[@"card_no"];
            NSString *cardCode = bank[@"label"];
            if (kIsEmptyString(cardCode)) {
                myBank.cardImage = @"bank";
                myBank.cardBgImage = @"bank2";
            }else{
                myBank.cardImage = cardCode;
                myBank.cardBgImage = [NSString stringWithFormat:@"%@2",cardCode];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.withdrawView.hidden = NO;
                weakSelf.cardView.hidden = NO;
                weakSelf.nonCardView.hidden = YES;
                weakSelf.cardView.bank = myBank;
                [confirmButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
                confirmButton.enabled = YES;
            });
        }else{
         
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.withdrawView.hidden = NO;
                weakSelf.cardView.hidden = YES;
                weakSelf.nonCardView.hidden = NO;
                [confirmButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"button_gray_ipad"]:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
                confirmButton.enabled = NO;
            });
        }
    }];
}

#pragma mark -- getters
#pragma mark 无银行卡
-(NonBankCardView *)nonCardView{
    if (!_nonCardView) {
        _nonCardView = [[NonBankCardView alloc] initWithFrame:IS_IPAD?CGRectMake(12, kNavHeight+12, kScreenWidth-24, 136):CGRectMake(10, kNavHeight+10, kScreenWidth-20, 85)];
        kSelfWeak;
        _nonCardView.clickAction = ^{
            AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
            [weakSelf.navigationController pushViewController:addBankCardVC animated:YES];
        };
    }
    return _nonCardView;
}

#pragma mark 银行卡
-(BankCardView *)cardView{
    if (!_cardView) {
        _cardView = [[BankCardView alloc] initWithFrame:IS_IPAD?CGRectMake(16, kNavHeight+15, kScreenWidth-32, 130):CGRectMake(10, kNavHeight+10, kScreenWidth-20, 85)];
        _cardView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBankCardAction)];
        [_cardView addGestureRecognizer:tap];
    }
    return _cardView;
}

#pragma mark 提现金额
-(UIView *)withdrawView{
    if (!_withdrawView) {
        _withdrawView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardView.bottom+10, kScreenWidth, kScreenHeight-self.cardView.bottom-10)];
        _withdrawView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(58, 21.4, 110, 36):CGRectMake(25, 14, 100, 22)];
        titleLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:16];
        titleLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        titleLab.text = @"提现金额";
        [_withdrawView addSubview:titleLab];
        
        UILabel *unitLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(61,titleLab.bottom+17,28, 65):CGRectMake(27, titleLab.bottom+13, 18, 42)];
        unitLab.text = @"¥";
        unitLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?46:30];
        unitLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_withdrawView addSubview:unitLab];
        
        withdrawTextField = [[UITextField alloc] initWithFrame:IS_IPAD?CGRectMake(unitLab.right+23, titleLab.bottom+17, kScreenWidth-unitLab.right-50, 65):CGRectMake(unitLab.right+15, titleLab.bottom+13, kScreenWidth-unitLab.right-30, 42)];
        withdrawTextField.returnKeyType = UIReturnKeyDone;
        withdrawTextField.keyboardType = UIKeyboardTypeDecimalPad;
        withdrawTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        withdrawTextField.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?46:30];
        withdrawTextField.placeholder = @"0.00";
        withdrawTextField.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        withdrawTextField.delegate = self;
        [_withdrawView addSubview:withdrawTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(40, withdrawTextField.bottom, kScreenWidth-80, 0.5):CGRectMake(22.5, withdrawTextField.bottom, kScreenWidth-45, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_withdrawView addSubview:lineView];
        
        balanceLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(55, lineView.bottom+21, kScreenWidth-110, 30):CGRectMake(23, lineView.bottom+12, kScreenWidth-46, 20)];
        balanceLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        balanceLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        balanceLabel.text = [NSString stringWithFormat:@"可提现金额：¥%.2f",self.amount];
        [_withdrawView addSubview:balanceLabel];
        
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,balanceLabel.bottom+60,515, 75):CGRectMake(48,balanceLabel.bottom+40,kScreenWidth-96, 60);
        confirmButton = [[LoginButton alloc] initWithFrame:btnFrame title:@"确定"];
        [confirmButton addTarget:self action:@selector(confirmWithrawAction) forControlEvents:UIControlEventTouchUpInside];
        [_withdrawView addSubview:confirmButton];
        
        UILabel *tipsTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, confirmButton.bottom+50, 120, 30)];
        tipsTitleLab.text = @"提现须知";
        tipsTitleLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        tipsTitleLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_withdrawView addSubview:tipsTitleLab];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tipsLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        tipsLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        tipsLabel.numberOfLines = 0;
        
        NSString *labelText = @"1、申请提现金额不得低于50元；\n2、每日提现最高金额不得超过5000元；\n3、请在每周六之前提交申请。";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        tipsLabel.attributedText = attributedString;
        
        CGFloat tipsH = [labelText boundingRectWithSize:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:tipsLabel.font].height;
        tipsLabel.frame = CGRectMake(25, tipsTitleLab.bottom, kScreenWidth-50, tipsH+30);
        [_withdrawView addSubview:tipsLabel];
    }
    return _withdrawView;
}

@end
