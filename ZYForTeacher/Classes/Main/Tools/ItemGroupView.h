//
//  ItemGroupView.h
//  ZuoYe
//
//  Created by vision on 2018/8/7.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemGroupView;
@protocol ItemGroupViewDelegate <NSObject>

-(void)itemGroupView:(ItemGroupView *)groupView didClickActionWithIndex:(NSInteger)index;

@end

@interface ItemGroupView : UIView

@property (nonatomic, weak) id<ItemGroupViewDelegate>viewDelegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

-(void)changeItemForClickAction:(UIButton *)sender;

-(void)changeItemForSwipMenuAction:(UIButton *)sender;

@end
