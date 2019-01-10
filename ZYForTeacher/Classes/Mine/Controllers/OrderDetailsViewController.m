//
//  OrderDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "JobCheckViewController.h"
#import "ConnecttingViewController.h"
#import "ComplainInfoViewController.h"
#import "CommentInfoViewController.h"
#import "ContactServiceViewController.h"
#import "CancelViewController.h"
#import "HomeworkModel.h"
#import "JobPicsView.h"

@interface OrderDetailsViewController (){
    UILabel       *typeLabel;          //作业类型
    UILabel       *stateLabel;         //订单状态
    UIImageView   *headImageView;        //头像
    UILabel       *nameLab;              //姓名
    UILabel       *gradeLab;             //年级/科目
    
    UILabel       *durationTitleLabel;   //辅导时长标题
    UILabel       *durationLabel;        //辅导时长
    
    UILabel       *amountTitleLabel;
    UILabel       *amountLabel;      //检查价格或辅导金额
    UILabel       *payAmountLabel;   //付款金额
    
    UILabel       *orderSnLabel;     //订单号
    UILabel       *orderTimeLabel;     //下单时间
    UILabel       *paywayLabel;        //支付方式
    UILabel       *payTimeLabel;       //支付时间
    
    
    OrderModel    *order;
    ComplainModel *complainModel;
    CommentModel  *commentModel;
}

@property (nonatomic ,strong) UIScrollView *rootScrollView;
@property (nonatomic ,strong) UIView     *headView;
@property (nonatomic ,strong) JobPicsView  *jobPicsView;      //作业检查结果
@property (nonatomic ,strong) UIView     *homeworkView;
@property (nonatomic ,strong) UIView     *amountView;
@property (nonatomic ,strong) UIView     *orderView;
@property (nonatomic ,strong) UIView     *payView;
@property (nonatomic ,strong) UIView     *bottomView;

@property (nonatomic ,strong) UIButton   *checkCommentBtn; //查看评论
@property (nonatomic ,strong) UIButton   *checkComplainBtn; //查看投诉
@property (nonatomic ,strong) UIButton   *handleBtn; //继续检查或继续辅导
@property (nonatomic ,strong) UIButton   *connectServiceBtn; //联系客服
@property (nonatomic ,strong) UIButton   *cancelButton; //取消订单


@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"订单详情";
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    order = [[OrderModel alloc] init];
    complainModel = [[ComplainModel alloc] init];
    commentModel = [[CommentModel alloc] init];
    
    [self initOrdeDetailsView];
    [self loadOrderDetailsData];
}


#pragma mark 初始化
-(void)initOrdeDetailsView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.headView];
    [self.rootScrollView addSubview:self.jobPicsView];
    [self.rootScrollView addSubview:self.homeworkView];
    [self.rootScrollView addSubview:self.amountView];
    [self.rootScrollView addSubview:self.orderView];
    [self.rootScrollView addSubview:self.payView];
    self.rootScrollView.hidden = YES;
    
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden = YES;
}

