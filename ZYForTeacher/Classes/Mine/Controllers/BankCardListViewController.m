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

/*
 {"ICBC":"中国工商银行","ABC":"中国农业银行","BOC":"中国银行","CCB":"中国建设银行","PSBC":"中国邮政储蓄银行","COMM":"交通银行","CMB":"招商银行","CIB":"兴业银行","HXBANK":"华夏银行","GDB":"广东发展银行","CMBC":"中国民生银行","CITIC":"中信银行","CEB":"中国光大银行","EGBANK":"恒丰银行","CZBANK":"浙商银行","BOHAIB":"渤海银行","SPABANK":"平安银行","BSB":"包商银行"}
 */

@interface BankCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView    *bankTableView;
@property (nonatomic, strong) NSMutableArray *bankCardList;

@end

@implementation BankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    self.baseTitle = @"我的银行卡";
    self.rightImageName = @"add_card_gray";
    
    [self.view addSubview:self.bankTableView];
    [self loadBankCardsData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZYHelper sharedZYHelper].isUpdateBankList) {
        [self loadBankCardsData];
        [ZYHelper sharedZYHelper].isUpdateBankList = NO;
    }
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
    return IS_IPAD?130:95;
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
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@",kUserTokenValue];
    [TCHttpRequest postMethodWithURL:kMyBankCardAPI body:body success:^(id json) {
        NSArray *data = [json objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            BankModel *model = [[BankModel alloc] init];
            model.bankName = dict[@"bank"];
            model.bankNum = dict[@"card_no"];
            NSString *cardCode = dict[@"label"];
            if (kIsEmptyString(cardCode)) {
                model.cardImage = @"bank";
                model.cardImage = @"bank2";
            }else{
                model.cardImage = cardCode;
                model.cardBgImage = [NSString stringWithFormat:@"%@2",cardCode];
            }
            [tempArr addObject:model];
        }
        weakSelf.bankCardList = tempArr;
        [weakSelf.bankTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
}

#pragma mark -- Getters
#pragma mark 银行卡列表
-(UITableView *)bankTableView{
    if (!_bankTableView) {
        _bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+10, kScreenWidth, kScreenHeight-kNavHeight-10) style:UITableViewStylePlain];
        _bankTableView.dataSource = self;
        _bankTableView.delegate = self;
        _bankTableView.tableFooterView = [[UIView alloc] init];
        _bankTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _bankTableView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _bankTableView;
}

-(NSMutableArray *)bankCardList{
    if (!_bankCardList) {
        _bankCardList = [[NSMutableArray alloc] init];
    }
    return _bankCardList;
}


@end
