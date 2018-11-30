//
//  ChooseGradeViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ChooseGradeViewController.h"
#import "GradeTableViewCell.h"

@interface ChooseGradeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView  *gradeTableView;

@property (strong, nonatomic) NSMutableArray  *selectedIndexPaths;    //多选选中的行

@end

@implementation ChooseGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"　授课年级";
    
    self.rigthTitleName = @"确定";
    
    [self.view addSubview:self.gradeTableView];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gradesArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"*最多可以选两个年级";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradeTableViewCell *cell = [[GradeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = self.gradesArray[indexPath.row];
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    for (NSIndexPath *index in self.selectedIndexPaths) {
        if (index == indexPath) { //改行在选择的数组里面有记录
            cell.isSelected = YES;
            break;
        }
    }
    if (self.selectedGradesArray.count>0) {
        for (NSString *gradeStr in self.selectedGradesArray) {
            NSInteger selRow = [self.gradesArray indexOfObject:gradeStr];
            if (selRow == indexPath.row) {
                cell.isSelected = YES;
                [self.selectedIndexPaths addObject:indexPath];
                break;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //获取到点击的cell
    GradeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) { //如果为选中状态
        cell.isSelected = NO;
        [self.selectedIndexPaths removeObject:indexPath];
    }else {
        if (self.selectedIndexPaths.count>1) {
            [self.view makeToast:@"您最多只能选择两个年级" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        cell.isSelected = YES;
        [self.selectedIndexPaths addObject:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark -- Event response
-(void)rightNavigationItemAction{
    NSMutableArray *tempGradesArr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        NSString *gradeStr = self.gradesArray[indexPath.row];
        [tempGradesArr addObject:gradeStr];
    }

    if (tempGradesArr.count>0) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.getGradeBlock) {
            self.getGradeBlock(tempGradesArr);
        }
    }else{
        [self.view makeToast:@"请选择年级" duration:1.0 position:CSToastPositionCenter];
    }
}

#pragma mark -- Getters
-(UITableView *)gradeTableView{
    if (!_gradeTableView) {
        _gradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+10, kScreenWidth, kScreenHeight-kNavHeight-10) style:UITableViewStyleGrouped];
        _gradeTableView.delegate = self;
        _gradeTableView.dataSource = self;
        _gradeTableView.backgroundColor = [UIColor whiteColor];
        _gradeTableView.allowsSelection = YES; //允许多选
    }
    return _gradeTableView;
}

-(NSMutableArray *)selectedIndexPaths{
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    return _selectedIndexPaths;
}

@end
