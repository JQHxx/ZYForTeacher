//
//  ChatViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageCell.h"
#import "ChatTimeCell.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView    *chatTableView;
@property (nonatomic ,strong) NSMutableArray *chatInfo;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"小美老师";
    
    [self.view addSubview:self.chatTableView];

}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.chatInfo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self.chatInfo objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        static NSString *identifier = @"ChatTimeCell";
        ChatTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.titleStr = object;
        return cell;
    }else{
        static NSString *identifier = @"ChatMessageCell";
        ChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}

#pragma mark ChatToolBarDelegate
-(void)didSendText:(NSString *)text{
    MyLog(@"didSendText:%@",text);
}

#pragma mark 聊天视图
-(UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight -50) style:UITableViewStyleGrouped];
        _chatTableView.dataSource = self;
        _chatTableView.delegate = self;
        _chatTableView.tableFooterView = [[UIView alloc] init];
        _chatTableView.backgroundColor= [UIColor colorWithHexString:@"#f8f8f8"];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _chatTableView;
}

#pragma mark 聊天信息
-(NSMutableArray *)chatInfo{
    if (!_chatInfo) {
        _chatInfo = [[NSMutableArray alloc] init];
    }
    return _chatInfo;
}


@end
