//
//  BaseTutoringViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/15.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseTutoringViewController.h"
#import "CancelViewController.h"
#import "ChatViewController.h"
#import "YBPopupMenu.h"

@interface BaseTutoringViewController ()<YBPopupMenuDelegate>

@property (nonatomic, strong ) UIButton      *rightBtn;

@end

@implementation BaseTutoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.rootScrollView];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.endBtn];
    
}

#pragma mark -- Delegate
#pragma mark  YBPopupMenuDelegate
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if(index==0){
        CancelViewController *cancelVC = [[CancelViewController alloc] init];
        [self.navigationController pushViewController:cancelVC animated:YES];
    }else{
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma mark -- Event response
#pragma mark 查看更多（取消辅导和消息）
-(void)getMoreHandleListAction{
    [YBPopupMenu showRelyOnView:self.rightBtn titles:@[@"取消辅导",@"消息"] icons:@[@"",@"",@""] menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.borderWidth = 0.5;
        popupMenu.borderColor = [UIColor colorWithHexString:@"0xeeeeeee"];
        popupMenu.delegate = self;
        popupMenu.textColor = [UIColor colorWithHexString:@"0x626262"];
        popupMenu.fontSize = 14;
    }];
}

#pragma mark 结束
-(void)endHomeworkCheckAction{
    
}

#pragma mark -- Getters
#pragma mark 根视图
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
    }
    return _rootScrollView;
}

#pragma mark 更多
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, KStatusHeight, 30, 40)];
        [_rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(getMoreHandleListAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


-(UIButton *)endBtn{
    if (!_endBtn) {
        _endBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2, kScreenHeight-80, 60, 60)];
        [_endBtn setTitle:@"结束" forState:UIControlStateNormal];
        [_endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _endBtn.backgroundColor = [UIColor whiteColor];
        _endBtn.layer.cornerRadius = 30;
        _endBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _endBtn.layer.borderWidth = 1;
        [_endBtn addTarget:self action:@selector(endHomeworkCheckAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}

@end
