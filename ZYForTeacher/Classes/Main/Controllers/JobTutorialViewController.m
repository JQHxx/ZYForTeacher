//
//  JobTutorialViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "JobTutorialViewController.h"
#import "LoginButton.h"
#import "TutorialToolBarView.h"
#import <NIMAVChat/NIMAVChat.h>
#import "CancelViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "WhiteboardManager.h"
#import "WhiteboardLines.h"
#import "WhiteboardPoint.h"
#import "WhiteboardDrawView.h"
#import "WhiteboardCmdHandler.h"
#import "YBPopupMenu.h"
#import "NIMSessionViewController.h"
#import "SketchpadView.h"
#import "WhiteboardManagerView.h"
#import "MyOrderViewController.h"
#import "SDPhotoBrowser.h"

@interface JobTutorialViewController ()<UIScrollViewDelegate,TutorialToolBarViewDelegate,NIMNetCallManagerDelegate,WhiteboardManagerDelegate,NIMLoginManagerDelegate,YBPopupMenuDelegate,WhiteboardCmdHandlerDelegate,WhiteboardManagerViewDelegate,NIMConversationManagerDelegate,SDPhotoBrowserDelegate>{
    NSInteger     allNum;
    UILabel       *timeLabel;
    NSInteger     timeCount;    //时间
    NSInteger     currentIndex;  //当前图片页码
    NSInteger     currentWhiteboardIndex; //当前白板页码
    
    NSMutableArray *drawViewResultsArray;
    BOOL          isShowBrush; //显示画笔
    BOOL          isShowWhiteboard; //显示白板
    BOOL         isCoaching;  //正在辅导
    BOOL         isEndCoach;  //结束辅导
    UILabel      *menuBadgeLbl;
}

@property (nonatomic , strong) UILabel        *badgeLabel;          //红点
@property (nonatomic , strong ) UIButton      *moreBtn;      //更多
@property (nonatomic , strong ) UIScrollView  *homeworkScrollView;
@property (nonatomic , strong ) UILabel       *countLab;
@property (nonatomic , strong ) UIImageView   *callBgImageView;       //通话
@property (nonatomic , strong ) UIView        *examView;              //审题
@property (nonatomic , strong ) LoginButton   *tutoringBtn;           //开始辅导
@property (nonatomic , strong ) TutorialToolBarView  *toolBarView;    //辅导工具栏
@property (nonatomic , strong ) SketchpadView  *brushView;    //画笔

//白板相关
@property (nonatomic , strong ) WhiteboardManagerView  *managerView;    //白板管理界面
@property (nonatomic , strong ) WhiteboardCmdHandler   *cmdHander;

@property (nonatomic , strong ) NSArray    *colors;
@property (nonatomic ,  copy  ) NSString   *myUid;      //通信ID
@property (nonatomic , assign ) NSInteger  myDrawColor;   //画笔颜色
@property (nonatomic , assign ) CGFloat    myLineWidth;   //画笔宽度

@property (nonatomic, strong ) NSMutableArray  *whiteboardLinesArray;
@property (nonatomic, strong ) NSMutableArray  *drawViewsArray;

@property (nonatomic ,strong) NSTimer *timer;


@end

@implementation JobTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentIndex = 1;
    currentWhiteboardIndex = 0;
    
    //设置扬声器
    BOOL setSpeakerSuccess = [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
    if (setSpeakerSuccess) {
        MyLog(@"设置扬声器成功");
    }else{
        MyLog(@"设置扬声器失败");
    }
    //切换成音频模式
    [[NIMAVChatSDK sharedSDK].netCallManager switchType:NIMNetCallMediaTypeAudio];
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    
    _whiteboardLinesArray = [[NSMutableArray alloc] init];
    _drawViewsArray = [[NSMutableArray alloc] init];
    drawViewResultsArray = [[NSMutableArray alloc] init];
    
    _colors = @[@(0xe42a2a), @(0x4a4a4a), @(0x5ca1ff)];
    _myDrawColor = [_colors[0] intValue];
    _myLineWidth = 1.5;
    
    _cmdHander = [[WhiteboardCmdHandler alloc] initWithDelegate:self];
    [[WhiteboardManager sharedWhiteboardManager] setDataHandler:_cmdHander];
    [[WhiteboardManager sharedWhiteboardManager] setDelegate:self];
    
    //获取通信ID
    _myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    MyLog(@"通信ID：%@，callID:%lld",_myUid,self.callInfo.callID);
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
    self.isHiddenNavBar = YES;
    
    [self initTutoringView];
    [self createWhiteBoard];
}

