//
//  UserDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/30.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "UserDetailsViewController.h"

#define kImageViewHeight 200

@interface UserDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray    *imagesArray;
    NSArray    *titlesArray;
    NSArray    *classesArray;
}

@property (nonatomic ,strong) UIButton       *backBtn;
@property (nonatomic ,strong) UITableView    *userTableView;
@property (nonatomic, strong) UIImageView    *backImageView;    //背景图片
@property (nonatomic, strong) UIImageView    *headImageView;    //头像
@property (nonatomic, strong) UILabel        *nickNameLabel;    //昵称

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    imagesArray = @[@"",@"",@"",@"",@"",@""];
    titlesArray = @[@"个人信息",@"教学信息",@"实名认证",@"学历认证",@"教师资质",@"专业认证"];
    classesArray = @[@"UserInfo",@"TeachInfo",@"Verified",@"Academic",@"TeacherCertificate",@"Professional"];
    
    [self initUserDetailsView];
    [self loadUserInfoData];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.imageView.image = [UIImage imageNamed:imagesArray[indexPath.row]];
    cell.textLabel.text = titlesArray[indexPath.row];
    if (indexPath.row==0||indexPath.row==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *classStr = [NSString stringWithFormat:@"%@ViewController",classesArray[indexPath.row]];
    Class aClass = NSClassFromString(classStr);
    BaseViewController *vc = (BaseViewController *)[[aClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if (y < -kImageViewHeight) {
        CGRect frame=self.backImageView.frame;
        frame.origin.y=y;
        frame.size.height=-y;
        self.backImageView.frame=frame;
    }
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initUserDetailsView{
    [self.view addSubview:self.userTableView];
    [self.userTableView addSubview:self.backImageView];
    [self.backImageView addSubview:self.headImageView];
    [self.backImageView addSubview:self.nickNameLabel];
    
    [self.view addSubview:self.backBtn];
}

#pragma mark 加载数据
-(void)loadUserInfoData{
    UIImage *img = [UIImage imageNamed:@"ic_m_head"];
    self.headImageView.image = [img imageWithCornerRadius:50.0];
    self.nickNameLabel.text = @"小美老师";
}

#pragma mark 返回按钮
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [_backBtn setImage:[UIImage drawImageWithName:@"back"size:CGSizeMake(12, 19)] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [_backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark 用户信息
-(UITableView *)userTableView{
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.showsVerticalScrollIndicator=NO;
        _userTableView.contentInset=UIEdgeInsetsMake(kImageViewHeight, 0, 0, 0);
        _userTableView.backgroundColor=[UIColor whiteColor];
        _userTableView.tableFooterView = [[UIView alloc] init];
    }
    return _userTableView;
}

#pragma mark 背景图片
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageViewHeight-20, kScreenWidth, kImageViewHeight+20)];
        _backImageView.image = [UIImage imageNamed:@"mine_background"];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.autoresizesSubviews = YES; //设置autoresizesSubviews让子类自动布局
    }
    return _backImageView;
}

#pragma mark 头像
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 60, 100, 100)];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;  //自动布局，自适应顶部
    }
    return _headImageView;
}

#pragma mark 昵称
-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.headImageView.bottom+10,kScreenWidth-120, 30)];
        _nickNameLabel.textColor=[UIColor whiteColor];
        _nickNameLabel.font=[UIFont systemFontOfSize:15];
        _nickNameLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameLabel;
}



@end
