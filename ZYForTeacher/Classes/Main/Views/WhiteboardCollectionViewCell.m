//
//  WhiteboardCollectionViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardCollectionViewCell.h"

@interface WhiteboardCollectionViewCell (){
    UIImageView  *imgView;
    UILabel      *lab;
}

@end

@implementation WhiteboardCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,13, 74, 74)];
        [self.contentView addSubview:imgView];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(10, imgView.bottom+5, 75, 18)];
        lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:13];
        lab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lab];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.right-10, 3, 20, 20)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"coach_whiteboard_delete"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteBtn];
        
    }
    return self;
}

#pragma mark 设置图片
-(void)setContentImage:(UIImage *)contentImage{
    imgView.image = contentImage;
}

#pragma mark 设置标题
-(void)setTitleStr:(NSString *)titleStr{
    lab.text = titleStr;
}

@end
