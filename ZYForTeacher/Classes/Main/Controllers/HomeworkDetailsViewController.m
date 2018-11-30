//
//  HomeworkDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "HomeworkDetailsViewController.h"
#import "CancelViewController.h"
#import "JobCheckViewController.h"
#import "JobTutorialViewController.h"
#import "ConnecttingViewController.h"
#import "YBPopupMenu.h"
#import "PhotosView.h"
#import "NSDate+Extension.h"
#import <NIMSDK/NIMSDK.h>
#import "NIMSessionViewController.h"
#import "UserDetailsViewController.h"

@interface HomeworkDetailsViewController ()<YBPopupMenuDelegate,NIMConversationManagerDelegate>{
    UILabel     *orderTimeLab;
    UIImageView *headImageView;
    UILabel     *nameLabel;
    UILabel     *gradeLabel;
    UILabel     *priceTitleLabel;
    UILabel     *priceLabel;
    
    UILabel      *menuBadgeLbl;
    
    NSTimer      *myTimer;
}

@property (nonatomic, strong) UIButton     *rightItem;
@property (nonatomic , strong) UILabel     *badgeLabel;          //红点
@property (nonatomic, strong) UIView       *orderTimeView;
@property (nonatomic, strong) UIView       *studentInfoView;
@property (nonatomic ,strong) PhotosView   *photosView;
@property (nonatomic, strong) UIButton     *handleButton;



@end

@implementation HomeworkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"作业详情";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [self initHomeworkDetailsView];
}

