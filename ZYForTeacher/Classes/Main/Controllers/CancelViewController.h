//
//  CancelViewController.h
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    CancelTypeHomework  = 2,
    CancelTypeOrderCheck = 4,
    CancelTypeOrderCoach = 6,
} CancelType;


@interface CancelViewController : BaseViewController

@property (nonatomic, copy )NSString *myTitle;
@property (nonatomic,strong)NSNumber  *jobid;       //作业id
@property (nonatomic, copy )NSString  *oid;          //订单id
@property (nonatomic,assign)CancelType type;          //2=作业取消接单原因4=取消作业检查订单原因 6 = 取消作业辅导订单原因

@end
