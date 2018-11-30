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
#import "UIViewController+MMDrawerController.h"
#import "JobCheckViewController.h"
#import "JobTutorialViewController.h"
#import "ConnecttingViewController.h"
#import "HomeworkDetailsViewController.h"
#import "SlideMenuView.h"
#import "LoginButton.h"
#import "HomeworkView.h"
#import "HomeworkModel.h"
#import "MessagesViewController.h"
#import "UserHelpViewController.h"
#import "MJRefresh.h"
#import "UserDetailsViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface MainViewController ()<SlideMenuViewDelegate,HomeworkViewDelegate,NIMConversationManagerDelegate>{
    BOOL         isShowOrderList;
    BOOL         isLoadedData;
    NSInteger    selectedIndex;
    NSInteger    page;
    NSInteger    sessionUnreadCount;
}

@property (nonatomic , strong) UILabel         *badgeLabel;          //红点
@property (nonatomic , strong) UIImageView     *bgImageView;         //头部背景
@property (nonatomic , strong) UIView          *navBarView;          //导航栏
@property (nonatomic , strong) UIImageView     *bannerImageView;   //新手指引

@property (nonatomic, strong) SlideMenuView      *titleView;
@property (nonatomic, strong) HomeworkView       *homeworkView;
@property (nonatomic , strong) LoginButton       *startOnBtn;
@property (nonatomic, strong) UIButton           *closeOnlineBtn;

@property (nonatomic, strong) NSMutableArray  *checkOrderArray;              //作业检查
@property (nonatomic, strong) NSMutableArray  *tutorialReceivedOrderArray;   //作业辅导（已接单）
@property (nonatomic, strong) NSMutableArray  *tutorialRealTimeArray;        //作业辅导（已接单）
@property (nonatomic, strong) NSMutableArray  *tutorialReserveOrderArray;    //作业辅导（预约）

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    self.baseTitle = @"";
    self.isHiddenBackBtn = YES;
    self.rightImageName =@"home_news_gray";
    self.leftImageName = @"home_my_gray";
    
    isShowOrderList = [[NSUserDefaultsInfos getValueforKey:kIsOnline] boolValue];
    
    selectedIndex = 0;
    page = 1;
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
    [self initHomeView];
    
    if (isShowOrderList) {
        [self loadAllOrderData];
    }
    [self loadUnReadMessageData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    if ([ZYHelper sharedZYHelper].isUpdateHome) {
        [self loadAllOrderData];
        [ZYHelper sharedZYHelper].isUpdateHome = NO;
    }
    
    if ([ZYHelper sharedZYHelper].isUpdateMessageUnread) {
        [self loadUnReadMessageData];
        [ZYHelper sharedZYHelper].isUpdateMessageUnread = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAllOrderData) name:kGuideCancelNotification object:nil];
}

#pragma mark -- ItemGroupViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    selectedIndex = index;
    self.homeworkView.isTutoring = selectedIndex;
    page = 1;
    [self loadAllOrderData];
}

#pragma mark CheckZuoyeViewDelegate
#pragma mark 刷新检查作业
-(void)homeworkView:(HomeworkView *)aView loadCheckZuoyeForIsLoadNew:(BOOL)isLoadNew{
    if (isLoadNew) {
        page =1;
    }else{
        page++;
    }
    [self loadAllOrderData];
}

#pragma mark 检查作业
-(void)homeworkView:(HomeworkView *)aView didCheckZuoyeForHomework:(HomeworkModel *)homework{
    kSelfWeak;
    if ([ZYHelper sharedZYHelper].isCertified) {
        NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,homework.job_id];
        [TCHttpRequest postMethodWithURL:kJobCheckAPI body:body success:^(id json) {
            NSDictionary *data = [json objectForKey:@"data"];
            [ZYHelper sharedZYHelper].isUpdateHome = YES;
            dispatch_sync(dispatch_get_main_queue(), ^{
                JobCheckViewController *checkVC = [[JobCheckViewController alloc] init];
                checkVC.jobId = homework.job_id;
                checkVC.jobPics = homework.job_pic;
                checkVC.orderId = [data valueForKey:@"oid"];
                checkVC.third_id = homework.third_id;
                [weakSelf pushTagetViewController:checkVC];
            });
        }];
    }else{
        [self.view makeToast:@"请先完成实名认证和学历认证" duration:1.0 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UserDetailsViewController *userDetaisVC = [[UserDetailsViewController alloc] init];
            [weakSelf pushTagetViewController:userDetaisVC];
        });
    }
}

