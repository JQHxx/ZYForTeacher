//
//  ContactServiceViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ContactServiceViewController.h"

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
    values = @[@"67850199",@"15200989767"];
    
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
    return cell;
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
