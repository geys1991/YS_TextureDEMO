//
//  NSObject+JSONString.m
//  Higo
//
//  Created by 2015-031 on 6/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "NSObjectValue.h"


@implementation NSString (NSObjectValue)

- (NSString *)stringValue
{
    return self;
}

+ (NSString *)convertValue:(id)value
{
    return [value stringValue];
}

@end


@implementation NSArray (NSObjectValue)

- (NSArray *)arrayValue
{
    return self;
}

+ (NSArray *)convertValue:(id)value
{
    return [value arrayValue];
}

@end


@implementation NSDictionary (NSObjectValue)

- (NSDictionary *)dictionaryValue
{
    return self;
}

+ (NSDictionary *)convertValue:(id)value
{
    return [value dictionaryValue];
}

@end


@implementation NSObject (NSObjectValue)

+ (id)convertValue:(id)value
{
    NSLog(@"Bad convert to:%@",[self description]);
    return value;
}

- (NSString *)stringValue
{
    NSLog(@"Bad convert to NSString:%@",[self description]);
    return @"";
}

- (NSArray *)arrayValue
{
    NSLog(@"Bad convert to NSArray:%@",[self description]);
    return [NSArray array];
}

- (NSDictionary *)dictionaryValue
{
    NSLog(@"Bad convert to NSDictionary:%@",[self description]);
    return [NSMutableDictionary dictionary];
}
@end