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
    
    NSArray *titlesArr = @[@"评    分",@"评    论"];
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 23+(30+50)*i, 90, 30):CGRectMake(18, 10+50*i, 60, 30)];
        lab.text = titlesArr[i];
        lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:IS_IPAD?22:14];
        [rootView addSubview:lab];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40,76, kScreenWidth-80, 0.5):CGRectMake(12, 50, kScreenWidth-13, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [rootView addSubview:line];
    
    //加星级
    CGSize scoreSize = IS_IPAD?CGSizeMake(20, 20):CGSizeMake(13, 13);
    double scoreNum = [self.myComment.score doubleValue];
    NSInteger oneScroe=(NSInteger)scoreNum;
    NSInteger num=scoreNum>oneScroe?oneScroe+1:oneScroe;
    for (int i = 0; i<5; i++) {
        UIImageView *scoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score"]];
        [scoreImage setFrame:IS_IPAD?CGRectMake(162+(scoreSize.width+7)*i, 29, scoreSize.width, scoreSize.height):CGRectMake(60+(scoreSize.width+4.0)*i,18.0, scoreSize.width, scoreSize.height)];
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
    commentValueLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
    commentValueLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    commentValueLab.numberOfLines = 0;
    commentValueLab.text = self.myComment.comment;
    CGFloat valueHeight = [self.myComment.comment boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-220, CGFLOAT_MAX):CGSizeMake(kScreenWidth-100, CGFLOAT_MAX) withTextFont:commentValueLab.font].height;
    commentValueLab.frame = IS_IPAD?CGRectMake(159, 102, kScreenWidth-220, valueHeight):CGRectMake(60, 65, kScreenWidth-100, valueHeight);
    [rootView addSubview:commentValueLab];
    
    rootView.frame = IS_IPAD?CGRectMake(0, kNavHeight+15, kScreenWidth, valueHeight+126):CGRectMake(0, kNavHeight+10,kScreenWidth, valueHeight+30+50);
}


@end