#pragma mark 加载数据
-(void)loadOrderDetailsData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&oid=%@",kUserTokenValue,self.orderId];
    [TCHttpRequest postMethodWithURL:kOrderDetailsAPI body:body success:^(id json) {
        if (weakSelf.isNotifyIn) {
            [ZYHelper sharedZYHelper].isUpdateMessageUnread = YES;
            [ZYHelper sharedZYHelper].isUpdateMessageInfo = YES;
        }
        
        NSDictionary *data = [json objectForKey:@"data"];
        [order setValues:data];
        
        NSDictionary *complainDict = [data valueForKey:@"complain"];
        [complainModel setValues:complainDict];
        
        NSDictionary *commentDict = [data valueForKey:@"comment"];
        [commentModel setValues:commentDict];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.rootScrollView.hidden = NO;
            weakSelf.bottomView.hidden = NO;
            //作业类型
            typeLabel.text = [order.label integerValue]<2?@"作业检查":@"作业辅导";
            //头像
            if (!kIsEmptyString(order.trait)) {
                [headImageView sd_setImageWithURL:[NSURL URLWithString:order.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
            }else{
                headImageView.image = [UIImage imageNamed:@"default_head_image"];
            }
            //姓名
            nameLab.text = order.username;
            CGFloat nameW = [order.username boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:nameLab.font].width;
            nameLab.frame =IS_IPAD?CGRectMake(headImageView.right+24, typeLabel.bottom+46, nameW, 30): CGRectMake(headImageView.right+16.0,typeLabel.bottom+28.0, nameW, 20);
            //年级
            gradeLab.text = [NSString stringWithFormat:@"%@/%@",order.grade,order.subject];
            
            if ([order.status integerValue]==0||[order.status integerValue]==3) { //进行中或已取消
                weakSelf.connectServiceBtn.hidden = weakSelf.homeworkView.hidden =YES;
                weakSelf.amountView.hidden =   self.payView.hidden = YES;
                if ([order.status integerValue]==0) { //进行中
                    stateLabel.text = [order.label integerValue]==1?@"检查中":@"辅导中";
                    [_handleBtn setTitle:[order.label integerValue]==1?@"继续检查":@"继续辅导" forState:UIControlStateNormal];
                    weakSelf.handleBtn.hidden = weakSelf.cancelButton.hidden = NO;
                     durationTitleLabel.hidden = durationLabel.hidden = YES;
                }else{ //已取消
                   weakSelf.handleBtn.hidden = weakSelf.bottomView.hidden = weakSelf.cancelButton.hidden = YES;
                   stateLabel.text =@"已取消";
                }
                
                if (kIsArray(order.job_pic)&&order.job_pic.count>0) {
                    CGFloat imgW = (kScreenWidth-45)/3.0; //图片宽高
                    NSInteger allNum = order.job_pic.count;
                    [weakSelf.jobPicsView updateCollectViewWithPhotosArr:[NSMutableArray arrayWithArray:order.job_pic]];
                    weakSelf.jobPicsView.frame = CGRectMake(0,weakSelf.headView.bottom, kScreenWidth, (imgW+5)*(1+(allNum-1)/3)+10);
                }else{
                    weakSelf.jobPicsView.frame = CGRectZero;
                }
                weakSelf.orderView.frame =IS_IPAD?CGRectMake(0, weakSelf.jobPicsView.bottom+15, kScreenWidth, 112):CGRectMake(0, weakSelf.jobPicsView.bottom+10, kScreenWidth, 72);
                weakSelf.rootScrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.orderView.top+weakSelf.orderView.height+10);
            }else if([order.status integerValue]==1||[order.status integerValue]==2){ //待付款或已完成
                weakSelf.connectServiceBtn.hidden = NO;
                weakSelf.amountView.hidden = NO;
                weakSelf.handleBtn.hidden = weakSelf.cancelButton.hidden = YES;
                if ([order.label integerValue]==1) { //作业检查
                    weakSelf.homeworkView.hidden = durationTitleLabel.hidden = durationLabel.hidden = YES;
                    weakSelf.jobPicsView.hidden = NO;
                    //设置检查图片
                    if (kIsArray(order.pics)&&order.pics.count>0) {
                        CGFloat imgW = (kScreenWidth-45)/3.0; //图片宽高
                        NSInteger allNum = order.pics.count;
                        [weakSelf.jobPicsView updateCollectViewWithPhotosArr:[NSMutableArray arrayWithArray:order.pics]];
                        weakSelf.jobPicsView.frame = CGRectMake(0,weakSelf.headView.bottom, kScreenWidth, (imgW+5)*(1+(allNum-1)/3)+10);
                    }else{
                        weakSelf.jobPicsView.frame = CGRectZero;
                    }
                    //检查价格
                    amountTitleLabel.text = @"检查价格：";
                    amountLabel.text = [NSString stringWithFormat:@"¥%.2f",[order.price doubleValue]]; //检查价格
                    weakSelf.amountView.frame =IS_IPAD?CGRectMake(0, weakSelf.jobPicsView.bottom+15, kScreenWidth, 122):CGRectMake(0, weakSelf.jobPicsView.bottom+10, kScreenWidth, 80);
                }else{  //作业辅导
                    weakSelf.homeworkView.hidden = durationTitleLabel.hidden = durationLabel.hidden = NO;

                    weakSelf.jobPicsView.hidden = NO;
                    
                    CGFloat imgW = (kScreenWidth-45)/3.0; //图片宽高
                    NSInteger allNum = order.job_pic.count;
                    [weakSelf.jobPicsView updateCollectViewWithPhotosArr:[NSMutableArray arrayWithArray:order.job_pic]];
                    weakSelf.jobPicsView.frame = CGRectMake(0,weakSelf.headView.bottom, kScreenWidth, (imgW+5)*(1+(allNum-1)/3)+10);
                    weakSelf.homeworkView.frame =IS_IPAD?CGRectMake(0, weakSelf.jobPicsView.bottom, kScreenWidth,50):CGRectMake(0, weakSelf.jobPicsView.bottom, kScreenWidth, 30);
                    
                    //辅导金额和辅导时长
                    amountTitleLabel.text = @"辅导金额：";
                    NSInteger jobTime = [order.job_time integerValue];
                    durationLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",jobTime/60,jobTime%60];
                    amountLabel.text = [NSString stringWithFormat:@"%.2f元/分钟",[order.price doubleValue]]; //辅导价格
                    weakSelf.amountView.frame =IS_IPAD?CGRectMake(0, weakSelf.jobPicsView.bottom+15, kScreenWidth, 122):CGRectMake(0, weakSelf.homeworkView.bottom+10, kScreenWidth, 80);
                }
                
                //支付信息
                payAmountLabel.text = [NSString stringWithFormat:@"¥%.2f",[order.pay_money doubleValue]]; //付款金额
                
                if ([order.status integerValue]==1) {
                    stateLabel.text = @"待付款";
                    weakSelf.orderView.frame = IS_IPAD?CGRectMake(0, weakSelf.amountView.bottom, kScreenWidth, 111):CGRectMake(0, weakSelf.amountView.bottom, kScreenWidth, 72);
                    weakSelf.payView.hidden = YES;
                    weakSelf.rootScrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.orderView.top+weakSelf.orderView.height+10);
                }else{
                    stateLabel.text = @"已完成";
                    if ([order.cate integerValue]==1) {
                        paywayLabel.text = @"支付宝支付";
                    }else if ([order.cate integerValue]==2){
                        paywayLabel.text = @"微信支付";
                    }else{
                        paywayLabel.text = @"余额支付";
                    }
                    payTimeLabel.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:order.pay_time format:@"yyyy-MM-dd HH:mm"];
                    
                    weakSelf.orderView.frame = IS_IPAD?CGRectMake(0, weakSelf.amountView.bottom, kScreenWidth, 101):CGRectMake(0, weakSelf.amountView.bottom, kScreenWidth, 62);
                    weakSelf.payView.hidden = NO;
                    weakSelf.payView.frame = IS_IPAD?CGRectMake(0, weakSelf.orderView.bottom, kScreenWidth, 91):CGRectMake(0, weakSelf.orderView.bottom, kScreenWidth, 62);
                    weakSelf.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.payView.top+self.payView.height+10);
                    
                    if (!kIsEmptyString(complainModel.complain)&&!kIsEmptyString(commentModel.comment)) {
                        weakSelf.checkCommentBtn.hidden = weakSelf.checkComplainBtn.hidden = NO;
                        weakSelf.checkComplainBtn.frame = IS_IPAD?CGRectMake(kScreenWidth-325, 14, 135, 49):CGRectMake(kScreenWidth-190, 11, 80, 28);
                        weakSelf.checkCommentBtn.frame = IS_IPAD?CGRectMake(kScreenWidth-488, 14, 135, 49):CGRectMake(kScreenWidth-280, 11, 80, 28);
                    }else{
                        if (!kIsEmptyString(complainModel.complain)) {
                            weakSelf.checkComplainBtn.hidden = NO;
                            weakSelf.checkCommentBtn.hidden = YES;
                            weakSelf.checkComplainBtn.frame = IS_IPAD?CGRectMake(kScreenWidth-325, 14, 135, 49): CGRectMake(kScreenWidth-190, 11, 80, 28);
                        }else if (!kIsEmptyString(commentModel.comment)){
                            weakSelf.checkComplainBtn.hidden = YES;
                            weakSelf.checkCommentBtn.hidden = NO;
                            weakSelf.checkCommentBtn.frame = IS_IPAD?CGRectMake(kScreenWidth-325, 14, 135, 49):CGRectMake(kScreenWidth-190, 11, 80, 28);
                        }else{
                           weakSelf.checkCommentBtn.hidden = weakSelf.checkComplainBtn.hidden = YES;
                        }
                    }
                }
            }
            //订单信息
            orderSnLabel.text = order.oid;
            orderTimeLabel.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:order.create_time format:@"yyyy-MM-dd HH:mm"];
        });
    }];
}

