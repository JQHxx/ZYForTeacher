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

@interface AddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray       *titlesArr;
    
    UITextField    *cardholderTextField;
    UITextField    *bankCardTextField;
}

@property (nonatomic , strong) UITableView *addBankTableView;
@property (nonatomic , strong) UIButton    *nextButton;
@property ( nonatomic, strong) WLCardNoFormatter *cardNoFormatter;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"添加银行卡";
    
    titlesArr = @[@"持卡人",@"银行卡号"];
    
    [self.view addSubview:self.addBankTableView];
    [self.view addSubview:self.nextButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请绑定持卡人本人的银行卡";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titlesArr[indexPath.row];
    cell.textLabel.font = kFontWithSize(14);
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, kScreenWidth-120, 34)];
    textfield.font = kFontWithSize(14);
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.placeholder = indexPath.row==0?@"请填写持卡人姓名":@"请输入银行卡号";
    textfield.delegate = self;
    [cell.contentView addSubview:textfield];
    
    if (indexPath.row==0) {
        cardholderTextField = textfield;
    }else{
        bankCardTextField = textfield;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
    BindBankCardViewController *bindBankCardVC = [[BindBankCardViewController alloc] init];
    bindBankCardVC.cardholder = cardholderTextField.text;
    bindBankCardVC.bankCardNumber = bankCardTextField.text;
    [self.navigationController pushViewController:bindBankCardVC animated:YES];
}

#pragma mark -- getters and setters
-(UITableView *)addBankTableView{
    if (!_addBankTableView) {
        _addBankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
        _addBankTableView.dataSource = self;
        _addBankTableView.delegate = self;
        _addBankTableView.tableFooterView = [[UIView alloc] init];
    }
    return _addBankTableView;
}

#pragma mark 下一步
-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 240, kScreenWidth-40, 40)];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.backgroundColor = [UIColor redColor];
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
