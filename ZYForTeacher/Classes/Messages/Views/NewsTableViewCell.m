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
        
        timeLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake((kScreenWidth-100)/2.0, 45, 100, 34):CGRectMake((kScreenWidth-80)/2.0, 9, 80, 22)];
        timeLab.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?18:12];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.boderRadius = IS_IPAD?6.0:4.0;
        [self.contentView addSubview:timeLab];
        
        rootView = [[UIView alloc] initWithFrame:CGRectZero];
        rootView.backgroundColor = [UIColor whiteColor];
        rootView.layer.cornerRadius = IS_IPAD?6.0:4.0;
        rootView.layer.borderWidth = 0.5;
        rootView.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8"].CGColor;
        [self.contentView addSubview:rootView];
        
        titleLab=[[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 109, kScreenWidth-80, 30):CGRectMake(25, 50, kScreenWidth-50, 20)];
        titleLab.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        titleLab.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [self.contentView addSubview:titleLab];
        
        coverImgView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(40, titleLab.bottom+16, kScreenWidth-80, (kScreenWidth-80)*(157.0/680.0)):CGRectMake(25, titleLab.bottom+10, kScreenWidth-50, (kScreenWidth-50)*(3.0/13.0))];
        [self.contentView addSubview:coverImgView];
        
        descLab=[[UILabel alloc] initWithFrame:CGRectZero];
        descLab.textColor=[UIColor colorWithHexString:@"#9B9B9B"];
        descLab.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?18:12];
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
    CGFloat descH = [model.desc boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-80, CGFLOAT_MAX):CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:descLab.font].height;
    descLab.frame = IS_IPAD?CGRectMake(40, coverImgView.bottom+22, kScreenWidth-80, descH):CGRectMake(25, coverImgView.bottom+10, kScreenWidth-50, descH);
    
    rootView.frame = IS_IPAD?CGRectMake(22, timeLab.bottom+15, kScreenWidth-44, descH+(kScreenWidth-80)*(157.0/680.0)+80):CGRectMake(12.5, timeLab.bottom+10, kScreenWidth-25, descH+(kScreenWidth-50)*(3.0/13.0)+60);
}


+(CGFloat)getCellHeightWithNews:(MessageModel *)model{
    CGFloat descH = [model.desc boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-80, CGFLOAT_MAX):CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?18: 12]].height;
    return IS_IPAD?descH+(kScreenWidth-80)*(157.0/680.0)+174:descH+(kScreenWidth-50)*(3.0/13.0)+100;
}


@end
