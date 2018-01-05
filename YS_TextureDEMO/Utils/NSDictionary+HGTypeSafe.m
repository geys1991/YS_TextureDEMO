//
//  NSDictionary+HGTypeSafe.m
//  Higirl
//
//  Created by  jieli on 15/8/17.
//  Copyright (c) 2015年 ___MEILISHUO___. All rights reserved.
//

#import "NSDictionary+HGTypeSafe.h"
#import "NSDictionary+TypeSafe.h"

@implementation NSDictionary (HGTypeSafe)

- (id)hg_objectForKey:(id)aKey ofClass:(Class)aClass {
    id value = [self objectForKey:aKey];
    
    if (![value isKindOfClass:aClass]) {
        value = nil;
    }
    
    return value;
}

- (NSString *)hg_stringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if([value isKindOfClass:[NSNumber class]]){
        return  [((NSNumber *)value) stringValue];
    }else{
        return [self objectForKey:aKey ofClass:[NSString class]];
    }
    
}

- (NSArray *)hg_arrayForKey:(id)aKey
{
    return [self objectForKey:aKey ofClass:[NSArray class]];
}

- (NSDictionary *)hg_dictionaryForKey:(id)aKey
{
    return [self objectForKey:aKey ofClass:[NSDictionary class]];
}

- (NSInteger)hg_integerForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    else {
        return 0;
    }
}

- (CGFloat)hg_floatForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    }
    else {
        return 0;
    }
}

- (BOOL)hg_boolForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    }
    else if ([object respondsToSelector:@selector(integerValue)]) {
        return ([object integerValue] != 0);
    }
    else {
        return 0;
    }
}

@end
