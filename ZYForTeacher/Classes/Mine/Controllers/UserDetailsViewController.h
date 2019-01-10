//
//  UserDetailsViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/30.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@interface UserDetailsViewController : BaseViewController

@property (nonatomic,assign) BOOL     isHomeworkIn; 

@property (nonatomic,strong) UserModel  *userInfo;

@end
