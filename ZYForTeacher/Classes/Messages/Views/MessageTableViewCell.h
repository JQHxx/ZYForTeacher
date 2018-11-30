//
//  MessageTableViewCell.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageTableViewCell : UITableViewCell

-(void)messageCellDisplayWithMessage:(MessageModel *)messageInfo type:(NSInteger)messageType;

@end