#pragma mark 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCurrentCoach) name:kOrderCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderCancelNotification object:nil];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.homeworkScrollView) {
        NSInteger currentIndex = scrollView.contentOffset.x/kScreenWidth;
        self.countLab.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,allNum];
    }
}

#pragma mark TutorialToolBarViewDelegate
#pragma mark 清除、撤销、还原
-(void)tutorialToolBarView:(TutorialToolBarView *)barView didClickItemForTag:(NSInteger)itemTag{
    switch (itemTag) {
        case 0:{ //画笔
            if (self.managerView) {
                [self makeHideWhiteboardManagerView];
            }
            
            isShowBrush = !isShowBrush;
            if (isShowBrush) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.brushView setFrame:CGRectMake(0, kScreenHeight-60-60, kScreenWidth, 60)];
                    [self.view addSubview:self.brushView];
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    [self.brushView setFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 0)];
                    [self.brushView removeFromSuperview];
                } completion:^(BOOL finished) {
                    self.brushView = nil;
                }];
            }
        }
            break;
        case 1: //白板
        {
            isShowWhiteboard = !isShowWhiteboard;
            if (isShowWhiteboard) {
                WhiteboardDrawView *view = self.drawViewsArray[currentWhiteboardIndex];
                UIImage *image = [UIImage snapshotForView:view];
                if (drawViewResultsArray.count>currentWhiteboardIndex) {
                   [drawViewResultsArray replaceObjectAtIndex:currentWhiteboardIndex withObject:image];
                }else{
                    [drawViewResultsArray addObject:image];
                }
                
                [self.view addSubview:self.managerView];
                self.managerView.whiteboardsArray = drawViewResultsArray;
                [self.managerView.myCollectionView reloadData];
                [UIView animateWithDuration:0.2 animations:^{
                    [self.managerView setFrame:CGRectMake(0, kScreenHeight-60-127, kScreenWidth, 127)];
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    [self.managerView setFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 0)];
                    [self.managerView removeFromSuperview];
                } completion:^(BOOL finished) {
                    self.managerView = nil;
                }];
            }
        }
            break;
        case 2: //清除
        {
            if (self.managerView) {
                [self makeHideWhiteboardManagerView];
            }
            WhiteboardLines *lines = _whiteboardLinesArray[currentWhiteboardIndex];
            [lines clear];
            [_cmdHander sendPureCmd:WhiteBoardCmdTypeClearLines];
        }
            break;
        case 3:  // 撤销
        {
            if (self.managerView) {
                [self makeHideWhiteboardManagerView];
            }
            WhiteboardLines *lines = _whiteboardLinesArray[currentWhiteboardIndex];
            [lines cancelLastLine:_myUid];
            [_cmdHander sendPureCmd:WhiteBoardCmdTypeCancelLine];
        }
            break;
        default:
            break;
    }
}

#pragma mark YBPopupMenuDelegate
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if(index==0){
        CancelViewController *cancelVC = [[CancelViewController alloc] init];
        cancelVC.jobid = self.homework.job_id;
        cancelVC.myTitle = @"取消辅导";
        cancelVC.type = CancelTypeOrderCoach;
        [self.navigationController pushViewController:cancelVC animated:YES];
    }else{
        NIMSession *session = [NIMSession session:self.homework.third_id type:NIMSessionTypeP2P];
        NIMSessionViewController *sessionVC = [[NIMSessionViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:sessionVC animated:YES];
    }
}

