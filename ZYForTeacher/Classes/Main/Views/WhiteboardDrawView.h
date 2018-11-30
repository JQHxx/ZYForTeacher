//
//  WhiteboardDrawView.h
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhiteboardDrawViewDataSource <NSObject>

- (NSDictionary *)allLinesToDraw;

- (BOOL)hasUpdate;

@end

@interface WhiteboardDrawView : UIView

@property(nonatomic, weak) id<WhiteboardDrawViewDataSource> dataSource;

@end
