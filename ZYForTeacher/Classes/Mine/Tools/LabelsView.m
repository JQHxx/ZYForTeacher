//
//  LabelsView.m
//  ZuoYe
//
//  Created by vision on 2018/8/16.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "LabelsView.h"

#define kItemH    30
#define kMargin      10  //按钮之间的间距
#define kGapping     10  //距离边缘的距离
#define kTitleWidth  60

@interface LabelsView(){
    UIButton  *selectItem;
}

@end

@implementation LabelsView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSMutableArray *itemArr = [NSMutableArray new];
    for (UIView *view in self.subviews) {
        [itemArr addObject:view];
    }
    //重新布局
    //先取出第一个button并布好局
    UIButton *lastBtn = nil;
    for (int i = 0; i < itemArr.count; i++) {
        UIButton *item = itemArr[i];
        [item setTitle:self.labelsArray[i] forState:UIControlStateNormal];
        //设置文字的宽度
        NSString *titleStr = self.labelsArray[i];
        
        item.width = [titleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kItemH) withTextFont:kFontWithSize(16)].width + 10;
        item.height = kItemH;
        if (i == 0) {  //第一个的时候放心大胆的布局，并记录下上一个button的位置
            if(item.width >kScreenWidth - 2*kGapping -kTitleWidth){  //单行文字超过一行处理
                item.width = kScreenWidth -2*kGapping-kTitleWidth;
            }
            item.x = kGapping;
            item.y = 0;
            lastBtn =item;
        }else{  //依据上一个button来布局
            if (lastBtn.right+item.width+kMargin+kTitleWidth>kScreenWidth) { //不足以再摆一行了
                item.y = lastBtn.bottom+kMargin;
                item.x = kGapping;
                if(item.width >kScreenWidth - 2*kGapping-kTitleWidth){  //单行文字超过一行处理
                    item.width = kScreenWidth -2*kGapping-kTitleWidth;
                }
            }else{  //还能在摆同一行
                item.y = lastBtn.y;
                item.x=lastBtn.right+kMargin;
            }
            //  保存上一次的Button
            lastBtn = item;
        }
    }
    
    //动态计算高度
    if (self.viewHeightRecalc) {
        self.viewHeightRecalc(lastBtn.bottom+kMargin);
    }
}

#pragma mark -- Action
#pragma mark 点击标签按钮
-(void)itemClickAction:(UIButton *)sender{
    if (selectItem) {
        selectItem.selected = NO;
        selectItem.layer.borderColor = [kLineColor CGColor];
    }
    
    sender.selected = YES;
    sender.layer.borderColor = [UIColor redColor].CGColor;
    selectItem = sender;
    
    self.didClickItem(sender.tag);
}

#pragma mark -- setters
#pragma mark 标签数组
-(void)setLabelsArray:(NSMutableArray *)labelsArray{
    _labelsArray = labelsArray;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < labelsArray.count; i ++) {
        UIButton *item = [[UIButton alloc] init];
        item.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [item setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        item.layer.cornerRadius = 1.0;
        item.clipsToBounds = YES;
        item.layer.borderWidth = 0.5;
        item.layer.borderColor = [kLineColor CGColor] ;
        item.tag = i;
        if (i==0) {
            item.selected = YES;
            item.layer.borderColor = [UIColor redColor].CGColor;
            selectItem = item;
        }
        [item addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}

@end
