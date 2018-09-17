//
//  MyOrderViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderDetailsViewController.h"
#import "SlideMenuView.h"
#import "OrderTableViewCell.h"

@interface MyOrderViewController ()<SlideMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray      *stateArray;
    NSInteger    selectedIndex;
}

@property (nonatomic, strong) SlideMenuView     *titleView;
@property (nonatomic, strong) SlideMenuView     *orderMenuView;
@property (nonatomic ,strong) UITableView       *orderTableView;

@property (nonatomic, strong) NSMutableArray   *checkArray;
@property (nonatomic, strong) NSMutableArray   *tutorialArray;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    stateArray = @[@"全部",@"待付款",@"已完成",@"已取消"];
    selectedIndex = 0;
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.orderMenuView];
    [self.view addSubview:self.orderTableView];
    
    [self loadOrderInfo];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return selectedIndex==0?self.checkArray.count:self.tutorialArray.count;
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
    
    OrderModel *model = nil;
    if (selectedIndex==0) {
        model = self.checkArray[indexPath.section];
    }else{
        model = self.tutorialArray[indexPath.section];
    }
    cell.myOrder = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *myOrder = nil;
    if (selectedIndex==0) {
        myOrder = self.checkArray[indexPath.section];
    }else{
        myOrder = self.tutorialArray[indexPath.section];
    }
    return myOrder.state==5?110:150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *myOrder = nil;
    if (selectedIndex==0) {
        myOrder = self.checkArray[indexPath.section];
    }else{
        myOrder = self.tutorialArray[indexPath.section];
    }
    OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc] init];
    orderDetailsVC.orderModel = myOrder;
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}

#pragma mark -- Delegate
#pragma mark SlideMenuViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    selectedIndex = index;
    [self loadOrderInfo];
    
}

#pragma mark -- Private Methods
#pragma mark
-(void)loadOrderInfo{
    NSArray *names =@[@"小美",@"张三",@"李四",@"王五",@"小芳",@"王五",@"小芳",@"王五",@"小芳"];
    NSArray *grades = @[@"一年级",@"二年级",@"三年级",@"二年级",@"一年级",@"三年级",@"一年级",@"三年级",@"二年级"];
    NSMutableArray *tempCheckArr = [[NSMutableArray alloc] init];
    NSMutableArray *tempTutorialArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<names.count; i++) {
        OrderModel *model = [[OrderModel alloc] init];
        model.type = i%2;
        model.head_image = @"photo";
        model.name = names[i];
        model.grade = grades[i];
        model.images = @[@""];
        model.state = i%3;
        model.create_time = @"2018/09/04 12:30";
        model.payPrice = 5.0+i*0.5;
        model.subject = @"数学";
        model.check_price = (double)i*5+10;
        model.perPrice = 1.0 + i*0.1;
        model.duration = 85+i*10;
        model.pay_price = (double)(i*15+5);
        model.order_sn = @"201878906547812";
        model.payway = i%3;
        model.video_cover = @"zuoye";
        model.payTime = [NSString stringWithFormat:@"2018-08-%02ld %02ld:%02ld",15+i,10+i,i*5];
        
        if (model.type==0) {
            [tempCheckArr addObject:model];
        }else{
            [tempTutorialArr addObject:model];
        }
    }
    self.checkArray = tempCheckArr;
    self.tutorialArray = tempTutorialArr;
    [self.orderTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 标题栏
-(SlideMenuView *)titleView{
    if (!_titleView) {
        _titleView = [[SlideMenuView alloc] initWithFrame:CGRectMake((kScreenWidth -200)/2, KStatusHeight, 200, kNavHeight-KStatusHeight) btnTitleFont:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16] color:[UIColor colorWithHexString:@"#4A4A4A"] selColor:[UIColor colorWithHexString:@"#FF6161"] showLine:NO];
        _titleView.isShowUnderLine = YES;
        _titleView.myTitleArray = @[@"作业检查",@"作业辅导"];
        _titleView.currentIndex = selectedIndex;
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
        _orderMenuView.currentIndex = 0;
        _orderMenuView.delegate = self;
        _orderMenuView.backgroundColor = [UIColor whiteColor];
    }
    return _orderMenuView;
}

#pragma mark 订单列表
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+45, kScreenWidth, kScreenHeight-kNavHeight-40) style:UITableViewStyleGrouped];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.estimatedSectionFooterHeight = 0.0;
        _orderTableView.estimatedSectionHeaderHeight = 0.0;
        
        
    }
    return _orderTableView;
}

#pragma mark 检查订单
-(NSMutableArray *)checkArray{
    if (!_checkArray) {
        _checkArray = [[NSMutableArray alloc] init];
    }
    return _checkArray;
}

#pragma mark 辅导订单
-(NSMutableArray *)tutorialArray{
    if (!_tutorialArray) {
        _tutorialArray = [[NSMutableArray alloc] init];
    }
    return _tutorialArray;
}


@end
