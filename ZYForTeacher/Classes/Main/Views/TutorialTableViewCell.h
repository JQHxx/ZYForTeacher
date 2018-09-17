//
//  TutorialTableViewCell.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface TutorialTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton   *cellButton;

-(void)cellDisplayWithModel:(OrderModel *)orderModel selIndex:(NSInteger)index;

@end
