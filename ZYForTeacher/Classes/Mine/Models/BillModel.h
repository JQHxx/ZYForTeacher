//
//  BillModel.h
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject

@property (nonatomic ,assign )  NSInteger  bill_type;      //0、提现 1、作业检查 2、作业辅导
@property (nonatomic , copy )   NSString   *create_time;   //交易时间
@property (nonatomic ,assign )  double     amount;         //金额
@property (nonatomic , copy )   NSString   *order_sn;      //交易单号

@end
