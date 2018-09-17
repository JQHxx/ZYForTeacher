//
//  RequestConnectionViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "RequestConnectionViewController.h"

@interface RequestConnectionViewController ()<UIScrollViewDelegate>{
    UIScrollView     *imagesScrollView;
    UIPageControl    *pageControl;
    UILabel          *priceLabel;
    UIImageView      *headImageView;
    UILabel          *nameLabel;
    UILabel          *gradeLabel;
    
    
}





@end

@implementation RequestConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self initRequestConnectionView];
    [self requestTutorialData];
}



#pragma mark -- Delegate
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index =scrollView.contentOffset.x/scrollView.frame.size.width+0.5;
    pageControl.currentPage = index;
}

#pragma mark -- Private Methods
#pragma mark 加载数据
-(void)requestTutorialData{
    
}

#pragma mark 初始化
-(void)initRequestConnectionView{
    imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, KStatusHeight+20, kScreenWidth-60, (kScreenWidth-60)*1.12)];
    imagesScrollView.showsHorizontalScrollIndicator = NO;
    imagesScrollView.pagingEnabled = YES;
    imagesScrollView.delegate = self;
    [self.view addSubview:imagesScrollView];
    
    NSArray *tempArr = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    for (NSInteger i=0; i<tempArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(kScreenWidth-60), 0, (kScreenWidth-60), (kScreenWidth-60)*1.12)];
        imgView.image = [UIImage imageNamed:tempArr[i]];
        [imagesScrollView addSubview:imgView];
    }
    imagesScrollView.contentSize = CGSizeMake((kScreenWidth-60)*tempArr.count, (kScreenWidth-60)*1.12);
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(90, (kScreenWidth-60)*1.12,kScreenWidth-180, 30)];
    pageControl.numberOfPages = tempArr.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.hidesForSinglePage = YES;
    [self.view addSubview:pageControl];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, imagesScrollView.bottom+10, kScreenWidth-60, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = @"作业辅导";
    titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, titleLabel.bottom, kScreenWidth-80, 20)];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = kFontWithSize(14);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.text = [NSString stringWithFormat:@"%.2f元/分钟",1.0];
    [self.view addSubview:priceLabel];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-50, priceLabel.bottom+10, 40, 40)];
    headImageView.image = [UIImage imageNamed:@"ic_m_head"];
    [self.view addSubview:headImageView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+10, priceLabel.bottom+10, 80, 20)];
    nameLabel.font = kFontWithSize(14);
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = @"小明";
    [self.view addSubview:nameLabel];
    
    gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+10, nameLabel.bottom, 80, 20)];
    gradeLabel.font = kFontWithSize(13);
    gradeLabel.textColor = [UIColor lightGrayColor];
    gradeLabel.text = @"一年级/数学";
    [self.view addSubview:gradeLabel];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, headImageView.bottom+20, kScreenWidth-60, 30)];
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.font = kFontWithSize(14);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"正在请求与您连线.....";
    [self.view addSubview:tipsLabel];
    
    UIButton *refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-100, tipsLabel.bottom+20, 70, 70)];
    [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    refuseButton.backgroundColor = [UIColor lightGrayColor];
    refuseButton.titleLabel.font = kFontWithSize(14);
    refuseButton.layer.cornerRadius =35;
    [self.view addSubview:refuseButton];
    
    UIButton *exceptButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0+30, tipsLabel.bottom+20, 70, 70)];
    [exceptButton setTitle:@"接受" forState:UIControlStateNormal];
    [exceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exceptButton.backgroundColor = kSystemColor;
    exceptButton.titleLabel.font = kFontWithSize(14);
    exceptButton.layer.cornerRadius = 35;
    [self.view addSubview:exceptButton];
}



@end
