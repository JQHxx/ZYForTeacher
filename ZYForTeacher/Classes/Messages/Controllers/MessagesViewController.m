//
//  MessagesViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/13.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MessagesViewController.h"
#import "SystemNewsViewController.h"
#import "ChatViewController.h"
#import "ConversationTableViewCell.h"
#import "SystemNewsModel.h"
#import "ConversationModel.h"

@interface MessagesViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    SystemNewsModel   *systemNewsModel;
}

@property (nonatomic,strong) UITableView     *messagesTableView;
@property (nonatomic,strong) NSMutableArray  *conservationsArray;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"消息";
    
    systemNewsModel = [[SystemNewsModel alloc] init];
    
    [self.view addSubview:self.messagesTableView];
    [self loadMessageData];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:self.conservationsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"ConversationTableViewCell";
    ConversationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[ConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    id model;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            model=systemNewsModel;
        }
    }else{
        model=self.conservationsArray[indexPath.row];
    }
    [cell conversationCellDisplayWithModel:model];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        SystemNewsViewController *newsVC = [[SystemNewsViewController alloc] init];
        [self.navigationController pushViewController:newsVC animated:YES];
    }else{
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1&&self.conservationsArray.count>0) {
        return 40;
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1&&self.conservationsArray.count>0) {
        return @"我的老师";
    }else{
        return @"";
    }
}

#pragma mark -- Private Methods
#pragma mark 加载数据
-(void)loadMessageData{
    systemNewsModel.isRead = NO;
    systemNewsModel.title = @"充值活动满100送10";
    systemNewsModel.send_time = @"今天 16:00";
    
    NSArray *teachers = @[@"小美老师",@"小芳老师",@"小明老师",@"张三"];
    NSArray *timesArr = @[@"今天 09:00" ,@"2018/08/12 12:30",@"2018/08/11 15:30",@"2018/08/10 18:30"];
    NSArray *msgArr = @[@"最近会话用于表示会话列表页的数据模型",@"当收到或者一条消息时，会自动生成这个消息对应的最近会话",@"获取最近会话，一般用于首页显示会话列表",@"在数据量过万的情况下会有一定的耗时"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<teachers.count; i++) {
        ConversationModel *model = [[ConversationModel alloc] init];
        model.lastMsgUserName = teachers[i];
        model.lastMsgHeadPic = @"ic_m_head";
        model.lastMsgTime = timesArr[i];
        model.lastMsg = msgArr[i];
        model.unreadCount = i*35+2;
        [tempArr addObject:model];
    }
    self.conservationsArray = tempArr;
    [self.messagesTableView reloadData];
}

#pragma mark -- 消息列表视图
-(UITableView *)messagesTableView{
    if (!_messagesTableView) {
        _messagesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _messagesTableView.dataSource = self;
        _messagesTableView.delegate = self;
        _messagesTableView.tableFooterView = [[UIView alloc] init];
        _messagesTableView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _messagesTableView;
}

#pragma mark 会话列表
-(NSMutableArray *)conservationsArray{
    if (!_conservationsArray) {
        _conservationsArray = [[NSMutableArray alloc] init];
    }
    return _conservationsArray;
}

@end
