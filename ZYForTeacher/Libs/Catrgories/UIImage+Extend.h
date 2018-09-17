//
//  UIImage+Extend.h
//  SRZCommonTool
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 SRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

/**
 *  自由拉伸图片
 *
 *  @param imgName 图片名称
 *
 */
+ (UIImage *)resizedImage:(NSString *)imgName;

/**
 *  自由拉伸图片
 *
 *  @param imgName 图片名称
 *  @param xPos    左边开始位置比例 值范围0-1
 *  @param yPos    上边开始位置比例 值范围0-1
 *
 *  @return  image
 */
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/**
 *  根据给定的大小设置图片
 *
 *  @param imgName   图片名称
 *  @param itemSize  图片大小
 *
 *  @return  image
 */
+(UIImage *)drawImageWithName:(NSString *)imgName size:(CGSize)itemSize;


/**
 *  根据颜色和大小获取Image
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  自由改变Image的大小
 *
 *  @param size 目的大小
 *
 *  @return 修改后的Image
 */
- (UIImage *)cropImageWithSize:(CGSize)size;
/**
 *  根据指定压缩宽度,生成等比压缩后的图片
 *
 *  @param scaleWidth 压缩宽度
 *
 *  @return 等比压缩后的图片
 */
- (UIImage *)compressWithWidth:(CGFloat)scaleWidth;

/**
 *   图片生成小缩略图保证图片不模糊
 *
 *
 *
*/
-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/*
 * 图片绘制圆角
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;


@end
