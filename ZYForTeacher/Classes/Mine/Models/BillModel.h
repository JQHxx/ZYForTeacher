//
//  BillModel.h
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject

@property (nonatomic ,strong)  NSNumber    *label;           //交易类型
@property (nonatomic ,strong)  NSNumber    *income_time;    //交易时间
@property (nonatomic ,strong)  NSNumber    *income;           //金额
@property (nonatomic , copy )  NSString    *income_no;      //交易单号
@property (nonatomic ,strong)  NSNumber    *status;   //交易状态

@property (nonatomic ,strong)  NSString    *extract_no;       //交易单号
@property (nonatomic ,strong)  NSNumber    *extract_status;   //交易状态
@property (nonatomic , copy )  NSString    *bank;             //银行
@property (nonatomic , copy )  NSString    *card;             //银行卡号
@property (nonatomic , copy )  NSString    *realname;         //持卡人

@end
