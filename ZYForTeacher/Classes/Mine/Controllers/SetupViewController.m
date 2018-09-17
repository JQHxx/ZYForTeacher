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

@interface SetupViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSArray  *titlesArray;
}

@property (nonatomic, strong) UITableView *setupTableView;
@property (nonatomic, strong) UIButton    *loginoutButton;   //退出登录

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
    cell.textLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    
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
        cell.detailTextLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self clearCache];
    }else if (indexPath.row == 1){
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if (indexPath.row == 2){
        
    }else{
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}

#pragma mark -- Event reponse
#pragma mark 退出登录
-(void)loginoutAction:(UIButton *)sender{
    
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
        _setupTableView.tableFooterView = [[UIView alloc] init];
    }
    return _setupTableView;
}

#pragma mark 退出登录
-(UIButton *)loginoutButton{
    if (!_loginoutButton) {
        _loginoutButton = [[UIButton alloc] initWithFrame:CGRectMake(43.0,kScreenHeight-(kScreenWidth-95.0)*(128.0/588.0)-45.0,kScreenWidth-95.0,(kScreenWidth-95.0)*(128.0/588.0))];
        [_loginoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginoutButton setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_loginoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginoutButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        [_loginoutButton addTarget:self action:@selector(loginoutAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginoutButton;
}

@end
