//
//  NSDictionary+HGTypeSafe.h
//  Higirl
//
//  Created by  jieli on 15/8/17.
//  Copyright (c) 2015年 ___MEILISHUO___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HGTypeSafe)

// Returns an object associated with a given key, and makes sure that the result
// is of given class.  Returns nil if key does not exist, or if the value for
// key is nil, or if the value is not of given class.
- (id)hg_objectForKey:(id)aKey ofClass:(Class)aClass;

- (NSString *)hg_stringForKey:(id)aKey;
- (NSArray *)hg_arrayForKey:(id)aKey;
- (NSDictionary *)hg_dictionaryForKey:(id)aKey;
- (NSInteger)hg_integerForKey:(id)aKey; // 值为数字、字符串都可以
- (float)hg_floatForKey:(id)aKey; // 值为数字、字符串都可以
- (BOOL)hg_boolForKey:(id)aKey; // 值为布尔、数字、字符串都可以

@end
