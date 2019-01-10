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
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:16];
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
    
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectGrade:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self setGradesForIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return IS_IPAD?50:35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IS_IPAD?76:50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,50, 0,50)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0,21, 0, 0)];
    }
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

#pragma mark 选择年级
-(void)selectGrade:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self setGradesForIndexPath:indexPath];
}

#pragma mark - Private Methods
#pragma mark 设置年级
-(void)setGradesForIndexPath:(NSIndexPath *)indexPath{
    GradeTableViewCell *cell = [self.gradeTableView cellForRowAtIndexPath:indexPath];
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

#pragma mark -- Getters
-(UITableView *)gradeTableView{
    if (!_gradeTableView) {
        _gradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _gradeTableView.delegate = self;
        _gradeTableView.dataSource = self;
        _gradeTableView.backgroundColor = [UIColor bgColor_Gray];
        _gradeTableView.allowsSelection = YES; //允许多选
        _gradeTableView.tableFooterView = [[UIView alloc] init];
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
