//
//  AddBankCardViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BindBankCardViewController.h"
#import "WLCardNoFormatter.h"
#import "BankModel.h"
#import "LoginButton.h"

@interface AddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray       *titlesArr;
    
    UITextField    *cardholderTextField;
    UITextField    *bankCardTextField;
}

@property (nonatomic , strong) UITableView *addBankTableView;
@property (nonatomic , strong) UILabel     *tipsLabel;
@property (nonatomic , strong) LoginButton    *nextButton;
@property ( nonatomic, strong) WLCardNoFormatter *cardNoFormatter;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"添加银行卡";
    
    titlesArr = @[@"持卡人",@"银行卡号"];
    
    [self.view addSubview:self.addBankTableView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.nextButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titlesArr[indexPath.row];
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:IS_IPAD?CGRectMake(166, 21, kScreenWidth-180, 36):CGRectMake(106, 15, kScreenWidth-120, 22)];
    textfield.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.placeholder = indexPath.row==0?@"请填写持卡人姓名":@"请输入银行卡号";
    textfield.delegate = self;
    textfield.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [cell.contentView addSubview:textfield];
    if (indexPath.row==0) {
        cardholderTextField = textfield;
    }else{
        bankCardTextField = textfield;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  IS_IPAD?80:50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 39, 0, 38)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0,21, 0, 0)];
    }
}

#pragma mark -- Delegate
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == bankCardTextField) {
        [self.cardNoFormatter bankNoField:textField shouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    return YES;
}

#pragma mark -- Event Response
#pragma mark 下一步
-(void)nextStepAction{
    kSelfWeak;
    NSString *cardNum = [bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *body = [NSString stringWithFormat:@"card=%@",cardNum];
    [TCHttpRequest postMethodWithURL:kSearchBankAPI body:body success:^(id json) {
        NSString *cardName = [json objectForKey:@"data"];
        NSArray *cardsArr = [cardName componentsSeparatedByString:@"-"];
        if ([cardName isEqualToString:@"该卡号信息暂未录入"]||cardsArr.count==0) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.view makeToast:@"请输入正确的持卡人姓名和卡号" duration:1.0 position:CSToastPositionCenter];
            });
        }else{
            BankModel *bank = [[BankModel alloc] init];
            bank.bankType = cardsArr[2];
            bank.cardHolder = cardholderTextField.text;
            bank.bankNum = bankCardTextField.text;
            bank.bankName = cardsArr[0];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                BindBankCardViewController *bindBankCardVC = [[BindBankCardViewController alloc] init];
                bindBankCardVC.bank = bank;
                [self.navigationController pushViewController:bindBankCardVC animated:YES];
            });
        }
    }];
}

#pragma mark -- getters and setters
-(UITableView *)addBankTableView{
    if (!_addBankTableView) {
        _addBankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+10, kScreenWidth, kScreenHeight-kNavHeight-10) style:UITableViewStylePlain];
        _addBankTableView.dataSource = self;
        _addBankTableView.delegate = self;
        _addBankTableView.scrollEnabled = NO;
        _addBankTableView.tableFooterView = [[UIView alloc] init];
    }
    return _addBankTableView;
}

#pragma mark 说明
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(50, kNavHeight+237, kScreenWidth-100, 30):CGRectMake(25, kNavHeight+160,kScreenWidth-50, 20)];
        _tipsLabel.text = @"*请绑定持卡人本人的银行卡";
        _tipsLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#E42A2A"];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

#pragma mark 下一步
-(LoginButton *)nextButton{
    if (!_nextButton) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,self.tipsLabel.bottom+22.0 ,515, 75):CGRectMake(48,kNavHeight+190,kScreenWidth-96, 60);
        _nextButton = [[LoginButton alloc] initWithFrame:btnFrame title:@"下一步"];
        [_nextButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

-(WLCardNoFormatter *)cardNoFormatter{
    if (!_cardNoFormatter) {
        _cardNoFormatter = [[WLCardNoFormatter alloc] init];
    }
    return _cardNoFormatter;
}

@end
