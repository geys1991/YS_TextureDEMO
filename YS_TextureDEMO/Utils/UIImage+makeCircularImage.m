//
//  UIImage+makeCircularImage.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/11.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "UIImage+makeCircularImage.h"

@implementation UIImage (makeCircularImage)

- (UIImage *)makeCircularImageWithSize:(CGSize)size
{
    // make a CGRect with the image's size
    CGRect circleRect = (CGRect) {CGPointZero, size};
    
    // begin the image context since we're not in a drawRect:
    UIGraphicsBeginImageContextWithOptions(circleRect.size, NO, 0);
    
    // create a UIBezierPath circle
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width/2];
    
    // clip to the circle
    [circle addClip];
    
    // draw the image in the circleRect *AFTER* the context is clipped
    [self drawInRect:circleRect];
    
    // create a border (for white background pictures)
#if StrokeRoundedImages
    circle.lineWidth = 1;
    [[UIColor darkGrayColor] set];
    [circle stroke];
#endif
    
    // get an image from the image context
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end the image context since we're not in a drawRect:
    UIGraphicsEndImageContext();
    
    return roundedImage;
}


@end
