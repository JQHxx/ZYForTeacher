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
    
    imagesArray = @[@"my_orders",@"my_wallet",@"my_service",@"my_invite",@"my_setup"];
    titleArray = @[@"我的订单",@"我的钱包",@"联系客服",@"邀请老师",@"设置"];
    classesArray = @[@"MyOrder",@"MyWallet",@"ContactService",@"",@"Setup"];
    
    [self initMineView];
    [self loadUserInfoData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoData:) name:kAuthUpdateNotification object:nil];
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
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@" #4A4A4A"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    [TCHttpRequest postMethodWithURL:kGetUserInfoAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        [user setValues:data];
        
        [NSUserDefaultsInfos putKey:kAuthIdentidy andValue:user.auth_id];   //实名认证
        [NSUserDefaultsInfos putKey:kAuthEducation andValue:user.auth_edu];  //学历认证
        [NSUserDefaultsInfos putKey:kAuthTeach andValue:user.auth_teach];   //教师资质
        [NSUserDefaultsInfos putKey:kAuthSkill andValue:user.auth_skill];    //技能认证
        
        if (!kIsEmptyString(user.trait)&&!kIsEmptyString(user.tch_name)&&!kIsEmptyString(user.subject)) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:user.tid,@"tch_id",user.trait,@"trait",user.tch_name,@"tch_name",user.grade,@"grade",user.subject,@"subject",user.score,@"score",user.guide_price,@"guide_price",user.guide_time,@"guide_time",user.check_num,@"check_num",nil];
            [NSUserDefaultsInfos putKey:kUserInfo anddict:userDict];
        }
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
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-85, 300)];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_headerView.width-100)/2.0, 50, 100, 100)];
        bgImageView.backgroundColor = [UIColor whiteColor];
        bgImageView.boderRadius = 50;
        [_headerView addSubview:bgImageView];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.left+5, 55, 90, 90)];
        headImageView.boderRadius = 45.0;
        headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserDetailsVC)];
        [headImageView addGestureRecognizer:tap];
        [_headerView addSubview:headImageView];
        
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, bgImageView.bottom+12,_headerView.width-60, 25)];
        nickNameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        nickNameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:nickNameLabel];
        
        levelLabel = [[UILabel alloc] initWithFrame:CGRectMake((_headerView.width-64)/2.0, nickNameLabel.bottom+3,64, 18)];
        levelLabel.textColor = [UIColor colorWithHexString:@"#FF9E1F"];
        levelLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        levelLabel.layer.borderColor = [UIColor colorWithHexString:@"#FF9E1F"].CGColor;
        levelLabel.layer.borderWidth = 0.5;
        [_headerView addSubview:levelLabel];
        
        NSArray *titles = @[@"评分",@"粉丝"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.width/2.0-90+100*i, levelLabel.bottom+10,80, 25)];
            valueLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:18];
            valueLabel.textAlignment = NSTextAlignmentCenter;
            [_headerView addSubview:valueLabel];
            if (i==0) {
                scoreLabel = valueLabel;
            }else{
                fansLabel = valueLabel;
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*100+_headerView.width/2.0-90, valueLabel.bottom+2,80, 20)];
            titleLabel.textColor = [UIColor colorWithHexString:@"#808080"];
            titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titles[i];
            [_headerView addSubview:titleLabel];
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.width/2.0, levelLabel.bottom+14, 1, 38)];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_headerView addSubview:line];
        
    }
    return _headerView;
}

#pragma mark 个人信息
-(UITableView *)mineTableView{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth-85, kScreenHeight) style:UITableViewStylePlain];
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