#pragma mark NIMNetCallManagerDelegate
#pragma mark 点对点通话建立成功
-(void)onCallEstablished:(UInt64)callID{
    MyLog(@"点对点通话建立成功--onCallEstablished:%lld",callID);
}

#pragma mark 通话异常断开
-(void)onCallDisconnected:(UInt64)callID withError:(NSError *)error{
    MyLog(@"通话异常断开--error:%@",error.localizedDescription);
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    [self.view makeToast:@"通话异常断开，请重新连接" duration:1.0 position:CSToastPositionCenter];
    kSelfWeak;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf backAction];
    });
}

#pragma mark 收到对方网络通话控制信息，用于方便通话双方沟通信息
-(void)onControl:(UInt64)callID from:(NSString *)user type:(NIMNetCallControlType)control{
    MyLog(@"收到对方网络通话控制信息,callID:%lld,user:%@,type:%zd",callID,user,control);
    if (control== NIMNetCallControlTypeBackground) {
        [self.timer setFireDate:[NSDate distantFuture]]; //关闭计时器
        [self.view makeToast:@"对方退到后台" duration:1.0 position:CSToastPositionCenter];
    }else if (control == NIMNetCallControlTypeFeedabck){
        [self.timer setFireDate:[NSDate distantPast]]; //开启计时器
        [self.view makeToast:@"对方回到前台" duration:1.0 position:CSToastPositionCenter];
    }
}

#pragma mark 对方挂断电话
-(void)onHangup:(UInt64)callID by:(NSString *)user{
    MyLog(@"对方挂断电话--onHangup");
    if (!isEndCoach) {
        [self.view makeToast:@"对方挂断电话" duration:1.0 position:CSToastPositionCenter];
        [self backAction];
    }
    
}

#pragma mark NIMConversationManagerDelegate
#pragma mark 增加最近会话的回调
-(void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    MyLog(@"TutorialViewController didAddRecentSession-- totalUnreadCount:%ld",totalUnreadCount);
    self.badgeLabel.hidden = totalUnreadCount<1;
}

#pragma mark 最近会话修改的回调
-(void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    MyLog(@"TutorialViewController 更新会话 didUpdateRecentSession -- totalUnreadCount:%ld",totalUnreadCount);
    self.badgeLabel.hidden = totalUnreadCount<1;
}

#pragma mark 已读回调
-(void)allMessagesRead{
    self.badgeLabel.hidden = YES;
}

#pragma mark - WhiteboardManagerDelegate
#pragma mark 创建互动白板
-(void)onReserve:(NSString *)name result:(NSError *)result{
     MyLog(@"Reserve conference %@ result:%@", name, result);
    if (result == nil) {
        NSError *result = [[WhiteboardManager sharedWhiteboardManager] joinConference:name];
        MyLog(@"join rts conference: %@ result %zd", name, result.code);
    }else {
        [self.view makeToast:[NSString stringWithFormat:@"创建互动白板出错:%zd", result.code]];
    }
}

#pragma mark 加入白板
-(void)onJoin:(NSString *)name result:(NSError *)result{
    
}

#pragma mark - NIMLoginManagerDelegate
-(void)onLogin:(NIMLoginStep)step{
    MyLog(@"NIMLoginManagerDelegate -- onLogin:%ld",step);
}

#pragma mark - WhiteboardCmdHandlerDelegate
#pragma mark 收到操作指令
- (void)onReceiveCmd:(WhiteBoardCmdType)type from:(NSString *)sender{
    MyLog(@"onReceiveCmd:%zd",type);
    if (type == WhiteBoardCmdTypeEndCoach) {
        isEndCoach = YES;
        [self.view makeToast:@"对方已结束当前作业辅导" duration:1.0 position:CSToastPositionCenter];
    }else if (type == WhiteBoardCmdTypeCancelCoach){
        [self.view makeToast:@"对方取消当前作业辅导" duration:1.0 position:CSToastPositionCenter];
    }
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    kSelfWeak;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf backAction];
    });
}

