//
//  MyOrderViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderDetailsViewController.h"
#import "JobCheckViewController.h"
#import "JobTutorialViewController.h"
#import "SlideMenuView.h"
#import "OrderTableViewCell.h"
#import "HomeworkModel.h"
#import "MJRefresh.h"
#import "ConnecttingViewController.h"
#import "CancelViewController.h"

@interface MyOrderViewController ()<SlideMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray      *stateArray;
    NSArray      *cateArray;
    NSInteger    typeSelectIndex;
    NSInteger    orderSelectIndex;
    
    NSInteger    page;
}

@property (nonatomic, strong) SlideMenuView     *titleView;
@property (nonatomic, strong) SlideMenuView     *orderMenuView;
@property (nonatomic ,strong) UITableView       *orderTableView;

@property (nonatomic ,strong) UIImageView       *blankView; //空白页

@property (nonatomic, strong) NSMutableArray   *orderListData;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    stateArray = @[@"全部",@"进行中",@"待付款",@"已完成",@"已取消"];
    cateArray = @[@"all",@"doing",@"nopay",@"complete",@"cancel"];
    typeSelectIndex = 0;
    orderSelectIndex = 0;
    page =1;
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.orderMenuView];
    [self.view addSubview:self.orderTableView];
    [self.orderTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
    
    [self loadOrderInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZYHelper sharedZYHelper].isUpdateOrderList) {
        [self loadOrderInfo];
        [ZYHelper sharedZYHelper].isUpdateOrderList = NO;
    }
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderListData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MyOrderTableViewCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrderModel *model = self.orderListData[indexPath.section];
    cell.myOrder = model;
    
    cell.cancelButton.tag = indexPath.section;
    [cell.cancelButton addTarget:self action:@selector(cancelOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.checkButton.tag = indexPath.section;
    [cell.checkButton addTarget:self action:@selector(checkActionForOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = self.orderListData[indexPath.section];
    if ([model.status integerValue]==0) {
        return 155;
    }else{
       return 112;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *myOrder = self.orderListData[indexPath.section];
    OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc] init];
    orderDetailsVC.orderId = myOrder.oid;
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}

#pragma mark -- Delegate
#pragma mark SlideMenuViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    if (menuView == self.titleView) {
        typeSelectIndex = index;
        orderSelectIndex = 0;
        self.orderMenuView.currentIndex = orderSelectIndex;
    }else{
        orderSelectIndex = index;
    }
    [self loadNewOrderData];
}

#pragma mark -- Event Response
#pragma mark 继续检查或继续辅导
-(void)checkActionForOrder:(UIButton *)sender{
    OrderModel *myOrder = self.orderListData[sender.tag];
    if ([myOrder.label integerValue]==1) {
        JobCheckViewController *checkVC = [[JobCheckViewController alloc] init];
        checkVC.jobId = myOrder.jobid;
        checkVC.orderId = myOrder.oid;
        checkVC.jobPics = myOrder.job_pic;
        checkVC.label = myOrder.label;
        checkVC.third_id = myOrder.third_id;
        [self.navigationController pushViewController:checkVC animated:YES];
    }else{
        kSelfWeak;
        NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,myOrder.jobid];
        [TCHttpRequest postMethodWithURL:kHomeworkDetailsAPI body:body success:^(id json) {
            NSDictionary *data = [json objectForKey:@"data"];
            HomeworkModel *model = [[HomeworkModel alloc] init];
            [model setValues:data];
            model.job_pic = myOrder.job_pic;
            model.label = myOrder.label;
            model.orderId = myOrder.oid;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ConnecttingViewController *connenttingVC = [[ConnecttingViewController alloc] initWithCallee:model.third_id];
                connenttingVC.isOrderIn = YES;
                connenttingVC.homework = model;
                [weakSelf.navigationController pushViewController:connenttingVC animated:YES];
            });
            
        }];
         
        
    }
}

#pragma mark 取消订单
-(void)cancelOrderAction:(UIButton *)sender{
    OrderModel *myOrder = self.orderListData[sender.tag];
    CancelViewController *cancelVC = [[CancelViewController alloc] init];
    cancelVC.oid = myOrder.oid;
    cancelVC.jobid = myOrder.jobid;
    cancelVC.myTitle = [myOrder.label integerValue]<2?@"取消检查":@"取消辅导";
    cancelVC.type = [myOrder.label integerValue]<2?CancelTypeOrderCheck:CancelTypeOrderCoach;
    [self.navigationController pushViewController:cancelVC animated:YES];
}

