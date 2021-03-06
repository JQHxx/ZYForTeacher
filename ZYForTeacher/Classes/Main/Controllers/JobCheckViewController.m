//
//  JobCheckViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "JobCheckViewController.h"
#import "CheckToolBarView.h"
#import "MyOrderViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "WhiteboardLines.h"
#import "WhiteboardPoint.h"
#import "WhiteboardDrawView.h"
#import "CancelViewController.h"
#import "SketchpadView.h"

#define kToolBarHeight (IS_IPAD?80:50)

@interface JobCheckViewController ()<CheckToolBarViewDelegate,NIMLoginManagerDelegate>{
    NSInteger currentIndex;
    NSMutableArray *snapshotsImagesArr;
    BOOL  isShowBrush;
}

@property (nonatomic, strong ) UIScrollView       *homeworkScrollView;
@property (nonatomic, strong ) UILabel            *countLabel;   //作业数量
@property (nonatomic, strong ) CheckToolBarView   *toolBarView;  //底部工具栏
@property (nonatomic, strong ) SketchpadView      *brushView;
@property (nonatomic, strong ) UIButton           *moreBtn;      //更多

@property (nonatomic, strong ) NSArray   *colors;
@property (nonatomic,  copy  ) NSString  *myUid;        //通信ID
@property (nonatomic, assign ) NSInteger myDrawColor;   //画笔颜色
@property (nonatomic, assign ) CGFloat   myLineWidth;   //画笔宽度

@property (nonatomic, strong ) NSMutableArray  *whiteboardLinesArray;
@property (nonatomic, strong ) NSMutableArray  *contentViewsArray;


@end

@implementation JobCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.isHiddenNavBar = YES;
    currentIndex = 1;
    snapshotsImagesArr = [[NSMutableArray alloc] init];
    
    
    _whiteboardLinesArray = [[NSMutableArray alloc] init];
    _contentViewsArray = [[NSMutableArray alloc] init];
    
    _colors = @[@(0xe42a2a), @(0x4a4a4a), @(0x5ca1ff)];
    _myDrawColor = [_colors[0] integerValue];
    _myLineWidth = 1.5;
    
    //获取通信ID
    _myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    MyLog(@"通信ID：%@",_myUid);
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    [self initCheckHomeworkView];
    [self loadHomeworkInfo];
}

#pragma mark 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [MobClick beginLogPageView:@"作业检查"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCurrentCheck) name:kOrderCancelNotification object:nil];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
      [MobClick endLogPageView:@"作业检查"];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - NIMLoginManagerDelegate
-(void)onLogin:(NIMLoginStep)step{
    MyLog(@"NIMLoginManagerDelegate -- onLogin:%ld",(long)step);
}

#pragma mark CheckToolBarViewDelegate
#pragma mark 撤销、清除、上一页、下一页
-(void)checkToolBarView:(CheckToolBarView *)barView didClickItemForTag:(NSInteger)tag{
    WhiteboardLines *lines = _whiteboardLinesArray[currentIndex-1];
    if (tag==3||tag==4) {
        if (tag==3) {
            if (currentIndex>1) {
                currentIndex--;
            }else{
                return;
            }
        }else{
            if (currentIndex<self.jobPics.count) {
                currentIndex++;
            }else{
                return;
            }
        }
        [self.homeworkScrollView setContentOffset:CGPointMake(kScreenWidth*(currentIndex-1), 0) animated:YES];
        self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex,self.jobPics.count];
    }else if (tag==0){ //显示画笔
        isShowBrush = !isShowBrush;
        if (isShowBrush) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.brushView setFrame: CGRectMake(0, kScreenHeight-kToolBarHeight-kToolBarHeight, kScreenWidth, kToolBarHeight)];
                [self.view insertSubview:self.brushView belowSubview:self.toolBarView];
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                [self.brushView setFrame:CGRectMake(0, kScreenHeight-kToolBarHeight, kScreenWidth, 0)];
                [self.brushView removeFromSuperview];
            } completion:^(BOOL finished) {
                self.brushView = nil;
            }];
        }
        
    }else if (tag==1){  //撤销
        [lines cancelLastLine:_myUid];
    }else{ // 清除
        [lines clear];
    }
}

