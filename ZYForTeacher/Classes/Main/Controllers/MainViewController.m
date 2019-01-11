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

@interface MainViewController ()<SlideMenuViewDelegate,HomeworkViewDelegate>{
    BOOL         isShowOrderList;
    BOOL         isLoadedData;
    NSInteger    selectedIndex;
    NSInteger    page;
}

@property (nonatomic , strong) UILabel         *badgeLabel;          //红点
@property (nonatomic , strong) UIImageView     *bgImageView;         //头部背景
@property (nonatomic , strong) UIView          *navBarView;          //导航栏
@property (nonatomic , strong) UIImageView     *bannerImageView;   //新手指引

@property (nonatomic, strong) SlideMenuView      *titleView;
@property (nonatomic, strong) UIView             *reminderView;
@property (nonatomic, strong) HomeworkView       *homeworkView;
@property (nonatomic , strong) LoginButton       *startOnBtn;
@property (nonatomic, strong) UIButton           *closeOnlineBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    self.baseTitle = @"";
    self.isHiddenBackBtn = YES;
    self.rightImageName = IS_IPAD?@"home_news_gray_ipad":@"home_news_gray";
    self.leftImageName = IS_IPAD?@"home_my_gray_ipad":@"home_my_gray";
    
    isShowOrderList = [[NSUserDefaultsInfos getValueforKey:kIsOnline] boolValue];
    
    selectedIndex = 0;
    page = 1;
    
    
    [self initHomeView];
    
    [self loadUnReadMessageData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"首页"];
    
    
    if (isShowOrderList) {
        [self refreshDataWithIndex:selectedIndex];
    }
    
    [self updateCertifiedReminderView];
    
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    if ([ZYHelper sharedZYHelper].isUpdateMessageUnread) {
        [self loadUnReadMessageData];
        [ZYHelper sharedZYHelper].isUpdateMessageUnread = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCertifiedReminderView) name:kAuthUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderData) name:kGuideCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCheckData) name:kCheckRecieveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGuideData) name:kGuideRecieveNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"首页"];
}

#pragma mark -- ItemGroupViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    selectedIndex = index;
    self.homeworkView.isTutoring = selectedIndex;
    [self.homeworkView.myZuoyeArray removeAllObjects];
    [self.homeworkView.tutorialReserveArray removeAllObjects];
    [self.homeworkView.tutorialRealTimeArray removeAllObjects];
    [self.homeworkView.tutorialReceivedArray removeAllObjects];
    page = 1;
    [self loadAllOrderDataForIsLoading:YES];
}

#pragma mark CheckZuoyeViewDelegate
#pragma mark 刷新检查作业
-(void)homeworkView:(HomeworkView *)aView loadCheckZuoyeForIsLoadNew:(BOOL)isLoadNew{
    if (isLoadNew) {
        page =1;
    }else{
        page++;
    }
    [self loadAllOrderDataForIsLoading:YES];
}

#pragma mark 检查作业
-(void)homeworkView:(HomeworkView *)aView didCheckZuoyeForHomework:(HomeworkModel *)homework{
    kSelfWeak;
    if ([ZYHelper sharedZYHelper].isCertified) {
        NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,homework.job_id];
        [TCHttpRequest postMethodWithURL:kJobCheckAPI body:body success:^(id json) {
            NSDictionary *data = [json objectForKey:@"data"];
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
            userDetaisVC.isHomeworkIn = YES;
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
                    [weakSelf refreshDataWithIndex:selectedIndex];
                });
            }];
        }
    }else{
        [self.view makeToast:@"请先完成实名认证和学历认证" duration:1.0 position:CSToastPositionCenter];
        kSelfWeak;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UserDetailsViewController *userDetaisVC = [[UserDetailsViewController alloc] init];
            userDetaisVC.isHomeworkIn = YES;
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
            [self loadAllOrderDataForIsLoading:YES];
        }
    }];
}

