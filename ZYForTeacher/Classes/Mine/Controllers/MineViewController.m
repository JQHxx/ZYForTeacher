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

#define kImageViewHeight 120

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSArray       *titleArray;
    NSArray       *imagesArray;
    NSArray       *classesArray;
}

@property (nonatomic ,strong) UITableView    *mineTableView;
@property (nonatomic, strong) UIImageView    *zoomImageView;    //背景图片
@property (nonatomic, strong) UIImageView    *headImageView;    //头像
@property (nonatomic, strong) UILabel        *nickNameLabel;    //昵称
@property (nonatomic, strong) UILabel        *levelLabel;       //等级

@end

@implementation MineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    titleArray = @[@"我的订单",@"我的钱包",@"联系客服",@"邀请老师",@"设置"];
    classesArray = @[@"MyOrder",@"MyWallet",@"ContactService",@"InviteTeacher",@"Setup"];
    
    [self initMineView];
    [self loadUserInfoData];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = kFontWithSize(16);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *classStr = [NSString stringWithFormat:@"%@ViewController",classesArray[indexPath.row]];
    Class aClass = NSClassFromString(classStr);
    BaseViewController *vc = (BaseViewController *)[[aClass alloc] init];
    [self pushToViewController:vc];
}

#pragma mark -- UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if (y < -kImageViewHeight) {
        CGRect frame=_zoomImageView.frame;
        frame.origin.y=y;
        frame.size.height=-y;
        _zoomImageView.frame=frame;
    }
}

#pragma mark -- Event Response
-(void)gotoUserDetailsVC{
    UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] init];
    [self pushToViewController:userDetailsVC];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initMineView{
    [self.view addSubview:self.mineTableView];
    [self.mineTableView addSubview:self.zoomImageView];
    [self.zoomImageView addSubview:self.headImageView];
    [self.zoomImageView addSubview:self.nickNameLabel];
    [self.zoomImageView addSubview:self.levelLabel];
}

#pragma mark 加载数据
-(void)loadUserInfoData{
    UIImage *img = [UIImage imageNamed:@"ic_m_head"];
    self.headImageView.image = [img imageWithCornerRadius:30.0];
    self.nickNameLabel.text = @"小明";
    self.levelLabel.text = @"高级教师";
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
#pragma mark 个人信息
-(UITableView *)mineTableView{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth-100, kScreenHeight) style:UITableViewStylePlain];
        _mineTableView.dataSource = self;
        _mineTableView.delegate = self;
        _mineTableView.showsVerticalScrollIndicator=NO;
        _mineTableView.contentInset=UIEdgeInsetsMake(kImageViewHeight, 0, 0, 0);
        _mineTableView.backgroundColor=[UIColor whiteColor];
        _mineTableView.estimatedSectionHeaderHeight=0;
        _mineTableView.estimatedSectionFooterHeight=0;
    }
    return _mineTableView;
}

#pragma mark 背景图片
-(UIImageView *)zoomImageView{
    if (!_zoomImageView) {
        _zoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageViewHeight, kScreenWidth-100, kImageViewHeight)];
        _zoomImageView.image = [UIImage imageNamed:@"mine_background"];
        _zoomImageView.userInteractionEnabled = YES;
        _zoomImageView.autoresizesSubviews = YES; //设置autoresizesSubviews让子类自动布局
    }
    return _zoomImageView;
}

#pragma mark 头像
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 60, 60)];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;  //自动布局，自适应顶部
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserDetailsVC)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

#pragma mark 昵称
-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.right+10, 45, 100, 30)];
        _nickNameLabel.textColor=[UIColor whiteColor];
        _nickNameLabel.font=[UIFont systemFontOfSize:15];
        _nickNameLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    }
    return _nickNameLabel;
}

#pragma mark 年级
-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.right+10, self.nickNameLabel.bottom, 80, 20)];
        _levelLabel.textColor=[UIColor lightGrayColor];
        _levelLabel.font=[UIFont systemFontOfSize:13];
        _levelLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    }
    return _levelLabel;
}

@end