#pragma mark - WhiteboardManagerViewDelegate
#pragma mark 新建白板
-(void)whiteboardManagerViewAddWhiteboard{
    [self makeHideWhiteboardManagerView];
    
    currentWhiteboardIndex++;
    [self addWhiteboard];
}

#pragma mark 选择白板
-(void)whiteboardManagerView:(WhiteboardManagerView *)managerView didSelectWhiteboardWithIndex:(NSInteger)itemIndex{
    [self makeHideWhiteboardManagerView];
    currentWhiteboardIndex = itemIndex;
    WhiteboardDrawView *drawView = _drawViewsArray[itemIndex];
    [self.view bringSubviewToFront:drawView];
    [_cmdHander sendHandleCmd:WhiteBoardCmdTypeChooseWhiteboard index:currentWhiteboardIndex];
}

#pragma mark 删除白板
-(void)whiteboardManagerView:(WhiteboardManagerView *)managerView deleteWhiteboardWithIndex:(NSInteger)itemIndex{
    WhiteboardDrawView *drawView = _drawViewsArray[itemIndex];
    [drawView removeFromSuperview];
    drawView = nil;
    [_drawViewsArray removeObjectAtIndex:itemIndex];
    [_whiteboardLinesArray removeObjectAtIndex:itemIndex];
    [drawViewResultsArray removeObjectAtIndex:itemIndex];
    
    self.managerView.whiteboardsArray = drawViewResultsArray;
    [self.managerView.myCollectionView reloadData];
    
    if (itemIndex<currentWhiteboardIndex) {
        currentWhiteboardIndex--;
    }else if (itemIndex==currentWhiteboardIndex){
        if (currentWhiteboardIndex>0) {
            WhiteboardDrawView *drawView = _drawViewsArray[itemIndex-1];
            [self.view bringSubviewToFront:drawView];
            currentWhiteboardIndex -- ;
        }
    }
    [_cmdHander sendHandleCmd:WhiteBoardCmdTypeDeleteWhiteboard index:itemIndex];
    
    [self makeHideWhiteboardManagerView];
}

#pragma mark - SDPhotoBrowserDelegate
#pragma mark 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
     return [UIImage imageNamed:@"task_details_loading"];
}

#pragma mark
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *imgUrl = self.homework.job_pic[index];
    return [NSURL URLWithString:imgUrl];
}

#pragma mark -- NSNotification
#pragma mark APP回到前台
-(void)appEnterForeground:(UIApplication *)application{
    MyLog(@"APP回到前台 语音发送指令，control:%lld,type:%zd",self.callInfo.callID,NIMNetCallControlTypeFeedabck);
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeFeedabck];
    [self.timer setFireDate:[NSDate distantPast]]; //开启计时器
}

#pragma mark APP退到后台
-(void)appEnterBackground:(UIApplication *)application{
    MyLog(@"退出后台 语音发送指令，control:%lld,type:%zd",self.callInfo.callID,NIMNetCallControlTypeBackground);
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeBackground];
    [self.timer setFireDate:[NSDate distantFuture]]; //关闭计时器
}

#pragma mark 退出APP
-(void)appTerminate:(UIApplication *)application{
    MyLog(@"退出app 语音发送指令，control:%lld",self.callInfo.callID);
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
}

#pragma mark 取消当前辅导
-(void)cancelCurrentCoach{
    [self.view makeToast:@"对方取消当前作业辅导" duration:1.0 position:CSToastPositionCenter];
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    kSelfWeak;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf backAction];
    });
}

#pragma mark  - UIResponder
#pragma mark 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isCoaching) {
        WhiteboardDrawView *drawView = [self.drawViewsArray objectAtIndex:currentWhiteboardIndex];
        CGPoint p = [[touches anyObject] locationInView:drawView];
        [self onPointCollected:p type:WhiteboardPointTypeStart];
    }
}

#pragma mark 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isCoaching) {
        WhiteboardDrawView *drawView = [self.drawViewsArray objectAtIndex:currentWhiteboardIndex];
        CGPoint p = [[touches anyObject] locationInView:drawView];
        [self onPointCollected:p type:WhiteboardPointTypeMove];
    }
}

