//
//  TeachInfoViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@interface TeachInfoViewController : BaseViewController

@property (nonatomic ,assign ) BOOL isLoginIn;
@property (nonatomic ,strong ) UserModel  *user;

@end
