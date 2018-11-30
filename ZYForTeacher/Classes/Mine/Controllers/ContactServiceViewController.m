//
//  ContactServiceViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ContactServiceViewController.h"

#define QQ_NUMBER    @"5037334"
#define PHONE_NUMBER @"15675858101"

@interface ContactServiceViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray  *images;
    NSArray  *titles;
    NSArray  *values;
}

@property (nonatomic ,strong) UITableView *serviceTableView;

@end

@implementation ContactServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"联系客服";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    images = @[@"QQ",@"telephone"];
    titles = @[@"客服QQ",@"客服热线"];
    values = @[QQ_NUMBER,PHONE_NUMBER];
    
    [self.view addSubview:self.serviceTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.textLabel.text = titles[indexPath.row];
    cell.detailTextLabel.text = values[indexPath.row];
    cell.detailTextLabel.textColor = kRGBColor(82, 150, 243);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *scheme = nil;
    if (indexPath.row==0) {
        scheme =[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ_NUMBER];
    }else {
        scheme=[NSString stringWithFormat:@"telprompt://%@",PHONE_NUMBER];
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               MyLog(@"ios10以上 Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        MyLog(@"ios10以下 Open %@: %d",scheme,success);
    }
}

#pragma mark 我的主界面
-(UITableView *)serviceTableView{
    if (!_serviceTableView) {
        _serviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHeight+3, kScreenWidth, kScreenHeight-kTabHeight) style:UITableViewStylePlain];
        _serviceTableView.dataSource = self;
        _serviceTableView.delegate = self;
        _serviceTableView.showsVerticalScrollIndicator=NO;
        _serviceTableView.scrollEnabled = NO;
        _serviceTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-154)/2.0, 60, 154, 120)];
        imgView.image = [UIImage imageNamed:@"images_custom_service"];
        [headView addSubview:imgView];
        _serviceTableView.tableHeaderView = headView;
        _serviceTableView.tableFooterView = [[UIView alloc] init];
    }
    return _serviceTableView;
}

@end
