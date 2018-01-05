//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

- (UIImage*)deepCopy;

/**
 *  修复图像方向
 *
 *  @return      修复后的image
 */
- (UIImage*)orientationFixedImage;


/**
 *  缩放图像（拉伸模式）
 *
 *  @param       size        目标大小
 *  @return      缩放后的image
 */
- (UIImage*)resize:(CGSize)size;

/**
 *  缩放图像（维持原比例）
 *
 *  @param       size        目标大小
 *  @return      缩放后的image
 */
- (UIImage*)aspectFit:(CGSize)size;

/**
 *  缩放图像（维持原比例并填充）
 *
 *  @param       size        目标大小
 *  @return      缩放后的image
 */
- (UIImage*)aspectFill:(CGSize)size;

/**
 *  缩放图像（维持原比例并填充）
 *
 *  @param       size        目标大小
 *  @param       offset      缩放后图片中心偏移量
 *  @return      缩放后的image
 */
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;


// 聊天中发图片用到的该函数
- (UIImage *)renderAtSize:(const CGSize) size leftCap:(NSInteger)leftcap topCap:(NSInteger)topcap;


/**
 *  截取图像
 *
 *  @param       rect         在image要截取的rect
 *  @return      截取后的image
 */
- (UIImage*)crop:(CGRect)rect;
- (UIImage*)crop:(CGRect)rect scale:(CGFloat)scale;
/**
 *  遮罩图像
 *
 *  @param       maskImage    蒙板图像
 *  @return      遮罩后的image
 */
- (UIImage*)maskWithImage:(UIImage*)maskImage;

/**
 *  图像高斯模糊
 *
 *  @param       blurLevel    模糊等级 取值0至1
 *  @return      模糊image
 */
- (UIImage*)gaussBlur:(CGFloat)blurLevel;

/**
 * 水印函数
 *
 *
 */
-(UIImage*)waterprintWithImage:(UIImage *)waterImage inSize:(CGSize)size;

/**
 * 水印函数对其方式
 *
 *
 */

-(UIImage*)waterprintWithImage:(UIImage *)waterImage inSize:(CGSize)size withTextAlignment:(NSTextAlignment)alignment;

-(UIImage *)resizeImageForSend;

@end
