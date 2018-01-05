//
//  NSString+Utility.h
//  Higirl
//
//  Created by silvon on 15-4-1.
//  Copyright (c) 2015年 ___MEILISHUO___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

- (BOOL)higoContainsString:(NSString*)other;

- (NSString *)stringValue;
/**
 *  删除字符串两头的,。.，?？！!符号
 *
 *  @return     删除后的字符串
 */
- (NSString *)trimTagCode;

/**
 *  删除字符串两头的空格
 *
 *  @return     删除后的字符串
 */
- (NSString *)trimSpace;

/**
 *  删除字符串两头的空格和换行符
 *
 *  @return     删除后的字符串
 */
- (NSString *)trimSpaceAndNewline;

/**
 *  删除字符串两头的空格和换行符后是否是空字符串
 *
 *  @return     yes,是空字符串;no,非空字符串
 */
- (BOOL)isEmptyAfterTrimed;

/**
 *  是否是由0-9组成的字符串
 *
 *  @return     yes,由0-9组成;no,含有非0-9字符
 */
- (BOOL)isAllDigits;

/**
 *  是否是数字（整数、小数）
 *
 *  @return     yes是数字;no不是数字
 */
- (BOOL)isNumeric;

/**
 *  计算字符串的md5值
 *
 *  @return     md5字符串
 */
- (NSString *)md5;

// 获取字符串高度和宽度
- (CGSize)boundingRectWithFont:(UIFont*)font andSize:(CGSize)size;
- (CGSize)boundingRectWithFont:(UIFont*)font lineSpacing:(CGFloat)lineSpace andSize:(CGSize)size;

/**
 *  将json串转为数组或字典
 *
 *  @return     json结构
 */
- (id)objectFromJSONValue;

@end
