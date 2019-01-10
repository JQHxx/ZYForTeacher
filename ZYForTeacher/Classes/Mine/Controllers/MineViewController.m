//
//  MineViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MineViewController.h"
#import "UserDetailsViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "UserModel.h"
#import <UShareUI/UShareUI.h>
#import "MJRefresh.h"
#import "BaseWebViewController.h"

#define kImageViewHeight 120

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSArray       *titleArray;
    NSArray       *imagesArray;
    NSArray       *classesArray;
    
    UIImageView    *headImageView;    //头像
    UILabel        *nickNameLabel;    //昵称
    UILabel        *levelLabel;       //等级
    UILabel        *scoreLabel;       //评分
    UILabel        *fansLabel;        //粉丝
    
    UserModel     *user;
}

@property (nonatomic ,strong) UIView         *headerView;
@property (nonatomic ,strong) UITableView    *mineTableView;

@end

@implementation MineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isHiddenNavBar = YES;
    
    user = [[UserModel alloc] init];
    
    imagesArray = IS_IPAD?@[@"my_orders_ipad",@"my_wallet_ipad",@"my_service_ipad",@"my_invitation_ipad",@"use_help_ipad",@"my_setup_ipad"]:@[@"my_orders",@"my_wallet",@"my_service",@"my_invite",@"use_help",@"my_setup"];
    titleArray = @[@"我的订单",@"我的钱包",@"联系客服",@"邀请老师",@"常见问题",@"设置"];
    classesArray = @[@"MyOrder",@"MyWallet",@"ContactService",@"",@"UserHelp",@"Setup"];
    
    [self initMineView];
    [self loadUserInfoData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的"];
    
    [self loadUserInfoData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoData:) name:kAuthUpdateNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"我的"];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.image = [UIImage imageNamed:imagesArray[indexPath.row]];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?23:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@" #4A4A4A"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IS_IPAD?75:50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==3) {
        kSelfWeak;
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //创建网页内容对象
            UIImage *image = [UIImage imageNamed:@"logo180"];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"下载作业101教师端" descr:@"中小学作业1对1在线辅导" thumImage:image];
            shareObject.webpageUrl = @"http://zuoye101.com/";
            messageObject.shareObject = shareObject;
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view makeToast:@"分享成功" duration:1.0 position:CSToastPositionCenter];
                    });
                } else {
                    if (error.code == 2009) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.view makeToast:@"您已取消分享" duration:1.0 position:CSToastPositionCenter];
                        });
                    }
                    MyLog(@"分享失败， error:%@",error.localizedDescription);
                }
                
            }];
        }];
    }else if (indexPath.row==4){
        BaseWebViewController *commonProlemVC = [[BaseWebViewController alloc] init];
        commonProlemVC.webTitle = @"常见问题";
        commonProlemVC.urlStr = kCommonProblemURL;
        commonProlemVC.webType = WebViewTypeCommonProblem;
        [self pushToViewController:commonProlemVC];
    }else{
        NSString *classStr = [NSString stringWithFormat:@"%@ViewController",classesArray[indexPath.row]];
        Class aClass = NSClassFromString(classStr);
        BaseViewController *vc = (BaseViewController *)[[aClass alloc] init];
        [self pushToViewController:vc];
    }
}

#pragma mark -- Event Response
-(void)gotoUserDetailsVC{
    UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] init];
    userDetailsVC.userInfo = user;
    [self pushToViewController:userDetailsVC];
}

#pragma mark 消息回调
#pragma mark 刷新用户信息
-(void)refreshUserInfoData:(NSNotification *)notify{
    [self loadUserInfoData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAuthUpdateNotification object:nil];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initMineView{
    [self.view addSubview:self.mineTableView];
    self.mineTableView.tableHeaderView = self.headerView;
}

#pragma mark 加载数据
-(void)loadUserInfoData{
    NSString *body = [NSString stringWithFormat:@"token=%@",kUserTokenValue];
    [TCHttpRequest postMethodWithoutLoadingForURL:kGetUserInfoAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        [user setValues:data];
        
        [NSUserDefaultsInfos putKey:kAuthIdentidy andValue:user.auth_id];   //实名认证
        [NSUserDefaultsInfos putKey:kAuthEducation andValue:user.auth_edu];  //学历认证
        [NSUserDefaultsInfos putKey:kAuthTeach andValue:user.auth_teach];   //教师资质
        [NSUserDefaultsInfos putKey:kAuthSkill andValue:user.auth_skill];    //技能认证
        
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setObject:user.tid forKey:@"tch_id"];
        if (!kIsEmptyString(user.trait)&&!kIsEmptyString(user.tch_name)) {
            [userDict setObject:user.trait forKey:@"trait"];
            [userDict setObject:user.tch_name forKey:@"tch_name"];
        }
        if (!kIsEmptyString(user.subject)&&user.grade.count>0) {
            [userDict setObject:user.subject forKey:@"subject"];
            [userDict setObject:user.grade forKey:@"grade"];
        }
        [userDict setObject:user.score forKey:@"score"];
        [userDict setObject:user.guide_price forKey:@"guide_price"];
        [userDict setObject:user.guide_time forKey:@"guide_time"];
        [userDict setObject:user.check_num forKey:@"check_num"];
        [NSUserDefaultsInfos putKey:kUserInfo anddict:userDict];
        
        [NSUserDefaultsInfos putKey:kIsOnline andValue:user.online];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (kIsEmptyString(user.trait)) {
                headImageView.image = [UIImage imageNamed:@"default_head_image"];
            }else{
                [headImageView sd_setImageWithURL:[NSURL URLWithString:user.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
            }
            nickNameLabel.text = user.tch_name;
            levelLabel.hidden = kIsEmptyString(user.level);
            levelLabel.text = kIsEmptyString(user.level)?@"":user.level;
            scoreLabel.text = [NSString stringWithFormat:@"%.1f",[user.score doubleValue]];
            fansLabel.text = [NSString stringWithFormat:@"%@",user.follower_num];
        });
    }];
}

