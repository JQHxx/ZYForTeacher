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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.rightBtn];
    
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
    NSArray *titles = self.myOrder.type==0?@[@"取消检查",@"消息"]:@[@"取消辅导",@"消息"];
    [YBPopupMenu showRelyOnView:self.rightBtn titles:titles icons:@[@"",@"",@""] menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
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
#pragma mark 更多
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, KStatusHeight, 30, 40)];
        [_rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(getMoreHandleListAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}



@end
