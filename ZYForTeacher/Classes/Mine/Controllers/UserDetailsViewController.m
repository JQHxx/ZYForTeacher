//
//  UserDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/30.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "UserInfoViewController.h"
#import "TeachInfoViewController.h"
#import "VerifiedViewController.h"
#import "AcademicViewController.h"
#import "TeacherCertificateViewController.h"
#import "ProfessionalViewController.h"
#import "UserModel.h"


@interface UserDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray    *titlesArray;
    NSArray    *classesArray;
    
    NSInteger  userIdentity;
}

@property (nonatomic ,strong) UITableView    *userTableView;

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"个人中心";
    
    
    titlesArray = @[@"个人信息",@"教学信息",@"实名认证",@"学历认证",@"教师资质",@"等级职称"];
    
    [self.view addSubview:self.userTableView];
    
    if (self.isHomeworkIn) {
        self.userInfo = [[UserModel alloc] init];
        [self loadUserInfoData];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZYHelper sharedZYHelper].isUpdateUserInfo) {
        [self loadUserInfoData];
        [ZYHelper sharedZYHelper].isUpdateUserInfo = NO;
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0||indexPath.row==1) {
        if (IS_IPAD) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-55.4,27,12.6,23)];
            arrowImageView.image = [UIImage imageNamed:@"arrow_ipad"];
            [cell.contentView addSubview:arrowImageView];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView *authenticateImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-162, 21, 34, 34):CGRectMake(kScreenWidth-97, 14, 22, 22)];
        authenticateImageView.image = [UIImage imageNamed:IS_IPAD?@"authentication_ipad":@"authentication"];
        [cell.contentView addSubview:authenticateImageView];
        
        UILabel *authenticateLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-118, 20, 80, 36):CGRectMake(kScreenWidth-68, 14, 50, 22)];
        authenticateLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        authenticateLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:authenticateLabel];
        if (indexPath.row==2) {
            authenticateImageView.hidden = [self.userInfo.auth_id integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_id];
        }else if (indexPath.row==3){
            authenticateImageView.hidden = [self.userInfo.auth_edu integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_edu];
        }else if (indexPath.row==4){
            authenticateImageView.hidden = [self.userInfo.auth_teach integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_teach];
        }else{
            authenticateImageView.hidden = [self.userInfo.auth_skill integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_skill];;
        }
        if ([authenticateLabel.text isEqualToString:@"已认证"]) {
            authenticateLabel.textColor = [UIColor colorWithHexString:@"#F5A623"];
        }else{
            authenticateLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        }
        if ([authenticateLabel.text isEqualToString:@"审核未通过"]) {
            authenticateLabel.frame = IS_IPAD?CGRectMake(kScreenWidth-175, 20,140, 36):CGRectMake(kScreenWidth-97, 14, 82, 22);
        }else{
            authenticateLabel.frame = IS_IPAD?CGRectMake(kScreenWidth-118, 20, 80, 36):CGRectMake(kScreenWidth-68, 14, 50, 22);
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==0) {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.userModel = self.userInfo;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else if (indexPath.row==1){
        TeachInfoViewController *teachInfoVC = [[TeachInfoViewController alloc] init];
        teachInfoVC.user = self.userInfo;
        [self.navigationController pushViewController:teachInfoVC animated:YES];
    }else if(indexPath.row==2){
        if ([self.userInfo.auth_id integerValue]==0||[self.userInfo.auth_id integerValue]==3) {
            VerifiedViewController *verfiedVC = [[VerifiedViewController alloc] init];
            [self.navigationController pushViewController:verfiedVC animated:YES];
        }
    }else if (indexPath.row==3){
        if ([self.userInfo.auth_edu integerValue]==0||[self.userInfo.auth_edu integerValue]==3) {
            AcademicViewController *academicVC = [[AcademicViewController alloc] init];
            [self.navigationController pushViewController:academicVC animated:YES];
        }
    }else if (indexPath.row==4){
        if ([self.userInfo.auth_teach integerValue]==0||[self.userInfo.auth_teach integerValue]==3) {
            TeacherCertificateViewController *teacherCertVC = [[TeacherCertificateViewController alloc] init];
            [self.navigationController pushViewController:teacherCertVC animated:YES];
        }
    }else{
        if ([self.userInfo.auth_skill integerValue]==0||[self.userInfo.auth_skill integerValue]==3) {
            ProfessionalViewController *professionalVC = [[ProfessionalViewController alloc] init];
            [self.navigationController pushViewController:professionalVC animated:YES];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IS_IPAD?76:50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,40, 0,40)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0,21, 0, 0)];
    }
}

