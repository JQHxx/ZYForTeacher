//
//  WithdrawViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WithdrawViewController.h"
#import "BankCardListViewController.h"
#import "BankCardView.h"
#import "BankModel.h"

@interface WithdrawViewController (){
    UITextField    *withdrawTextField;
    UILabel        *balanceLabel;
    double         balance;
}

@property (nonatomic, strong) BankCardView *cardView;
@property (nonatomic, strong) UIView    *withdrawView;
@property (nonatomic, strong) UIButton  *confirmButton;
@property (nonatomic, strong) UILabel   *tipsLabel;


@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"提现";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [self.view addSubview:self.cardView];
    [self.view addSubview:self.withdrawView];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.tipsLabel];
    
    [self loadWithdrawData];
}

#pragma mark -- event response
#pragma mark 确定
-(void)confirmWithrawAction{
    
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

#pragma mark -- Private Methods
#pragma mark 加载提现信息
-(void)loadWithdrawData{
    BankModel *model = [[BankModel alloc] init];
    model.cardImage = @"bank";
    model.bankName = @"招商银行";
    model.bankNum = @"4839489294t77525";
    self.cardView.bank = model;
    
    balance = 2000.0;
    balanceLabel.text = [NSString stringWithFormat:@"可提现金额：¥%.2f",balance];
}

#pragma mark -- getters
#pragma mark 银行卡
-(BankCardView *)cardView{
    if (!_cardView) {
        _cardView = [[BankCardView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 70)];
        
        _cardView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBankCardAction)];
        [_cardView addGestureRecognizer:tap];
        
    }
    return _cardView;
}

#pragma mark 提现金额
-(UIView *)withdrawView{
    if (!_withdrawView) {
        _withdrawView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardView.bottom+10, kScreenWidth, 120)];
        _withdrawView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        titleLab.font = kFontWithSize(14);
        titleLab.textColor = [UIColor blackColor];
        titleLab.text = @"提现金额";
        [_withdrawView addSubview:titleLab];
        
        UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab.bottom+10, 20, 30)];
        unitLab.text = @"¥";
        unitLab.font = [UIFont boldSystemFontOfSize:16];
        [_withdrawView addSubview:unitLab];
        
        withdrawTextField = [[UITextField alloc] initWithFrame:CGRectMake(unitLab.right, titleLab.bottom+10, kScreenWidth-unitLab.right-30, 30)];
        withdrawTextField.returnKeyType = UIReturnKeyDone;
        withdrawTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        withdrawTextField.font = kFontWithSize(16);
        withdrawTextField.placeholder = @"0.00";
        [_withdrawView addSubview:withdrawTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(unitLab.right, withdrawTextField.bottom, withdrawTextField.width, 0.5)];
        lineView.backgroundColor = kLineColor;
        [_withdrawView addSubview:lineView];
        
        balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.bottom+5, kScreenWidth-40, 30)];
        balanceLabel.font = kFontWithSize(14);
        balanceLabel.textColor = [UIColor lightGrayColor];
        [_withdrawView addSubview:balanceLabel];
        
    }
    return _withdrawView;
}

#pragma mark 确定
-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.withdrawView.bottom+30, kScreenWidth-40, 40)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor redColor];
        _confirmButton.layer.cornerRadius = 5;
        [_confirmButton addTarget:self action:@selector(confirmWithrawAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark 提现须知
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.font = kFontWithSize(14);
        _tipsLabel.numberOfLines = 0;
        
        NSString *labelText = @"提现须知\n1、申请提现金额不得低于50元；\n2、每日提现最高金额不得超过5000元；\n3、请在每周六之前提交申请。";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        _tipsLabel.attributedText = attributedString;
        
        CGFloat tipsH = [labelText boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:_tipsLabel.font].height;
        _tipsLabel.frame = CGRectMake(20, self.confirmButton.bottom+20, kScreenWidth-40, tipsH+50);
    }
    return _tipsLabel;
}


@end