#pragma mark 左右滑动
-(void)swipOrderTableView:(UISwipeGestureRecognizer *)gesture{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            orderSelectIndex++;
            if (orderSelectIndex>stateArray.count-1) {
                orderSelectIndex=stateArray.count;
                return;
            }
        }break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            orderSelectIndex--;
            if (orderSelectIndex<0) {
                orderSelectIndex=0;
                return;
            }
        }
        default:
            break;
    }
    
    self.orderMenuView.currentIndex = orderSelectIndex;
    [self loadNewOrderData];
}

#pragma mark -- Private Methods
#pragma mark 加载最新订单
-(void)loadNewOrderData{
    page =1;
    [self loadOrderInfo];
}

#pragma mark 加载更多订单
-(void)loadMoreOrderData{
    page++;
    [self loadOrderInfo];
}

#pragma mark 加载订单数据
-(void)loadOrderInfo{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&label=%ld&cate=%@&page=%ld",kUserTokenValue,typeSelectIndex+1,cateArray[orderSelectIndex],page];
    [TCHttpRequest postMethodWithURL:kMyOrderAPI body:body success:^(id json) {
        NSArray *data = [json objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            OrderModel *order = [[OrderModel alloc] init];
            [order setValues:dict];
            [tempArr addObject:order];
        }
        if (page==1) {
            _orderListData = tempArr;
        }else{
            [_orderListData addObjectsFromArray:tempArr];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.orderTableView.mj_footer.hidden = data.count<20;
            weakSelf.blankView.hidden = data.count>0;
            [weakSelf.orderTableView reloadData];
            [weakSelf.orderTableView.mj_header endRefreshing];
            [weakSelf.orderTableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark -- Getters
#pragma mark 标题栏
-(SlideMenuView *)titleView{
    if (!_titleView) {
        _titleView = [[SlideMenuView alloc] initWithFrame:CGRectMake((kScreenWidth -200)/2, KStatusHeight, 200, kNavHeight-KStatusHeight) btnTitleFont:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16] color:[UIColor colorWithHexString:@"#4A4A4A"] selColor:[UIColor colorWithHexString:@"#FF6161"] showLine:NO];
        _titleView.isShowUnderLine = YES;
        _titleView.myTitleArray = @[@"作业检查",@"作业辅导"];
        _titleView.currentIndex = typeSelectIndex;
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.delegate = self;
    }
    return _titleView;
}

#pragma mark 订单状态栏
-(SlideMenuView *)orderMenuView{
    if (!_orderMenuView) {
        _orderMenuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, kNavHeight+5, kScreenWidth, 40) btnTitleFont:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:13] color:[UIColor colorWithHexString:@"#9B9B9B "] selColor:nil showLine:NO];
        _orderMenuView.myTitleArray = stateArray;
        _orderMenuView.currentIndex = orderSelectIndex;
        _orderMenuView.delegate = self;
        _orderMenuView.backgroundColor = [UIColor whiteColor];
    }
    return _orderMenuView;
}

#pragma mark 订单列表
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+45, kScreenWidth, kScreenHeight-kNavHeight-45) style:UITableViewStyleGrouped];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.showsVerticalScrollIndicator = NO;
        _orderTableView.estimatedSectionFooterHeight = 0.0;
        _orderTableView.estimatedSectionHeaderHeight = 0.0;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UISwipeGestureRecognizer *leftSwipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipOrderTableView:)];
        leftSwipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [_orderTableView addGestureRecognizer:leftSwipGesture];
        
        UISwipeGestureRecognizer *rightSwipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipOrderTableView:)];
        rightSwipGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [_orderTableView addGestureRecognizer:rightSwipGesture];
        
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrderData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _orderTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderData)];
        footer.automaticallyRefresh = NO;
        _orderTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _orderTableView;
}

#pragma mark 空白页
-(UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-149)/2.0,70, 149, 127)];
        _blankView.image = [UIImage imageNamed:@"default_order"];
    }
    return _blankView;
}

#pragma mark 检查订单
-(NSMutableArray *)orderListData{
    if (!_orderListData) {
        _orderListData = [[NSMutableArray alloc] init];
    }
    return _orderListData;
}


@end
