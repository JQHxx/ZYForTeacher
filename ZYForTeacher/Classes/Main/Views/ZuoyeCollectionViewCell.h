//
//  ZuoyeCollectionViewCell.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkModel.h"

@interface ZuoyeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton  *checkButton;
@property (nonatomic, strong) UIButton  *acceptButton;
@property (nonatomic, strong) UIButton  *tutriolButton;

-(void)configCellWithMyHomework:(HomeworkModel *)homework;


@end