#pragma mark 触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isCoaching) {
        WhiteboardDrawView *drawView = [self.drawViewsArray objectAtIndex:currentWhiteboardIndex];
        CGPoint p = [[touches anyObject] locationInView:drawView];
        [self onPointCollected:p type:WhiteboardPointTypeEnd];
    }
}

#pragma mark - Private Methods
#pragma mark 添加线条
- (void)onPointCollected:(CGPoint)p type:(WhiteboardPointType)type{
    WhiteboardDrawView *drawView = [self.drawViewsArray objectAtIndex:currentWhiteboardIndex];
    WhiteboardPoint *point = [[WhiteboardPoint alloc] init];
    point.type = type;
    point.xScale = p.x/drawView.frame.size.width;
    point.yScale = p.y/drawView.frame.size.height;
    point.colorRGB = _myDrawColor;
    point.lineWidth = _myLineWidth;
    [_cmdHander sendMyPoint:point];
    
    WhiteboardLines *lines = _whiteboardLinesArray[currentWhiteboardIndex];
    [lines addPoint:point uid:_myUid];
}

#pragma mark -- Event Reponse
#pragma mark 查看更多（取消辅导和消息）
-(void)getMoreHandleListAction{
    NSArray *titles = @[@"取消辅导",@"消息"];
    kSelfWeak;
    [YBPopupMenu showRelyOnView:self.moreBtn titles:titles icons:@[@"",@"",@""] menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.borderWidth = 0.5;
        popupMenu.borderColor = [UIColor colorWithHexString:@"0xeeeeeee"];
        popupMenu.delegate = self;
        popupMenu.textColor = [UIColor colorWithHexString:@"0x626262"];
        popupMenu.fontSize = 14;
        
        if (menuBadgeLbl==nil) {
            menuBadgeLbl=[[UILabel alloc] initWithFrame:CGRectMake(50,65, 8, 8)];
            menuBadgeLbl.backgroundColor=[UIColor redColor];
            menuBadgeLbl.boderRadius = 4;
            [popupMenu addSubview:menuBadgeLbl];
        }
        menuBadgeLbl.hidden=weakSelf.badgeLabel.hidden;
    }];
}

#pragma mark 开始审题
-(void)startExamHomeworkAction{
    self.countLab.frame = CGRectMake(kScreenWidth-50, kScreenHeight-105, 34, 22);
    [self.view addSubview:self.tutoringBtn];
    
    [self.examView removeFromSuperview];
    [self.callBgImageView removeFromSuperview];
    self.examView = nil;
    self.callBgImageView = nil;
    
    [self sendCmdDataWithType:WhiteBoardCmdTypeExam];  //发送开始审题指令
}

#pragma mark 开始辅导
-(void)startTutoringHomeworkAction{
    self.countLab.frame = CGRectMake(kScreenWidth-50, KStatusHeight+60, 34, 22);
    [self.tutoringBtn removeFromSuperview];

    [self addWhiteboard]; //添加白板
    [self.view addSubview:self.toolBarView];
    [self sendCmdDataWithType:WhiteBoardCmdTypeStartCoach];  //发送开始辅导指令
    [self startCountTime];
    
    isCoaching = YES;
}

#pragma mark 结束辅导
-(void)endHomeworkTutoringAction{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    isEndCoach = YES;
    [self sendCmdDataWithType:WhiteBoardCmdTypeEndCoach]; //发送结束辅导指令
    [ZYHelper sharedZYHelper].isUpdateOrderList = YES;
    [self.view makeToast:@"已结束当前作业辅导" duration:1.0 position:CSToastPositionCenter];
    kSelfWeak;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf backAction];
    });
}

