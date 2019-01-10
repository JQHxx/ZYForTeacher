//
//  MessagesViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/13.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageModel.h"
#import "MessageTableViewCell.h"
#import "MessagesListViewController.h"
#import "SystemNewsViewController.h"

@interface MessagesViewController ()<UITableViewDelegate,UITableViewDataSource>{
   
}

@property (nonatomic,strong) UITableView      *messagesTableView;
@property (nonatomic,strong) NSMutableArray   *messagesArr;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"消息";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [self.view addSubview:self.messagesTableView];
    [self loadMessageData];
}

#pragma mark
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZYHelper sharedZYHelper].isUpdateMessageInfo) {
        [self loadMessageData];
        [ZYHelper sharedZYHelper].isUpdateMessageInfo = NO;
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    MessageModel *model = self.messagesArr[indexPath.row];
    [cell messageCellDisplayWithMessage:model type:indexPath.row];
    return cell;
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IS_IPAD?110:70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==0) {
        SystemNewsViewController *systemNewsVC = [[SystemNewsViewController alloc] init];
        [self.navigationController pushViewController:systemNewsVC animated:YES];
    }else{
        MessagesListViewController  *messagesListVC = [[MessagesListViewController alloc] init];
        messagesListVC.type = indexPath.row;
        [self.navigationController pushViewController:messagesListVC animated:YES];
    }
}


#pragma mark -- Private Methods
#pragma mark 加载数据
-(void)loadMessageData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@",kUserTokenValue];
    [TCHttpRequest postMethodWithoutLoadingForURL:kMessageLastAPI body:body success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        
        NSMutableArray *tempMessageArr = [[NSMutableArray alloc] init];
        //系统消息
        NSDictionary *systemInfo = [data valueForKey:@"sys"];
        MessageModel *systemModel = [[MessageModel alloc] init];
        [systemModel setValues:systemInfo];
        systemModel.icon = @"news";
        systemModel.myTitle = @"系统消息";
        systemModel.desc = systemInfo[@"desc"];
        [tempMessageArr addObject:systemModel];
        
        
        //支付信息
        NSDictionary *payInfo = [data valueForKey:@"pay"];
        MessageModel *payModel = [[MessageModel alloc] init];
        [payModel setValues:payInfo];
        payModel.icon = @"news_pay";
        payModel.myTitle = @"支付消息";
        [tempMessageArr addObject:payModel];
        
        
        //评论信息
        NSDictionary *commentInfo = [data valueForKey:@"comment"];
        MessageModel *commentModel = [[MessageModel alloc] init];
        [commentModel setValues:commentInfo];
        commentModel.icon = @"news_comment";
        commentModel.myTitle = @"评论消息";
        [tempMessageArr addObject:commentModel];
        
        //投诉信息
        NSDictionary *complainInfo = [data valueForKey:@"complain"];
        MessageModel *complainModel = [[MessageModel alloc] init];
        [complainModel setValues:complainInfo];
        complainModel.icon = @"news";
        complainModel.myTitle = @"投诉消息";
        [tempMessageArr addObject:complainModel];
        
        weakSelf.messagesArr = tempMessageArr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.messagesTableView reloadData];
        });
        
    }];
}


#pragma mark -- Getters
#pragma mark -- 消息列表视图
-(UITableView *)messagesTableView{
    if (!_messagesTableView) {
        _messagesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+5, kScreenWidth, kScreenHeight-kNavHeight-5) style:UITableViewStylePlain];
        _messagesTableView.dataSource = self;
        _messagesTableView.delegate = self;
        _messagesTableView.tableFooterView = [[UIView alloc] init];
        _messagesTableView.backgroundColor = [UIColor bgColor_Gray];
        _messagesTableView.estimatedSectionFooterHeight = 0.0;
        _messagesTableView.estimatedSectionHeaderHeight = 0.0;
    }
    return _messagesTableView;
}


-(NSMutableArray *)messagesArr{
    if (!_messagesArr) {
        _messagesArr = [[NSMutableArray alloc] init];
    }
    return _messagesArr;
}


@end