#pragma mark
-(void)cancelCurrentCheck{
    [self.view makeToast:@"对方取消当前作业检查" duration:1.0 position:CSToastPositionCenter];
    kSelfWeak;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf backAction];
    });
}

#pragma mark 结束检查
-(void)checkToolBarViewDidFinishedCheck{
    BOOL allHasLines = YES;
    for (WhiteboardLines *lines in _whiteboardLinesArray) {
        if(!lines.hasLines){
            allHasLines = NO;
            break;
        }
    }
    if (!allHasLines) {
        [self.view makeToast:@"您还有检查没完成，请完成您的检查后再结束" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    kSelfWeak;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"结束检查" message:@"确定要结束作业检查吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        for (NSInteger i=0; i<self.jobPics.count; i++) {
            UIView *contentView = _contentViewsArray[i];
            UIImage *image = [UIImage snapshotForView:contentView];
            [snapshotsImagesArr addObject:image];
        }
        
        NSMutableArray *encodeImageArr = [[ZYHelper sharedZYHelper] imageDataProcessingWithImgArray:snapshotsImagesArr];
        NSString *encodeResult = [TCHttpRequest getValueWithParams:encodeImageArr];
      
        NSString *body = [NSString stringWithFormat:@"pic=%@&dir=3",encodeResult];
        [TCHttpRequest postMethodWithURL:kUploadPicAPI body:body success:^(id json) {
            NSArray *imgUrls = [json objectForKey:@"data"];
            NSString *picsStr = [TCHttpRequest getValueWithParams:imgUrls];
            NSString *body2 = [NSString stringWithFormat:@"token=%@&oid=%@&pics=%@",kUserTokenValue,self.orderId,picsStr];
            [TCHttpRequest postMethodWithURL:kCheckOverAPI body:body2 success:^(id json) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf.view makeToast:@"作业检查已结束" duration:0.5 position:CSToastPositionCenter];
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf backAction];
                });
            }];
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 返回
-(void)backAction{
    BOOL isOrderIn = NO;
    for (BaseViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyOrderViewController class]]) {
            isOrderIn = YES;
            [ZYHelper sharedZYHelper].isUpdateOrderList = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (!isOrderIn) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark  - UIResponder
#pragma mark 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *contentView = _contentViewsArray[currentIndex-1];
    WhiteboardDrawView *drawView = [contentView viewWithTag:currentIndex-1];
    CGPoint p = [[touches anyObject] locationInView:drawView];
    [self onPointCollected:p type:WhiteboardPointTypeStart];
}

#pragma mark 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *contentView = _contentViewsArray[currentIndex-1];
    WhiteboardDrawView *drawView = [contentView viewWithTag:currentIndex-1];
    CGPoint p = [[touches anyObject] locationInView:drawView];
    [self onPointCollected:p type:WhiteboardPointTypeMove];
}

#pragma mark 触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *contentView = _contentViewsArray[currentIndex-1];
    WhiteboardDrawView *drawView = [contentView viewWithTag:currentIndex-1];
    CGPoint p = [[touches anyObject] locationInView:drawView];
    [self onPointCollected:p type:WhiteboardPointTypeEnd];
}

#pragma mark -- Event Response
#pragma mark 取消检查
-(void)getMoreHandleListAction{
    CancelViewController *cancelVC = [[CancelViewController alloc] init];
    cancelVC.oid = self.orderId;
    cancelVC.jobid = self.jobId;
    cancelVC.myTitle = @"取消检查";
    cancelVC.type = CancelTypeOrderCheck;
    [self.navigationController pushViewController:cancelVC animated:YES];
}


#pragma mark - Private Methods
#pragma mark 添加线条
- (void)onPointCollected:(CGPoint)p type:(WhiteboardPointType)type{
    UIView *contentView = _contentViewsArray[currentIndex-1];
    WhiteboardDrawView *drawView = [contentView viewWithTag:currentIndex-1];
    
    WhiteboardPoint *point = [[WhiteboardPoint alloc] init];
    point.type = type;
    point.xScale = p.x/drawView.width;
    point.yScale = p.y/drawView.height;
    point.colorRGB = _myDrawColor;
    point.lineWidth = _myLineWidth;
    
    WhiteboardLines *lines = _whiteboardLinesArray[currentIndex-1];
    [lines addPoint:point uid:_myUid];
}

