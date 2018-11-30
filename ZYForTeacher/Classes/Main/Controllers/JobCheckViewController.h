//
//  JobCheckViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

@interface JobCheckViewController : BaseViewController

@property (nonatomic ,strong) NSNumber      *jobId;
@property (nonatomic , copy ) NSArray       *jobPics;
@property (nonatomic , copy ) NSString      *orderId;
@property (nonatomic ,strong) NSNumber      *label;
@property (nonatomic , copy ) NSString      *third_id;

@end
