//
//  NSObject+JSONString.m
//  Higo
//
//  Created by 2015-031 on 6/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "NSObjetHGJSON.h"

@implementation NSArray (NSObjetHGJSON)

- (NSString*)jsonValue
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    
    if (!jsonData) {
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end


@implementation NSDictionary (NSObjetHGJSON)

- (NSString *)jsonValue
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end


@implementation NSObject (NSObjetHGJSON)

- (NSString* )jsonValue
{
    NSLog(@"Bad convert to NSArray:%@",[self description]);
    return @"";
}


@end