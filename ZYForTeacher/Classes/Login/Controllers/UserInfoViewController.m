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
#import "AppDelegate.h"
#import "LoginButton.h"
#import <NIMSDK/NIMSDK.h>

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NIMUserManagerDelegate>{
    UIImage     *selImage;
    NSArray     *titlesArr;
}
@property (nonatomic, strong) UILabel            *titleLabel;     //标题
@property (nonatomic ,strong) UITableView        *userInfoTableView;
@property (nonatomic, strong) LoginButton        *completeButton;       //确定


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenShaw = YES;
    
    titlesArr = @[@"昵称",@"性别",@"出生日期",@"所在地区",@"个人介绍"];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.userInfoTableView];
    if (self.isLoginIn) {
        [self.view addSubview:self.completeButton];
    }
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
        bgHeadImgView.boderRadius = 56;
        [cell.contentView addSubview:bgHeadImgView];
        
        UIImageView  *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2.0, 16,100, 100)];
        headImageView.boderRadius = 50;
        if (kIsEmptyString(self.userModel.trait)) {
            headImageView.image = [UIImage imageNamed:@"default_head_image"];
        }else{
            [headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
        }
        [cell.contentView addSubview:headImageView];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titlesArr[indexPath.row-1];
        cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        cell.detailTextLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        
        if(indexPath.row == 1){
            cell.detailTextLabel.text = self.userModel.tch_name;
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = [self.userModel.sex integerValue]<2?@"男":@"女";
        }else if (indexPath.row == 3){
            cell.detailTextLabel.text = [self.userModel.birthday integerValue]>0?[[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:self.userModel.birthday format:@"yyyy年MM月dd日"]:[NSDate getLastYearDate:20];
        }else if (indexPath.row == 4){
            cell.detailTextLabel.text = kIsEmptyString(self.userModel.province)?@"":[NSString stringWithFormat:@"%@ %@ %@",self.userModel.province,self.userModel.city,self.userModel.country];
        }else{
            cell.detailTextLabel.text = kIsEmptyString(self.userModel.intro)?@"":@"已填写";
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
        introductionVC.introStr = weakSelf.userModel.intro;
        introductionVC.getIntroBlock = ^(NSString *intro) {
            weakSelf.userModel.intro = intro;
            
            if (!weakSelf.isLoginIn) {
                NSString *body = [NSString stringWithFormat:@"token=%@&intro=%@",weakSelf.userModel.token,weakSelf.userModel.intro];
                [weakSelf setUserInfoRequestWithBody:body];
            }else{
                [weakSelf.userInfoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
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
    selImage=[curImage cropImageWithSize:CGSizeMake(160, 160)];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:selImage, nil];
    NSMutableArray *encodeImageArr = [[ZYHelper sharedZYHelper] imageDataProcessingWithImgArray:arr];
    NSString *encodeResult = [TCHttpRequest getValueWithParams:encodeImageArr];
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"pic=%@&dir=1",encodeResult];
    [TCHttpRequest postMethodWithURL:kUploadPicAPI body:body success:^(id json) {
         weakSelf.userModel.trait = [[json objectForKey:@"data"] objectAtIndex:0];
        
        if (!weakSelf.isLoginIn) {
            NSString *body = [NSString stringWithFormat:@"token=%@&trait=%@",weakSelf.userModel.token,weakSelf.userModel.trait];
            [weakSelf setUserInfoRequestWithBody:body];
        }else{
            [weakSelf.userInfoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
}

#pragma mark -- NIMUserManagerDelegate
-(void)onUserInfoChanged:(NIMUser *)user{
    MyLog(@"onUserInfoChanged");
}

#pragma mark -- Event response
#pragma mark 设置个人信息完成
-(void)confirmSetUserInfoAction{
    if (kIsEmptyObject(selImage)) {
        [self.view makeToast:@"请上传头像" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (kIsEmptyString(self.userModel.tch_name)) {
        [self.view makeToast:@"请设置昵称" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (kIsEmptyString(self.userModel.trait)) {
        [self.view makeToast:@"请上传头像" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (kIsEmptyString(self.userModel.province)||kIsEmptyString(self.userModel.city)) {
        [self.view makeToast:@"请设置所在地区" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.userModel.intro)) {
        [self.view makeToast:@"请填写个人简介" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    self.userModel.sex = [self.userModel.sex integerValue]==0?@1:self.userModel.sex;
    NSString *body = [NSString stringWithFormat:@"token=%@&trait=%@&username=%@&sex=%@&birthday=%@&province=%@&city=%@&country=%@&intro=%@",self.userModel.token,self.userModel.trait,self.userModel.tch_name,self.userModel.sex,self.userModel.birthday,self.userModel.province,self.userModel.city,self.userModel.country,self.userModel.intro];
    [self setUserInfoRequestWithBody:body];
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
            weakSelf.userModel.tch_name = toBeString;
            if (!weakSelf.isLoginIn) {
                NSString *body = [NSString stringWithFormat:@"token=%@&username=%@",weakSelf.userModel.token,weakSelf.userModel.tch_name];
                [weakSelf setUserInfoRequestWithBody:body];
            }else{
                [weakSelf.userInfoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
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
    NSString *sexStr =[self.userModel.sex integerValue]<2?@"男":sexArr[[self.userModel.sex integerValue]-1];
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"选择性别" dataSource:sexArr defaultSelValue:sexStr isAutoSelect:NO resultBlock:^(id selectValue) {
        NSInteger sex = [sexArr indexOfObject:selectValue]+1;
        weakSelf.userModel.sex = [NSNumber numberWithInteger:sex];
        
        if (!weakSelf.isLoginIn) {
            NSString *body = [NSString stringWithFormat:@"token=%@&sex=%@",weakSelf.userModel.token,weakSelf.userModel.sex];
            [weakSelf setUserInfoRequestWithBody:body];
        }else{
            [weakSelf.userInfoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
}

#pragma mark 设置出生年月
-(void)setBirthDate{
    NSString *currentDate = [NSDate currentDate];
    NSString *minDate = [NSDate getLastYearDate:80];
    
    NSString *defaultDate = [self.userModel.birthday integerValue]>0?[[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:self.userModel.birthday format:@"yyyy年MM月dd日"]:[NSDate getLastYearDate:20];
    kSelfWeak;
    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:UIDatePickerModeDate defaultSelValue:defaultDate minDateStr:minDate maxDateStr:currentDate isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        weakSelf.userModel.birthday = [[ZYHelper sharedZYHelper] timeSwitchTimestamp:selectValue format:@"yyyy年MM月dd日"];
        if (!weakSelf.isLoginIn) {
            NSString *body = [NSString stringWithFormat:@"token=%@&birthday=%@",weakSelf.userModel.token,weakSelf.userModel.birthday];
            [weakSelf setUserInfoRequestWithBody:body];
        }else{
            [weakSelf.userInfoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
}

#pragma mark 设置所在地区
-(void)setUserArea{
    kSelfWeak;
    [BRAddressPickerView showAddressPickerWithTitle:@"所在地区" defaultSelected:@[@0,@0,@0] isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
        weakSelf.userModel.province = selectAddressArr[0];
        weakSelf.userModel.city = selectAddressArr[1];
        weakSelf.userModel.country = selectAddressArr[2];
        if (!weakSelf.isLoginIn) {
            NSString *body = [NSString stringWithFormat:@"token=%@&province=%@&city=%@&country=%@",weakSelf.userModel.token,weakSelf.userModel.province,weakSelf.userModel.city,weakSelf.userModel.country];
            [weakSelf setUserInfoRequestWithBody:body];
        }else{
            [weakSelf.userInfoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
}

#pragma mark 设置个人信息
-(void)setUserInfoRequestWithBody:(NSString *)body{
    kSelfWeak;
    [TCHttpRequest postMethodWithURL:kSetUserInfoAPI body:body success:^(id json) {
        NSDictionary *userDict = @{@(NIMUserInfoUpdateTagNick):weakSelf.userModel.tch_name,@(NIMUserInfoUpdateTagAvatar):weakSelf.userModel.trait,@(NIMUserInfoUpdateTagGender):[NSString stringWithFormat:@"%@",weakSelf.userModel.sex]};
        [[NIMSDK sharedSDK].userManager updateMyUserInfo:userDict completion:^(NSError * _Nullable error) {
            if (error) {
                MyLog(@"NIM updateMyUserInfo fail--error:%@",error.localizedDescription);
            }else{
                MyLog(@"NIM updateMyUserInfo success");
            }
        }];
        if (!weakSelf.isLoginIn) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[NSUserDefaultsInfos getDicValueforKey:kUserInfo]];
            [dic setObject:weakSelf.userModel.trait forKey:@"trait"];
            [dic setObject:weakSelf.userModel.tch_name forKey:@"tch_name"];
            [NSUserDefaultsInfos putKey:kUserInfo anddict:dic];
        }
        [ZYHelper sharedZYHelper].isUpdateUserInfo = YES;
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.isLoginIn) {
                if ([self.userModel.tch_label integerValue]==1) {
                    TeachInfoViewController *teachInfoVC = [[TeachInfoViewController alloc] init];
                    teachInfoVC.isLoginIn = YES;
                    teachInfoVC.user = weakSelf.userModel;
                    [self.navigationController pushViewController:teachInfoVC animated:YES];
                }else{
                    [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:YES]];
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate setMyRootViewController];
                }
            }else{
                [weakSelf.userInfoTableView reloadData];
            }
        });
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
        NSString *titleStr = nil;
        titleStr = [self.userModel.tch_label integerValue] == 1?@"下一步":@"确定";
        _completeButton = [[LoginButton alloc] initWithFrame:CGRectMake(48.0,self.titleLabel.bottom+132+50*5+20, kScreenWidth-95.0, (kScreenWidth-95.0)*(128.0/588.0)) title:titleStr];
        [_completeButton addTarget:self action:@selector(confirmSetUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}



@end
