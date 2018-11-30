//
//  TeachInfoViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TeachInfoViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "ChooseGradeViewController.h"
#import "BRPickerView.h"
#import "AppDelegate.h"
#import "LoginButton.h"

@interface TeachInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray    *teachTitlesArray;
    NSString   *lastStage;
}

@property (nonatomic, strong) UILabel            *titleLabel;     //标题
@property (nonatomic ,strong) UITableView        *teachInfoTableView;
@property (nonatomic, strong) LoginButton        *completeButton;       //确定

@end

@implementation TeachInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.isHiddenShaw = YES;
    
    if (self.user&&[self.user.edu_stage integerValue]>0) {
        lastStage = [self.user.edu_stage integerValue]==1?@"小学":@"初中";
    }
    
    teachTitlesArray = @[@"教学经验",@"教授阶段",@"授课年级",@"教学科目"];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.teachInfoTableView];
    [self.view addSubview:self.completeButton];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return teachTitlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    cell.textLabel.text = teachTitlesArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [self.user.edu_exp integerValue]>0?[NSString stringWithFormat:@"%@年",self.user.edu_exp]:@"";
    }else if (indexPath.row == 1){
        if ([self.user.edu_stage integerValue]>0) {
            cell.detailTextLabel.text = [self.user.edu_stage integerValue]==1?@"小学":@"初中";
        }
    }else if (indexPath.row == 2){
        if (self.user.grade.count>0) {
            cell.detailTextLabel.text = [self.user.grade componentsJoinedByString:@","];
        }
    }else{
        cell.detailTextLabel.text = kIsEmptyString(self.user.subject)?@"":self.user.subject;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self setTeachingExperience];
    }else if (indexPath.row == 1){
        [self setTeachingStage];
    }else if (indexPath.row == 2){
        if ([self.user.edu_stage integerValue]==0) {
            [self.view makeToast:@"请先设置教授阶段" duration:1.0 position:CSToastPositionCenter];
        }else{
            [self setTeachingGrade];
        }
    }else{
        if ([self.user.edu_stage integerValue]==0) {
            [self.view makeToast:@"请先设置教授阶段" duration:1.0 position:CSToastPositionCenter];
        }else{
            [self setTeachingSubjects];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark -- Private Methods
#pragma mark 教学经验
-(void)setTeachingExperience{
    NSMutableArray *experienceArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<30; i++) {
        NSString *str = [NSString stringWithFormat:@"%ld年",i+1];
        [experienceArr addObject:str];
    }
    NSString *defaultExp = [self.user.edu_exp integerValue]>0?[NSString stringWithFormat:@"%@年",self.user.edu_exp]:@"1年";
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"教学经验" dataSource:experienceArr defaultSelValue:defaultExp  isAutoSelect:NO resultBlock:^(id selectValue) {
        NSString *value = (NSString *)selectValue;
        NSInteger stage = [[value substringToIndex:value.length-1] integerValue];
        weakSelf.user.edu_exp = [NSNumber numberWithInteger:stage];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 教授阶段
-(void)setTeachingStage{
    kSelfWeak;
    NSString *defaultStage = [self.user.edu_stage integerValue]<2?@"小学":@"初中";
    [BRStringPickerView showStringPickerWithTitle:@"授课阶段" dataSource:@[@"小学",@"初中"] defaultSelValue:defaultStage isAutoSelect:NO resultBlock:^(id selectValue) {
        if (!kIsEmptyString(lastStage)) {
            if (![lastStage isEqualToString:selectValue]) {
                lastStage = selectValue;
                weakSelf.user.edu_stage = [selectValue isEqualToString:@"小学"]?@1:@2;
                weakSelf.user.grade = nil;
                weakSelf.user.subject = nil;
                [weakSelf.teachInfoTableView reloadData];
            }
        }else{
            lastStage = selectValue;
            weakSelf.user.edu_stage = [selectValue isEqualToString:@"小学"]?@1:@2;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

#pragma mark 授课年级
-(void)setTeachingGrade{
    NSArray *gradesArr = [self.user.edu_stage integerValue]==1?@[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"]:@[@"初一",@"初二",@"初三"];
    ChooseGradeViewController *chooseGradeVC = [[ChooseGradeViewController alloc] init];
    chooseGradeVC.gradesArray = gradesArr;
    if (kIsArray(self.user.grade)&&self.user.grade.count>0) {
        chooseGradeVC.selectedGradesArray = self.user.grade;
    }
    
    kSelfWeak;
    chooseGradeVC.getGradeBlock = ^(NSMutableArray *gradesArr) {
        weakSelf.user.grade = gradesArr;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:chooseGradeVC animated:YES];
}

#pragma mark 教学科目
-(void)setTeachingSubjects{
    NSArray *subjects = [ZYHelper sharedZYHelper].subjects;
    
    NSString *eduStage = [self.user.edu_stage integerValue]==1?@"小学":@"初中";
    NSArray *subjectsArr = [eduStage isEqualToString:@"小学"]?@[@"语文",@"数学",@"英语"]:subjects;
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"教学科目" dataSource:subjectsArr defaultSelValue:self.user.subject isAutoSelect:NO resultBlock:^(id selectValue) {
        weakSelf.user.subject = selectValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark -- Event response
#pragma mark 完成
-(void)confirmSetTeachInfoAction{
    if ([self.user.edu_exp integerValue]<1) {
        [self.view makeToast:@"请设置教学经验" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.user.edu_stage integerValue]<1) {
        [self.view makeToast:@"请设置教授阶段" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.user.grade.count<1) {
        [self.view makeToast:@"请选择授课年级" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.user.subject)) {
        [self.view makeToast:@"请选择教学科目" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableArray *gradesArr = [[ZYHelper sharedZYHelper] setGradeIdsArrayWithGradeStrs:self.user.grade];
    NSString *gradesJsonStr = [TCHttpRequest getValueWithParams:gradesArr];
    
    NSArray *subjectsArr = [ZYHelper sharedZYHelper].subjects;
    NSInteger subIndex = [subjectsArr indexOfObject:self.user.subject]+1;
    
    NSString *body = [NSString stringWithFormat:@"token=%@&exp=%@&stage=%@&grade=%@&subject=%ld",self.user.token,self.user.edu_exp,self.user.edu_stage,gradesJsonStr,subIndex];
    kSelfWeak;
    [TCHttpRequest postMethodWithURL:kSetUserInfoAPI body:body success:^(id json) {
        if (!weakSelf.isLoginIn) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[NSUserDefaultsInfos getDicValueforKey:kUserInfo]];
            [dic setObject:weakSelf.user.grade forKey:@"grade"];
            [dic setObject:weakSelf.user.subject forKey:@"subject"];
            [NSUserDefaultsInfos putKey:kUserInfo anddict:dic];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (weakSelf.isLoginIn) {
                [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:YES]];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate setMyRootViewController];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        });
    }];
}


#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, kNavHeight+15, 120, 28)];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _titleLabel.text = @"教学信息";
    }
    return _titleLabel;
}

#pragma mark 教学信息
-(UITableView *)teachInfoTableView{
    if (!_teachInfoTableView) {
        _teachInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom+20, kScreenWidth, 200) style:UITableViewStylePlain];
        _teachInfoTableView.dataSource = self;
        _teachInfoTableView.delegate = self;
        _teachInfoTableView.tableFooterView = [[UIView alloc] init];
    }
    return _teachInfoTableView;
}

#pragma mark 确定
-(LoginButton *)completeButton{
    if (!_completeButton) {
        _completeButton = [[LoginButton alloc] initWithFrame:CGRectMake(48.0,self.teachInfoTableView.bottom+50, kScreenWidth-95.0, (kScreenWidth-95.0)*(128.0/588.0)) title:@"确定"];
        [_completeButton addTarget:self action:@selector(confirmSetTeachInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}


@end
