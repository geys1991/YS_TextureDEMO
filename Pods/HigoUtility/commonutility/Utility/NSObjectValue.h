//
//  NSObject+JSONString.h
//  Higo
//
//  Created by 2015-031 on 6/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSObjectValue)
- (NSString *)stringValue;
+ (NSString *)convertValue:(id)value;
@end


@interface NSArray (NSObjectValue)
- (NSArray *)arrayValue;
+ (NSArray *)convertValue:(id)value;
@end

@interface NSDictionary (NSObjectValue)
- (NSDictionary *)dictionaryValue;
+ (NSDictionary *)convertValue:(id)value;
@end


@interface NSObject (NSObjectValue)
+ (id)convertValue:(id)value;
@end
