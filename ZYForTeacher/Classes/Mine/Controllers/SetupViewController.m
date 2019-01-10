//
//  SetupViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SetupViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "LoginButton.h"

#define kAppstoreUrl @"https://itunes.apple.com/cn/app/id1440442719"

@interface SetupViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSArray  *titlesArray;
}

@property (nonatomic, strong) UITableView *setupTableView;
@property (nonatomic, strong) LoginButton    *loginoutButton;   //退出登录

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"设置";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    titlesArray=@[@"清除缓存",@"意见反馈",@"评价一下",@"关于我们"];
    
    [self.view addSubview:self.setupTableView];
    [self.view addSubview:self.loginoutButton];
}

#pragma mark --UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        double fileValue = [self folderSizeAtPath];
        NSString *dataValueStr = nil;
        if (fileValue>100) {
            dataValueStr = [NSString stringWithFormat:@"大于%.2fMB",fileValue];
        }else if (fileValue<1){
            dataValueStr = [NSString stringWithFormat:@"%.fKB",fileValue*1024];
            
        }else {
            dataValueStr = [NSString stringWithFormat:@"%.2fMB",fileValue];
        }
        cell.detailTextLabel.text = dataValueStr;
        cell.detailTextLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
    }else{
        if (IS_IPAD) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-55.4,27,12.6,23)];
            arrowImageView.image = [UIImage imageNamed:@"arrow_ipad"];
            [cell.contentView addSubview:arrowImageView];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self clearCache];
    }else if (indexPath.row == 1){
        kSelfWeak;
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        feedbackVC.backBlock = ^(id object) {
            [weakSelf.view makeToast:@"您的意见已提交!" duration:1.0 position:CSToastPositionCenter];
        };
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if(indexPath.row==2){
        NSURL * url = [NSURL URLWithString:kAppstoreUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }else{
            MyLog(@"can not open");
        }
    }else{
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IS_IPAD?78:50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,40, 0,40)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0,21, 0, 0)];
    }
}

#pragma mark -- Event reponse
#pragma mark 退出登录
-(void)loginoutAction:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [TCHttpRequest signOut];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- Private Methods
#pragma mark 清除缓存
-(void)clearCache{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    MyLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCacheSuccess) withObject : nil waitUntilDone : YES ];
}

#pragma mark -- 清除成功
-(void)clearCacheSuccess{
    [self.view makeToast:@"清除缓存成功" duration:1.0 position:CSToastPositionCenter];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];//刷新
    [self.setupTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 计算文件大小
- (double)folderSizeAtPath{
    NSString * folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory ,NSUserDomainMask,YES) firstObject ];
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

#pragma mark  计算单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}


#pragma mark -- Getters
#pragma mark 设置
-(UITableView *)setupTableView{
    if (!_setupTableView) {
        _setupTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+3.0, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _setupTableView.backgroundColor=[UIColor bgColor_Gray];
        _setupTableView.delegate=self;
        _setupTableView.dataSource=self;
        _setupTableView.showsVerticalScrollIndicator=NO;
        _setupTableView.scrollEnabled = NO;
        _setupTableView.tableFooterView = [[UIView alloc] init];
    }
    return _setupTableView;
}

#pragma mark 退出登录
-(LoginButton *)loginoutButton{
    if (!_loginoutButton) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,kScreenHeight-85.0,515, 75):CGRectMake(48,kScreenHeight-75.0,kScreenWidth-96, 60);
        _loginoutButton = [[LoginButton alloc] initWithFrame:btnFrame title:@"退出登录"];
        [_loginoutButton addTarget:self action:@selector(loginoutAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginoutButton;
}

@end
