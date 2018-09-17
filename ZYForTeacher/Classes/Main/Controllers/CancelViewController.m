//
//  CancelViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CancelViewController.h"

@interface CancelViewController (){
    NSArray   *reasonsArr;
    UIButton  *selectBtn;
}

@property (nonatomic, strong) UIButton      *confirmBtn;


@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.isTutorial?@"取消辅导":@"取消检查";
    
    reasonsArr = self.isTutorial?@[@"我选错科目了",@"老师解答不了我的问题",@"老师不在线",@"我临时有事，不能辅导了",@"我下错单了，想重新下单"]:@[@"不会检查学生的作业",@"我有事，不想检查了",@"学生的题目超纲",@"学生选错科目了"];
    
    [self initCancelView];
}



#pragma mark -- event response
#pragma mark 选择取消原因
-(void)chooseCancelReaonsAction:(UIButton *)sender{
    if (selectBtn) {
        selectBtn.selected = NO;
    }
    sender.selected = YES;
    selectBtn = sender;
}

#pragma mark 确定
-(void)confirmChooseCancelReasonAction{
    
}

#pragma mark 初始化
-(void)initCancelView{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(52,kNavHeight+38, kScreenWidth-52, 22)];
    titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    titleLabel.text = @"请说明您的取消辅导的原因";
    [self.view addSubview:titleLabel];
    
    for (NSInteger i=0; i<reasonsArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(53,titleLabel.bottom+24+(30+16)*i, kScreenWidth-80, 30)];
        [btn setTitle:reasonsArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pay_choose_gray"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pay_choose"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF6161"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        btn.titleEdgeInsets = UIEdgeInsetsMake(5,5,5, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseCancelReaonsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(48.0,titleLabel.bottom+24+46*reasonsArr.count+30,kScreenWidth-95.0,(kScreenWidth-95.0)*(128.0/588.0))];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    [confirmButton addTarget:self action:@selector(confirmChooseCancelReasonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}



@end
