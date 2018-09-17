//
//  MyWalletViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/30.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WalletDetailsViewController.h"
#import "WithdrawViewController.h"

@interface MyWalletViewController ()

@property (nonatomic ,strong) UIView    *balanceView;
@property (nonatomic ,strong) UIView    *withdrawView;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"我的钱包";
    self.rigthTitleName = @"明细";
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    
    [self.view addSubview:self.balanceView];
    [self.view addSubview:self.withdrawView];
    
}




#pragma mark -- Event response
#pragma mark 明细
-(void)rightNavigationItemAction{
    WalletDetailsViewController *detailsVC = [[WalletDetailsViewController alloc] init];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark 提现
-(void)toWithdrawAction{
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}


#pragma mark -- Getters
#pragma mark 账户余额
-(UIView *)balanceView{
    if (!_balanceView) {
        _balanceView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 100)];
        _balanceView.backgroundColor = kSystemColor;
        
        UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,30, kScreenWidth-40, 40)];
        balanceLabel.font = kFontWithSize(32);
        balanceLabel.textColor = [UIColor redColor];
        balanceLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString *balanceStr = [NSString stringWithFormat:@"%.2f元",2000.0];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:balanceStr];
        [attributeStr addAttribute:NSFontAttributeName value:kFontWithSize(14) range:NSMakeRange(balanceStr.length-1, 1)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(balanceStr.length-1, 1)];
        balanceLabel.attributedText = attributeStr;
        
        [_balanceView addSubview:balanceLabel];
        
    }
    return _balanceView;
}

#pragma mark 提现
-(UIView *)withdrawView{
    if (!_withdrawView) {
        _withdrawView = [[UIView alloc] initWithFrame:CGRectMake(0, self.balanceView.bottom, kScreenWidth, 40)];
        _withdrawView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        imgView.image = [UIImage imageNamed:@"提现"];
        [_withdrawView addSubview:imgView];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, 5, 60, 30)];
        lab.font = kFontWithSize(14);
        lab.textColor = [UIColor blackColor];
        lab.text = @"提现";
        [_withdrawView addSubview:lab];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30,10, 20, 20)];
        arrowImageView.image =[ UIImage drawImageWithName:@"箭头" size:CGSizeMake(20, 20)];
        [_withdrawView addSubview:arrowImageView];
        
        _withdrawView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toWithdrawAction)];
        [_withdrawView addGestureRecognizer:tap];
        
    }
    return _withdrawView;
}

@end
