//
//  JobDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/1.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "JobDetailsViewController.h"
#import "ChatViewController.h"
#import "CancelViewController.h"
#import "CheckViewController.h"
#import "TutorialViewController.h"
#import "ConnecttingViewController.h"
#import "YBPopupMenu.h"

@interface JobDetailsViewController ()<YBPopupMenuDelegate>

@property (nonatomic, strong) UIScrollView *photosScrollView;
@property (nonatomic, strong) UIView       *bottomView;

@end

@implementation JobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"作业详情";
    self.rightImageName = @"more";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    self.rightBtn.hidden = self.orderInfo.state == 0;
    
    [self.view addSubview:self.photosScrollView];
    [self.view addSubview:self.bottomView];
    
    MyLog(@"%.f",kScreenHeight);
}

#pragma mark -- Delegate
#pragma mark YBPopupMenuDelegate
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if(index==0){
        CancelViewController *cancelVC = [[CancelViewController alloc] init];
        cancelVC.isTutorial = self.orderInfo.type;
        [self.navigationController pushViewController:cancelVC animated:YES];
    }else{
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma mark -- Event Response
#pragma mark 更多
-(void)getMoreHandleListAction{
    NSArray *titles = self.orderInfo.type==0?@[@"取消检查",@"消息"]:@[@"取消辅导",@"消息"];
    [YBPopupMenu showRelyOnView:self.rightBtn titles:titles icons:@[@"",@"",@""] menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.borderWidth = 0.5;
        popupMenu.borderColor = [UIColor colorWithHexString:@"0xeeeeeee"];
        popupMenu.delegate = self;
        popupMenu.textColor = [UIColor colorWithHexString:@"0x626262"];
        popupMenu.fontSize = 14;
    }];
}

#pragma mark 处理订单
-(void)handleOrderAction:(UIButton *)sender{
    if (self.orderInfo.type==0) {
        CheckViewController *checkVC = [[CheckViewController alloc] init];
        checkVC.myOrder = self.orderInfo;
        [self.navigationController pushViewController:checkVC animated:YES];
    }else{
        if ([sender.currentTitle isEqualToString:@"去辅导"]) {
            TutorialViewController *tutorialVC = [[TutorialViewController alloc] init];
            tutorialVC.myOrder = self.orderInfo;
            [self.navigationController pushViewController:tutorialVC animated:YES];
        }else{
            ConnecttingViewController *connecttingVC = [[ConnecttingViewController alloc] init];
            connecttingVC.orderModel = self.orderInfo;
            [self.navigationController pushViewController:connecttingVC animated:YES];
        }
    }
}



#pragma mark -- Getters and Setters
#pragma mark 作业图片
-(UIScrollView *)photosScrollView{
    if (!_photosScrollView) {
        _photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, kNavHeight+10, kScreenWidth-20, (kScreenWidth-20)*1.12)];
        _photosScrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _photosScrollView;
}

#pragma mark 底部视图
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-170, kScreenWidth, 170)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        titleLab.font = [UIFont boldSystemFontOfSize:16];
        titleLab.textColor = [UIColor blackColor];
        titleLab.text = self.orderInfo.type==0?@"作业检查":@"作业辅导";
        [_bottomView addSubview:titleLab];
        
        UILabel *orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-110, 10, 100, 30)];
        orderTimeLabel.font = kFontWithSize(14);
        orderTimeLabel.textAlignment = NSTextAlignmentRight;
        orderTimeLabel.textColor = [UIColor redColor];
        if (self.orderInfo.type==1&&self.orderInfo.time_type==1) {
            orderTimeLabel.text = self.orderInfo.order_time;
            orderTimeLabel.hidden = NO;
        }else{
            orderTimeLabel.hidden = YES;
        }
        [_bottomView addSubview:orderTimeLabel];
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLab.bottom+10, kScreenWidth-10, 0.5)];
        lineLab.backgroundColor = kLineColor;
        [_bottomView addSubview:lineLab];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineLab.bottom+10, 40, 40)];
        imgView.image = [UIImage imageNamed:self.orderInfo.head_image];
        [_bottomView addSubview:imgView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, lineLab.bottom+10, 100, 25)];
        nameLabel.text = self.orderInfo.name;
        nameLabel.font = kFontWithSize(14);
        [_bottomView addSubview:nameLabel];
        
        UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, nameLabel.bottom, 100, 25)];
        gradeLabel.text = self.orderInfo.grade;
        gradeLabel.textColor = [UIColor lightGrayColor];
        [_bottomView addSubview:gradeLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-110, nameLabel.bottom, 100, 25)];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [UIColor redColor];
        priceLabel.text = self.orderInfo.type==0?[NSString stringWithFormat:@"%.2f元",self.orderInfo.check_price]:[NSString stringWithFormat:@"%.2f元/分钟",self.orderInfo.perPrice];
        [_bottomView addSubview:priceLabel];
        
        
        UIButton *handleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 130, kScreenWidth, 40)];
        handleButton.backgroundColor = [UIColor redColor];
        if (self.orderInfo.type==0) {
            handleButton.enabled = YES;
            [handleButton setTitle:@"去检查" forState:UIControlStateNormal];
        }else{
            if (self.orderInfo.state==0) {
                handleButton.enabled = YES;
                [handleButton setTitle:@"接单" forState:UIControlStateNormal];
            }else{
                if(self.orderInfo.received_state==0){
                    handleButton.enabled = NO;
                    [handleButton setTitle:@"距离辅导开始还有1小时23分钟" forState:UIControlStateNormal];
                }else{
                    handleButton.enabled = YES;
                    [handleButton setTitle:@"去辅导" forState:UIControlStateNormal];
                }
            }
        }
        [handleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [handleButton addTarget:self action:@selector(handleOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:handleButton];
        
        
    }
    return _bottomView;
}





@end
