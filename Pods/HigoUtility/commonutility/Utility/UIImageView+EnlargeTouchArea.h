//
//  UIButton+EnlargeTouchArea.h
//  Meilishuo
//
//  Created by Gao Xiaolin on 7/18/13.
//  Copyright (c) 2013 Meilishuo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

/*!
 *  把点击范围设置成size大小
 *
 *  @param size <#size description#>
 *
 *  @since 4.0.0
 */
- (void)setTouchAreaToSize:(CGSize)size;

@end
