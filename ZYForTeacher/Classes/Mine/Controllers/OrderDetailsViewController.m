//
//  OrderDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "OrderDetailsViewController.h"

@interface OrderDetailsViewController (){
    UILabel       *typeLabel;          //作业类型
    UILabel       *stateLabel;         //订单状态
    UIImageView   *headImageView;        //头像
    UILabel       *nameLab;              //姓名
    UILabel       *gradeLab;             //年级/科目
    
    UIScrollView  *imagesScrollView;      //作业检查结果
    UIButton      *videoPlayBtn;         //视频播放
    UILabel       *durationTitleLabel;   //辅导时长标题
    UILabel       *durationLabel;        //辅导时长
    
    UILabel       *amountTitleLabel;
    UILabel       *amountLabel;      //检查价格或辅导金额
    UILabel       *payAmountLabel;   //付款金额
    
    UILabel       *orderSnLabel;     //订单号
    UILabel       *orderTimeLabel;     //下单时间
    UILabel       *paywayLabel;        //支付方式
    UILabel       *payTimeLabel;       //支付时间
}

@property (nonatomic ,strong) UIScrollView *rootScrollView;
@property (nonatomic ,strong) UIView     *headView;
@property (nonatomic ,strong) UIView     *homeworkView;
@property (nonatomic ,strong) UIView     *amountView;
@property (nonatomic ,strong) UIView     *orderView;
@property (nonatomic ,strong) UIView     *payView;



@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"订单详情";
    
    [self initOrdeDetailsView];
    [self loadOrderDetailsData];
}

#pragma mark -- Event Response
#pragma mark 视频播放
-(void)replayTutorialVideoAction{
    
}


#pragma mark 初始化
-(void)initOrdeDetailsView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.headView];
    [self.rootScrollView addSubview:self.homeworkView];
    [self.rootScrollView addSubview:self.amountView];
    [self.rootScrollView addSubview:self.orderView];
    [self.rootScrollView addSubview:self.payView];
}

#pragma mark 加载数据
-(void)loadOrderDetailsData{
    typeLabel.text = self.orderModel.type==0?@"作业检查":@"作业辅导";
    
    headImageView.image = [UIImage imageNamed:self.orderModel.head_image];
    
    nameLab.text = self.orderModel.name;
    CGFloat nameW = [self.orderModel.name boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:nameLab.font].width;
    nameLab.frame = CGRectMake(headImageView.right+16.0,typeLabel.bottom+28.0, nameW, 20);
    
    gradeLab.text = [NSString stringWithFormat:@"%@/%@",self.orderModel.grade,self.orderModel.subject];
    
    if (self.orderModel.state==2) {
        self.homeworkView.hidden = self.amountView.hidden =   self.payView.hidden = YES;
        stateLabel.text = @"已取消";
        self.orderView.frame = CGRectMake(0, self.headView.bottom+10, kScreenWidth, 72);
    }else{
        self.homeworkView.hidden = self.amountView.hidden = NO;
        if (self.orderModel.type==0) {
            self.homeworkView.frame = CGRectMake(0, self.headView.bottom, kScreenWidth, 245);
            videoPlayBtn.hidden = durationTitleLabel.hidden = durationLabel.hidden = YES;
            imagesScrollView.hidden = NO;
            
            amountTitleLabel.text = @"检查价格：";
            amountLabel.text = [NSString stringWithFormat:@"¥%.2f",self.orderModel.check_price]; //检查价格
        }else{
            self.homeworkView.frame = CGRectMake(0, self.headView.bottom, kScreenWidth, 230);
            videoPlayBtn.hidden = durationTitleLabel.hidden = durationLabel.hidden = NO;
            imagesScrollView.hidden = YES;
            
            
            [videoPlayBtn setBackgroundImage:[UIImage imageNamed:self.orderModel.video_cover] forState:UIControlStateNormal];
            amountTitleLabel.text = @"辅导金额：";
            durationLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",self.orderModel.duration/60,self.orderModel.duration%60];
            amountLabel.text = [NSString stringWithFormat:@"%.2f元/分钟",self.orderModel.perPrice]; //辅导价格
        }
        payAmountLabel.text = [NSString stringWithFormat:@"¥%.2f",self.orderModel.pay_price]; //付款金额
        self.amountView.frame = CGRectMake(0, self.homeworkView.bottom+10, kScreenWidth, 80);
        
        if (self.orderModel.state==0) {
            stateLabel.text = @"待付款";
            self.orderView.frame = CGRectMake(0, self.amountView.bottom, kScreenWidth, 72);
            self.payView.hidden = YES;
            self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.orderView.top+self.orderView.height+10);
        }else{
            stateLabel.text = @"已完成";
            if (self.orderModel.payway==0) {
                paywayLabel.text = @"余额支付";
            }else if (self.orderModel.payway==1){
                paywayLabel.text = @"微信支付";
            }else{
                paywayLabel.text = @"支付宝支付";
            }
            payTimeLabel.text = self.orderModel.payTime;
            
            self.orderView.frame = CGRectMake(0, self.amountView.bottom, kScreenWidth, 62);
            self.payView.hidden = NO;
            self.payView.frame = CGRectMake(0, self.orderView.bottom, kScreenWidth, 62);
            self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.payView.top+self.payView.height+10);
        }
    }
    
    orderSnLabel.text = self.orderModel.order_sn;
    orderTimeLabel.text = self.orderModel.create_time;
    
}

