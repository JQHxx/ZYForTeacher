//
//  ComplainInfoViewController.m
//  ZuoYe
//
//  Created by vision on 2018/10/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ComplainInfoViewController.h"

@interface ComplainInfoViewController (){
    UILabel  *typeLabel;
    UILabel  *complainValueLab;
}

@end

@implementation ComplainInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"投诉";
    
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    [self initComplainInfoView];
}

#pragma mark -- Private methods
#pragma mark 初始化界面
-(void)initComplainInfoView{
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectZero];
    rootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rootView];
    
    NSArray *titlesArr = @[@"投诉类型",@"投诉内容"];
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
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, kScreenWidth-100, 30)];
    typeLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    typeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
    NSString *typeStr = nil;
    if ([self.myComplain.label integerValue]==1) {
        typeStr = @"对订单有疑问";
    }else if ([self.myComplain.label integerValue]==2){
        typeStr = @"对老师有疑问";
    }else{
        typeStr = @"其他";
    }
    typeLabel.text = typeStr;
    [rootView addSubview:typeLabel];
    
    complainValueLab = [[UILabel alloc] initWithFrame:CGRectZero];
    complainValueLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
    complainValueLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    complainValueLab.text = self.myComplain.complain;
    complainValueLab.numberOfLines = 0;
    CGFloat valueHeight = [self.myComplain.complain boundingRectWithSize:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX) withTextFont:complainValueLab.font].height;
    complainValueLab.frame = CGRectMake(90, 65, kScreenWidth-100, valueHeight);
    [rootView addSubview:complainValueLab];
    
    rootView.frame =CGRectMake(0, kNavHeight+10,kScreenWidth, valueHeight+30+50);
}




@end