#pragma mark 跳转
-(void)pushToViewController:(BaseViewController *)vc{
    BaseNavigationController *nav = (BaseNavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:vc animated:YES];
    
    //当我们push成功之后，关闭我们的抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

#pragma mark -- Getters
#pragma mark 头视图
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(0, 0, 445.0, 420): CGRectMake(0, 0,240, 300)];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake((_headerView.width-154.0)/2.0, 76.0, 154.0, 154.0):CGRectMake((_headerView.width-100)/2.0, 50, 100, 100)];
        bgImageView.image = [UIImage imageNamed:IS_IPAD?@"head_portrait_ipad":@"connection_head_image_white"];
        [_headerView addSubview:bgImageView];
        
        headImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(bgImageView.left+8, 84, 138, 138):CGRectMake(bgImageView.left+5, 55, 90, 90)];
        headImageView.boderRadius = IS_IPAD?69:45.0;
        headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserDetailsVC)];
        [headImageView addGestureRecognizer:tap];
        [_headerView addSubview:headImageView];
        
        nickNameLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(60, headImageView.bottom+25, _headerView.width-120, 40):CGRectMake(30, bgImageView.bottom+12,_headerView.width-60, 25)];
        nickNameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        nickNameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?28:18];
        nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:nickNameLabel];
        
        levelLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake((_headerView.width-98.0)/2.0, nickNameLabel.bottom+4, 98.0, 28):CGRectMake((_headerView.width-64)/2.0, nickNameLabel.bottom+3,64, 18)];
        levelLabel.textColor = [UIColor colorWithHexString:@"#FF9E1F"];
        levelLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?18:12];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        levelLabel.layer.borderColor = [UIColor colorWithHexString:@"#FF9E1F"].CGColor;
        levelLabel.layer.borderWidth = 1;
        [_headerView addSubview:levelLabel];
        
        NSArray *titles = @[@"评分",@"粉丝"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(_headerView.width/2.0-90+100*i, levelLabel.bottom+20, 80, 40):CGRectMake(_headerView.width/2.0-90+100*i, levelLabel.bottom+10,80, 25)];
            valueLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:IS_IPAD?28:18];
            valueLabel.textAlignment = NSTextAlignmentCenter;
            [_headerView addSubview:valueLabel];
            if (i==0) {
                scoreLabel = valueLabel;
            }else{
                fansLabel = valueLabel;
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(_headerView.width/2.0-90+100*i, valueLabel.bottom, 80, 28):CGRectMake(i*100+_headerView.width/2.0-90, valueLabel.bottom+2,80, 20)];
            titleLabel.textColor = [UIColor colorWithHexString:@"#808080"];
            titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?20:18];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titles[i];
            [_headerView addSubview:titleLabel];
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(_headerView.width/2.0, levelLabel.bottom+26, 1, 58):CGRectMake(_headerView.width/2.0, levelLabel.bottom+14, 1, 38)];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_headerView addSubview:line];
        
    }
    return _headerView;
}

#pragma mark 个人信息
-(UITableView *)mineTableView{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:IS_IPAD?CGRectMake(0, 0, 445, kScreenHeight):CGRectMake(0, 0,240, kScreenHeight) style:UITableViewStylePlain];
        _mineTableView.dataSource = self;
        _mineTableView.delegate = self;
        _mineTableView.showsVerticalScrollIndicator=NO;
        _mineTableView.backgroundColor = [UIColor whiteColor];
        _mineTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mineTableView.estimatedSectionHeaderHeight=0;
        _mineTableView.estimatedSectionFooterHeight=0;
    }
    return _mineTableView;
}


@end
