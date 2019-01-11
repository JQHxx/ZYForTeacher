//
//  HomeworkDetailsViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "HomeworkDetailsViewController.h"
#import "CancelViewController.h"
#import "JobCheckViewController.h"
#import "JobTutorialViewController.h"
#import "ConnecttingViewController.h"
#import "NSDate+Extension.h"
#import "UserDetailsViewController.h"
#import "iCarousel.h"
#import "ZYCustomPageControl.h"
#import "SDPhotoBrowser.h"

@interface HomeworkDetailsViewController ()<iCarouselDelegate,iCarouselDataSource,SDPhotoBrowserDelegate>{
    UILabel     *orderTimeLab;
    UIImageView *headImageView;
    UILabel     *nameLabel;
    UILabel     *gradeLabel;
    UILabel     *priceTitleLabel;
    UILabel     *priceLabel;
    
    NSTimer      *myTimer;
}

@property (nonatomic, strong) UIButton     *rightItem;
@property (nonatomic, strong) UIView       *orderTimeView;
@property (nonatomic, strong) UIView       *studentInfoView;
@property (nonatomic ,strong) iCarousel    *photosCarousel;
@property (nonatomic, strong) UIView       *selectView;
@property (nonatomic ,strong) ZYCustomPageControl *pageControl;
@property (nonatomic, strong) UIButton     *handleButton;


@end

@implementation HomeworkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"作业详情";
    
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [self initHomeworkDetailsView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.photosCarousel scrollToItemAtIndex:0 animated:NO];
}

#pragma mark -- iCarouselDataSource
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.homeworkInfo.job_pic.count;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view==nil) {
        CGRect viewFrame;
        if (IS_IPAD) {
            viewFrame= CGRectMake(0, 0, kScreenWidth-328, kScreenHeight-kNavHeight-300);
        }else{
            if (isXDevice) {
                viewFrame = CGRectMake(0, 0, kScreenWidth-148, kScreenHeight-kNavHeight-333);
            }else{
                viewFrame= CGRectMake(0, 0,kScreenWidth-148, kScreenHeight-kNavHeight-263);
            }
        }
        view = [[UIView alloc] initWithFrame:viewFrame];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.tag = 1000+index;
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookOverFullImageAction:)];
        [imageView addGestureRecognizer:tap];
    }
    UIImageView *imageView = [view viewWithTag:1000+index];
    NSString *imgUrl = [self.homeworkInfo.job_pic objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"task_details_loading"]];
    
    return view;
}

#pragma mark -- iCarouselDelegate
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    MyLog(@"___1 %ld",carousel.currentItemIndex);
    UIView *view = carousel.currentItemView;
    self.selectView = view;
    self.pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    MyLog(@"___2 %ld",carousel.currentItemIndex);
    if (self.selectView != carousel.currentItemView) {
        self.selectView.backgroundColor = [UIColor clearColor];
        UIView *view = carousel.currentItemView;
        view.backgroundColor = [UIColor whiteColor];
        self.pageControl.currentPage = carousel.currentItemIndex;
    }
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset * self.photosCarousel.itemWidth * 1.4, 0.0, 0.0);
}


#pragma mark -- Delegate

#pragma mark - SDPhotoBrowserDelegate
#pragma mark 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    UIImageView *imageView = [self.selectView viewWithTag:index+1000];
    return imageView.image;
}

#pragma mark
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *imgUrl = self.homeworkInfo.job_pic[index];
    return [NSURL URLWithString:imgUrl];
}

#pragma mark -- Event Response
-(void)rightNavigationItemAction{
    CancelViewController *cancelVC = [[CancelViewController alloc] init];
    cancelVC.jobid = self.homeworkInfo.job_id;
    cancelVC.type = CancelTypeHomework;
    cancelVC.myTitle = @"取消辅导";
    [self.navigationController pushViewController:cancelVC animated:YES];
}
    

