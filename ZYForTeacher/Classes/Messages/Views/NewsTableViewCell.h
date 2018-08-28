//
//  NewsTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/7/10.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SystemNewsModel.h"


@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong)SystemNewsModel  *model;

+(CGFloat)getCellHeightWithNews:(SystemNewsModel *)model;

@end
