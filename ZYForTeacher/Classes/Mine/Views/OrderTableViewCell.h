//
//  OrderTableViewCell.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton   *cancelButton;       //取消订单
@property (nonatomic ,strong) UIButton   *checkButton;

@property (nonatomic ,strong) OrderModel *myOrder;

@end
