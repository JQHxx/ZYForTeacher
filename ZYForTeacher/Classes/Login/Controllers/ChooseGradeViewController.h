//
//  ChooseGradeViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^GetGradeValueBlock)(NSMutableArray *gradesArr);

@interface ChooseGradeViewController : BaseViewController

@property (nonatomic ,strong) NSArray  *gradesArray;
@property (nonatomic ,strong) NSArray  *selectedGradesArray;
@property (nonatomic , copy ) GetGradeValueBlock getGradeBlock;

@end