#pragma mark 继续检查或继续辅导
-(void)continueHandleAction{
    if ([order.label integerValue]==1) {
        JobCheckViewController *checkVC = [[JobCheckViewController alloc] init];
        checkVC.jobId = order.jobid;
        checkVC.orderId = order.oid;
        checkVC.jobPics = order.job_pic;
        checkVC.label = order.label;
        checkVC.third_id = order.third_id;
        [self.navigationController pushViewController:checkVC animated:YES];
    }else{
        kSelfWeak;
        NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,order.jobid];
        [TCHttpRequest postMethodWithURL:kHomeworkDetailsAPI body:body success:^(id json) {
            NSDictionary *data = [json objectForKey:@"data"];
            HomeworkModel *model = [[HomeworkModel alloc] init];
            [model setValues:data];
            model.job_pic = order.job_pic;
            model.label = order.label;
            model.orderId = order.oid;
            model.temp_time = order.temp_time;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ConnecttingViewController *connenttingVC = [[ConnecttingViewController alloc] initWithCallee:model.third_id];
                connenttingVC.isOrderIn = YES;
                connenttingVC.homework = model;
                [weakSelf.navigationController pushViewController:connenttingVC animated:YES];
            });
        }];
    }
}

#pragma mark 查看评论
-(void)checkOrderCommentAction{
    CommentInfoViewController *commentInfoVC = [[CommentInfoViewController alloc] init];
    commentInfoVC.myComment = commentModel;
    [self.navigationController pushViewController:commentInfoVC animated:YES];
}