#pragma mark 处理订单
-(void)handleHomeworkAction:(UIButton *)sender{
    if ([ZYHelper sharedZYHelper].isCertified) {
        if ([self.homeworkInfo.label integerValue]>1) {
            if ([sender.currentTitle isEqualToString:@"去辅导"]) { //去辅导
                ConnecttingViewController *connectting = [[ConnecttingViewController alloc] initWithCallee:self.homeworkInfo.third_id];
                connectting.homework = self.homeworkInfo;
                [self.navigationController pushViewController:connectting animated:YES];
            }else{    //接单
                if ([self.homeworkInfo.label integerValue]==3) {
                    ConnecttingViewController *connectting = [[ConnecttingViewController alloc] initWithCallee:self.homeworkInfo.third_id];
                    connectting.homework = self.homeworkInfo;
                    connectting.isGuideNow = YES;
                    [self.navigationController pushViewController:connectting animated:YES];
                }else{
                    kSelfWeak;
                    NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,self.homeworkInfo.job_id];
                    [TCHttpRequest postMethodWithURL:kJobAcceptAPI body:body success:^(id json) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.view makeToast:@"接单成功" duration:1.0 position:CSToastPositionCenter];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }];
                }
            }
        }else{ //去检查
            kSelfWeak;
            NSString *body = [NSString stringWithFormat:@"token=%@&jobid=%@",kUserTokenValue,self.homeworkInfo.job_id];
            [TCHttpRequest postMethodWithURL:kJobCheckAPI body:body success:^(id json) {
                NSDictionary *data = [json objectForKey:@"data"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    JobCheckViewController *checkVC = [[JobCheckViewController alloc] init];
                    checkVC.jobId = weakSelf.homeworkInfo.job_id;
                    checkVC.jobPics = weakSelf.homeworkInfo.job_pic;
                    checkVC.orderId = [data valueForKey:@"oid"];
                    checkVC.label = weakSelf.homeworkInfo.label;
                    checkVC.third_id = weakSelf.homeworkInfo.third_id;
                    [weakSelf.navigationController pushViewController:checkVC animated:YES];
                });
            }];
        }
    }else{
        [self.view makeToast:@"请先完成实名认证和学历认证" duration:1.0 position:CSToastPositionCenter];
        kSelfWeak;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UserDetailsViewController *userDetaisVC = [[UserDetailsViewController alloc] init];
            userDetaisVC.isHomeworkIn = YES;
            [weakSelf pushTagetViewController:userDetaisVC];
        });
    }
}

#pragma mark 查看大图
-(void)lookOverFullImageAction:(UITapGestureRecognizer *)sender{
    NSInteger selectIndex = sender.view.tag-1000;
    MyLog(@"selectIndex:%ld",selectIndex);
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = selectIndex;
    photoBrowser.imageCount = self.homeworkInfo.job_pic.count;
    photoBrowser.sourceImagesContainerView = self.photosCarousel;
    [photoBrowser show];
}

#pragma mark -- private Methods
#pragma mark 初始化界面
-(void)initHomeworkDetailsView{
    if ([self.homeworkInfo.label integerValue]==2&&[self.homeworkInfo.is_receive integerValue] == 2) {
        self.rigthTitleName = @"取消";
    }else{
        self.rigthTitleName = @"";
    }
    
    [self.view addSubview:self.orderTimeView];
    if ([self.homeworkInfo.label integerValue]==2) {
        self.orderTimeView.hidden = NO;
        self.orderTimeView.frame = IS_IPAD?CGRectMake(0, kNavHeight+20, kScreenWidth, 50):CGRectMake(0,kNavHeight+10, kScreenWidth, 30);
        NSString *orderTimeStr = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:self.homeworkInfo.start_time format:@"MM/dd HH:mm"];
        orderTimeLab.text = [NSString stringWithFormat:@"辅导时间-%@",orderTimeStr];
    }else{
        self.orderTimeView.hidden = YES;
        self.orderTimeView.frame = CGRectMake(0,kNavHeight+20, kScreenWidth, 0);
    }
    [self.view addSubview:self.studentInfoView];
    [self.view addSubview:self.photosCarousel];
    [self.view addSubview:self.pageControl];
    self.pageControl.hidden = self.homeworkInfo.job_pic.count<2;
    [self.view addSubview:self.handleButton];
}


#pragma mark -- Getters and Setters
/*
#pragma mark 导航栏右按钮
-(UIButton *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-60, KStatusHeight+9, 50, 50):CGRectMake(kScreenWidth-50, KStatusHeight+2, 40, 40)];
        [_rightItem setImage:[UIImage drawImageWithName:@"more" size:CGSizeMake(30, 9)] forState:UIControlStateNormal];
        [_rightItem addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}
 */

