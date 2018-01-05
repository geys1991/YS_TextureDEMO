//
//  UIImage+Utility.m
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "UIImage+Utility.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Utility)

+ (UIImage*)decode:(UIImage*)image
{
    if(image==nil){  return nil; }
    
    UIGraphicsBeginImageContext(image.size);
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)fastImageWithData:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    return [self decode:image];
}

+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [self decode:image];
}

#pragma mark- Copy

- (UIImage*)deepCopy
{
    return [UIImage decode:self];
}

#pragma mark- 其他
- (UIImage*)orientationFixedImage
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark- Resizing

- (UIImage*)resize:(CGSize)size
{
    int W = size.width;
    int H = size.height;
    
    CGImageRef   imageRef   = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W = size.height;
        H = size.width;
    }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, W, H), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

- (UIImage*)aspectFit:(CGSize)size
{
    CGFloat ratio = MIN(size.width/self.size.width, size.height/self.size.height);
    return [self resize:CGSizeMake(self.size.width*ratio, self.size.height*ratio)];
}

- (UIImage*)aspectFill:(CGSize)size
{
    return [self aspectFill:size offset:0];
}

- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset
{
    int W  = size.width;
    int H  = size.height;
    int W0 = self.size.width;
    int H0 = self.size.height;
    
    CGImageRef   imageRef = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W  = size.height;
        H  = size.width;
        W0 = self.size.height;
        H0 = self.size.width;
    }
    
    double ratio = MAX(W/(double)W0, H/(double)H0);
    W0 = ratio * W0;
    H0 = ratio * H0;
    
    int dW = abs((W0-W)/2);
    int dH = abs((H0-H)/2);
    
    if(dW==0){ dH += offset; }
    if(dH==0){ dW += offset; }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(-dW, -dH, W0, H0), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}


- (UIImage *) renderAtSize:(const CGSize) size leftCap:(NSInteger)leftcap topCap:(NSInteger)topcap
{
    CGImageRef base = self.CGImage;
    CGFloat BASE_COL_X[] = {0,leftcap,leftcap + 1};
    CGFloat BASE_ROW_Y[] = {0,topcap,topcap +1};
    CGFloat BASE_COL_WIDTH[] = {leftcap,1,CGImageGetWidth(base) - leftcap -1};
    CGFloat BASE_ROW_HEIGHT[] = {topcap,1,CGImageGetHeight(base) - topcap -1};
    
    CGFloat TARGET_COL_WIDTH[] = {BASE_COL_WIDTH[0], size.width - BASE_COL_WIDTH[0] - BASE_COL_WIDTH[2], BASE_COL_WIDTH[2]};
    CGFloat TARGET_ROW_HEIGHT[] = {BASE_ROW_HEIGHT[0], size.height - BASE_ROW_HEIGHT[0] - BASE_ROW_HEIGHT[2], BASE_ROW_HEIGHT[2]};
    CGFloat TARGET_COL_X[] = {0,TARGET_COL_WIDTH[0],TARGET_COL_WIDTH[0]+TARGET_COL_WIDTH[1]};
    
    
    CGFloat TARGET_ROW_Y[] = {size.height - TARGET_ROW_HEIGHT[0],
        size.height - TARGET_ROW_HEIGHT[0] - TARGET_ROW_HEIGHT[1],
        size.height - TARGET_ROW_HEIGHT[0] - TARGET_ROW_HEIGHT[1] - TARGET_ROW_HEIGHT[2]};
    
    //CGFloat TARGET_ROW_Y[] = {0,TARGET_ROW_HEIGHT[0],TARGET_ROW_HEIGHT[0] + TARGET_ROW_HEIGHT[1]};
    
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    const CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    for (int row=0; row<3; row++)
    {
        for (int col=0; col<3; col++)
        {
            CGRect source = CGRectMake(BASE_COL_X[col], BASE_ROW_Y[row], BASE_COL_WIDTH[col], BASE_ROW_HEIGHT[row]);
            CGRect target = CGRectMake(TARGET_COL_X[col], TARGET_ROW_Y[row], TARGET_COL_WIDTH[col], TARGET_ROW_HEIGHT[row]);
            
            if (source.origin.x<0)
                source.origin.x=0;
            if (source.origin.y<0)
                source.origin.y=0;
            if (source.size.width<0)
                source.size.width=0;
            if (source.size.height<0)
                source.size.height=0;
            
            if (target.origin.x<0)
                target.origin.x=0;
            if (target.origin.y<0)
                target.origin.y=0;
            if (target.size.width<0)
                target.size.width=0;
            if (target.size.height<0)
                target.size.height=0;
            
            
            CGImageRef ref = CGImageCreateWithImageInRect(base, source);
            
            if (ref)
            {
                CGContextDrawImage(context, target, ref);
                CFRelease(ref);
            }
            
        }
    }
    const CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *renderedImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    UIGraphicsEndImageContext();
    
    return renderedImage;
}


