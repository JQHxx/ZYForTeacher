//
//  PicturesCollectionViewCell.m
//  ZuoYe
//
//  Created by vision on 2018/10/25.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "PicturesCollectionViewCell.h"

@implementation PicturesCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imgW = (kScreenWidth-45)/3.0; //图片宽高
        
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgW)];
        self.myImageView.userInteractionEnabled = YES;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.myImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.myImageView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgW-20, imgW-20, 15, 14)];
        iconImageView.image = [UIImage imageNamed:@"check"];
        [self.myImageView addSubview:iconImageView];
    }
    return self;
}

@end
