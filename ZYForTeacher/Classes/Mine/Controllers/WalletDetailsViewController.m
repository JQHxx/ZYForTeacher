//
//  WalletDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WalletDetailsViewController.h"
#import "FilterViewController.h"
#import "NSDate+Extension.h"
#import "BillTableViewCell.h"
#import "STPopupController.h"
#import "BillModel.h"

@interface WalletDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray  *detailsMonthArr;
}

@property (nonatomic, strong) UITableView     *detailsTableView;
@property (nonatomic, strong) NSMutableArray  *detailsData;

@end

@implementation WalletDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"明细";
    self.rigthTitleName = @"筛选";
    
    detailsMonthArr = [NSDate getDatesForNumberMonth:12 WithFromDate:[NSDate date]];
    
    [self.view addSubview:self.detailsTableView];
    
    [self loadWalletDetailsData];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return detailsMonthArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailsData.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return detailsMonthArr[section];
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
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


#pragma mark -- Event Response
#pragma mark 筛选
-(void)rightNavigationItemAction{
    FilterViewController *filterVC = [[FilterViewController alloc] init];
    filterVC.backBlock = ^(id object) {
        NSString *typeStr = (NSString *)object;
        MyLog(@"bill -- type：%@",typeStr);
    };
    STPopupController *popupVC = [[STPopupController alloc] initWithRootViewController:filterVC];
    popupVC.style = STPopupStyleBottomSheet;
    popupVC.navigationBarHidden = YES;
    [popupVC presentInViewController:self];
}

#pragma mark 加载账单数据
-(void)loadWalletDetailsData{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *amounts = @[@"5.00",@"20.35",@"200.00",@"5.00",@"23.00",@"54.50",@"65.25"];
    for (NSInteger i=0; i<amounts.count; i++) {
        BillModel *model = [[BillModel alloc] init];
        model.bill_type = i%3;
        model.create_time = [NSString stringWithFormat:@"8月%02ld %02ld:%02ld:%2ld",22-i,10+i%3,20+i,10+i*3];
        model.amount = [amounts[i] doubleValue];
        [tempArr addObject:model];
    }
    self.detailsData = tempArr;
    [self.detailsTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 账单列表
-(UITableView *)detailsTableView{
    if (!_detailsTableView) {
        _detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
        _detailsTableView.delegate = self;
        _detailsTableView.dataSource = self;
        _detailsTableView.estimatedSectionHeaderHeight = 0;
        _detailsTableView.estimatedSectionFooterHeight = 0;
        _detailsTableView.tableFooterView = [[UIView alloc] init];
    }
    return _detailsTableView;
}

#pragma mark 账单数据
-(NSMutableArray *)detailsData{
    if (!_detailsData) {
        _detailsData = [[NSMutableArray alloc] init];
    }
    return _detailsData;
}


@end