#pragma mark 查看投诉
-(void)checkOrderComplainAction{
    ComplainInfoViewController *complainInfoVC = [[ComplainInfoViewController alloc] init];
    complainInfoVC.myComplain = complainModel;
    [self.navigationController pushViewController:complainInfoVC animated:YES];
}

#pragma mark 联系客服
-(void)connectSeriveAction{
    ContactServiceViewController *contactServiceVC = [[ContactServiceViewController alloc] init];
    [self.navigationController pushViewController:contactServiceVC animated:YES];
}

#pragma mark 取消订单
-(void)cancelCurrentOrderAction{
    CancelViewController *cancelVC = [[CancelViewController alloc] init];
    cancelVC.oid = self.orderId;
    cancelVC.jobid = order.jobid;
    cancelVC.myTitle = [order.label integerValue]>1?@"取消辅导":@"取消检查";
    cancelVC.type = [order.label integerValue]<2?CancelTypeOrderCheck:CancelTypeOrderCoach;
    [self.navigationController pushViewController:cancelVC animated:YES];
}

#pragma mark -- Getters
#pragma mark
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _rootScrollView;
}

#pragma mark 老师信息
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(0, 10, kScreenWidth, 180):CGRectMake(0, 10, kScreenWidth, 115)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        typeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 14, 100, 30):CGRectMake(12, 11,75, 20)];
        typeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        typeLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        [_headView addSubview:typeLabel];
        
        stateLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-110, 14,70, 30):CGRectMake(kScreenWidth-100, 10,75, 20)];
        stateLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        stateLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        stateLabel.textAlignment = NSTextAlignmentRight;
        [_headView addSubview:stateLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(18, typeLabel.bottom+12, kScreenWidth-18, 0.5):CGRectMake(12.0, 38.0, kScreenWidth-12, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_headView addSubview:line];
        
        UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(40, line.bottom+19, 80, 80):CGRectMake(18.0,line.bottom+9.0, 52, 52)];
        bgHeadImageView.backgroundColor = [UIColor colorWithHexString:@"#FFE0D3"];
        [bgHeadImageView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:IS_IPAD?40:26];
        [_headView addSubview:bgHeadImageView];
        
        headImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(44, line.bottom+24, 71, 71):CGRectMake(20.7, line.bottom+12.9, 46.6, 46.6)];
        headImageView.boderRadius = IS_IPAD?35.5:23.3;
        [_headView addSubview:headImageView];
        
        nameLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(headImageView.right+24, typeLabel.bottom+46, 150, 30):CGRectMake(headImageView.right+16.0,typeLabel.bottom+28.0, 65, 20)];
        nameLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        nameLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_headView addSubview:nameLab];
        
        gradeLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(headImageView.right+25.5, nameLab.bottom+2, 160, 26):CGRectMake(headImageView.right+16, nameLab.bottom, 90, 17)];
        gradeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?19:12];
        gradeLab.textColor = [UIColor colorWithHexString:@"#808080"];
        [_headView addSubview:gradeLab];
    }
    return _headView;
}

#pragma mark 作业检查图片
-(JobPicsView *)jobPicsView{
    if (!_jobPicsView) {
        _jobPicsView = [[JobPicsView alloc] initWithFrame:CGRectZero];
    }
    return _jobPicsView;
}