#pragma mark 新手指引
-(void)showUserHelpAction{
    UserHelpViewController *userHelpVC = [[UserHelpViewController alloc] init];
    [self pushTagetViewController:userHelpVC];
}

#pragma mark 去认证
-(void)toUserDetailsAction{
    UserDetailsViewController *userDetaisVC = [[UserDetailsViewController alloc] init];
    userDetaisVC.isHomeworkIn = YES;
    [self pushTagetViewController:userDetaisVC];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initHomeView{
    if (isShowOrderList) {
        [self.view addSubview:self.titleView];
        [self.view addSubview:self.badgeLabel];
        self.badgeLabel.hidden = YES;
        [self.view addSubview:self.homeworkView];
    
        [self.view addSubview:self.closeOnlineBtn];
        
        [self updateCertifiedReminderView];
        
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
        [self.badgeLabel removeFromSuperview];
        [self.homeworkView removeFromSuperview];
        [self.closeOnlineBtn removeFromSuperview];
        self.titleView = nil;
        self.homeworkView = nil;
        self.closeOnlineBtn = nil;
    }
}

#pragma mark 更新认证
-(void)updateCertifiedReminderView{
    MyLog(@"去认证提醒");
    if (isShowOrderList) {
        if ([ZYHelper sharedZYHelper].isCertified) {
            if (self.reminderView) {
                [self.reminderView removeFromSuperview];
                self.reminderView = nil;
            }
            self.homeworkView.frame = IS_IPAD?CGRectMake(0,kNavHeight+6, kScreenWidth, kScreenHeight-80):CGRectMake(0, kNavHeight+5, kScreenWidth, kScreenHeight-kNavHeight-60);
        }else{
            [self.view addSubview:self.reminderView];
            self.homeworkView.frame = IS_IPAD?CGRectMake(0, self.reminderView.bottom+5, kScreenWidth, kScreenHeight-self.reminderView.bottom-80):CGRectMake(0, self.reminderView.bottom+5, kScreenWidth, kScreenHeight-self.reminderView.bottom-60);
        }
    }
}

#pragma mark 刷新数据
-(void)refreshOrderData{
    [self updateCertifiedReminderView];
    [self loadAllOrderDataForIsLoading:NO];
}

#pragma mark 刷新作业检查
-(void)refreshCheckData{
    [self refreshDataWithIndex:0];
}

#pragma mark 刷新作业辅导
-(void)refreshGuideData{
    [self refreshDataWithIndex:1];
}

#pragma mark 刷新
-(void)refreshDataWithIndex:(NSInteger)index{
    selectedIndex = index;
    self.titleView.currentIndex = selectedIndex;
    self.homeworkView.isTutoring = selectedIndex;
    [self.homeworkView.myZuoyeArray removeAllObjects];
    [self.homeworkView.tutorialReserveArray removeAllObjects];
    [self.homeworkView.tutorialRealTimeArray removeAllObjects];
    [self.homeworkView.tutorialReceivedArray removeAllObjects];
    page = 1;
    [self loadAllOrderDataForIsLoading:NO];
}


#pragma mark 加载数据
-(void)loadAllOrderDataForIsLoading:(BOOL)isLoading{
    kSelfWeak;
    NSString *body = nil;
    if (selectedIndex==0) {
       body = [NSString stringWithFormat:@"token=%@&page=%ld&label=1",kUserTokenValue,page];
    }else{
       body = [NSString stringWithFormat:@"token=%@&label=2",kUserTokenValue];
    }
    
    NSString *urlString=[NSString stringWithFormat:kHostTempURL,kHomeAPI];
    [[TCHttpRequest sharedTCHttpRequest] requstMethod:@"POST" url:urlString body:body isLoading:isLoading success:^(id json) {
        isLoadedData = YES;
        if (selectedIndex==0) {
            NSArray *data = [json objectForKey:@"data"];
            if (kIsArray(data)&&data.count>0) {
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in data) {
                    HomeworkModel *model = [[HomeworkModel alloc] init];
                    [model setValues:dict];
                    [tempArr addObject:model];
                }
                weakSelf.homeworkView.myZuoyeArray = tempArr;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.homeworkView.myCollectionView reloadData];
                [weakSelf.homeworkView.myCollectionView.mj_header endRefreshing];
                [weakSelf.homeworkView.myCollectionView.mj_footer endRefreshing];
            });
            
        }else{
            NSDictionary *data = [json objectForKey:@"data"];
            NSArray *receiveArr = [data valueForKey:@"receive"];  //已接单
            if (kIsArray(receiveArr)&&receiveArr.count>0) {
                NSMutableArray *tempReceivedArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in receiveArr) {
                    HomeworkModel *model = [[HomeworkModel alloc] init];
                    [model setValues:dict];
                    [tempReceivedArr addObject:model];
                }
                weakSelf.homeworkView.tutorialReceivedArray = tempReceivedArr;
            }
            
            //实时
            NSArray *guideNowArr = [data valueForKey:@"guide_now"];
            if (kIsArray(guideNowArr)&&guideNowArr.count>0) {
                NSMutableArray *tempRealtimeArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in guideNowArr) {
                    HomeworkModel *model = [[HomeworkModel alloc] init];
                    [model setValues:dict];
                    [tempRealtimeArr addObject:model];
                }
                weakSelf.homeworkView.tutorialRealTimeArray = tempRealtimeArr;
            }
            
            //预约
            NSArray *guidePreArr = [data valueForKey:@"guide_pre"];  //预约
            if (kIsArray(guidePreArr)&&guidePreArr.count>0) {
                NSMutableArray *tempReserveArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in guidePreArr) {
                    HomeworkModel *model = [[HomeworkModel alloc] init];
                    [model setValues:dict];
                    [tempReserveArr addObject:model];
                }
                weakSelf.homeworkView.tutorialReserveArray = tempReserveArr;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.homeworkView.myCollectionView reloadData];
                
            });
        }
    } failure:^(NSString *errorStr) {
        if (selectedIndex==0) {
            [weakSelf.homeworkView.myCollectionView.mj_header endRefreshing];
            [weakSelf.homeworkView.myCollectionView.mj_footer endRefreshing];
        }
        
        if (isLoading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
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
            weakSelf.badgeLabel.hidden = count<1;
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
        
        UIButton *leftBtn=[[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(10, KStatusHeight+9, 50, 50):CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [leftBtn setImage:[UIImage drawImageWithName:@"home_my"size:IS_IPAD?CGSizeMake(32, 32):CGSizeMake(24, 24)] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:leftBtn];
        
        UILabel  *titleLabel =[[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake((kScreenWidth-280)/2.0, KStatusHeight+16, 280, 36):CGRectMake((kScreenWidth-180)/2, KStatusHeight, 180, 44)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"首页";
        [_navBarView addSubview:titleLabel];
        
        UIButton *rightBtn=[[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-60, KStatusHeight+9,50,50):CGRectMake(kScreenWidth-45, KStatusHeight+2, 40, 40)];
        [rightBtn setImage:[UIImage drawImageWithName:@"home_news" size:IS_IPAD?CGSizeMake(34, 28):CGSizeMake(28, 24)] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:rightBtn];
    }
    return _navBarView;
}

#pragma mark 红色标记
-(UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-26, KStatusHeight+18, 12, 12):CGRectMake(kScreenWidth-16, KStatusHeight+14, 8, 8)];
        _badgeLabel.boderRadius = IS_IPAD?6.0:4.0;
        _badgeLabel.backgroundColor = [UIColor colorWithHexString:@" #F50000"];
    }
    return _badgeLabel;
}

#pragma mark 滚动图片视图
-(UIImageView *)bannerImageView{
    if (!_bannerImageView) {
        CGRect imgFrame = isXDevice?CGRectMake(40, KStatusHeight+80, kScreenWidth-80, kScreenHeight-320):CGRectMake(40, KStatusHeight+80, kScreenWidth-80, kScreenHeight-220);
        _bannerImageView = [[UIImageView alloc] initWithFrame:imgFrame];
        _bannerImageView.image = [UIImage imageNamed:@"banner"];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageView.userInteractionEnabled = YES;
        _bannerImageView.boderRadius=5.0;
        _bannerImageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserHelpAction)];
        [_bannerImageView addGestureRecognizer:tap];
    }
    return _bannerImageView;
}

