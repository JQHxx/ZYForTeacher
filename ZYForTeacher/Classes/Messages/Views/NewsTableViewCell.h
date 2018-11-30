//
//  NewsTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/7/10.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MessageModel.h"


@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong)MessageModel  *model;

+(CGFloat)getCellHeightWithNews:(MessageModel *)model;

@end