#pragma mark 辅导时间
-(UIView *)orderTimeView{
    if (!_orderTimeView) {
        _orderTimeView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(0, kNavHeight+20, kScreenWidth, 50):CGRectMake(0,kNavHeight+10, kScreenWidth, 30)];
        
        UILabel *badgeLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(0, 3, 6, 24):CGRectMake(0, 2, 4, 16)];
        badgeLab.backgroundColor = [UIColor colorWithHexString:@"#FF6161"];
        [_orderTimeView addSubview:badgeLab];
        
        orderTimeLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(badgeLab.right+18, 0, 280, 30):CGRectMake(badgeLab.right+12, 0, 200, 20)];
        orderTimeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        orderTimeLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [_orderTimeView addSubview:orderTimeLab];
    }
    return _orderTimeView;
}

#pragma mark 学生信息
-(UIView *)studentInfoView{
    if (!_studentInfoView) {
        _studentInfoView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(20, self.orderTimeView.bottom, kScreenWidth-40, 122):CGRectMake(10,self.orderTimeView.bottom, kScreenWidth-20, 80)];
        [_studentInfoView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:4.0];
        _studentInfoView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(40, 16, 88, 88):CGRectMake(16, 11, 58, 58)];
        bgHeadImageView.backgroundColor = [UIColor colorWithHexString:@"#FFE0D3"];
        [bgHeadImageView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:IS_IPAD?44:29.0];
        [_studentInfoView addSubview:bgHeadImageView];
        
        //头像
        headImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(44, 20, 80, 80): CGRectMake(19, 14, 52, 52)];
        headImageView.boderRadius = IS_IPAD?40:26.0;
        if (kIsEmptyString(self.homeworkInfo.trait)) {
            headImageView.image = [UIImage imageNamed:IS_IPAD?@"default_head_image_ipad":@"default_head_image"];
        }else{
            [headImageView sd_setImageWithURL:[NSURL URLWithString:self.homeworkInfo.trait] placeholderImage:[UIImage imageNamed:IS_IPAD?@"default_head_image_ipad":@"default_head_image"]];
        }
        [_studentInfoView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(headImageView.right+24, 28, 180, 36):CGRectMake(headImageView.right+16.0, 19.0,80, 22)];
        nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:16];
        nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        nameLabel.text = self.homeworkInfo.username;
        [_studentInfoView addSubview:nameLabel];
        
        gradeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(headImageView.right+26, nameLabel.bottom, 120, 30):CGRectMake(headImageView.right+17, nameLabel.bottom+3.0, 80, 20)];
        gradeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        gradeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        gradeLabel.text = self.homeworkInfo.grade;
        [_studentInfoView addSubview:gradeLabel];
        
        UIImageView  *tipsImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-191, 31, 24, 24):CGRectMake(kScreenWidth-111, 21, 15, 15)];
        tipsImageView.image = [UIImage imageNamed:IS_IPAD?@"price_gray_ipad":@"price_gray"];
        [_studentInfoView addSubview:tipsImageView];
        
        priceTitleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(tipsImageView.right+11, 28, 100, 30):CGRectMake(tipsImageView.right+4,20.0, 52, 18.0)];
        priceTitleLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        priceTitleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:13];
        priceTitleLabel.text = [self.homeworkInfo.label integerValue]>1?@"辅导价格":@"检查价格";
        [_studentInfoView addSubview:priceTitleLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-260, priceTitleLabel.bottom,200, 36):CGRectMake(kScreenWidth-141, priceTitleLabel.bottom+3.0,101.0, 22.0)];
        priceLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
        priceLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:16];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = [self.homeworkInfo.label integerValue]>1?[NSString stringWithFormat:@"%.2f元/分钟",[self.homeworkInfo.price doubleValue]]:[NSString stringWithFormat:@"%.2f元",[self.homeworkInfo.price doubleValue]];
        [_studentInfoView addSubview:priceLabel];
    }
    return _studentInfoView;
}