#pragma mark 标题栏
-(SlideMenuView *)titleView{
    if (!_titleView) {
        CGFloat titleW = IS_IPAD?280:200;
        _titleView = [[SlideMenuView alloc] initWithFrame:CGRectMake((kScreenWidth -titleW)/2, KStatusHeight, titleW, kNavHeight-KStatusHeight) btnTitleFont:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:16] color:[UIColor colorWithHexString:@"#4A4A4A"] selColor:[UIColor colorWithHexString:@"#FF6161"] showLine:NO];
        _titleView.isShowUnderLine = YES;
        _titleView.myTitleArray = @[@"作业检查",@"作业辅导"];
        _titleView.currentIndex = selectedIndex;
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.delegate = self;
    }
    return _titleView;
}

#pragma mark 认证提醒
-(UIView *)reminderView{
    if (!_reminderView) {
        _reminderView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(0, kNavHeight+6, kScreenWidth, 70):CGRectMake(0, kNavHeight+5, kScreenWidth,50)];
        _reminderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(15, 18, kScreenWidth-180, 33):CGRectMake(10, 10, 225, 30)];
        lab.text = @"完成实名认证和学历认证后即可接单";
        lab.textColor = [UIColor colorWithHexString:@"#808080"];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:13];
        [_reminderView addSubview:lab];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-165, 15, 150, 40):CGRectMake(kScreenWidth-90, 12, 80, 26)];
        [btn setImage:[UIImage imageNamed:IS_IPAD?@"tips_authentication_ipad":@"tips_authentication"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(toUserDetailsAction) forControlEvents:UIControlEventTouchUpInside];
        [_reminderView addSubview:btn];
    }
    return _reminderView;
}