#pragma mark -- Private Methods
-(NSString *)getAuthStateWithAuth:(NSNumber *)authNum{
    NSString *state =nil;
    NSInteger auth = [authNum integerValue];
    if (auth==0) {
        state = @"待认证";
    }else if (auth==1){
        state = @"待审核";
    }else if (auth==2){
       state = @"已认证";
    }else{
       state = @"审核未通过";
    }
    return state;
}

#pragma mark 获取用户信息
-(void)loadUserInfoData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@",kUserTokenValue];
    [TCHttpRequest postMethodWithURL:kGetUserInfoAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        [weakSelf.userInfo setValues:data];
        
        weakSelf.userInfo.subject = kIsEmptyObject(data[@"subject"])?@"":weakSelf.userInfo.subject;
        
        [NSUserDefaultsInfos putKey:kAuthIdentidy andValue:weakSelf.userInfo.auth_id];   //实名认证
        [NSUserDefaultsInfos putKey:kAuthEducation andValue:weakSelf.userInfo.auth_edu];  //学历认证
        [NSUserDefaultsInfos putKey:kAuthTeach andValue:weakSelf.userInfo.auth_teach];   //教师资质
        [NSUserDefaultsInfos putKey:kAuthSkill andValue:weakSelf.userInfo.auth_skill];    //技能认证
        
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setObject:weakSelf.userInfo.tid forKey:@"tch_id"];
        if (!kIsEmptyString(weakSelf.userInfo.trait)&&!kIsEmptyString(weakSelf.userInfo.tch_name)) {
            [userDict setObject:weakSelf.userInfo.trait forKey:@"trait"];
            [userDict setObject:weakSelf.userInfo.tch_name forKey:@"tch_name"];
        }
        if (!kIsEmptyString(weakSelf.userInfo.subject)&&weakSelf.userInfo.grade.count>0) {
            [userDict setObject:weakSelf.userInfo.subject forKey:@"subject"];
            [userDict setObject:weakSelf.userInfo.grade forKey:@"grade"];
        }
        [userDict setObject:weakSelf.userInfo.score forKey:@"score"];
        [userDict setObject:weakSelf.userInfo.guide_price forKey:@"guide_price"];
        [userDict setObject:weakSelf.userInfo.guide_time forKey:@"guide_time"];
        [userDict setObject:weakSelf.userInfo.check_num forKey:@"check_num"];
        [NSUserDefaultsInfos putKey:kUserInfo anddict:userDict];
        
        [NSUserDefaultsInfos putKey:kIsOnline andValue:weakSelf.userInfo.online];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.userTableView reloadData];
        });
    }];
}

#pragma mark -- getters
#pragma mark 用户信息
-(UITableView *)userTableView{
    if (!_userTableView) {
        CGFloat navheight = kNavHeight;
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,navheight+6, kScreenWidth, kScreenHeight-navheight-6) style:UITableViewStylePlain];
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.showsVerticalScrollIndicator=NO;
        _userTableView.backgroundColor=[UIColor whiteColor];
        _userTableView.tableFooterView = [[UIView alloc] init];
    }
    return _userTableView;
}



@end
