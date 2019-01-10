//
//  SystemNewsViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SystemNewsViewController.h"
#import "BaseWebViewController.h"
#import "NewsTableViewCell.h"
#import "MessageModel.h"
#import "MJRefresh.h"

@interface SystemNewsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page;
}

@property (nonatomic, strong ) UITableView     *newsTableView;
@property (nonatomic ,strong) UIImageView      *blankView; //空白页
@property (nonatomic, strong ) NSMutableArray  *newsArray;

@end

@implementation SystemNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"系统消息";
    
    page = 1;
    [self.view addSubview:self.newsTableView];
    [self.newsTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MessageModel *model=self.newsArray[indexPath.row];
    cell.model=model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=self.newsArray[indexPath.row];
    return [NewsTableViewCell getCellHeightWithNews:model];
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=self.newsArray[indexPath.row];
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.urlStr = model.url;
    webVC.webTitle = @"消息详情";
    webVC.webType = WebViewTypeSystem;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -- Private Methods
#pragma mark 加载最新数据
-(void)loadNewSystemNewsListData{
    page=1;
    [self loadSystemNewsData];
}

#pragma mark 加载更多数据
-(void)loadMoreSystemNewsListData{
    page++;
    [self loadSystemNewsData];
}

#pragma mark 加载数据
-(void)loadSystemNewsData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&label=4&page=%ld",kUserTokenValue,page];
    [TCHttpRequest postMethodWithURL:kMessageListAPI body:body success:^(id json) {
        NSArray *data = [json objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            MessageModel *model = [[MessageModel alloc] init];
            [model setValues:dict];
            model.desc = dict[@"desc"];
            [tempArr addObject:model];
        }
        if (page==1) {
            weakSelf.newsArray = tempArr;
        }else{
            [weakSelf.newsArray addObjectsFromArray:tempArr];
        }
        
        
        [ZYHelper sharedZYHelper].isUpdateMessageUnread = YES;
        [ZYHelper sharedZYHelper].isUpdateMessageInfo = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.newsTableView.mj_footer.hidden = data.count<20;
            weakSelf.blankView.hidden = weakSelf.newsArray.count>0;
            
            [weakSelf.newsTableView reloadData];
            [weakSelf.newsTableView.mj_header endRefreshing];
            [weakSelf.newsTableView.mj_footer endRefreshing];
        });
    }];
}


#pragma mark -- Getters
#pragma mark 消息列表
-(UITableView *)newsTableView{
    if (!_newsTableView) {
        _newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _newsTableView.dataSource = self;
        _newsTableView.delegate = self;
        _newsTableView.backgroundColor = [UIColor bgColor_Gray];
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newsTableView.tableFooterView = [[UIView alloc] init];
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSystemNewsListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _newsTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSystemNewsListData)];
        footer.automaticallyRefresh = NO;
        _newsTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _newsTableView;
}

#pragma mark 空白页
-(UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-149)/2.0,70, 149, 127)];
        _blankView.image = [UIImage imageNamed:@"default_news"];
    }
    return _blankView;
}

-(NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}


@end
