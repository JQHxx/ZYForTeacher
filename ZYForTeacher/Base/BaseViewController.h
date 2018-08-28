//
//  BaseViewController.h
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BaseReturnBackBlock)(id object);

@interface BaseViewController : UIViewController

@property (nonatomic ,assign)BOOL      isHiddenBackBtn;       //隐藏返回按钮
@property (nonatomic ,assign)BOOL      isHiddenNavBar;       //隐藏导航栏
@property (nonatomic ,copy)NSString    *baseTitle;           //标题
@property (nonatomic ,copy)NSString    *leftImageName;       //导航栏左侧图片名称
@property (nonatomic ,copy)NSString    *leftTitleName;       //导航栏左侧标题名称
@property (nonatomic ,copy)NSString    *rightImageName;      //导航栏右侧图片名称
@property (nonatomic ,copy)NSString    *rigthTitleName;      //导航栏右侧标题名称

@property (nonatomic, copy)BaseReturnBackBlock backBlock;


-(void)leftNavigationItemAction;
-(void)rightNavigationItemAction;

@end
