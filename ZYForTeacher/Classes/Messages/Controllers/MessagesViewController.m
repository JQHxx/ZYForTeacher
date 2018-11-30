//
//  MessagesViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/13.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageModel.h"
#import <NIMSDK/NIMSDK.h>
#import "MessageTableViewCell.h"
#import "MessagesListViewController.h"
#import "SystemNewsViewController.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "NIMSessionViewController.h"

@interface MessagesViewController ()<UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate>{
   
}

@property (nonatomic,strong) UITableView      *messagesTableView;
@property (nonatomic,strong) NSMutableArray   *messagesArr;
@property (nonatomic,strong) NSMutableArray   *recentSessions;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"消息";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?self.messagesArr.count:self.recentSessions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MessageTableViewCell *cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        MessageModel *model = self.messagesArr[indexPath.row];
        [cell messageCellDisplayWithMessage:model type:indexPath.row];
        return cell;
    }else{
        static NSString * cellId = @"cellId";
       
        NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        [cell.avatarImageView setAvatarBySession:recent.session];
        
        cell.nameLabel.text = [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
        [cell.nameLabel sizeToFit];
        
        cell.messageLabel.text  = [self messageContent:recent.lastMessage];
        [cell.messageLabel sizeToFit];
        
        cell.timeLabel.text = [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
        [cell.timeLabel sizeToFit];
        
        [cell refresh:recent];
        return cell;
    }
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            SystemNewsViewController *systemNewsVC = [[SystemNewsViewController alloc] init];
            [self.navigationController pushViewController:systemNewsVC animated:YES];
        }else{
            MessagesListViewController  *messagesListVC = [[MessagesListViewController alloc] init];
            messagesListVC.type = indexPath.row;
            [self.navigationController pushViewController:messagesListVC animated:YES];
        }
    }else{
        NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
        NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:recentSession.session];

        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 3.0f;
    }else{
        return 10.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

#pragma mark - NIMConversationManagerDelegate
#pragma mark NIMConversationManagerDelegate
#pragma mark 增加最近会话的回调
-(void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    MyLog(@"didAddRecentSession");
    NIMMessageType type = recentSession.lastMessage.messageType;
    if (type==NIMMessageTypeText||type==NIMMessageTypeImage||type==NIMMessageTypeAudio) {
        [self.recentSessions addObject:recentSession];
        [self sortRecentSessions];
        [self.messagesTableView reloadData];
    }
}

#pragma mark 最近会话修改的回调
-(void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    MyLog(@"更新会话 didUpdateRecentSession");
    NIMMessageType type = recentSession.lastMessage.messageType;
    if (type==NIMMessageTypeText||type==NIMMessageTypeImage||type==NIMMessageTypeAudio) {
        for (NIMRecentSession *recent in self.recentSessions) {
            if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId]) {
                [self.recentSessions removeObject:recent];
                break;
            }
        }
        NSInteger insert = [self findInsertPlace:recentSession];
        [self.recentSessions insertObject:recentSession atIndex:insert];
        [self.messagesTableView reloadData];
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
        
        NSArray *sessionsArr = [[NIMSDK sharedSDK].conversationManager allRecentSessions];
        NSMutableArray *tempSessionsArr = [[NSMutableArray alloc] init];
        for (NIMRecentSession *session in sessionsArr) {
            NIMMessageType type = session.lastMessage.messageType;
            if (type==NIMMessageTypeText||type==NIMMessageTypeImage||type==NIMMessageTypeAudio) {
                [tempSessionsArr addObject:session];
            }
        }
        weakSelf.recentSessions = tempSessionsArr;
        
        MyLog(@"sessionArr:%@",sessionsArr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.messagesTableView reloadData];
        });
        
    }];
}

#pragma mark -- 解析消息
- (NSString*)messageContent:(NIMMessage*)lastMessage{
    NSString *text = @"";
    switch (lastMessage.messageType) {
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        default:
            text = @"[未知消息]";
    }
    return text;
}

#pragma mark 会话进行排序
- (void)sortRecentSessions{
    [self.recentSessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NIMRecentSession *item1 = obj1;
        NIMRecentSession *item2 = obj2;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp) {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

#pragma mark 查找插入会话的位置
- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    }else{
        return self.recentSessions.count;
    }
}

#pragma mark -- Getters
#pragma mark -- 消息列表视图
-(UITableView *)messagesTableView{
    if (!_messagesTableView) {
        _messagesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
        _messagesTableView.dataSource = self;
        _messagesTableView.delegate = self;
        _messagesTableView.tableFooterView = [[UIView alloc] init];
        _messagesTableView.backgroundColor = [UIColor bgColor_Gray];
        _messagesTableView.estimatedSectionFooterHeight = 0.0;
        _messagesTableView.estimatedSectionHeaderHeight = 0.0;
    }
    return _messagesTableView;
}

#pragma mark 会话列表
-(NSMutableArray *)recentSessions{
    if (!_recentSessions) {
        _recentSessions = [[NSMutableArray alloc] init];
    }
    return _recentSessions;
}

-(NSMutableArray *)messagesArr{
    if (!_messagesArr) {
        _messagesArr = [[NSMutableArray alloc] init];
    }
    return _messagesArr;
}

-(void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

@end