#pragma mark 返回
-(void)backAction{
    BOOL isOrderIn = NO;
    for (BaseViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyOrderViewController class]]) {
            isOrderIn = YES;
            [ZYHelper sharedZYHelper].isUpdateOrderList = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (!isOrderIn) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark 点击作业图片
-(void)homeworkPicTapAction:(UITapGestureRecognizer *)gesture{
    NSInteger index = gesture.view.tag;
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = index;
    photoBrowser.imageCount = self.homework.job_pic.count;
    photoBrowser.sourceImagesContainerView = self.homeworkScrollView;
    [photoBrowser show];
}

#pragma mark -- Private methods
#pragma mark 初始化界面
-(void)initTutoringView{
    [self.view addSubview:self.homeworkScrollView];
    [self.view addSubview:self.countLab];
    self.countLab.text = [NSString stringWithFormat:@"1/%ld",allNum];
    [self.view addSubview:self.examView];
    [self.view addSubview:self.callBgImageView];
    [self.view addSubview:self.moreBtn];
    [self.view addSubview:self.badgeLabel];
    self.badgeLabel.hidden = YES;
}

#pragma mark 创建白板
-(void)createWhiteBoard{
    NSString *conferenceName = [NSString stringWithFormat:@"%@-%@",[self.homework.label integerValue]>1?@"tutorial":@"check",self.homework.job_id];
    NSError *error = [[WhiteboardManager sharedWhiteboardManager] reserveConference:conferenceName];
    if (error) {
        MyLog(@"reserve rts conference:%@ error -- code:%ld,desc:%@",conferenceName,error.code,error.localizedDescription);
    }
}

#pragma mark 添加白板
-(void)addWhiteboard{
    [_cmdHander sendHandleCmd:WhiteBoardCmdTypeAddWhiteboard index:currentWhiteboardIndex];
    
    WhiteboardDrawView *drawView = [[WhiteboardDrawView alloc] initWithFrame:CGRectMake(0, KStatusHeight+100, kScreenWidth, kScreenHeight-KStatusHeight-160)];
    drawView.backgroundColor = [UIColor whiteColor];
    
    WhiteboardLines *lines = [[WhiteboardLines alloc] init];
    drawView.dataSource = lines;
    
    [self.view addSubview:drawView];
    [_whiteboardLinesArray addObject:lines];
    [_drawViewsArray addObject:drawView];
}

#pragma mark 开始计时
-(void)startCountTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    timeCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime:) userInfo:nil repeats:YES];
}

-(void)repeatShowTime:(NSTimer *)timer{
    timeCount++;
    timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",timeCount/3600,timeCount/60,timeCount%60];
}

#pragma mark 发送指令
-(void)sendCmdDataWithType:(WhiteBoardCmdType)type{
    [_cmdHander sendPureCmd:type];
}

#pragma mark 关闭白板管理界面
-(void)makeHideWhiteboardManagerView{
    isShowWhiteboard = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self.managerView setFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 0)];
        [self.managerView removeFromSuperview];
    } completion:^(BOOL finished) {
        self.managerView = nil;
    }];
}

#pragma mark -- gettters and setters
#pragma mark 作业图片
-(UIScrollView *)homeworkScrollView{
    if (!_homeworkScrollView) {
        _homeworkScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _homeworkScrollView.showsHorizontalScrollIndicator = NO;
        _homeworkScrollView.delegate = self;
        _homeworkScrollView.pagingEnabled = YES;
        _homeworkScrollView.backgroundColor = [UIColor bgColor_Gray];
        
        allNum = self.homework.job_pic.count;
        for (NSInteger i=0; i<allNum; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.homework.job_pic[i]] placeholderImage:[UIImage imageNamed:@"task_details_loading"]];
            [_homeworkScrollView addSubview:imgView];
            imgView.userInteractionEnabled = YES;
            imgView.tag = i;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeworkPicTapAction:)];
            [imgView addGestureRecognizer:tap];
        }
        _homeworkScrollView.contentSize = CGSizeMake(kScreenWidth*allNum, kScreenHeight);
        
    }
    return _homeworkScrollView;
}

#pragma mark 图片数量
-(UILabel *)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50,KStatusHeight+454, 34, 22)];
        _countLab.textAlignment = NSTextAlignmentRight;
        _countLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _countLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    }
    return _countLab;
}