#pragma mark -- Delegate
#pragma mark YBPopupMenuDelegate
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if(index==0){
        CancelViewController *cancelVC = [[CancelViewController alloc] init];
        cancelVC.jobid = self.homeworkInfo.job_id;
        cancelVC.type = CancelTypeHomework;
        cancelVC.myTitle = [self.homeworkInfo.label integerValue]<2?@"取消检查":@"取消辅导";
        [self.navigationController pushViewController:cancelVC animated:YES];
    }else{
        NIMSession *session = [NIMSession session:self.homeworkInfo.third_id type:NIMSessionTypeP2P];
        NIMSessionViewController *sessionVC = [[NIMSessionViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:sessionVC animated:YES];
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

#pragma mark -- Event Response
#pragma mark 更多
-(void)rightNavigationItemAction{
    NSArray *titles = @[@"取消辅导",@"消息"];
    kSelfWeak;
    [YBPopupMenu showRelyOnView:self.rightItem titles:titles icons:@[@"",@"",@""] menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
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

#pragma mark 处理订单
-(void)handleHomeworkAction:(UIButton *)sender{
    if ([ZYHelper sharedZYHelper].isCertified) {
        if ([self.homeworkInfo.label integerValue]>1) {
            if ([sender.currentTitle isEqualToString:@"去辅导"]) { //去辅导
                ConnecttingViewController *connectting = [[ConnecttingViewController alloc] initWithCallee:self.homeworkInfo.third_id];
                connectting.homework = self.homeworkInfo;
                [self.navigationController pushViewController:connectting animated:YES];
            }else{    //接单
                if ([self.homeworkInfo.label integerValue]==3) {
                    ConnecttingViewController *connectting = [[ConnecttingViewController alloc] initWithCallee:self.homeworkInfo.third_id];
                    connectting.homework = self.homeworkInfo;
                    connectting.isGuideNow = YES;
                    [self.navigationController pushViewController:connectting animated:YES];
                }else{
                    kSelfWeak;
                    NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,self.homeworkInfo.job_id];
                    [TCHttpRequest postMethodWithURL:kJobAcceptAPI body:body success:^(id json) {
                        [ZYHelper sharedZYHelper].isUpdateHome = YES;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.view makeToast:@"接单成功" duration:1.0 position:CSToastPositionCenter];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }];
                }
            }
        }else{ //去检查
            kSelfWeak;
            NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,self.homeworkInfo.job_id];
            [TCHttpRequest postMethodWithURL:kJobCheckAPI body:body success:^(id json) {
                NSDictionary *data = [json objectForKey:@"data"];
                [ZYHelper sharedZYHelper].isUpdateHome = YES;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    JobCheckViewController *checkVC = [[JobCheckViewController alloc] init];
                    checkVC.jobId = weakSelf.homeworkInfo.job_id;
                    checkVC.jobPics = weakSelf.homeworkInfo.job_pic;
                    checkVC.orderId = [data valueForKey:@"oid"];
                    checkVC.label = weakSelf.homeworkInfo.label;
                    checkVC.third_id = weakSelf.homeworkInfo.third_id;
                    [weakSelf.navigationController pushViewController:checkVC animated:YES];
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

#pragma mark -- private Methods
#pragma mark 初始化界面
-(void)initHomeworkDetailsView{
    if ([self.homeworkInfo.label integerValue]==2&&[self.homeworkInfo.is_receive integerValue] == 2) {
        [self.view addSubview:self.rightItem];
        [self.view addSubview:self.badgeLabel];
        self.badgeLabel.hidden = YES;
    }    
    
    [self.view addSubview:self.orderTimeView];
    if ([self.homeworkInfo.label integerValue]==2) {
        self.orderTimeView.hidden = NO;
        self.orderTimeView.frame = CGRectMake(0,kNavHeight+10, kScreenWidth, 30);
        NSString *orderTimeStr = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:self.homeworkInfo.start_time format:@"MM/dd HH:mm"];
        orderTimeLab.text = [NSString stringWithFormat:@"辅导时间-%@",orderTimeStr];
    }else{
        self.orderTimeView.hidden = YES;
        self.orderTimeView.frame = CGRectMake(0,kNavHeight+10, kScreenWidth, 0);
    }
    [self.view addSubview:self.studentInfoView];
    [self.view addSubview:self.photosView];
    [self.view addSubview:self.handleButton];
}

#pragma mark -- Getters and Setters
#pragma mark 导航栏右按钮
-(UIButton *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, KStatusHeight+2, 40, 40)];
        [_rightItem setImage:[UIImage drawImageWithName:@"more" size:CGSizeMake(30, 9)] forState:UIControlStateNormal];
        [_rightItem addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}

#pragma mark 红色标记
-(UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-16, KStatusHeight+14, 8, 8)];
        _badgeLabel.boderRadius = 4.0;
        _badgeLabel.backgroundColor = [UIColor colorWithHexString:@"#F50000"];
    }
    return _badgeLabel;
}

#pragma mark 辅导时间
-(UIView *)orderTimeView{
    if (!_orderTimeView) {
        _orderTimeView = [[UIView alloc] initWithFrame:CGRectMake(0,kNavHeight+10, kScreenWidth, 30)];
        
        UILabel *badgeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 4, 16)];
        badgeLab.backgroundColor = [UIColor colorWithHexString:@"#FF6161"];
        [_orderTimeView addSubview:badgeLab];
        
        orderTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(badgeLab.right+12, 0, 200, 20)];
        orderTimeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
        orderTimeLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_orderTimeView addSubview:orderTimeLab];
    }
    return _orderTimeView;
}

