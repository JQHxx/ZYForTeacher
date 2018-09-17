//
//  AcademicViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AcademicViewController.h"
#import "InputNameViewController.h"
#import "SearchSchoolViewController.h"
#import "NSDate+Extension.h"
#import "BRPickerView.h"

@interface AcademicViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray        *academicTitles;
    
    NSString       *academicStr;     //学历
    NSString       *schoolStr;       //学校
    NSString       *schoolTimeStr;   //在校时间
    UIImage        *academicImage;       //图片
    
    NSString       *tipsStr;
}

@property (nonatomic ,strong) UITableView *academicTableView;

@end

@implementation AcademicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"学历认证";
    self.rigthTitleName = @"保存";
    
    academicTitles = @[@"学历",@"学校",@"在校时间"];
    tipsStr = @"如果你是在校生，请上传学生证照片，如果你已毕业，请上传毕业证照片";
    
    [self.view addSubview:self.academicTableView];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?academicTitles.count:1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section==0?@"学历信息":@"上传学历证明照片";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return section==0?@"":tipsStr;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.text = academicTitles[indexPath.row];
        cell.textLabel.font =kFontWithSize(14);
        cell.detailTextLabel.font = kFontWithSize(14);
        if (indexPath.row==0) {
            cell.detailTextLabel.text = academicStr;
        }else if (indexPath.row==1){
            cell.detailTextLabel.text = schoolStr;
        }else{
            cell.detailTextLabel.text = schoolTimeStr;
        }
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *academicBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-80, 200)];
        UIImage *tempImage = academicImage?academicImage:[UIImage imageNamed:@"ic_frame_add"];
        [academicBtn setImage:tempImage forState:UIControlStateNormal];
        [academicBtn addTarget:self action:@selector(addAcademicImageAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:academicBtn];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (indexPath.row==0) {
            [self setAcademicAction];
        }else if (indexPath.row==1){
            [self setSchoolInfoAction];
        }else{
            [self setSchoolTimeAction];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0?44:220;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat footerHeight = [tipsStr boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) withTextFont:kFontWithSize(14)].height;
    return section==0?0.5:footerHeight+10;
}

#pragma mark -- delegate
#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage* curImage = [info objectForKey:UIImagePickerControllerEditedImage];
    curImage = [curImage cropImageWithSize:CGSizeMake(kScreenWidth-80, 200)];
    academicImage = curImage;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.academicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- Event Response
#pragma mark 设置学历
-(void)setAcademicAction{
    NSArray *academicArr = @[@"大专",@"本科",@"硕士",@"博士",@"其他"];
    [BRStringPickerView showStringPickerWithTitle:@"选择学历" dataSource:academicArr defaultSelValue:@"本科" isAutoSelect:NO resultBlock:^(id selectValue) {
        academicStr = selectValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.academicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 设置学校
-(void)setSchoolInfoAction{
    SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
    searchVC.backBlock = ^(id object) {
        schoolStr = object;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.academicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 设置在校时间
-(void)setSchoolTimeAction{
    NSInteger currentYear = [NSDate currentYear];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=currentYear-50; i<currentYear+10; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%ld年",i]];
    }
    NSArray *timeArr = @[tempArr,@[@"至"],tempArr];
    NSString *currentYearStr = [NSString stringWithFormat:@"%ld年",currentYear];
    [BRStringPickerView showStringPickerWithTitle:@"在校时间" dataSource:timeArr defaultSelValue:@[currentYearStr,@"至",currentYearStr] isAutoSelect:NO resultBlock:^(id selectValue) {
        MyLog(@"value:%@",selectValue);
        NSArray *values = (NSArray *)selectValue;
        schoolTimeStr = [values componentsJoinedByString:@""];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.academicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 上传图片
-(void)addAcademicImageAction{
    [self addPhoto];
}


#pragma mark -- Getters and Setters
#pragma mark 学历
-(UITableView *)academicTableView{
    if (!_academicTableView) {
        _academicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
        _academicTableView.delegate = self;
        _academicTableView.dataSource = self;
        _academicTableView.estimatedSectionHeaderHeight = 0.0;
        _academicTableView.estimatedSectionFooterHeight = 0.0;
    }
    return _academicTableView;
}

@end
