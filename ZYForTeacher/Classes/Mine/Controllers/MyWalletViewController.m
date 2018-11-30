//
//  MyWalletViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/30.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WithdrawViewController.h"
#import "WalletDetailsViewController.h"
#import "BillTableViewCell.h"
#import "BillHeaderView.h"
#import "FilterViewController.h"
#import "NSDate+Extension.h"
#import "STPopupController.h"
#import "MJRefresh.h"
#import "CustomDatePickerView.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BillHeaderViewDelegate>{
    UILabel   *balanceLabel;
    double    balance;
    NSInteger label; //1检查2辅导3提现4全部
    NSInteger page;
    NSString  *dateStr;
}

@property (nonatomic ,strong) UIScrollView   *rootScrollView;
@property (nonatomic ,strong) UIView         *balanceView;
@property (nonatomic ,strong) UIView         *navBarView;     //导航栏
@property (nonatomic ,strong) UITableView    *detailsTableView;  //明细
@property (nonatomic ,strong) BillHeaderView *headerView;
@property (nonatomic ,strong) BillHeaderView *headerCoverView;

@property (nonatomic ,strong) UIImageView       *blankView; //空白页

@property (nonatomic, strong) NSMutableArray  *detailsData;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    page=1;
    label=4;
    
    
    [self initMyWalletView];
    
    [self loadWalletDetailsData];
}

#pragma mark 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailsData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BillTableViewCell";
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    BillModel *model = self.detailsData[indexPath.row];
    cell.myBill = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BillModel *model = self.detailsData[indexPath.row];
    
    WalletDetailsViewController *walletDetailsVC = [[WalletDetailsViewController alloc] init];
    walletDetailsVC.incomeNo = model.income_no;
    [self.navigationController pushViewController:walletDetailsVC animated:YES];
}


#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.rootScrollView) {
        if (self.rootScrollView.contentOffset.y > self.balanceView.bottom) {
            self.headerCoverView.hidden = NO;
        }else{
            self.headerCoverView.hidden = YES;
        }
    }
}

#pragma mark -- BillHeaderViewDelegate
-(void)billHeaderView:(BillHeaderView *)headerView didFilterForTag:(NSInteger)tag{
    if (tag==0) { //筛选
        FilterViewController *filterVC = [[FilterViewController alloc] init];
        filterVC.transactionType = label;
        kSelfWeak;
        filterVC.backBlock = ^(id object) {
            dateStr = nil;
            label = [object integerValue];
            [weakSelf loadNewDetailsData];
        };
        STPopupController *popupVC = [[STPopupController alloc] initWithRootViewController:filterVC];
        popupVC.style = STPopupStyleBottomSheet;
        popupVC.navigationBarHidden = YES;
        [popupVC presentInViewController:self];
    }else{ // 时间
        kSelfWeak;
        NSString *currentMonth = kIsEmptyString(dateStr)?[NSDate currentYearMonth]:dateStr;
        [CustomDatePickerView showDatePickerWithTitle:@"选择时间" defauldValue:currentMonth minDateStr:@"2018-08" maxDateStr:[NSDate currentYearMonth] resultBlock:^(NSString *selectValue) {
            MyLog(@"selectValue:%@",selectValue);
            label = 4;
            dateStr = selectValue;
            [weakSelf loadNewDetailsData];
        }];
    }
}

