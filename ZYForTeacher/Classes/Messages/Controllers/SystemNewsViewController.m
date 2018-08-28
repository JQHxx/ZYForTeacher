//
//  SystemNewsViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SystemNewsViewController.h"
#import "NewsTableViewCell.h"

@interface SystemNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong ) UITableView     *newsTableView;
@property (nonatomic, strong ) NSMutableArray  *newsArray;

@end

@implementation SystemNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"系统消息";
    
    [self.view addSubview:self.newsTableView];
    [self loadSystemNewsData];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenfier=@"NewsTableViewCell";
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfier];
    }
    SystemNewsModel *model=self.newsArray[indexPath.row];
    cell.model=model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemNewsModel *model=self.newsArray[indexPath.row];
    return [NewsTableViewCell getCellHeightWithNews:model];
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark -- Private Methods
#pragma mark 加载数据
-(void)loadSystemNewsData{
    NSArray *titles = @[@"系统消息标题111",@"系统消息标题2222",@"系统消息标题33333",@"系统消息标题444444"];
    NSArray *timesArr = @[@"今天 09:00" ,@"2018/08/12 12:30",@"2018/08/11 15:30",@"2018/08/10 18:30"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<titles.count; i++) {
        SystemNewsModel *model = [[SystemNewsModel alloc] init];
        model.message_id = i+100;
        model.title = titles[i];
        model.send_time = timesArr[i];
        model.isRead = NO;
        [tempArr addObject:model];
    }
    self.newsArray = tempArr;
    [self.newsTableView reloadData];
}


#pragma mark -- Getters
#pragma mark 消息列表
-(UITableView *)newsTableView{
    if (!_newsTableView) {
        _newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _newsTableView.dataSource = self;
        _newsTableView.delegate = self;
        _newsTableView.tableFooterView = [[UIView alloc] init];
    }
    return _newsTableView;
}

-(NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}


@end
