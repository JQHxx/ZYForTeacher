//
//  MyConnecttingViewController.m
//  ZuoYe
//
//  Created by vision on 2018/9/17.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MyConnecttingViewController.h"
#import "SDPhotoBrowser.h"

#define kBtnCapW (kScreenWidth-140-85)/2.0

@interface MyConnecttingViewController ()<UIScrollViewDelegate,SDPhotoBrowserDelegate>{
    NSInteger   allNum;
    UILabel     *countLab;
    NSInteger   currentIndex;
}

@property (nonatomic ,strong) UIScrollView  *homeworkScrollView;
@property (nonatomic ,strong) UIView        *rootView;
@property (nonatomic ,strong) UIImageView   *headImageView;     //头像
@property (nonatomic ,strong) UILabel       *nameLabel;         //姓名
@property (nonatomic ,strong) UILabel       *gradeLabel;        //年级/科目
@property (nonatomic ,strong) UILabel       *priceLabel;        //辅导价格
@property (nonatomic, strong) UILabel       *connecttingLabel;   //正在请求连线
@property (nonatomic, strong) UIButton      *refuseButton;   //拒绝
@property (nonatomic, strong) UIButton       *acceptButton;   //接受

@end

@implementation MyConnecttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    currentIndex = 0;
    
    [self initConnecttingView];
    [self loadMyConnecttingView];
}

#pragma mark -- Delegate
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    currentIndex = scrollView.contentOffset.x/kScreenWidth;
    countLab.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,allNum];
}

#pragma mark 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - SDPhotoBrowserDelegate
#pragma mark 返回临时占位图片
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return [UIImage imageNamed:@"task_details_loading"];
}

#pragma mark
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *imgUrl = self.homework.job_pic[index];
    return [NSURL URLWithString:imgUrl];
}

#pragma mark -- Event Response
#pragma mark 取消
-(void)refuseConnecttingAction{
    [self responseFromCallWithAccept:NO];
}

#pragma mark 接受
-(void)acceptConnecttingAction{
    [self responseFromCallWithAccept:YES];
}

#pragma mark 查看所有图片
-(void)viewFullPhotosAction{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = currentIndex;
    photoBrowser.imageCount = self.homework.job_pic.count;
    photoBrowser.sourceImagesContainerView = self.homeworkScrollView;
    [photoBrowser show];
}

#pragma mark -- Private Methods
#pragma mark 初始化
- (void)initConnecttingView{
    [self.view addSubview:self.homeworkScrollView];
    
    countLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50, 30, 34, 22)];
    countLab.textAlignment = NSTextAlignmentRight;
    countLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    countLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    [self.view addSubview:countLab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, KStatusHeight+185, 32, 32)];
    [btn setImage:[UIImage imageNamed:@"view_photos_gray"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(viewFullPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.rootView];
    
    UIImageView *bgHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2.0,kScreenHeight-420-60,120,120)];
    bgHeadImageView.image = [UIImage imageNamed:@"connection_head_image_white"];
    [self.view addSubview:bgHeadImageView];
    [self.view addSubview:self.headImageView];
    
    [self.rootView addSubview:self.nameLabel];
    [self.rootView addSubview:self.gradeLabel];
    [self.rootView addSubview:self.priceLabel];
    
    UIView *line2= [[UIView alloc] initWithFrame:CGRectMake(26,self.priceLabel.bottom+32,kScreenWidth-51, 0.5)];
    line2.backgroundColor  = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.rootView addSubview:line2];
    
    [self.rootView addSubview:self.connecttingLabel];
    [self.rootView addSubview:self.refuseButton];
    [self.rootView addSubview:self.acceptButton];
    
}

