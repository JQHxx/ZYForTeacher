//
//  MainViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MainViewController.h"
#import "MineViewController.h"
#import "MessagesViewController.h"
#import "YBUnlimitedSlideViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CheckViewController.h"
#import "TutorialViewController.h"
#import "ConnecttingViewController.h"
#import "JobDetailsViewController.h"

#import "RequestConnectionViewController.h"
#import "TutoringEndViewController.h"
#import "SlideMenuView.h"
#import "TutorialTableViewCell.h"

@interface MainViewController ()<YBUnlimitedSlideViewControllerDelegate,SlideMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIButton    *myButton;
    
    BOOL        isShowOrderList;
    
    NSInteger    selectedIndex;
}

@property (nonatomic , strong) UIImageView     *bgImageView;         //头部背景
@property (nonatomic , strong) UIView          *navBarView;          //导航栏
@property (nonatomic, strong) YBUnlimitedSlideViewController *unlimitedSlideVC;
@property (nonatomic, strong)SlideMenuView     *titleView;
@property (nonatomic, strong) UITableView      *orderTableView;
@property (nonatomic, strong) UIView           *bottomView;

@property (nonatomic, strong) NSMutableArray  *checkOrderArray;              //作业检查
@property (nonatomic, strong) NSMutableArray  *tutorialReceivedOrderArray;   //作业辅导（已接单）
@property (nonatomic, strong) NSMutableArray  *tutorialRealTimeArray;        //作业辅导（已接单）
@property (nonatomic, strong) NSMutableArray  *tutorialReserveOrderArray;    //作业辅导（预约）

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = 0;
    
    [self initHomeView];
    [self loadAllOrderData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (selectedIndex==0) {
        return 1;
    }else{
        return self.tutorialReceivedOrderArray.count > 0?3:2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (selectedIndex==0) {
        return self.checkOrderArray.count;
    }else{
        if (self.tutorialReserveOrderArray.count>0) {
            if (section==0) {
                return self.tutorialReserveOrderArray.count;
            }else if (section==1){
                return self.tutorialRealTimeArray.count;
            }else{
                return self.tutorialReserveOrderArray.count;
            }
        }else{
            if (section==0){
                return self.tutorialRealTimeArray.count;
            }else{
                return self.tutorialReserveOrderArray.count;
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (selectedIndex==0) {
        return nil;
    }else{
        if (self.tutorialReserveOrderArray.count>0) {
            if (section==0) {
                return @"  已接单";
            }else if (section==1){
                return @"  实时";
            }else{
                return @"  预约";
            }
        }else{
            if (section==0){
                return @"  实时";
            }else{
                return @"  预约";
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TutorialTableViewCell";
    TutorialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[TutorialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrderModel *model = nil;
    if (selectedIndex == 0) {
        model = self.checkOrderArray[indexPath.row];
    }else{
        if (self.tutorialReceivedOrderArray.count>0) {
            if (indexPath.section==0) {
                model = self.tutorialReceivedOrderArray[indexPath.row];
            }else if (indexPath.section==1){
                model = self.tutorialRealTimeArray[indexPath.row];
            }else{
                model = self.tutorialReserveOrderArray[indexPath.row];
            }
        }else{
            if (indexPath.section==0){
                model = self.tutorialRealTimeArray[indexPath.row];
            }else{
                model = self.tutorialReserveOrderArray[indexPath.row];
            }
        }
    }
    [cell cellDisplayWithModel:model selIndex:selectedIndex];
    
    cell.cellButton.tag = indexPath.section*1000+indexPath.row;
    [cell.cellButton addTarget:self action:@selector(checkOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex==0) {
        return 70;
    }else{
        if (self.tutorialReceivedOrderArray.count>0) {
            if (indexPath.section==0) {
                return 110;
            }else if (indexPath.section==1){
                return 70;
            }else{
                return 110;
            }
        }else{
            if (indexPath.section==0){
                return 70;
            }else{
                return 110;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (selectedIndex==0) {
        return 5.0;
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = nil;
    if (selectedIndex == 0) {
        model = self.checkOrderArray[indexPath.row];
    }else{
        if (self.tutorialReceivedOrderArray.count>0) {
            if (indexPath.section==0) {
                model = self.tutorialReceivedOrderArray[indexPath.row];
            }else if (indexPath.section==1){
                model = self.tutorialRealTimeArray[indexPath.row];
            }else{
                model = self.tutorialReserveOrderArray[indexPath.row];
            }
        }else{
            if (indexPath.section==0){
                model = self.tutorialRealTimeArray[indexPath.row];
            }else{
                model = self.tutorialReserveOrderArray[indexPath.row];
            }
        }
    }
    JobDetailsViewController *jobDetailsVC = [[JobDetailsViewController alloc] init];
    jobDetailsVC.orderInfo = model;
    [self.navigationController pushViewController:jobDetailsVC animated:YES];
}


#pragma mark -- YBUnlimitedSlideViewControllerDelegate
#pragma mark
-(NSMutableArray *)dataSourceArray{
    NSArray *array = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    return [NSMutableArray arrayWithArray:array];
}

#pragma mark 滚动视图宽高
-(CGSize)getScrollerViewForWidthAndHeight{
    return CGSizeMake(kScreenWidth-20, kScreenHeight-kNavHeight-120);
}

#pragma mark -- ItemGroupViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    selectedIndex = index;
    [self.orderTableView reloadData];
}

#pragma mark -- Event Response
#pragma mark 导航栏左侧按钮
-(void)leftNavigationItemAction{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark 导航栏右侧按钮
-(void)rightNavigationItemAction{
    MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
    [self.navigationController pushViewController:messagesVC animated:YES];
}

#pragma mark 去检查或去辅导
-(void)checkOrderAction:(UIButton *)sender{
    MyLog(@"%ld",sender.tag);
    
    if (selectedIndex==0) {
        OrderModel *model = self.checkOrderArray[sender.tag];
        CheckViewController *checkVC = [[CheckViewController alloc] init];
        checkVC.myOrder = model;
        [self.navigationController pushViewController:checkVC animated:YES];
    }else{
        OrderModel *model = nil;
        NSInteger section = sender.tag/1000;
        NSInteger index = sender.tag%1000;
        if (self.tutorialReceivedOrderArray.count>0) {
            if (section==0) {
                model = self.tutorialReceivedOrderArray[index];
            }else if (index==1){
                model = self.tutorialRealTimeArray[index];
            }else{
                model = self.tutorialReserveOrderArray[index];
            }
        }else{
            if (section==0) {
                model = self.tutorialRealTimeArray[index];
            }else{
                model = self.tutorialReserveOrderArray[index];
            }
        }
        if (self.tutorialReceivedOrderArray.count>0&&section==0) {
            TutorialViewController *tutorialVC = [[TutorialViewController alloc] init];
            tutorialVC.myOrder = model;
            [self.navigationController pushViewController:tutorialVC animated:YES];
        }else{
            
            TutoringEndViewController *connecttingVC = [[TutoringEndViewController alloc] init];
//            ConnecttingViewController *connecttingVC = [[ConnecttingViewController alloc] init];
//            connecttingVC.orderModel = model;
            [self.navigationController pushViewController:connecttingVC animated:YES];
        }
    }
}

#pragma mark 开启或关闭在线辅导
-(void)turnOnlineTutoringAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    isShowOrderList = sender.selected;
    [self initHomeView];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initHomeView{
    if (isShowOrderList) {
        myButton.backgroundColor = [UIColor lightGrayColor];
        
        self.isHiddenNavBar = NO;
        self.baseTitle = @"";
        self.isHiddenBackBtn = YES;
        self.rightImageName =@"home_news_gray";
        self.leftImageName = @"home_my_gray";
        
        [self.bgImageView removeFromSuperview];
        [self.navBarView removeFromSuperview];
        [self.unlimitedSlideVC removeFromParentViewController];
        [self.unlimitedSlideVC.view removeFromSuperview];
        self.bgImageView = nil;
        self.navBarView = nil;
        self.unlimitedSlideVC = nil;
        
        
        [self.view addSubview:self.titleView];
        [self.view addSubview:self.orderTableView];
        selectedIndex = 0;
    }else{
        myButton.backgroundColor = [UIColor greenColor];
        self.isHiddenNavBar = YES;
        
        [self.view addSubview:self.bgImageView];
        [self.view addSubview:self.navBarView];
        [self addChildViewController:self.unlimitedSlideVC];
        [self.view addSubview:self.unlimitedSlideVC.view];
        
        [self.titleView removeFromSuperview];
        [self.orderTableView removeFromSuperview];
        self.titleView = nil;
        self.orderTableView = nil;
    }
    [self.view addSubview:self.bottomView];
}

-(void)loadAllOrderData{
    
    //作业检查
    NSArray *names =@[@"小美",@"张三",@"李四",@"王五",@"小芳",@"王五",@"小芳",@"王五",@"小芳"];
    NSArray *grades = @[@"一年级",@"二年级",@"三年级",@"二年级",@"一年级",@"三年级",@"一年级",@"三年级",@"二年级"];
    for (NSInteger i=0; i<names.count; i++) {
        OrderModel *model = [[OrderModel alloc] init];
        model.type = 0;
        model.head_image = @"ic_m_head";
        model.name = names[i];
        model.grade = grades[i];
        model.images = @[@""];
        model.state = 0;
        model.check_price = 2.0 - 0.2*i;
        [self.checkOrderArray addObject:model];
    }
   
    //作业辅导
    for (NSInteger i=0; i<names.count; i++) {
        OrderModel *model = [[OrderModel alloc] init];
        model.type = 1;
        model.head_image = @"ic_m_head";
        model.name = names[i];
        model.grade = grades[i];
        model.images = @[@""];
        model.time_type = i%2;
        model.state = i==2||i==3||i==5?1:0;
        model.received_state = i%2;
        model.perPrice = 2.0 - 0.2*i;
        if (model.state==1) {
            model.order_time = [NSString stringWithFormat:@"今天 %02ld:%02ld",14+i,i*5];
            [self.tutorialReceivedOrderArray addObject:model];
        }else{
            if (model.time_type==0) {
                [self.tutorialRealTimeArray addObject:model];
            }else{
                model.order_time = [NSString stringWithFormat:@"今天 %02ld:%02ld",18+i,i*10];
                [self.tutorialReserveOrderArray addObject:model];
            }
        }
    }
     [self.orderTableView reloadData];
    
}

#pragma mark -- Getters and Setters
#pragma mark 头部背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:@"background1"];
    }
    return _bgImageView;
}

#pragma mark 导航栏
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        
        UIButton *leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [leftBtn setImage:[UIImage drawImageWithName:@"home_my"size:CGSizeMake(24, 24)] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:leftBtn];
        
        UILabel  *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight, 180, 44)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"首页";
        [_navBarView addSubview:titleLabel];
        
        UIButton *rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, KStatusHeight+2, 40, 40)];
        [rightBtn setImage:[UIImage drawImageWithName:@"home_news" size:CGSizeMake(24, 24)] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:rightBtn];
    }
    return _navBarView;
}



#pragma mark 滚动图片视图
-(YBUnlimitedSlideViewController *)unlimitedSlideVC{
    if (!_unlimitedSlideVC) {
        _unlimitedSlideVC = [[YBUnlimitedSlideViewController alloc] init];
        _unlimitedSlideVC.isPageControl = YES;
        _unlimitedSlideVC.delegate = self;
        _unlimitedSlideVC.view.frame = CGRectMake(10, kNavHeight+30, kScreenWidth-20, kScreenHeight-kNavHeight-120);
    }
    return _unlimitedSlideVC;
}

#pragma mark 头部
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

#pragma mark 辅导订单
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-60) style:UITableViewStyleGrouped];
        _orderTableView.dataSource = self;
        _orderTableView.delegate = self;
        _orderTableView.estimatedSectionHeaderHeight = 0;
        _orderTableView.estimatedSectionFooterHeight = 0;
        _orderTableView.showsVerticalScrollIndicator = NO;
        if ([_orderTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _orderTableView.separatorInset = UIEdgeInsetsZero;
        }
    }
    return _orderTableView;
}

#pragma mark 底部视图
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 60)];
        _bottomView.backgroundColor = [UIColor bgColor_Gray];
        
        myButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-40, 40)];
        myButton.backgroundColor = [UIColor greenColor];
        [myButton setTitle:@"开启在线辅导" forState:UIControlStateNormal];
        [myButton setTitle:@"关闭在线辅导" forState:UIControlStateSelected];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(turnOnlineTutoringAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:myButton];
    }
    return _bottomView;
}

#pragma mark 检查订单列表
-(NSMutableArray *)checkOrderArray{
    if (!_checkOrderArray) {
        _checkOrderArray = [[NSMutableArray alloc] init];
    }
    return _checkOrderArray;
}

#pragma mark 辅导订单(已接单)
-(NSMutableArray *)tutorialReceivedOrderArray{
    if (!_tutorialReceivedOrderArray) {
        _tutorialReceivedOrderArray = [[NSMutableArray alloc] init];
    }
    return _tutorialReceivedOrderArray;
}

#pragma mark 辅导订单(实时)
-(NSMutableArray *)tutorialRealTimeArray{
    if (!_tutorialRealTimeArray) {
        _tutorialRealTimeArray = [[NSMutableArray alloc] init];
    }
    return _tutorialRealTimeArray;
}

#pragma mark 辅导订单(预约)
-(NSMutableArray *)tutorialReserveOrderArray{
    if (!_tutorialReserveOrderArray) {
        _tutorialReserveOrderArray = [[NSMutableArray alloc] init];
    }
    return _tutorialReserveOrderArray;
}



@end
