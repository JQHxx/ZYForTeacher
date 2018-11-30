//
//  MessagesListViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MessagesListViewController.h"
#import "OrderDetailsViewController.h"
#import "MessageListTableViewCell.h"
#import "MJRefresh.h"

@interface MessagesListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page;
}

@property (nonatomic,strong) UITableView    *listTableView;
@property (nonatomic ,strong) UIImageView   *blankView; //空白页
@property (nonatomic,strong) NSMutableArray *messagesList;

@end

@implementation MessagesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type==1) {
        self.baseTitle = @"支付消息";
    }else if (self.type==2){
        self.baseTitle = @"评论消息";
    }else{
        self.baseTitle = @"投诉消息";
    }
    page = 1;
    
    [self.view addSubview:self.listTableView];
    [self.listTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
    [self loadMessagesListData];

}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MessageListTableViewCell";
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[MessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:self.type];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MessageModel *model = self.messagesList[indexPath.row];
    cell.messageModel = model;
    
    cell.checkDetailsBtn.tag = indexPath.row;
    [cell.checkDetailsBtn addTarget:self action:@selector(checkOrderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.messagesList[indexPath.row];
    return [MessageListTableViewCell getCellHeightWithModel:model type:self.type];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.messagesList[indexPath.row];
    OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc] init];
    orderDetailsVC.orderId = model.oid;
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}

#pragma mark - Event Response
-(void)checkOrderDetailsAction:(UIButton *)sender{
    MessageModel *model = self.messagesList[sender.tag];
    OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc] init];
    orderDetailsVC.orderId = model.oid;
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}

#pragma mark -- Private Methods
#pragma mark 加载最新消息
-(void)loadNewMessageListData{
    page=1;
    [self loadMessagesListData];
}

#pragma mark 加载更多消息
-(void)loadMoreMessageListData{
    page++;
    [self loadMessagesListData];
}

#pragma mark 加载消息数据
-(void)loadMessagesListData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&label=%ld&page=%ld",kUserTokenValue,self.type,page];
    [TCHttpRequest postMethodWithURL:kMessageListAPI body:body success:^(id json) {
        NSArray *data = [json objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            MessageModel *model = [[MessageModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        if (page==1) {
            weakSelf.messagesList = tempArr;
        }else{
            [weakSelf.messagesList addObjectsFromArray:tempArr];
        }
        
        
        [ZYHelper sharedZYHelper].isUpdateMessageUnread = YES;
        [ZYHelper sharedZYHelper].isUpdateMessageInfo = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.listTableView.mj_footer.hidden = tempArr.count<20;
            weakSelf.blankView.hidden = weakSelf.messagesList.count>0;
            [weakSelf.listTableView reloadData];
            [weakSelf.listTableView.mj_header endRefreshing];
            [weakSelf.listTableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark -- Getters
-(NSMutableArray *)messagesList{
    if (!_messagesList) {
        _messagesList = [[NSMutableArray alloc] init];
    }
    return _messagesList;
}

#pragma mark
-(UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = [UIColor bgColor_Gray];
        _listTableView.showsVerticalScrollIndicator = NO;
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewMessageListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _listTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessageListData)];
        footer.automaticallyRefresh = NO;
        _listTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _listTableView;
}

#pragma mark 空白页
-(UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-149)/2.0,70, 149, 127)];
        _blankView.image = [UIImage imageNamed:@"default_news"];
    }
    return _blankView;
}


@end
