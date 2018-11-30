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

#define kImageViewHeight 200

@interface UserDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray    *titlesArray;
    NSArray    *classesArray;
}


@property (nonatomic ,strong) UITableView    *userTableView;

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"个人中心";
    
    titlesArray = @[@"个人信息",@"教学信息",@"实名认证",@"学历认证",@"教师资质",@"专业认证"];
    
    [self.view addSubview:self.userTableView];
    if (kIsEmptyObject(self.userInfo)) {
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
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0||indexPath.row==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView *authenticateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-97, 14, 22, 22)];
        authenticateImageView.image = [UIImage imageNamed:@"authentication"];
        [cell.contentView addSubview:authenticateImageView];
        
        UILabel *authenticateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-68, 14, 50, 22)];
        authenticateLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        [cell.contentView addSubview:authenticateLabel];
        if (indexPath.row==2) {
            authenticateImageView.hidden = [self.userInfo.auth_id integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_id];
        }else if (indexPath.row==3){
            authenticateImageView.hidden = [self.userInfo.auth_edu integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_edu];
        }else if (indexPath.row==4){
            authenticateImageView.hidden = [self.userInfo.auth_teach integerValue]!=2;
            authenticateLabel.text = [self getAuthStateWithAuth:self.userInfo.auth_teach];;
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
            authenticateLabel.frame = CGRectMake(kScreenWidth-97, 14, 82, 22);
        }else{
            authenticateLabel.frame = CGRectMake(kScreenWidth-68, 14, 50, 22);
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
    return 50;
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
        
        [NSUserDefaultsInfos putKey:kAuthIdentidy andValue:weakSelf.userInfo.auth_id];   //实名认证
        [NSUserDefaultsInfos putKey:kAuthEducation andValue:weakSelf.userInfo.auth_edu];  //学历认证
        [NSUserDefaultsInfos putKey:kAuthTeach andValue:weakSelf.userInfo.auth_teach];   //教师资质
        [NSUserDefaultsInfos putKey:kAuthSkill andValue:weakSelf.userInfo.auth_skill];    //技能认证
        
        if (!kIsEmptyString(weakSelf.userInfo.trait)&&!kIsEmptyString(weakSelf.userInfo.tch_name)) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:weakSelf.userInfo.tid,@"tid",weakSelf.userInfo.trait,@"trait",weakSelf.userInfo.tch_name,@"tch_name",weakSelf.userInfo.grade,@"grade",weakSelf.userInfo.subject,@"subject",weakSelf.userInfo.score,@"score",weakSelf.userInfo.guide_price,@"guide_price",weakSelf.userInfo.guide_time,@"tutoring_time",weakSelf.userInfo.check_num,@"check_num",nil];
            [NSUserDefaultsInfos putKey:kUserInfo anddict:userDict];
        }
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
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.showsVerticalScrollIndicator=NO;
        _userTableView.backgroundColor=[UIColor whiteColor];
        _userTableView.tableFooterView = [[UIView alloc] init];
    }
    return _userTableView;
}



@end