#pragma mark 获取作业详情
-(void)loadHomeworkInfo{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,self.jobId];
    [TCHttpRequest postMethodWithURL:kHomeworkDetailsAPI body:body success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        weakSelf.orderId = dict[@"oid"];
    }];
}

#pragma mark 初始化界面
-(void)initCheckHomeworkView{
    [self.view addSubview:self.homeworkScrollView];
    [self.view addSubview:self.moreBtn];
    
    if (self.jobPics.count>1) {
        [self.view addSubview:self.countLabel];
    }
    [self.view addSubview:self.toolBarView];
}

#pragma mark -- Getters
#pragma mark 作业图片
-(UIScrollView *)homeworkScrollView{
    if (!_homeworkScrollView) {
        _homeworkScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kToolBarHeight)];
        _homeworkScrollView.showsHorizontalScrollIndicator = NO;
        _homeworkScrollView.showsVerticalScrollIndicator = NO;
        _homeworkScrollView.pagingEnabled = YES;
        _homeworkScrollView.scrollEnabled = NO;
        _homeworkScrollView.backgroundColor = [UIColor whiteColor];
        _homeworkScrollView.bounces = NO;
        
        _homeworkScrollView.userInteractionEnabled =NO;
        
        if (@available(iOS 11.0, *)) {
            _homeworkScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    
        for (NSInteger i=0; i<self.jobPics.count; i++) {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight-kToolBarHeight)];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kToolBarHeight)];
            imgView.image = [UIImage imageNamed:self.jobPics[i]];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.jobPics[i]] placeholderImage:[UIImage imageNamed:@"task_details_loading"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    MyLog(@"error:%@",error.localizedDescription);
                }
            }];
            [contentView addSubview:imgView];
            
            WhiteboardDrawView *drawView = [[WhiteboardDrawView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kToolBarHeight)];
            drawView.backgroundColor = [UIColor clearColor];
            drawView.tag = i;
            
            WhiteboardLines *lines = [[WhiteboardLines alloc] init];
            drawView.dataSource = lines;
            [contentView addSubview:drawView];
            
            [_homeworkScrollView addSubview:contentView];
            [_whiteboardLinesArray addObject:lines];
            [_contentViewsArray addObject:contentView];
            
        }
        _homeworkScrollView.contentSize = CGSizeMake(kScreenWidth*self.jobPics.count, kScreenHeight);
        
    }
    return _homeworkScrollView;
}

#pragma mark 更多
-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-66, KStatusHeight+10, 46, 46):CGRectMake(kScreenWidth-40, KStatusHeight, 30, 40)];
        [_moreBtn setImage:[UIImage imageNamed:IS_IPAD?@"connection_more_ipad":@"connection_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(getMoreHandleListAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}


#pragma mark 数量
-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-100, kScreenHeight-120, 80, 30):CGRectMake(kScreenWidth-70, kScreenHeight- 90, 50, 22)];
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex,self.jobPics.count];
        _countLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _countLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

#pragma mark 底部工具栏
-(CheckToolBarView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [[CheckToolBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kToolBarHeight, kScreenWidth, kToolBarHeight)];
        _toolBarView.delegate = self;
        _toolBarView.selColorIndex = 0;
    }
    return _toolBarView;
}

#pragma mark 画板颜色
-(SketchpadView *)brushView{
    if (!_brushView) {
        _brushView = [[SketchpadView alloc] initWithFrame:CGRectMake(0,kScreenHeight-kToolBarHeight, kScreenWidth, 0)];
        _brushView.backgroundColor = [UIColor clearColor];
        kSelfWeak;
        _brushView.setColor = ^(NSInteger index) {
            isShowBrush = NO;
            weakSelf.toolBarView.selColorIndex = index;
            _myDrawColor = [_colors[index] integerValue];
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.brushView setFrame:CGRectMake(0, kScreenHeight-kToolBarHeight, kScreenWidth, 0)];
                [weakSelf.brushView removeFromSuperview];
            } completion:^(BOOL finished) {
                weakSelf.brushView = nil;
            }];
        };
    }
    return _brushView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderCancelNotification object:nil];
}

@end
