//
//  NSJSONSerialization+Extras.m
//  Meilishuo
//
//  Created by yang yu on 2/4/14.
//  Copyright (c) 2014 Meilishuo, Inc. All rights reserved.
//

#import "NSJSONSerialization+Extras.h"

@implementation NSJSONSerialization (Extras)

+ (NSDictionary *)dictionaryWithString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            return json;
        }
    }
    
    return nil;
}

+ (NSString *)stringWithJSONObject:(id)object
{
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        if (data) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    return @"{}";
}

@end
