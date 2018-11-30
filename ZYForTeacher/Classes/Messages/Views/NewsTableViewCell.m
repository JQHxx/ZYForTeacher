//
//  NewsTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/7/10.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell (){
    UILabel       *timeLab;
    UIView        *rootView;
    UILabel       *titleLab;
    UIImageView   *coverImgView;
    UILabel       *descLab;
    
}

@end

@implementation NewsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor bgColor_Gray];
        
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2.0, 9, 80, 22)];
        timeLab.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.boderRadius = 4.0;
        [self.contentView addSubview:timeLab];
        
        rootView = [[UIView alloc] initWithFrame:CGRectZero];
        rootView.backgroundColor = [UIColor whiteColor];
        rootView.layer.cornerRadius =4.0;
        rootView.layer.borderWidth = 0.5;
        rootView.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8"].CGColor;
        [self.contentView addSubview:rootView];
        
        titleLab=[[UILabel alloc] initWithFrame:CGRectMake(25, 50, kScreenWidth-50, 20)];
        titleLab.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        titleLab.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        [self.contentView addSubview:titleLab];
        
        coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, titleLab.bottom+10, kScreenWidth-50, (kScreenWidth-50)*(3.0/13.0))];
        [self.contentView addSubview:coverImgView];
        
        descLab=[[UILabel alloc] initWithFrame:CGRectZero];
        descLab.textColor=[UIColor colorWithHexString:@"#9B9B9B"];
        descLab.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        descLab.numberOfLines = 0;
        [self.contentView addSubview:descLab];
        
    }
    return self;
}

-(void)setModel:(MessageModel *)model{
    timeLab.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:model.create_time format:@"MM/dd HH:mm"];
    titleLab.text = model.title;
    if (!kIsEmptyString(model.cover)) {
        [coverImgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        coverImgView.image = [UIImage imageNamed:@""];
    }
    descLab.text = model.desc;
    CGFloat descH = [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:descLab.font].height;
    descLab.frame = CGRectMake(25, coverImgView.bottom+10, kScreenWidth-50, descH);
    
    rootView.frame = CGRectMake(12.5, timeLab.bottom+10, kScreenWidth-25, descH+(kScreenWidth-50)*(3.0/13.0)+60);
}


+(CGFloat)getCellHeightWithNews:(MessageModel *)model{
    CGFloat descH = [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12]].height;
    return descH+(kScreenWidth-50)*(3.0/13.0)+100;
}


@end
