//
//  NSObject+JSONString.h
//  Higo
//
//  Created by 2015-031 on 6/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSObjetHGJSON)
- (NSString *)jsonValue;
@end

@interface NSDictionary (NSObjetHGJSON)
- (NSString*)jsonValue;
@end
