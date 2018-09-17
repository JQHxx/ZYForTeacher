//
//  UserInfoViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/28.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TeachInfoViewController.h"
#import "BRPickerView.h"
#import "UserModel.h"
#import "NSDate+Extension.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "IntroductionViewController.h"
#import "AppDelegate+Extension.h"
#import "LoginButton.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray     *titlesArr;
}
@property (nonatomic, strong) UILabel            *titleLabel;     //标题
@property (nonatomic ,strong) UITableView        *userInfoTableView;
@property (nonatomic, strong) LoginButton        *completeButton;       //确定
@property (nonatomic ,strong) UserModel          *userInfo;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenShaw = YES;
    
    titlesArr = @[@"昵称",@"性别",@"出生日期",@"所在地区",@"个人介绍"];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.userInfoTableView];
    [self.view addSubview:self.completeButton];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (indexPath.row == 0) {
         cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView  *bgHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-112)/2.0, 10, 112, 112)];
        bgHeadImgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        bgHeadImgView.layer.cornerRadius = 56;
        [cell.contentView addSubview:bgHeadImgView];
        
        UIImageView  *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2.0, 16,100, 100)];
        headImageView.image = self.userInfo.headImage?[self.userInfo.headImage imageWithCornerRadius:50]:[UIImage imageNamed:@"default_head_image"];
        [cell.contentView addSubview:headImageView];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titlesArr[indexPath.row-1];
        cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        cell.detailTextLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        
        if(indexPath.row == 1){
            cell.detailTextLabel.text = self.userInfo.nick_name;
        }else if (indexPath.row == 2){
            if (self.userInfo.sex>0) {
                cell.detailTextLabel.text = self.userInfo.sex==1?@"男":@"女";
            }
        }else if (indexPath.row == 3){
            cell.detailTextLabel.text = self.userInfo.birth_date;
        }else if (indexPath.row == 4){
            cell.detailTextLabel.text = self.userInfo.area;
        }else{
            cell.detailTextLabel.text = kIsEmptyString(self.userInfo.intro)?@"":@"已填写";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self uploadUserHeadPhotos];
    }else if (indexPath.row == 1){
        [self setNickName];
    }else if (indexPath.row == 2){
        [self setUserSex];
    }else if (indexPath.row == 3){
        [self setBirthDate];
    }else if (indexPath.row == 4){
        [self setUserArea];
    }else if (indexPath.row == 5){
        IntroductionViewController *introductionVC = [[IntroductionViewController alloc] init];
        kSelfWeak;
        introductionVC.getIntroBlock = ^(NSString *intro) {
            weakSelf.userInfo.intro = intro;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
            [weakSelf.userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        [self presentViewController:introductionVC animated:YES completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row==0?132:50;
}

#pragma mark--Delegate
#pragma mark UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage* curImage=[info objectForKey:UIImagePickerControllerEditedImage];
    curImage=[curImage cropImageWithSize:CGSizeMake(160, 160)];
    self.userInfo.headImage = curImage;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSData *imageData = UIImagePNGRepresentation(curImage);
    //将图片数据转化为64为加密字符串
    NSString *encodeResult = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *body=[NSString stringWithFormat:@"photo=%@",encodeResult];
    MyLog(@"body：%@",body);
}

#pragma mark -- Event response
#pragma mark 设置个人信息完成
-(void)confirmSetUserInfoAction{
    if (self.isLoginIn) {
        if (self.identityType==0) {
            TeachInfoViewController *teachInfoVC = [[TeachInfoViewController alloc] init];
            teachInfoVC.isLoginIn = YES;
            [self.navigationController pushViewController:teachInfoVC animated:YES];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate setMyRootViewController];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Private Methods
#pragma mark 上传照片
-(void)uploadUserHeadPhotos{
    [self addPhoto];
}

#pragma mark 昵称
-(void)setNickName{
    NSString *title = NSLocalizedString(@"设置昵称", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *okButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"请输入昵称"];
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setReturnKeyType:UIReturnKeyDone];
        textField.delegate=self;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    kSelfWeak;
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController.textFields.firstObject resignFirstResponder];
        alertController.textFields.firstObject.text = [alertController.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *toBeString=alertController.textFields.firstObject.text;
        if (toBeString.length<1) {
            [weakSelf.view makeToast:@"昵称不能为空" duration:1.0 position:CSToastPositionCenter];
        }else if (toBeString.length>8){
            [weakSelf.view makeToast:@"昵称仅支持1-8个字符" duration:1.0 position:CSToastPositionCenter];
        }else{
            weakSelf.userInfo.nick_name = toBeString;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    alertController.view.layer.cornerRadius = 20;
    alertController.view.layer.masksToBounds = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 设置性别
-(void)setUserSex{
    NSArray *sexArr = @[@"男",@"女"];
    NSString *sexStr =self.userInfo.sex>0?sexArr[self.userInfo.sex-1]:@"男";
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"选择性别" dataSource:sexArr defaultSelValue:sexStr isAutoSelect:NO resultBlock:^(id selectValue) {
        weakSelf.userInfo.sex = [sexArr indexOfObject:selectValue]+1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [weakSelf.userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 设置出生年月
-(void)setBirthDate{
    NSString *currentDate = [NSDate currentDate];
    NSString *minDate = [NSDate getLastYearDate:80];
    NSString *defaultDate = [NSDate getLastYearDate:20];
    kSelfWeak;
    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:UIDatePickerModeDate defaultSelValue:defaultDate minDateStr:minDate maxDateStr:currentDate isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        weakSelf.userInfo.birth_date = selectValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [weakSelf.userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 设置所在地区
-(void)setUserArea{
    kSelfWeak;
    [BRAddressPickerView showAddressPickerWithTitle:@"所在地区" defaultSelected:@[@0,@0,@0] isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
        weakSelf.userInfo.area = [NSString stringWithFormat:@"%@%@%@",selectAddressArr[0],selectAddressArr[1],selectAddressArr[2]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        [weakSelf.userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, kNavHeight+15, 120, 28)];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _titleLabel.text = @"个人信息";
    }
    return _titleLabel;
}

#pragma mark 个人信息
-(UITableView *)userInfoTableView{
    if (!_userInfoTableView) {
        _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom+10, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _userInfoTableView.delegate = self;
        _userInfoTableView.dataSource = self;
        _userInfoTableView.tableFooterView = [[UIView alloc] init];
    }
    return _userInfoTableView;
}

#pragma mark 确定
-(LoginButton *)completeButton{
    if (!_completeButton) {
        NSString *titleStr = self.identityType == 0?@"下一步":@"确定";
        _completeButton = [[LoginButton alloc] initWithFrame:CGRectMake(48.0,kScreenHeight-(kScreenWidth-95.0)*(128.0/588.0)-69, kScreenWidth-95.0, (kScreenWidth-95.0)*(128.0/588.0)) title:titleStr];
        [_completeButton addTarget:self action:@selector(confirmSetUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

#pragma mark 用户信息
-(UserModel *)userInfo{
    if (!_userInfo) {
        _userInfo = [[UserModel alloc] init];
    }
    return _userInfo;
}


@end
