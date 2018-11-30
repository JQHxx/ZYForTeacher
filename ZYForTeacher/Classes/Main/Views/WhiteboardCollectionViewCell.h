//
//  WhiteboardCollectionViewCell.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhiteboardCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIButton  *deleteBtn;
@property (nonatomic,strong)UIImage   *contentImage;
@property (nonatomic, copy )NSString  *titleStr;

@end

NS_ASSUME_NONNULL_END
