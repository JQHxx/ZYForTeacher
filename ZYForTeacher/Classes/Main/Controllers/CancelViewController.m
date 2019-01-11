//
//  CancelViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CancelViewController.h"
#import "MyOrderViewController.h"
#import "WhiteboardCmdHandler.h"
#import "UIButton+Touch.h"
#import <NIMAVChat/NIMAVChat.h>

@interface CancelViewController ()<WhiteboardCmdHandlerDelegate>{
    NSArray   *reasonsArr;
    UIButton  *selectBtn;
    NSInteger selectRid;
}

@property (nonatomic , strong ) UIButton *confirmButton;
@property (nonatomic , strong ) WhiteboardCmdHandler   *cmdHander;

@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.myTitle;
    
    _cmdHander = [[WhiteboardCmdHandler alloc] initWithDelegate:self];
    
    [self initCancelView];
    [self loadCancelReasonsInfo];
    
    
    MyLog(@"orderid:%@",self.oid);
    if (kIsEmptyString(self.oid)) {
        [self loadHomeworkInfo];
    }
    
}

#pragma mark -- event response
#pragma mark 选择取消原因
-(void)chooseCancelReaonsAction:(UIButton *)sender{
    if (selectBtn) {
        selectBtn.selected = NO;
    }
    sender.selected = YES;
    selectBtn = sender;
    selectRid = sender.tag;
}

#pragma mark 确定
-(void)confirmChooseCancelReasonAction{
     kSelfWeak;
    NSString *body = nil;
    NSString *urlStr = nil;
    if (self.type==2) {
        body = [NSString stringWithFormat:@"token=%@&jobid=%@&rid=%ld",kUserTokenValue,self.jobid,selectRid];
        urlStr =kJobCancelAPI;
    }else{
        body = [NSString stringWithFormat:@"token=%@&jobid=%@&rid=%ld",kUserTokenValue,self.jobid,selectRid];
        urlStr = kOrderCancelAPI;
    }
    [TCHttpRequest postMethodWithURL:urlStr body:body success:^(id json) {
        if (weakSelf.type==CancelTypeOrderCoach) {
            [_cmdHander sendPureCmd:WhiteBoardCmdTypeCancelCoach];
        }
        
        if (weakSelf.callID>0) {
            [[NIMAVChatSDK sharedSDK].netCallManager hangup:weakSelf.callID];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.view makeToast:[NSString stringWithFormat:@"您已取消%@",weakSelf.type==2?@"作业":@"订单"] duration:1.0 position:CSToastPositionCenter];
        });
        if (weakSelf.type==2) {
           [NSUserDefaultsInfos removeObjectForKey:kCallingForID];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOOL isOrder = NO;
            for (BaseViewController *controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MyOrderViewController class]]) {
                    [ZYHelper sharedZYHelper].isUpdateOrderList = YES;
                    [weakSelf.navigationController popToViewController:controller animated:YES];
                    isOrder = YES;
                    break;
                }
            }
            if(!isOrder){
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        });
    }];
}

#pragma mark 初始化
-(void)initCancelView{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(80, kNavHeight+50, kScreenWidth-160, 36):CGRectMake(30,kNavHeight+18, kScreenWidth-52, 22)];
    titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    titleLabel.text = [NSString stringWithFormat:@"请说明您的%@的原因",self.myTitle];
    [self.view addSubview:titleLabel];
    
    [self.view addSubview:self.confirmButton];
}

#pragma mark 获取取消原因
-(void)loadCancelReasonsInfo{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&label=%ld",kUserTokenValue,self.type];
    [TCHttpRequest postMethodWithURL:kCancelReasonAPI body:body success:^(id json) {
        reasonsArr = [json objectForKey:@"data"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf creatReasonsListViewWithReasons:reasonsArr];
            CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,kNavHeight+120+63*reasonsArr.count+30,515, 75):CGRectMake(48,kNavHeight+44+46*reasonsArr.count+30,kScreenWidth-96, 60);
            weakSelf.confirmButton.frame = btnFrame;
        });
    }];
}

#pragma mark 获取作业详情
-(void)loadHomeworkInfo{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,self.jobid];
    [TCHttpRequest postMethodWithoutLoadingForURL:kHomeworkDetailsAPI body:body success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        weakSelf.oid = dict[@"oid"];
    }];
}

#pragma mark
-(void)creatReasonsListViewWithReasons:(NSArray *)reasonsArr{
    for (NSInteger i=0; i<reasonsArr.count; i++) {
        NSDictionary *dict = reasonsArr[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(82, kNavHeight+120+(30+33)*i, kScreenWidth-100, 30):CGRectMake(30,kNavHeight+54+(30+16)*i, kScreenWidth-40, 30)];
        [btn setTitle:dict[@"reason"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:IS_IPAD?@"choose_gray_ipad":@"pay_choose_gray"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:IS_IPAD?@"choose_ipad":@"pay_choose"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF6161"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        btn.titleEdgeInsets = UIEdgeInsetsMake(5,5,5, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.tag = [dict[@"rid"] integerValue];
        [btn addTarget:self action:@selector(chooseCancelReaonsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

#pragma mark 确定
-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?24:16];
        [_confirmButton addTarget:self action:@selector(confirmChooseCancelReasonAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.timeInterval = 3.0;
    }
    return _confirmButton;
}



@end