#pragma mark -- Getters
#pragma mark
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _rootScrollView;
}

#pragma mark 老师信息
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 115)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11,75, 20)];
        typeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
        typeLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        [_headView addSubview:typeLabel];
        
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, 10,75, 20)];
        stateLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
        stateLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        stateLabel.textAlignment = NSTextAlignmentRight;
        [_headView addSubview:stateLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12.0, 38.0, kScreenWidth-12, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_headView addSubview:line];
        
        UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.0,line.bottom+9.0, 52, 52)];
        bgHeadImageView.backgroundColor = [UIColor colorWithHexString:@"#FFE0D3"];
        [bgHeadImageView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:26];
        [_headView addSubview:bgHeadImageView];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.7, line.bottom+12.9, 46.6, 46.6)];
        [_headView addSubview:headImageView];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+16.0,typeLabel.bottom+28.0, 65, 20)];
        nameLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
        nameLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_headView addSubview:nameLab];
        
        gradeLab = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+16, nameLab.bottom, 90, 17)];
        gradeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        gradeLab.textColor = [UIColor colorWithHexString:@"#808080"];
        [_headView addSubview:gradeLab];
    }
    return _headView;
}

#pragma mark 作业信息
-(UIView *)homeworkView{
    if (!_homeworkView) {
        _homeworkView = [[UIView alloc] initWithFrame:CGRectZero];
        _homeworkView.backgroundColor = [UIColor whiteColor];
        
        imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(18, 0, kScreenWidth-35, 225)];
        imagesScrollView.backgroundColor = [UIColor lightGrayColor];
        [_homeworkView addSubview:imagesScrollView];
        
        videoPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(28, 0, kScreenWidth-56, 180)];
        [videoPlayBtn setImage:[UIImage drawImageWithName:@"play2" size:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [videoPlayBtn addTarget:self action:@selector(replayTutorialVideoAction) forControlEvents:UIControlEventTouchUpInside];
        [_homeworkView addSubview:videoPlayBtn];
        
        durationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18,videoPlayBtn.bottom+15,80, 20)];
        durationTitleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        durationTitleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        durationTitleLabel.text = @"辅导时长：";
        [_homeworkView addSubview:durationTitleLabel];
        
        durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100,videoPlayBtn.bottom+15,83, 20)];
        durationLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        durationLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        durationLabel.textAlignment = NSTextAlignmentRight;
        [_homeworkView addSubview:durationLabel];
    }
    return _homeworkView;
}

#pragma mark 支付信息
-(UIView *)amountView{
    if (!_amountView) {
        _amountView = [[UIView alloc] initWithFrame:CGRectZero];
        _amountView.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i=0; i<2; i++) {
            UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18,12+(20+10)*i,80, 20)];
            titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            [_amountView addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-180,titleLabel.top,162, 20)];
            valueLabel.textAlignment = NSTextAlignmentRight;
            [_amountView addSubview:valueLabel];
            
            if (i==0) {
                titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
                amountTitleLabel = titleLabel;
                valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
                valueLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
                amountLabel = valueLabel;
            }else{
                titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
                titleLabel.text = @"付款金额：";
                valueLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
                payAmountLabel = valueLabel;
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12.0, 79.0, kScreenWidth-12, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_amountView addSubview:line];
    }
    return _amountView;
}

#pragma mark 订单信息
-(UIView *)orderView{
    if (!_orderView) {
        _orderView = [[UIView alloc] initWithFrame:CGRectZero];
        _orderView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[@"订单号",@"下单时间"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18,12+(20+6)*i,80, 20)];
            label.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            label.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            label.text = titles[i];
            [_orderView addSubview:label];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-180,label.top,162, 20)];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            valueLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            valueLabel.textAlignment = NSTextAlignmentRight;
            [_orderView addSubview:valueLabel];
            
            if (i==0) {
                orderSnLabel = valueLabel;
            }else{
                orderTimeLabel = valueLabel;
            }
        }
    }
    return _orderView;
}

#pragma mark 支付信息
-(UIView *)payView{
    if (!_payView) {
        _payView = [[UIView alloc] initWithFrame:CGRectZero];
        _payView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[@"支付方式",@"支付时间"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18,(20+6)*i,80, 20)];
            label.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            label.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            label.text = titles[i];
            [_payView addSubview:label];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-180,label.top,162, 20)];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
            valueLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            valueLabel.textAlignment = NSTextAlignmentRight;
            [_payView addSubview:valueLabel];
            
            if (i==0) {
                paywayLabel = valueLabel;
            }else{
                payTimeLabel = valueLabel;
            }
        }
        
    }
    return _payView;
}


@end