#pragma mark 作业检查
-(HomeworkView *)homeworkView {
    if (!_homeworkView) {
        _homeworkView = [[HomeworkView alloc] initWithFrame:IS_IPAD?CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-80):CGRectMake(0,kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-60)];
        _homeworkView.delegate = self;
        _homeworkView.isTutoring = NO;
    }
    return _homeworkView;
}

#pragma mark 开启在线辅导
-(LoginButton *)startOnBtn{
    if (!_startOnBtn) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,kScreenHeight-85,515, 75):CGRectMake(48, kScreenHeight-75,kScreenWidth-96, 60);
        _startOnBtn = [[LoginButton alloc] initWithFrame:btnFrame title:@"开启在线辅导"];
        _startOnBtn.tag = 100;
        [_startOnBtn addTarget:self action:@selector(turnOnlineTutoringAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startOnBtn;
}

#pragma mark 关闭在线
-(UIButton *)closeOnlineBtn{
    if (!_closeOnlineBtn) {
        CGFloat originY;
        if (IS_IPAD) {
            originY = kScreenHeight-65;
        }else{
            originY = isXDevice?kScreenHeight-60:kScreenHeight-50;
        }
        
        _closeOnlineBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake((kScreenWidth-515)/2.0, originY, 515, 55):CGRectMake(48, originY, kScreenWidth-96, 40)];
        _closeOnlineBtn.layer.cornerRadius = IS_IPAD?25:21;
        [_closeOnlineBtn setTitle:@"关闭在线" forState:UIControlStateNormal];
        [_closeOnlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeOnlineBtn.backgroundColor = [UIColor blackColor];
        _closeOnlineBtn.alpha = 0.5;
        _closeOnlineBtn.tag = 101;
        [_closeOnlineBtn addTarget:self action:@selector(turnOnlineTutoringAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeOnlineBtn;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGuideCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAuthUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCheckRecieveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGuideRecieveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
