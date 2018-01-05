//
//  ValueForKey.h
//  LeheV2
//
//  Created by zhangluyi on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(ValueForKey)

- (id)objForKey:(NSString *)key;
- (id)objForKeyPath:(NSString *)key;

@end

@interface NSArray(ValueForKey)

- (id)objForKey:(NSString *)key;
- (id)objForKeyPath:(NSString *)key;

@end
