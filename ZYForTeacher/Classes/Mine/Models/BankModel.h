//
//  BankModel.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

@property (nonatomic , copy ) NSString *cardBgImage;
@property (nonatomic , copy ) NSString *cardImage;
@property (nonatomic , copy ) NSString *bankName;   //开户行
@property (nonatomic , copy ) NSString *bankNum;   //卡号
@property (nonatomic , copy ) NSString *bankType;  //卡类型
@property (nonatomic , copy ) NSString *cardHolder;  //持卡人



@end