#pragma mark -- Event response
#pragma mark 提现
-(void)toWithdrawAction{
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    withdrawVC.amount = balance;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载最新明细数据
-(void)loadNewDetailsData{
    page=1;
    [self loadWalletDetailsData];
}

-(void)loadMoreDetailsData{
    page++;
    [self loadWalletDetailsData];
}

#pragma mark 加载账单数据
-(void)loadWalletDetailsData{
    kSelfWeak;
    NSString *body = kIsEmptyString(dateStr)?[NSString stringWithFormat:@"token=%@&label=%ld&page=%ld",kUserTokenValue,label,page]:[NSString stringWithFormat:@"token=%@&label=%ld&page=%ld&date=%@",kUserTokenValue,label,page,dateStr];
    [TCHttpRequest postMethodWithURL:kWalletDetailsAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        //余额
        NSDictionary *balanceInfo = [data valueForKey:@"userinfo"];
        balance = [[balanceInfo valueForKey:@"money"] doubleValue];
        
        //明细
        NSArray *details = [data valueForKey:@"bill"];  //明细
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in details) {
            BillModel *model = [[BillModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        if (page==1) {
            weakSelf.detailsData = tempArr;
        }else{
            [weakSelf.detailsData addObjectsFromArray:tempArr];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            balanceLabel.text = [NSString stringWithFormat:@"%.2f",balance];
            weakSelf.rootScrollView.mj_footer.hidden = details.count<20;
            weakSelf.blankView.hidden = data.count>0&&details.count>0;
            [weakSelf.detailsTableView reloadData];
            weakSelf.detailsTableView.frame = CGRectMake(0, self.balanceView.bottom, kScreenWidth, tempArr.count*68+46);
            weakSelf.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.detailsTableView.top+self.detailsTableView.height);
            [weakSelf.rootScrollView.mj_header endRefreshing];
            [weakSelf.rootScrollView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark 初始化界面
-(void)initMyWalletView{
    [self.view addSubview:self.rootScrollView];
    [self.view addSubview:self.navBarView];
    [self.rootScrollView addSubview:self.balanceView];
    [self.rootScrollView addSubview:self.detailsTableView];
    self.detailsTableView.tableHeaderView = self.headerView;
    
    [self.rootScrollView addSubview:self.blankView];
    self.blankView.hidden = YES;
    
    
    [self.view addSubview:self.headerCoverView];
    self.headerCoverView.hidden = YES;
}

#pragma mark -- Getters
#pragma mark
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.delegate = self;
        
        if (@available(iOS 11.0, *)) {
            _rootScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDetailsData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _rootScrollView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDetailsData)];
        footer.automaticallyRefresh = NO;
        _rootScrollView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _rootScrollView;
}

#pragma mark 账户余额
-(UIView *)balanceView{
    if (!_balanceView) {
        _balanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 183)];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_balanceView.bounds];
        bgImageView.image = [UIImage imageNamed:@"wallet_background"];
        [_balanceView addSubview:bgImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,30, kScreenWidth-120, 22)];
        titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"账户余额（元）";
        [_balanceView addSubview:titleLabel];
        
        
        balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,titleLabel.bottom+2.0, kScreenWidth-60, 48)];
        balanceLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:34];
        balanceLabel.textColor = [UIColor whiteColor];
        balanceLabel.textAlignment = NSTextAlignmentCenter;
        [_balanceView addSubview:balanceLabel];
        
        UIButton *withdrawBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-103)/2.0, balanceLabel.bottom+19, 103, 33)];
        withdrawBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        withdrawBtn.layer.borderWidth = 1.0;
        withdrawBtn.layer.cornerRadius = 2.0;
        [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        withdrawBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        [withdrawBtn addTarget:self action:@selector(toWithdrawAction) forControlEvents:UIControlEventTouchUpInside];
        [_balanceView addSubview:withdrawBtn];
    }
    return _balanceView;
}

#pragma mark 导航栏
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        _navBarView.backgroundColor = [UIColor colorWithHexString:@"#FF6161"];
        
        UIButton *leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [leftBtn setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:leftBtn];
        
        UILabel  *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight, 180, 44)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"我的钱包";
        [_navBarView addSubview:titleLabel];
    }
    return _navBarView;
}

#pragma mark 明细
-(UITableView *)detailsTableView{
    if (!_detailsTableView) {
        _detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.balanceView.bottom, kScreenWidth, kScreenHeight-self.balanceView.bottom) style:UITableViewStylePlain];
        _detailsTableView.delegate = self;
        _detailsTableView.dataSource = self;
        _detailsTableView.showsVerticalScrollIndicator = NO;
        _detailsTableView.scrollEnabled = NO;
        _detailsTableView.estimatedSectionHeaderHeight = 0;
        _detailsTableView.estimatedSectionFooterHeight = 0;
        _detailsTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _detailsTableView;
}

#pragma mark 明细头部视图
-(BillHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[BillHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark 明细头部视图
-(BillHeaderView *)headerCoverView{
    if (!_headerCoverView) {
        _headerCoverView = [[BillHeaderView alloc] initWithFrame:CGRectMake(0,kNavHeight, kScreenWidth, 46)];
        _headerCoverView.delegate = self;
    }
    return _headerCoverView;
}

#pragma mark 空白页
-(UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-149)/2.0,self.balanceView.bottom+90, 149, 127)];
        _blankView.image = [UIImage imageNamed:@"default_bill"];
    }
    return _blankView;
}

#pragma mark 账单数据
-(NSMutableArray *)detailsData{
    if (!_detailsData) {
        _detailsData = [[NSMutableArray alloc] init];
    }
    return _detailsData;
}


@end
