//
//  NSDictionary+TypeSafe.h
//  Higirl
//
//  Created by  阮春青 on 15/8/17.
//  Copyright (c) 2015年 ___MEILISHUO___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MLSNSDictionaryTypeSafeAdditions)

// Returns an object associated with a given key, and makes sure that the result
// is of given class.  Returns nil if key does not exist, or if the value for
// key is nil, or if the value is not of given class.
- (id)objectForKey:(id)aKey ofClass:(Class)aClass;

- (NSString *)stringForKey:(id)aKey;
- (NSArray *)arrayForKey:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey; // 值为数字、字符串都可以
- (CGFloat)floatForKey:(id)aKey; // 值为数字、字符串都可以
- (BOOL)boolForKey:(id)aKey; // 值为布尔、数字、字符串都可以

@end
