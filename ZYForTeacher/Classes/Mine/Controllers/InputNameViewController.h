//
//  InputNameViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    CertificationTypeActualName,
    CertificationTypeIdentificationNumber
} CertificationType;


@interface InputNameViewController : BaseViewController

@property (nonatomic ,assign) CertificationType type;
@property (nonatomic , copy ) NSString  *myText;


@end
