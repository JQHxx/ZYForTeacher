//
//  AcademicViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "AcademicViewController.h"
#import "SearchSchoolViewController.h"
#import "NSDate+Extension.h"
#import "BRPickerView.h"

#define kPhotoHeight (kScreenWidth-55)*(18.0/32.0)

@interface AcademicViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray        *academicTitles;
    
    NSString       *academicStr;     //学历
    NSString       *schoolStr;       //学校
    NSString       *startTimeStr;   //在校开始时间
    NSString       *endTimeStr;     //在校结束时间
    UIImage        *academicImage;       //图片
    
    NSString       *tipsStr;
}

@property (nonatomic ,strong) UITableView *academicTableView;

@end

@implementation AcademicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"学历认证";
    self.rigthTitleName = @"提交";
    
    academicTitles = @[@"学历",@"学校",@"在校时间"];
    tipsStr = @"*如果你是在校生，请上传学生证照片，如果你已毕业，请上传毕业证照片*";
    
    [self.view addSubview:self.academicTableView];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return academicTitles.count+1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.row<3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell.textLabel.text = academicTitles[indexPath.row];
        cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        cell.detailTextLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        if (indexPath.row==0) {
            cell.detailTextLabel.text = academicStr;
        }else if (indexPath.row==1){
            cell.detailTextLabel.text = schoolStr;
        }else{
            cell.detailTextLabel.text = kIsEmptyObject(startTimeStr)?@"": [NSString stringWithFormat:@"%@至%@",startTimeStr,endTimeStr];
        }
        
        if (IS_IPAD) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-55.4,27,12.6,23)];
            arrowImageView.image = [UIImage imageNamed:@"arrow_ipad"];
            [cell.contentView addSubview:arrowImageView];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 20, 240, 36):CGRectMake(15, 15, 200, 22)];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        lab.text = @"上传学历证明照片";
        lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [cell.contentView addSubview:lab];
        
        UIButton *academicBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(138, lab.bottom+20, kScreenWidth-276, 276):CGRectMake(28,lab.bottom+14,kScreenWidth-55,kPhotoHeight)];
        academicBtn.backgroundColor = [UIColor colorWithHexString:@"#F1F1F2"];
        academicBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        academicBtn.imageView.clipsToBounds = YES;
        UIImage *tempImage = academicImage?academicImage:[UIImage drawImageWithName:@"add_photo" size:IS_IPAD?CGSizeMake(70, 65):CGSizeMake(49, 46)];
        [academicBtn setImage:tempImage forState:UIControlStateNormal];
        [academicBtn addTarget:self action:@selector(addAcademicImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:academicBtn];
        
        UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 120, 22)];
        tipsLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?20:12];
        tipsLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        tipsLab.numberOfLines = 0;
        tipsLab.text = tipsStr;
        CGFloat tipsLabH = [tipsStr boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-238, CGFLOAT_MAX):CGSizeMake(kScreenWidth-56, CGFLOAT_MAX) withTextFont:tipsLab.font].height;
        tipsLab.frame = IS_IPAD?CGRectMake(119, academicBtn.bottom+20, kScreenWidth-238, tipsLabH):CGRectMake(28, academicBtn.bottom+16, kScreenWidth-56, tipsLabH);
        [cell.contentView addSubview:tipsLab];
    }
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<3) {
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
    if (indexPath.row<3) {
        return IS_IPAD?76:50;
    }else{
        CGFloat tipsLabH = [tipsStr boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-238, CGFLOAT_MAX):CGSizeMake(kScreenWidth-56, CGFLOAT_MAX) withTextFont:[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?20:12]].height;
        return IS_IPAD?276+tipsLabH+120:kPhotoHeight+tipsLabH+80;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,40, 0,40)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0,21, 0, 0)];
    }
}

#pragma mark -- delegate
#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    academicImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    MyLog(@"image-- h:%.1f,w:%.1f",academicImage.size.height,academicImage.size.width);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.academicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- Event Response
#pragma mark 保存
-(void)rightNavigationItemAction{
    if (kIsEmptyString(academicStr)) {
        [self.view makeToast:@"学历不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(schoolStr)) {
        [self.view makeToast:@"学校不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (kIsEmptyString(startTimeStr)) {
        [self.view makeToast:@"在校时间不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    startTimeStr = [startTimeStr substringToIndex:4];
    endTimeStr = [endTimeStr substringToIndex:4];
    
    if ([startTimeStr integerValue]>[endTimeStr integerValue]) {
        [self.view makeToast:@"在校时间设置有误" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if(!academicImage){
        [self.view makeToast:@"请上传学历证明图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
   
    //上传图片
    NSMutableArray *imgsArr = [NSMutableArray arrayWithObjects:academicImage, nil];
    NSMutableArray *encodeImageArr = [[ZYHelper sharedZYHelper] imageDataProcessingWithImgArray:imgsArr];
    NSString *encodeResult = [TCHttpRequest getValueWithParams:encodeImageArr];
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"pic=%@&dir=2",encodeResult];
    [TCHttpRequest postMethodWithURL:kUploadPicAPI body:body success:^(id json) {
        NSArray *imgUrls = [json objectForKey:@"data"];
        NSMutableArray *timesArr = [NSMutableArray arrayWithObjects:startTimeStr,endTimeStr, nil];
        NSString *timeJsonStr = [TCHttpRequest getValueWithParams:timesArr];
        NSString *body = [NSString stringWithFormat:@"token=%@&college=%@&level=%@&edu_time=%@&card_url=%@",kUserTokenValue,schoolStr,academicStr,timeJsonStr,imgUrls[0]];
        [TCHttpRequest postMethodWithURL:kCertifyEducationAPI body:body success:^(id json) {
            [ZYHelper sharedZYHelper].isUpdateUserInfo = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view makeToast:@"您的学历认证信息已提交，请等待审核" duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
}

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
        startTimeStr = values[0];
        endTimeStr = values[2];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.academicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 上传图片
-(void)addAcademicImageAction:(UIButton *)sender{
    [self addPhotoForView:sender];
}


#pragma mark -- Getters and Setters
#pragma mark 学历
-(UITableView *)academicTableView{
    if (!_academicTableView) {
        _academicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+10, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _academicTableView.delegate = self;
        _academicTableView.dataSource = self;
        _academicTableView.estimatedSectionHeaderHeight = 0.0;
        _academicTableView.estimatedSectionFooterHeight = 0.0;
        _academicTableView.tableFooterView = [[UIView alloc] init];
    }
    return _academicTableView;
}

@end