#pragma mark 加载数据
-(void)loadMyConnecttingView{
    allNum = self.homework.job_pic.count;
    for (NSInteger i=0; i<allNum; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        imgView.tag = i;
        NSString *imgUrlStr = self.homework.job_pic[i];
        if (kIsEmptyString(imgUrlStr)) {
            imgView.image = [UIImage imageNamed:@"task_details_loading"];
        }else{
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"task_details_loading"]];
        }
        [self.homeworkScrollView addSubview:imgView];
    }
    self.homeworkScrollView.contentSize = CGSizeMake(kScreenWidth*allNum, kScreenHeight);
    countLab.text = [NSString stringWithFormat:@"1/%ld",allNum];
    

    if (kIsEmptyString(self.homework.trait)) {
        _headImageView.image = [UIImage imageNamed:@"default_head_image"];
    }else{
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.homework.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
    }
    
    _nameLabel.text = self.homework.username;
    _gradeLabel.text = [NSString stringWithFormat:@"%@/%@",self.homework.grade,self.homework.subject];
    _priceLabel.text = [NSString stringWithFormat:@"作业辅导 %.2f元/分钟",[self.homework.price doubleValue]];
}

#pragma mark -- gettters and setters
#pragma mark 作业图片
-(UIScrollView *)homeworkScrollView{
    if (!_homeworkScrollView) {
        _homeworkScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _homeworkScrollView.showsHorizontalScrollIndicator = NO;
        _homeworkScrollView.delegate = self;
        _homeworkScrollView.pagingEnabled = YES;
        _homeworkScrollView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _homeworkScrollView;
}

#pragma mark
-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-420, kScreenWidth, 420)];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:8.0];
    }
    return _rootView;
}

#pragma mark 头像
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 110)/2.0,kScreenHeight-420-55, 110, 110)];
        _headImageView.boderRadius = 55.0;
    }
    return _headImageView;
}

#pragma mark 姓名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,70, kScreenWidth-80, 25)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }
    return _nameLabel;
}

#pragma mark 年级/科目
-(UILabel *)gradeLabel{
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.nameLabel.bottom,kScreenWidth-80, 25)];
        _gradeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        _gradeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _gradeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _gradeLabel;
}

#pragma mark 辅导价格
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.gradeLabel.bottom+4, kScreenWidth-80, 20)];
        _priceLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:14];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

#pragma mark 连线
-(UILabel *)connecttingLabel{
    if (!_connecttingLabel) {
        _connecttingLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.priceLabel.bottom+66, kScreenWidth-120, 20)];
        _connecttingLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        _connecttingLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _connecttingLabel.text = @"对方正在请求与你连线...";
        _connecttingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _connecttingLabel;
}

#pragma mark 拒绝
-(UIButton *)refuseButton{
    if (!_refuseButton) {
        _refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(kBtnCapW, self.connecttingLabel.bottom+39, 69, 100)];
        [_refuseButton setImage:[UIImage imageNamed:@"connection_cancel"] forState:UIControlStateNormal];
        [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseButton setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _refuseButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:16];
        _refuseButton.imageEdgeInsets = UIEdgeInsetsMake(-(_refuseButton.height - _refuseButton.titleLabel.height- _refuseButton.titleLabel.frame.origin.y-9),0, 0, 0);
        _refuseButton.titleEdgeInsets = UIEdgeInsetsMake(_refuseButton.imageView.height+_refuseButton.imageView.frame.origin.y, -_refuseButton.imageView.width, 0, 0);
        [_refuseButton addTarget:self action:@selector(refuseConnecttingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseButton;
}

#pragma mark 接受
-(UIButton *)acceptButton{
    if (!_acceptButton) {
        _acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kBtnCapW-69, self.connecttingLabel.bottom+39, 69, 100)];
        [_acceptButton setImage:[UIImage imageNamed:@"connection_accept"] forState:UIControlStateNormal];
        [_acceptButton setTitle:@"接受" forState:UIControlStateNormal];
        [_acceptButton setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _acceptButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:16];
        _acceptButton.imageEdgeInsets = UIEdgeInsetsMake(-(_acceptButton.height - _acceptButton.titleLabel.height- _acceptButton.titleLabel.frame.origin.y-9),0, 0, 0);
        _acceptButton.titleEdgeInsets = UIEdgeInsetsMake(_acceptButton.imageView.height+_acceptButton.imageView.frame.origin.y, -_acceptButton.imageView.width, 0, 0);
        [_acceptButton addTarget:self action:@selector(acceptConnecttingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptButton;
}

@end