#pragma mark 滚动图片
-(iCarousel *)photosCarousel{
    if (!_photosCarousel) {
        CGSize aSize = [[UIScreen mainScreen] currentMode].size;
        MyLog(@"w:%.f,h:%.f",aSize.width,aSize.height);
        CGFloat tempHeight;
        if (IS_IPAD) {
            tempHeight = kScreenHeight-self.studentInfoView.bottom-124;
        }else{
            if (isXDevice) {
                tempHeight =[self.homeworkInfo.label integerValue]==2?kScreenHeight-self.studentInfoView.bottom-154:kScreenHeight-self.studentInfoView.bottom-184;
            }else{
               tempHeight = [self.homeworkInfo.label integerValue]==2?kScreenHeight-self.studentInfoView.bottom-84:kScreenHeight-self.studentInfoView.bottom-114;
            }
        }
        
        _photosCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, self.studentInfoView.bottom+20, kScreenWidth, tempHeight)];
        _photosCarousel.delegate = self;
        _photosCarousel.dataSource = self;
        _photosCarousel.pagingEnabled = NO;
        _photosCarousel.bounces = NO;
        _photosCarousel.type = iCarouselTypeCustom;
    }
    return _photosCarousel;
}

#pragma mark
-(ZYCustomPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[ZYCustomPageControl alloc] initWithFrame:CGRectMake(0, self.photosCarousel.bottom-10, kScreenWidth, 5)];
        _pageControl.numberOfPages = self.homeworkInfo.job_pic.count;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.inactiveImage = [UIImage imageNamed:@"Oval"];
        _pageControl.inactiveImageSize = CGSizeMake(5.0, 5.0);
        _pageControl.currentImage = [UIImage imageNamed:@"Rectangle"];
        _pageControl.currentImageSize = CGSizeMake(10, 5);
        _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor clearColor];
    }
    return _pageControl;
}

#pragma mark 检查或接单
-(UIButton *)handleButton{
    if (!_handleButton) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,kScreenHeight-85,515, 75):CGRectMake(48, kScreenHeight-65,kScreenWidth-96, 50);
        CGFloat fontSize = IS_IPAD?24:16;
        _handleButton = [[UIButton alloc] initWithFrame:btnFrame];
        [_handleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _handleButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize];
         if ([self.homeworkInfo.label integerValue]==1) {
             _handleButton.tag = 0;
             _handleButton.enabled = YES;
             [_handleButton setTitle:@"去检查" forState:UIControlStateNormal];
             [_handleButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
         }else{
             if ([self.homeworkInfo.is_receive integerValue]==1) {
                 _handleButton.tag = 1;
                 _handleButton.enabled = YES;
                 [_handleButton setTitle:@"接单" forState:UIControlStateNormal];
                 [_handleButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
             }else{
                 NSNumber *currentTime =[[ZYHelper sharedZYHelper] timeSwitchTimestamp:[NSDate currentFullDate] format:@"yyyy年MM月dd日 HH:mm:ss"];
                 MyLog(@"startTime:%ld,currentTime:%ld",[self.homeworkInfo.start_time integerValue],[currentTime integerValue]);
                 if ([self.homeworkInfo.start_time integerValue]>[currentTime integerValue]) {
                     _handleButton.tag = 3;
                     _handleButton.enabled = NO;
                     NSString *startDateStr = [NSDate currentFullDate];
                     NSString *endDateStr = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:self.homeworkInfo.start_time format:@"yyyy年MM月dd日 HH:mm:ss"];
                     NSString *str = [[ZYHelper sharedZYHelper] pleaseInsertStarTimeo:startDateStr andInsertEndTime:endDateStr];
                     [_handleButton setTitle:[NSString stringWithFormat:@"距离辅导开始还有%@",str] forState:UIControlStateNormal];
                     [_handleButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"button_gray_ipad"]:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
                 }else{
                     _handleButton.tag = 2;
                     _handleButton.enabled = YES;
                     [_handleButton setTitle:@"去辅导" forState:UIControlStateNormal];
                     [_handleButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"button_blue_ipad"]:[UIImage imageNamed:@"button_blue"] forState:UIControlStateNormal];
                 }
             }
         }
        [_handleButton addTarget:self action:@selector(handleHomeworkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handleButton;
}


-(void)dealloc{
    self.photosCarousel.delegate = nil;
    self.photosCarousel.dataSource = nil;
}

@end
