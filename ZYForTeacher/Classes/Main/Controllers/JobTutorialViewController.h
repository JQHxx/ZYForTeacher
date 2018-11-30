//
//  JobTutorialViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"
#import "NetCallChatInfo.h"
#import "HomeworkModel.h"

@interface JobTutorialViewController : BaseViewController

@property (nonatomic,strong)HomeworkModel *homework;

@property (nonatomic,strong)  NetCallChatInfo *callInfo;


@end
