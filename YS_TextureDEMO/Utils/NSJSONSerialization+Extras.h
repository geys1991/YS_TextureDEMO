//
//  NSJSONSerialization+Extras.h
//  Meilishuo
//
//  Created by yang yu on 2/4/14.
//  Copyright (c) 2014 Meilishuo, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Extras)

/*!
 *  把JSON字符串转换成字典
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 *
 *  @since 4.1.0
 */
+ (NSDictionary *)dictionaryWithString:(NSString *)string;

/*!
 *  把JSON Object转换成JSON字符串
 *
 *  @param object 可以是 NSDictionary 或 NSArray
 *
 *  @return <#return value description#>
 *
 *  @since 4.1.0
 */
+ (NSString *)stringWithJSONObject:(id)object;

@end