#pragma mark 通话
-(UIImageView *)callBgImageView{
    if (!_callBgImageView) {
        _callBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-72.0)/2.0,kScreenHeight-186, 72, 72)];
        _callBgImageView.backgroundColor = [UIColor whiteColor];
        _callBgImageView.boderRadius = 36;
        
        UIImageView *callImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1.5,1.5, 69, 69)];
        callImageView.image = [UIImage imageNamed:@"coach_call"];
        callImageView.boderRadius = 34.5;
        [_callBgImageView addSubview:callImageView];
    }
    return _callBgImageView;
}

#pragma mark 审题
-(UIView *)examView{
    if (!_examView) {
        _examView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-163, kScreenWidth, 163)];
        _examView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 58, kScreenWidth-60, 17)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        lab.textColor = [UIColor colorWithHexString:@"#808080"];
        lab.text = @"语音通话中...";
        [_examView addSubview:lab];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-240)/2.0, lab.bottom+22, 240, 50)];
        [btn setBackgroundImage:[UIImage imageNamed:@"button4"] forState:UIControlStateNormal];
        [btn setTitle:@"开始审题" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        [btn addTarget:self action:@selector(startExamHomeworkAction) forControlEvents:UIControlEventTouchUpInside];
        [_examView addSubview:btn];
    }
    return _examView;
}

#pragma mark 开始辅导
-(LoginButton *)tutoringBtn{
    if (!_tutoringBtn) {
        _tutoringBtn = [[LoginButton alloc] initWithFrame:CGRectMake((kScreenWidth-280)/2.0, kScreenHeight-75, 280, 60) title:@"开始辅导"];
        [_tutoringBtn addTarget:self action:@selector(startTutoringHomeworkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tutoringBtn;
}

#pragma mark 辅导工具栏
-(TutorialToolBarView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [[TutorialToolBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth,60)];
        _toolBarView.delegate = self;
        
        UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100,6,95, 35)];
        [endBtn setImage:[UIImage imageNamed:@"coach_finish_button"] forState:UIControlStateNormal];
        [endBtn addTarget:self action:@selector(endHomeworkTutoringAction) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:endBtn];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-85, endBtn.bottom, 70,17.0)];
        timeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12.0];
        timeLabel.textColor = [ UIColor colorWithHexString:@"#4A4A4A"];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = @"00:00:00";
        [_toolBarView addSubview:timeLabel];
    }
    return _toolBarView;
}

#pragma mark 画板颜色
-(SketchpadView *)brushView{
    if (!_brushView) {
        _brushView = [[SketchpadView alloc] initWithFrame:CGRectMake(0,kScreenHeight-60, kScreenWidth, 0)];
        _brushView.backgroundColor = [UIColor clearColor];
        kSelfWeak;
        _brushView.setColor = ^(NSInteger index) {
            isShowBrush = NO;
            weakSelf.toolBarView.selColorIndex = index;
            _myDrawColor = [_colors[index] integerValue];
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.brushView setFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 0)];
                [weakSelf.brushView removeFromSuperview];
            } completion:^(BOOL finished) {
                weakSelf.brushView = nil;
            }];
        };
    }
    return _brushView;
}

#pragma mark 白板管理界面
-(WhiteboardManagerView *)managerView{
    if (!_managerView) {
        _managerView = [[WhiteboardManagerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 0)];
        _managerView.viewDelegate = self;
    }
    return _managerView;
}

#pragma mark 更多
-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, KStatusHeight, 30, 40)];
        [_moreBtn setImage:[UIImage imageNamed:@"connection_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(getMoreHandleListAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

#pragma mark 红色标记
-(UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-22, KStatusHeight+7, 8, 8)];
        _badgeLabel.boderRadius = 4.0;
        _badgeLabel.backgroundColor = [UIColor colorWithHexString:@"#F50000"];
    }
    return _badgeLabel;
}


-(void)dealloc{
    MyLog(@"dealloc--%@",NSStringFromClass([self class]));
    
    [[WhiteboardManager sharedWhiteboardManager] leaveCurrentConference];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
