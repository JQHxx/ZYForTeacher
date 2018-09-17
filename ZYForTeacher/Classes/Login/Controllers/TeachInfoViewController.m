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
#import "TeachModel.h"
#import "BRPickerView.h"
#import "AppDelegate+Extension.h"
#import "LoginButton.h"

@interface TeachInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray    *teachTitlesArray;
    NSString   *lastStage;
}

@property (nonatomic, strong) UILabel            *titleLabel;     //标题
@property (nonatomic ,strong) UITableView        *teachInfoTableView;
@property (nonatomic, strong) LoginButton        *completeButton;       //确定

@property (nonatomic ,strong) TeachModel *teachInfo;

@end

@implementation TeachInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.isHiddenShaw = YES;
    
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
        cell.detailTextLabel.text = self.teachInfo.teach;
    }else if (indexPath.row == 1){
        cell.detailTextLabel.text = self.teachInfo.teach_stage;
    }else if (indexPath.row == 2){
        cell.detailTextLabel.text = self.teachInfo.grade;
    }else{
        cell.detailTextLabel.text = self.teachInfo.subject;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self setTeachingExperience];
    }else if (indexPath.row == 1){
        [self setTeachingStage];
    }else if (indexPath.row == 2){
        if (kIsEmptyObject(self.teachInfo.teach_stage)) {
            [self.view makeToast:@"请先设置教授阶段" duration:1.0 position:CSToastPositionCenter];
        }else{
            [self setTeachingGrade];
        }
    }else{
        if (kIsEmptyObject(self.teachInfo.teach_stage)) {
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
    for (NSInteger i=0; i<20; i++) {
        NSString *str = [NSString stringWithFormat:@"%ld年",i+1];
        [experienceArr addObject:str];
    }
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"教学经验" dataSource:experienceArr defaultSelValue:self.teachInfo.teach isAutoSelect:NO resultBlock:^(id selectValue) {
        weakSelf.teachInfo.teach = selectValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 教授阶段
-(void)setTeachingStage{
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"授课阶段" dataSource:@[@"小学",@"初中"] defaultSelValue:self.teachInfo.teach_stage isAutoSelect:NO resultBlock:^(id selectValue) {
        if (!kIsEmptyString(lastStage)) {
            if (![lastStage isEqualToString:selectValue]) {
                lastStage = selectValue;
                weakSelf.teachInfo.teach_stage = selectValue;
                weakSelf.teachInfo.grade = nil;
                weakSelf.teachInfo.subject = nil;
                [weakSelf.teachInfoTableView reloadData];
            }
        }else{
            lastStage = selectValue;
            weakSelf.teachInfo.teach_stage = selectValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

#pragma mark 授课年级
-(void)setTeachingGrade{
    NSArray *gradesArr = [self.teachInfo.teach_stage isEqualToString:@"小学"]?@[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"]:@[@"初一",@"初二",@"初三"];
    ChooseGradeViewController *chooseGradeVC = [[ChooseGradeViewController alloc] init];
    chooseGradeVC.gradesArray = gradesArr;
    if (!kIsEmptyString(self.teachInfo.grade)) {
        chooseGradeVC.selectedGradesArray = [self.teachInfo.grade componentsSeparatedByString:@","];
    }
    
    kSelfWeak;
    chooseGradeVC.getGradeBlock = ^(NSString *gradeStr) {
        weakSelf.teachInfo.grade = gradeStr;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:chooseGradeVC animated:YES];
}

#pragma mark 教学科目
-(void)setTeachingSubjects{
    NSArray *subjectsArr = [[ZYHelper sharedZYHelper] getCourseForStage:self.teachInfo.teach_stage];
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"教学科目" dataSource:subjectsArr defaultSelValue:self.teachInfo.subject isAutoSelect:NO resultBlock:^(id selectValue) {
        weakSelf.teachInfo.subject = selectValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [weakSelf.teachInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark -- Event response
#pragma mark 完成
-(void)confirmSetTeachInfoAction{
    if (self.isLoginIn) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setMyRootViewController];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark
-(TeachModel *)teachInfo{
    if (!_teachInfo) {
        _teachInfo = [[TeachModel alloc] init];
    }
    return _teachInfo;
}


@end
