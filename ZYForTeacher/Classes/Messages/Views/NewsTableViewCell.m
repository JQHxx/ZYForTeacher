//
//  NewsTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/7/10.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell (){
    UILabel       *titleLab;
    UILabel       *timeLab;
    UILabel       *badgeLab;
    
}

@end

@implementation NewsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLab=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLab.numberOfLines=0;
        titleLab.textColor=[UIColor blackColor];
        titleLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:titleLab];
        
        timeLab=[[UILabel alloc] initWithFrame:CGRectZero];
        timeLab.textColor=[UIColor lightGrayColor];
        timeLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeLab];
        
        badgeLab=[[UILabel alloc] initWithFrame:CGRectZero];
        badgeLab.layer.cornerRadius=3;
        badgeLab.clipsToBounds=YES;
        badgeLab.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:badgeLab];
        
        
    }
    return self;
}

-(void)setModel:(SystemNewsModel *)model{
    titleLab.text = model.title;
    CGFloat titleH = [model.title boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) withTextFont:titleLab.font].height;
    titleLab.frame = CGRectMake(10, 5, kScreenWidth-20, titleH+5);
    
    timeLab.text = model.send_time;
    timeLab.frame = CGRectMake(10, titleLab.bottom, kScreenWidth-20, 20);
    
    CGFloat cellH = titleH+30;
    badgeLab.frame = CGRectMake(kScreenWidth-15,(cellH-10)/2, 6, 6);
    badgeLab.hidden = model.isRead;
}


+(CGFloat)getCellHeightWithNews:(SystemNewsModel *)model{
    CGFloat titleH=[model.title boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) withTextFont:[UIFont systemFontOfSize:14]].height;
    return titleH+35;
}


@end
