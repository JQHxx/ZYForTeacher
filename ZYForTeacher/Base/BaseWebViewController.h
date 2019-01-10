//
//  BaseWebViewController.h
//  ZuoYe
//
//  Created by vision on 2018/10/24.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    WebViewTypeSystem,
    WebViewTypeUserAgreement,
    WebViewTypeCommonProblem,
} WebViewType;

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : BaseViewController

@property (nonatomic, copy ) NSString *webTitle;
@property (nonatomic, copy ) NSString *urlStr;
@property (nonatomic,assign) WebViewType webType;

@end

NS_ASSUME_NONNULL_END
