//
//  WalletDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/9.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WalletDetailsViewController.h"
#import "ContactServiceViewController.h"
#import "BillModel.h"

@interface WalletDetailsViewController (){
    UIImageView  *imgView;
    UILabel      *typeLabel;
    UILabel      *amountLabel;
    
    UILabel      *statusLabel;  // 交易状态
    UILabel      *timeLabel;    //创建时间
    UILabel      *orderSnLabel; //订单号
    
    UILabel      *cardHolderLab;   //持卡人
    UILabel      *bankLabel;       //银行
    UILabel      *cardLabel;       //银行卡号
    
    NSMutableArray  *valueLabels;
}

@property (nonatomic, strong) UIView  *topView;
@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UIView  *serviceView;

@end

@implementation WalletDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"账单详情";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    valueLabels = [[NSMutableArray alloc] init];
    
    [self initWalletDetailsView];
    [self loadDetailsData];
    
}


#pragma mark -- Event response
#pragma mark 联系客服
-(void)contactServiceAction:(UITapGestureRecognizer *)gesture{
    ContactServiceViewController *contactVC = [[ContactServiceViewController alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

#pragma mark -- private methods
#pragma mark 加载明细详情
- (void)loadDetailsData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&income_no=%@",kUserTokenValue,self.incomeNo];
    [TCHttpRequest postMethodWithURL:kWalletBillDetailsAPI body:body success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        BillModel *myBill = [[BillModel alloc] init];
        [myBill setValues:dict];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *tempStr = nil;
            if ([myBill.label integerValue]==3) {
                imgView.image = [UIImage imageNamed:@"bill_recharge"];
                typeLabel.text = @"提现";
                amountLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
                tempStr = @"-";
                
                if ([myBill.extract_status integerValue]==1) {
                    statusLabel.text = @"待审核";
                }else if([myBill.extract_status integerValue]==2){
                    statusLabel.text = @"已审核通过";
                }else if([myBill.extract_status integerValue]==3){
                    statusLabel.text = @"已发放";
                }else{
                    statusLabel.text = @"审核未通过";
                }
                
                weakSelf.contentView.hidden = NO;
                weakSelf.contentView.frame = CGRectMake(0, weakSelf.topView.bottom+10, kScreenWidth, 115);
                
                orderSnLabel.text = myBill.extract_no;
                cardHolderLab.text = myBill.realname;
                bankLabel.text = myBill.bank;
                cardLabel.text = myBill.card;
                
            }else{
                 if ([myBill.label integerValue]==1){
                    imgView.image = [UIImage imageNamed:@"bill_inspect"];
                    typeLabel.text = @"作业检查";
                    amountLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
                    tempStr = @"+";
                }else{
                    imgView.image = [UIImage imageNamed:@"bill_coach"];
                    typeLabel.text = @"作业辅导";
                    amountLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
                    tempStr = @"+";
                }
                statusLabel.text = [myBill.status integerValue]==1?@"交易失败":@"交易成功";
                 orderSnLabel.text = myBill.income_no;
                
                weakSelf.contentView.hidden = YES;
                weakSelf.contentView.frame = CGRectMake(0, weakSelf.topView.bottom, kScreenWidth, 0);
            }
            amountLabel.text = [tempStr stringByAppendingString:[NSString stringWithFormat:@"¥%.2f",[myBill.income doubleValue]]];
            
            timeLabel.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:myBill.income_time format:@"yyyy-MM-dd HH:mm:ss"];
           
            weakSelf.serviceView.frame = CGRectMake(0, weakSelf.contentView.bottom+10, kScreenWidth, 45);
        });
        
    }];
}


#pragma mark 初始化
-(void)initWalletDetailsView{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.contentView];
    self.contentView.hidden = YES;
    [self.view addSubview:self.serviceView];
    
}

#pragma mark -- Setters
#pragma mark 明细类型
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight+3.0, kScreenWidth, 324)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-56)/2.0, 30, 56, 56)];
        [_topView addSubview:imgView];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, imgView.bottom+10, kScreenWidth-120, 22)];
        typeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        typeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        typeLabel.textAlignment =NSTextAlignmentCenter;
        [_topView addSubview:typeLabel];
        
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,typeLabel.bottom+10.0,kScreenWidth-120, 42)];
        amountLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:30];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:amountLabel];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(19.0,amountLabel.bottom+40.0, kScreenWidth-37.0, 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self.view addSubview:line2];
        
        NSArray *titles = @[@"当前状态",@"创建时间",@"交易单号"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, line2.bottom+13+i*(20+13), 60, 20)];
            titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
            titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            titleLabel.text = titles[i];
            [_topView addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-180, line2.bottom+13+i*(20+13),158, 20)];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            valueLabel.textColor = [UIColor colorWithHexString:@"#808080"];
            valueLabel.textAlignment = NSTextAlignmentRight;
            [_topView addSubview:valueLabel];
            
            if (i==0) {
                statusLabel = valueLabel;
            }else if (i==1){
                timeLabel = valueLabel;
            }else{
                orderSnLabel = valueLabel;
            }
        }
        
    }
    return _topView;
}

#pragma mark 明细信息
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, kScreenWidth, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[@"持卡人",@"银行",@"银行卡号"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 13+i*(20+13), 60, 20)];
            titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
            titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            titleLabel.text = titles[i];
            [_contentView addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-180,13+i*(20+13),158, 20)];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            valueLabel.textColor = [UIColor colorWithHexString:@"#808080"];
            valueLabel.textAlignment = NSTextAlignmentRight;
            [_contentView addSubview:valueLabel];
            
            if (i==0) {
                cardHolderLab = valueLabel;
            }else if (i==1){
                bankLabel = valueLabel;
            }else{
                cardLabel = valueLabel;
            }
        }
    }
    return _contentView;
}

#pragma mark 联系客服
-(UIView *)serviceView{
    if (!_serviceView) {
        _serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.bottom+10, kScreenWidth, 45)];
        _serviceView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(28, 13, 60, 20)];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
        lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        lab.text = @"联系客服";
        [_serviceView addSubview:lab];
        
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-35, 14, 8.2, 15)];
        arrowImgView.image = [UIImage imageNamed:@"arrow2_personal_information"];
        [_serviceView addSubview:arrowImgView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_serviceView.bounds];
        [btn addTarget:self action:@selector(contactServiceAction:) forControlEvents:UIControlEventTouchUpInside];
        [_serviceView addSubview:btn];
    }
    return _serviceView;
}


@end
