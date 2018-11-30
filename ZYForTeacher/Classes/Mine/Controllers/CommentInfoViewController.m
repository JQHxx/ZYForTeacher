//
//  CommentInfoViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CommentInfoViewController.h"

@interface CommentInfoViewController ()

@end

@implementation CommentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"评论";
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [self initComplainInfoView];
    
}

#pragma mark -- Private methods
#pragma mark 初始化界面
-(void)initComplainInfoView{
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectZero];
    rootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rootView];
    
    NSArray *titlesArr = @[@"评分",@"评论"];
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18, 10+50*i, 60, 30)];
        lab.text = titlesArr[i];
        lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:14];
        [rootView addSubview:lab];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, kScreenWidth-13, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [rootView addSubview:line];
    
    
    //加星级
    CGSize scoreSize = CGSizeMake(13, 13);
    double scoreNum = [self.myComment.score doubleValue];
    NSInteger oneScroe=(NSInteger)scoreNum;
    NSInteger num=scoreNum>oneScroe?oneScroe+1:oneScroe;
    for (int i = 0; i<5; i++) {
        UIImageView *scoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score"]];
        [scoreImage setFrame:CGRectMake(60+(scoreSize.width+4.0)*i,18.0, scoreSize.width, scoreSize.height)];
        if (i<= num-1) {
            if ((i==num-1)&&scoreNum>oneScroe) {
                scoreImage.image=[UIImage imageNamed:@"score_half"];
            }
        }else{
            scoreImage.image=[UIImage imageNamed:@"score_gray"];
        }
        [rootView addSubview:scoreImage];
    }
    
    UILabel *commentValueLab = [[UILabel alloc] initWithFrame:CGRectZero];
    commentValueLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
    commentValueLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    commentValueLab.numberOfLines = 0;
    commentValueLab.text = self.myComment.comment;
    CGFloat valueHeight = [self.myComment.comment boundingRectWithSize:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX) withTextFont:commentValueLab.font].height;
    commentValueLab.frame = CGRectMake(60, 65, kScreenWidth-100, valueHeight);
    [rootView addSubview:commentValueLab];
    
    rootView.frame =CGRectMake(0, kNavHeight+10,kScreenWidth, valueHeight+30+50);
}


@end