#pragma mark- Clipping

- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage*)crop:(CGRect)rect scale:(CGFloat)scale
{
    CGSize imageSize = self.size;
    
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [self drawInRect:CGRectMake(origin.x, origin.y, imageSize.width*scale, imageSize.height*scale)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark- Masking

- (UIImage *)maskWithImage:(UIImage *) maskImage
{
    float width = maskImage.size.width;
    float height = maskImage.size.height;
    
    const CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGImageRef maskImageRef = maskImage.CGImage;
    
    const CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (! mainViewContentContext)
    {
        return nil;
    }
    
    CGFloat ratio = width / self.size.width;
    
    if (ratio * self.size.height < height)
    {
        ratio = height / self.size.height;
    }
    
    const CGRect maskRect  = CGRectMake(0, 0, width, height);
    
    const CGRect imageRect  = CGRectMake(-((self.size.width * ratio) - width) / 2,
                                         -((self.size.height * ratio) - height) / 2,
                                         self.size.width * ratio,
                                         self.size.height * ratio);
    
    CGContextClipToMask(mainViewContentContext, maskRect, maskImageRef);
    CGContextDrawImage(mainViewContentContext, imageRect, self.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    return theImage;
    
}

#pragma mark- Blur


- (UIImage*)gaussBlur:(CGFloat)blurLevel
{
    blurLevel = MIN(1.0, MAX(0.0, blurLevel));
    
    int boxSize = (int)(blurLevel * 0.8 * MIN(self.size.width, self.size.height));
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    
    // convolution
    vImageConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    vImageConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

-(UIImage*)waterprintWithImage:(UIImage *)waterImage inSize:(CGSize)size
{
    if(waterImage!=nil)
    {
        CGRect destRect = CGRectMake(0, 0, size.width, size.height);
        CGRect waterRect = CGRectMake((size.width-waterImage.size.width)/2, (size.height-waterImage.size.height)/2, waterImage.size.width, waterImage.size.height);
        
        UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 1.0); // 0.0 for scale means "correct scale for device's main screen".
        [self drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
        [waterImage drawInRect:waterRect];
        UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    } else {
        return [UIImage imageWithCGImage:self.CGImage];
    }
    
}


-(UIImage*)waterprintWithImage:(UIImage *)waterImage inSize:(CGSize)size withTextAlignment:(NSTextAlignment)alignment
{
    if(waterImage!=nil)
    {
        CGRect destRect = CGRectMake(0, 0, size.width, size.height);
        CGRect waterRect = CGRectMake((size.width-waterImage.size.width)/2, (size.height-waterImage.size.height)/2, waterImage.size.width/2, waterImage.size.height/2);
        
        UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 1.0); // 0.0 for scale means "correct scale for device's main screen".
        [self drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
        [waterImage drawInRect:waterRect];
        UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    else
        return [UIImage imageWithCGImage:self.CGImage];
    
}

- (UIImage *)resizeImageForSend {
    
    CGFloat regularLength = 1280;
    CGFloat regularFactor = 2;
    CGFloat factor = self.size.width >= self.size.height ? self.size.width / self.size.height : self.size.height / self.size.width;
    UIImage *resizeImage = self;
    
    // 1.宽小于等于regularLength，高小于等于regularLength
    // 2.宽小于等于regularLength，高大于regularLength，且factor大于regularFactor
    // 3.宽大于regularLength，高小于等于regularLength，且factor大于regularFactor
    if ((self.size.width <= regularLength && self.size.height <= regularLength) ||
        (self.size.width <= regularLength && self.size.height >  regularLength && factor > regularFactor) ||
        (self.size.width >  regularLength && self.size.height <= regularLength && factor > regularFactor)) {
        // 保持尺寸
    }
    else {
        // 等比缩小
        CGRect targetRect;
        // 按宽=regularLength等比缩小
        // 1.宽大于regularLength，高小于等于regularLength，且factor小于等于regularFactor
        // 2.宽大于regularLength，高大于regularLength，且宽大于等于高
        if ((self.size.width > regularLength && self.size.height <= regularLength && factor <= regularFactor) ||
            (self.size.width > regularLength && self.size.height >  regularLength && self.size.width >= self.size.height)) {
            targetRect = CGRectMake(0, 0, regularLength, regularLength * self.size.height / self.size.width);
        }
        // 按高=regularLength等比缩小
        // 1.宽小于等于regularLength，高大于regularLength，且factor小于等于regularFactor
        // 2.宽大于regularLength，高大于regularLength，且宽小于高
        else {
            targetRect = CGRectMake(0, 0, regularLength * self.size.width / self.size.height, regularLength);
        }
        NSLog(@"处理图片，原图->%@", self);
        UIGraphicsBeginImageContextWithOptions(targetRect.size, NO, 1.0);
        [self drawInRect:targetRect];
        resizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"处理后->%@", resizeImage);
    }
    return resizeImage;
}
@end
