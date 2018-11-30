//
//  IntroductionViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^GetIntroInfoBackBlock)(NSString *intro);

@interface IntroductionViewController : BaseViewController

@property (nonatomic, copy ) NSString *introStr;

@property (nonatomic ,copy)GetIntroInfoBackBlock getIntroBlock;


@end
