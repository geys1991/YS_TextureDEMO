//
//  UIView+Frame.h
//  Higirl
//
//  Created by 2015-031 on 15/3/25.
//  Copyright (c) 2015年 ___MEILISHUO___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
- (id)initWithSize:(CGSize)size;

- (CGPoint)origin;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)right;
- (CGFloat)bottom;

- (CGSize)size;
- (CGFloat)height;
- (CGFloat)width;

- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

- (void)setOrigin:(CGPoint)origin;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setAnchorPoint:(CGPoint)anchorPoint;
- (void)setPosition:(CGPoint)point atAnchorPoint:(CGPoint)anchorPoint;
@end
