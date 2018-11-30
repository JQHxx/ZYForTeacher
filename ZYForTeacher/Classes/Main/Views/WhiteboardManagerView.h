//
//  WhiteboardManagerView.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WhiteboardManagerView;
@protocol WhiteboardManagerViewDelegate <NSObject>
//添加白板
-(void)whiteboardManagerViewAddWhiteboard;
//选择白板
-(void)whiteboardManagerView:(WhiteboardManagerView *)managerView didSelectWhiteboardWithIndex:(NSInteger)itemIndex;
//删除白板
-(void)whiteboardManagerView:(WhiteboardManagerView *)managerView deleteWhiteboardWithIndex:(NSInteger)itemIndex;

@end

@interface WhiteboardManagerView : UIView

@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)NSMutableArray *whiteboardsArray;
@property (nonatomic, weak ) id<WhiteboardManagerViewDelegate>viewDelegate;

@end

NS_ASSUME_NONNULL_END
