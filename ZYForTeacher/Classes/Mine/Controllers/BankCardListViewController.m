//
//  BankCardListViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BankCardListViewController.h"
#import "AddBankCardViewController.h"
#import "CardTableViewCell.h"
#import "BankModel.h"

@interface BankCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView    *bankTableView;
@property (nonatomic ,strong) NSMutableArray *bankCardList;

@end

@implementation BankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"我的银行卡";
    self.rightImageName = @"add";
    
    [self.view addSubview:self.bankTableView];
    
    [self loadBankCardsData];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankCardList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CardTableViewCell";
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[CardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BankModel *bank = self.bankCardList[indexPath.row];
    cell.bankModel = bank;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
    BankModel *bank = self.bankCardList[indexPath.row];
    self.backBlock(bank);
}

#pragma mark -- Event Response
-(void)rightNavigationItemAction{
    AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载银行卡数据
-(void)loadBankCardsData{
    NSArray *banks = @[@"招商银行",@"建设银行",@"中国银行",@"工商银行",@"交通银行"];
    for (NSInteger i=0; i<banks.count; i++) {
        BankModel *model = [[BankModel alloc] init];
        model.cardImage = @"bank";
        model.bankName = banks[i];
        model.bankNum = @"4839489294t77525";
        [self.bankCardList addObject:model];
    }
    [self.bankTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 银行卡列表
-(UITableView *)bankTableView{
    if (!_bankTableView) {
        _bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _bankTableView.dataSource = self;
        _bankTableView.delegate = self;
        _bankTableView.tableFooterView = [[UIView alloc] init];
    }
    return _bankTableView;
}

#pragma mark 银行卡信息
-(NSMutableArray *)bankCardList{
    if (!_bankCardList) {
        _bankCardList = [[NSMutableArray alloc] init];
    }
    return _bankCardList;
}


@end