#pragma mark 作业辅导接单
-(void)homeworkView:(HomeworkView *)aView didReceivedZuoyeForHomework:(HomeworkModel *)homework{
    if ([ZYHelper sharedZYHelper].isCertified) {
        if ([homework.label integerValue]==3) {
            ConnecttingViewController *connecttingVC = [[ConnecttingViewController alloc] initWithCallee:homework.third_id];
            connecttingVC.homework = homework;
            connecttingVC.isGuideNow = YES;
            [self pushTagetViewController:connecttingVC];
        }else{
            kSelfWeak;
            NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,homework.job_id];
            [TCHttpRequest postMethodWithURL:kJobAcceptAPI body:body success:^(id json) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.view makeToast:@"接单成功" duration:1.0 position:CSToastPositionCenter];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [weakSelf loadAllOrderData];
                });
            }];
        }
    }else{
        [self.view makeToast:@"请先完成实名认证和学历认证" duration:1.0 position:CSToastPositionCenter];
        kSelfWeak;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UserDetailsViewController *userDetaisVC = [[UserDetailsViewController alloc] init];
            [weakSelf pushTagetViewController:userDetaisVC];
        });
    }
}

#pragma mark 作业辅导去辅导
-(void)homeworkView:(HomeworkView *)aView didTutoringZuoyeForHomework:(HomeworkModel *)homework{
    ConnecttingViewController *connecttingVC = [[ConnecttingViewController alloc] initWithCallee:homework.third_id];
    connecttingVC.homework = homework;
    [self pushTagetViewController:connecttingVC];
}

#pragma mark 刷新辅导订单
-(void)homeworkView:(HomeworkView *)aView didRefreshTutorialDataWtihTag:(NSInteger)myTag{
    MyLog(@"didRefreshTutorialDataWtihTag：%ld",myTag);
}

#pragma mark 查看作业详情
-(void)checkZuoyeView:(HomeworkView *)aView didClickZuoyeItemForHomework:(HomeworkModel *)homework{
    HomeworkDetailsViewController *homeworkDetailsVC = [[HomeworkDetailsViewController alloc]  init];
    homeworkDetailsVC.homeworkInfo = homework;
    [self pushTagetViewController:homeworkDetailsVC];
}

#pragma mark NIMConversationManagerDelegate
#pragma mark 增加最近会话的回调
-(void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    MyLog(@"didAddRecentSession-- totalUnreadCount:%ld",totalUnreadCount);
    sessionUnreadCount = totalUnreadCount;
    [self loadUnReadMessageData];
}

#pragma mark 最近会话修改的回调
-(void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    MyLog(@"更新会话 didUpdateRecentSession -- totalUnreadCount:%ld",totalUnreadCount);
    sessionUnreadCount = totalUnreadCount;
    [self loadUnReadMessageData];
}

#pragma mark 已读回调
-(void)allMessagesRead{
    [self loadUnReadMessageData];
}

#pragma mark -- Event Response
#pragma mark 导航栏左侧按钮
-(void)leftNavigationItemAction{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark 导航栏右侧按钮
-(void)rightNavigationItemAction{
    MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
    [self pushTagetViewController:messagesVC];
}

#pragma mark 开启或关闭在线辅导
-(void)turnOnlineTutoringAction:(UIButton *)sender{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&online=%@",kUserTokenValue,[NSNumber numberWithBool:sender.tag == 100]];
    [TCHttpRequest postMethodWithURL:kSetOnlineAPI body:body success:^(id json) {
        isShowOrderList = sender.tag == 100;
        [NSUserDefaultsInfos putKey:kIsOnline andValue:[NSNumber numberWithBool:isShowOrderList]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf initHomeView];
        });
        if (isShowOrderList) {
            [self loadAllOrderData];
        }
    }];
}

#pragma mark 新手指引
-(void)showUserHelpAction{
    UserHelpViewController *userHelpVC = [[UserHelpViewController alloc] init];
    [self pushTagetViewController:userHelpVC];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initHomeView{
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.homeworkView];
    [self.view addSubview:self.startOnBtn];
    [self.view addSubview:self.closeOnlineBtn];
    
    [self.view addSubview:self.badgeLabel];
    self.badgeLabel.hidden = YES;
    
    if (isShowOrderList) {
        [self.view addSubview:self.titleView];
        [self.view addSubview:self.closeOnlineBtn];
        
        [self.bgImageView removeFromSuperview];
        [self.navBarView removeFromSuperview];
        [self.bannerImageView removeFromSuperview];
        [self.startOnBtn removeFromSuperview];
        self.startOnBtn = nil;
        self.bgImageView = nil;
        self.navBarView = nil;
        self.bannerImageView = nil;
        
    }else{
        [self.view addSubview:self.bgImageView];
        [self.view addSubview:self.navBarView];
        [self.view addSubview:self.bannerImageView];
        [self.view addSubview:self.startOnBtn];
        
        [self.titleView removeFromSuperview];
        [self.closeOnlineBtn removeFromSuperview];
        [self.closeOnlineBtn removeFromSuperview];
        self.titleView = nil;
        self.closeOnlineBtn = nil;
    }
}

