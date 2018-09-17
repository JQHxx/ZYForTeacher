//
//  TutoringEndViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TutoringEndViewController.h"
#import "XHStarRateView.h"

@interface TutoringEndViewController (){
    UILabel       *timeLab;
    UILabel       *priceLab;
    UILabel       *commentLab;
    UIScrollView  *commentView;
    
}

@end

@implementation TutoringEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"辅导结束";
    self.isHiddenBackBtn = YES;
    self.rigthTitleName = @"完成";
    
    [self initTutoringEndView];
    [self loadTutoringEndData];
}

-(void)rightNavigationItemAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -- Private methods
#pragma mark 加载数据
-(void)loadTutoringEndData{
    timeLab.text = [NSString stringWithFormat:@"辅导时长：%02ld分%02ld秒",(long)8,(long)25];
    NSString *priceStr = [NSString stringWithFormat:@"付款金额：%.2f元",12.2];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, priceStr.length-6)];
    priceLab.attributedText = attributedStr;
    
    commentLab.text = @"非常感谢小美老师的辅导，基本解决了我的作业问题非常感谢小美老师的辅导，基本解决了我的作业问题非常感谢小美老师的辅导，基本解决了我的作业问题非常感谢小美老师的辅导，基本解决了我的作业问题非常感谢小美老师的辅导，基本解决了我的作业问题.";
    CGFloat commentH = [commentLab.text boundingRectWithSize:CGSizeMake(kScreenWidth-85, CGFLOAT_MAX) withTextFont:commentLab.font].height;
    commentLab.frame = CGRectMake(65, 100, kScreenWidth-85, commentH);
    
    commentView.contentSize = CGSizeMake(kScreenWidth, 80+commentH+10);
}

#pragma mark 初始化
-(void)initTutoringEndView{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, kNavHeight+30, 80, 80)];
    imgView.backgroundColor = [UIColor lightGrayColor];
    imgView.layer.cornerRadius = 40;
    imgView.clipsToBounds = YES;
    [self.view addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, imgView.bottom+10, kScreenWidth-60, 30)];
    lab.text = @"本次辅导结束";
    lab.font = kFontWithSize(14);
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(30, lab.bottom+20, kScreenWidth-60, 25)];
    timeLab.font = kFontWithSize(14);
    timeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLab];
    
    priceLab = [[UILabel alloc] initWithFrame:CGRectMake(30, timeLab.bottom, kScreenWidth-60, 25)];
    priceLab.font = kFontWithSize(14);
    priceLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:priceLab];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLab.bottom+30, kScreenWidth-20, 0.5)];
    lineLab.backgroundColor = kLineColor;
    [self.view addSubview:lineLab];
    
    commentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lineLab.bottom, kScreenWidth, kScreenHeight-lineLab.bottom)];
    [self.view addSubview:commentView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,kScreenWidth-30, 30)];
    titleLab.text = @"学生对您的评价如下：";
    titleLab.font = kFontWithSize(16);
    titleLab.textColor = [UIColor blackColor];
    [commentView addSubview:titleLab];
    
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(25, titleLab.bottom+10, 40, 30)];
    scoreLab.text = @"评分";
    scoreLab.font = kFontWithSize(14);
    scoreLab.textColor = [UIColor blackColor];
    [commentView addSubview:scoreLab];
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(titleLab.right, 10, 200, 30)];
    starRateView.isAnimation = NO;
    starRateView.rateStyle = HalfStar;
    [commentView addSubview:starRateView];
    
    UILabel *commentTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, scoreLab.bottom+10, 40, 30)];
    commentTitleLab.text = @"评语";
    commentTitleLab.font = kFontWithSize(14);
    commentTitleLab.textColor = [UIColor blackColor];
    [commentView addSubview:commentTitleLab];
    
    commentLab = [[UILabel alloc] init];
    commentLab.font = kFontWithSize(14);
    commentLab.textColor = [UIColor blackColor];
    commentLab.numberOfLines = 0;
    [commentView addSubview:commentLab];
    
    
}




@end