#pragma mark 学生信息
-(UIView *)studentInfoView{
    if (!_studentInfoView) {
        _studentInfoView = [[UIView alloc] initWithFrame:CGRectMake(10,self.orderTimeView.bottom, kScreenWidth-20, 80)];
        [_studentInfoView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:4.0];
        _studentInfoView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 58, 58)];
        bgHeadImageView.backgroundColor = [UIColor colorWithHexString:@"#FFE0D3"];
        [bgHeadImageView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:29.0];
        [_studentInfoView addSubview:bgHeadImageView];
        
        //头像
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 14, 52, 52)];
        headImageView.boderRadius = 26.0;
        if (kIsEmptyString(self.homeworkInfo.trait)) {
            headImageView.image = [UIImage imageNamed:@"default_head_image"];
        }else{
            [headImageView sd_setImageWithURL:[NSURL URLWithString:self.homeworkInfo.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
        }
        [_studentInfoView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+16.0, 19.0,80, 22)];
        nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        nameLabel.text = self.homeworkInfo.username;
        [_studentInfoView addSubview:nameLabel];
        
        gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+17, nameLabel.bottom+3.0, 80, 20)];
        gradeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        gradeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        gradeLabel.text = self.homeworkInfo.grade;
        [_studentInfoView addSubview:gradeLabel];
        
        UIImageView  *tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-111, 21, 15, 15)];
        tipsImageView.image = [UIImage imageNamed:@"price_gray"];
        [_studentInfoView addSubview:tipsImageView];
        
        priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipsImageView.right+4,20.0, 52, 18.0)];
        priceTitleLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        priceTitleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:13];
        priceTitleLabel.text = [self.homeworkInfo.label integerValue]>1?@"辅导价格":@"检查价格";
        [_studentInfoView addSubview:priceTitleLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-141, priceTitleLabel.bottom+3.0,101.0, 22.0)];
        priceLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
        priceLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = [self.homeworkInfo.label integerValue]>1?[NSString stringWithFormat:@"%.2f元/分钟",[self.homeworkInfo.price doubleValue]]:[NSString stringWithFormat:@"%.2f元",[self.homeworkInfo.price doubleValue]];
        [_studentInfoView addSubview:priceLabel];
    }
    return _studentInfoView;
}

#pragma mark 图片
-(PhotosView *)photosView{
    if (!_photosView) {
        _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, self.studentInfoView.bottom+10, kScreenWidth,kScreenHeight-self.studentInfoView.bottom-80) bgColor:[UIColor bgColor_Gray]];
        _photosView.photosArray = [NSMutableArray arrayWithArray:self.homeworkInfo.job_pic];
    }
    return _photosView;
}

#pragma mark 检查或接单
-(UIButton *)handleButton{
    if (!_handleButton) {
        _handleButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth -280)/2.0, kScreenHeight-75.0,280, 60)];
        [_handleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _handleButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
         if ([self.homeworkInfo.label integerValue]==1) {
             _handleButton.tag = 0;
             _handleButton.enabled = YES;
             [_handleButton setTitle:@"去检查" forState:UIControlStateNormal];
             [_handleButton setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
         }else{
             if ([self.homeworkInfo.is_receive integerValue]==1) {
                 _handleButton.tag = 1;
                 _handleButton.enabled = YES;
                 [_handleButton setTitle:@"接单" forState:UIControlStateNormal];
                 [_handleButton setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
             }else{
                 NSNumber *currentTime =[[ZYHelper sharedZYHelper] timeSwitchTimestamp:[NSDate currentFullDate] format:@"yyyy年MM月dd日 HH:mm:ss"];
                 MyLog(@"startTime:%ld,currentTime:%ld",[self.homeworkInfo.start_time integerValue],[currentTime integerValue]);
                 if ([self.homeworkInfo.start_time integerValue]>[currentTime integerValue]) {
                     _handleButton.tag = 3;
                     _handleButton.enabled = NO;
                     NSString *startDateStr = [NSDate currentFullDate];
                     NSString *endDateStr = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:self.homeworkInfo.start_time format:@"yyyy年MM月dd日 HH:mm:ss"];
                     NSString *str = [[ZYHelper sharedZYHelper] pleaseInsertStarTimeo:startDateStr andInsertEndTime:endDateStr];
                     [_handleButton setTitle:[NSString stringWithFormat:@"距离辅导开始还有%@",str] forState:UIControlStateNormal];
                     [_handleButton setBackgroundColor:[UIColor colorWithHexString:@"#B4B4B4"]];
                     [_handleButton setFrame:CGRectMake((kScreenWidth -280)/2.0, kScreenHeight-65.0,280, 40)];
                     _handleButton.layer.cornerRadius = 10.0;
                 }else{
                     _handleButton.tag = 2;
                     _handleButton.enabled = YES;
                     [_handleButton setTitle:@"去辅导" forState:UIControlStateNormal];
                     [_handleButton setBackgroundImage:[UIImage imageNamed:@"button_blue"] forState:UIControlStateNormal];
                 }
             }
         }
        [_handleButton addTarget:self action:@selector(handleHomeworkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handleButton;
}


-(void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

@end