#pragma mark 加载数据
-(void)loadAllOrderData{
    kSelfWeak;
    NSString *body = nil;
    if (selectedIndex==0) {
       body = [NSString stringWithFormat:@"token=%@&page=%ld&label=1",kUserTokenValue,page];
    }else{
       body = [NSString stringWithFormat:@"token=%@&label=2",kUserTokenValue];
    }
    
    [TCHttpRequest postMethodWithURL:kHomeAPI body:body success:^(id json) {
        if (selectedIndex==0) {
            NSArray *data = [json objectForKey:@"data"];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in data) {
                HomeworkModel *model = [[HomeworkModel alloc] init];
                [model setValues:dict];
                [tempArr addObject:model];
            }
            weakSelf.checkOrderArray = tempArr;
            weakSelf.homeworkView.myZuoyeArray = weakSelf.checkOrderArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.homeworkView.myCollectionView reloadData];
                [weakSelf.homeworkView.myCollectionView.mj_header endRefreshing];
                [weakSelf.homeworkView.myCollectionView.mj_footer endRefreshing];
            });
        }else{
            NSDictionary *data = [json objectForKey:@"data"];
            NSArray *receiveArr = [data valueForKey:@"receive"];  //已接单
            NSMutableArray *tempReceivedArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in receiveArr) {
                HomeworkModel *model = [[HomeworkModel alloc] init];
                [model setValues:dict];
                [tempReceivedArr addObject:model];
            }
            weakSelf.homeworkView.tutorialReceivedArray = tempReceivedArr;
            
            //实时
            NSArray *guideNowArr = [data valueForKey:@"guide_now"];
            NSMutableArray *tempRealtimeArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in guideNowArr) {
                HomeworkModel *model = [[HomeworkModel alloc] init];
                [model setValues:dict];
                [tempRealtimeArr addObject:model];
            }
            weakSelf.homeworkView.tutorialRealTimeArray = tempRealtimeArr;
            
            //预约
            NSArray *guidePreArr = [data valueForKey:@"guide_pre"];  //预约
            NSMutableArray *tempReserveArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in guidePreArr) {
                HomeworkModel *model = [[HomeworkModel alloc] init];
                [model setValues:dict];
                [tempReserveArr addObject:model];
            }
            weakSelf.homeworkView.tutorialReserveArray = tempReserveArr;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.homeworkView.myCollectionView reloadData];
                
            });
        }
    }];
}

#pragma mark 获取未读消息信息
-(void)loadUnReadMessageData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@",kUserTokenValue];
    [TCHttpRequest postMethodWithoutLoadingForURL:kMessageUnreadAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        NSInteger count = [[data valueForKey:@"count"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.badgeLabel.hidden = count+sessionUnreadCount<1;
        });
    }];
}

#pragma mark -- Getters and Setters
#pragma mark 默认首页
#pragma mark 头部背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:@"teacher_home_background"];
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

#pragma mark 红色标记
-(UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-16, KStatusHeight+14, 8, 8)];
        _badgeLabel.boderRadius = 4.0;
        _badgeLabel.backgroundColor = [UIColor colorWithHexString:@" #F50000"];
    }
    return _badgeLabel;
}

#pragma mark 滚动图片视图
-(UIImageView *)bannerImageView{
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, KStatusHeight+64, kScreenWidth-40, kScreenHeight-KStatusHeight-150)];
        _bannerImageView.image = [UIImage imageNamed:@"banner"];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bannerImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserHelpAction)];
        [_bannerImageView addGestureRecognizer:tap];
    }
    return _bannerImageView;
}

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


#pragma mark 作业检查
-(HomeworkView *)homeworkView {
    if (!_homeworkView) {
        _homeworkView = [[HomeworkView alloc] initWithFrame:CGRectMake(0, kNavHeight+10, kScreenWidth, kScreenHeight-kNavHeight-75)];
        _homeworkView.delegate = self;
        _homeworkView.isTutoring = NO;
    }
    return _homeworkView;
}

#pragma mark 开启在线辅导
-(LoginButton *)startOnBtn{
    if (!_startOnBtn) {
        _startOnBtn = [[LoginButton alloc] initWithFrame:CGRectMake((kScreenWidth-280)/2.0, kScreenHeight-75,280, 60) title:@"开启在线辅导"];
        _startOnBtn.tag = 100;
        [_startOnBtn addTarget:self action:@selector(turnOnlineTutoringAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startOnBtn;
}

#pragma mark 关闭在线
-(UIButton *)closeOnlineBtn{
    if (!_closeOnlineBtn) {
        _closeOnlineBtn = [[UIButton alloc] initWithFrame:CGRectMake(48, kScreenHeight-50, kScreenWidth-96, 40)];
        _closeOnlineBtn.layer.cornerRadius = 21;
        [_closeOnlineBtn setTitle:@"关闭在线" forState:UIControlStateNormal];
        [_closeOnlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeOnlineBtn.backgroundColor = [UIColor blackColor];
        _closeOnlineBtn.alpha = 0.5;
        _closeOnlineBtn.tag =101;
        [_closeOnlineBtn addTarget:self action:@selector(turnOnlineTutoringAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeOnlineBtn;
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

-(void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGuideCancelNotification object:nil];
}

@end
