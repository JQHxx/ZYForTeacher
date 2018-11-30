//
//  OrderDetailsViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface OrderDetailsViewController : BaseViewController

@property (nonatomic ,  copy ) NSString   *orderId;
@property (nonatomic , assign) BOOL       isNotifyIn;  //推送消息点击进入

@end