#pragma mark 作业信息
-(UIView *)homeworkView{
    if (!_homeworkView) {
        _homeworkView = [[UIView alloc] initWithFrame:CGRectZero];
        _homeworkView.backgroundColor = [UIColor whiteColor];
        
        durationTitleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 10, 120, 30):CGRectMake(18,5,80, 20)];
        durationTitleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        durationTitleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        durationTitleLabel.text = @"辅导时长：";
        [_homeworkView addSubview:durationTitleLabel];
        
        durationLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-162, 10, 113, 30):CGRectMake(kScreenWidth-100,5,83, 20)];
        durationLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
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
            UILabel  *titleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 21+(30+17)*i, 140, 30):CGRectMake(18,12+(20+10)*i,80, 20)];
            titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            [_amountView addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-240,titleLabel.top, 200, 30):CGRectMake(kScreenWidth-180,titleLabel.top,162, 20)];
            valueLabel.textAlignment = NSTextAlignmentRight;
            [_amountView addSubview:valueLabel];
            
            if (i==0) {
                titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
                amountTitleLabel = titleLabel;
                valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
                valueLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
                amountLabel = valueLabel;
            }else{
                titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?24:16];
                titleLabel.text = @"付款金额：";
                valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?28:18];
                valueLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
                payAmountLabel = valueLabel;
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(25, 121.5, kScreenWidth-25, 0.5): CGRectMake(12.0, 79.0, kScreenWidth-12, 0.5)];
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
        
        NSArray *titles = @[@"订单号",@"接单时间"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 21+(30+10)*i, 140, 30):CGRectMake(18,12+(20+6)*i,80, 20)];
            label.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
            label.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            label.text = titles[i];
            [_orderView addSubview:label];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-300,label.top, 260, 30):CGRectMake(kScreenWidth-180,label.top,162, 20)];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
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
            UILabel *label = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40,(30+10)*i, 140, 30):CGRectMake(18,(20+6)*i,80, 20)];
            label.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
            label.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            label.text = titles[i];
            [_payView addSubview:label];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-240,label.top, 200, 30):CGRectMake(kScreenWidth-180,label.top,162, 20)];
            valueLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
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

#pragma mark 底部视图
-(UIView *)bottomView{
    if (!_bottomView) {
        CGFloat viewH;
        if (IS_IPAD) {
            viewH = 77.0;
        }else{
            viewH = isXDevice ? 70:50;
        }
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-viewH, kScreenWidth, viewH)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        _checkCommentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_checkCommentBtn setTitle:@"查看评论" forState:UIControlStateNormal];
        [_checkCommentBtn setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
        _checkCommentBtn.layer.cornerRadius = IS_IPAD?25:14;
        _checkCommentBtn.layer.borderColor = [UIColor colorWithHexString:@"#9B9B9B"].CGColor;
        _checkCommentBtn.layer.borderWidth = 1.0;
        _checkCommentBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [_checkCommentBtn addTarget:self action:@selector(checkOrderCommentAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_checkCommentBtn];
        
        _checkComplainBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_checkComplainBtn setTitle:@"查看投诉" forState:UIControlStateNormal];
        [_checkComplainBtn setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
        _checkComplainBtn.layer.cornerRadius = IS_IPAD?25:14;
        _checkComplainBtn.layer.borderColor = [UIColor colorWithHexString:@"#9B9B9B"].CGColor;
        _checkComplainBtn.layer.borderWidth = 1.0;
        _checkComplainBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [_checkComplainBtn addTarget:self action:@selector(checkOrderComplainAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_checkComplainBtn];
        
        _cancelButton = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-325, 14, 135, 49):CGRectMake(kScreenWidth-190, 11, 80,30)];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = IS_IPAD?25:14;
        _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#9B9B9B"].CGColor;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelCurrentOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_cancelButton];
        
        _handleBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-163, 14, 123, 49):CGRectMake(kScreenWidth-100, 10, 80, 30)];
        [_handleBtn setBackgroundImage:[UIImage imageNamed:@"button3"] forState:UIControlStateNormal];
        [_handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _handleBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        [_handleBtn addTarget:self action:@selector(continueHandleAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_handleBtn];
        
        _connectServiceBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-163, 14, 123, 49):CGRectMake(kScreenWidth-100, 10, 80,30)];
        [_connectServiceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_connectServiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_connectServiceBtn setBackgroundImage:[UIImage imageNamed:@"button3"] forState:UIControlStateNormal];
        _connectServiceBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [_connectServiceBtn addTarget:self action:@selector(connectSeriveAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_connectServiceBtn];
        
    }
    return _bottomView;
}


@end
