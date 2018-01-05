//
//  ValueForKey.m
//  LeheV2
//
//  Created by zhangluyi on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ValueForKey.h"

@implementation NSDictionary(ValueForKey)

- (id)objForKey:(NSString *)key {
    id ret = nil;
	
	if ([self isKindOfClass:[NSArray class]])
	{
		if ([(NSArray*)self count]==1) {
			self = [(NSArray*)self objectAtIndex:0];
		} else {
			return nil;
		}
	}

    @try {
        ret = [self valueForKey:key];
    }
    @catch (NSException *exception) {
        ret = nil;
    }
    
    if (!ret || [(NSNull *)ret isEqual:[NSNull null]]) {
        return nil;
    } else {
        return ret;
    }
}


- (id)objForKeyPath:(NSString *)key {
    id ret = nil;
	
	if ([self isKindOfClass:[NSArray class]])
	{
		if ([(NSArray*)self count]==1) {
			self = [(NSArray*)self objectAtIndex:0];
		} else {
			return nil;
		}
	}	
    
    @try {
        ret = [self valueForKeyPath:key];
    }
    @catch (NSException *exception) {
        ret = nil;
    }
    
    if (!ret || [(NSNull *)ret isEqual:[NSNull null]]) {
        return nil;
    } else {
        return ret;
    }
}

//- (id)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag {
//    
//    //NSLog(@"otherDictionary:%@",otherDictionary);
//    
//    if ([otherDictionary isKindOfClass:[NSDictionary class]]) {
//        NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
//        [otherDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [resultDict setObject:obj forKey:key];
//        }];
//        return resultDict;
//    }
//    return nil;
//}
@end

#pragma mark NSArray
@implementation NSArray(ValueForKey)
- (id)objForKey:(NSString *)key {
    id ret = nil;
	
	if ([self isKindOfClass:[NSArray class]])
	{
		if ([(NSArray*)self count]==1) {
			self = [(NSArray*)self objectAtIndex:0];
		} else {
			return nil;
		}
	}
	
    @try {
        ret = [self valueForKey:key];
    }
    @catch (NSException *exception) {
        ret = nil;
    }
    
    if (!ret || [(NSNull *)ret isEqual:[NSNull null]]) {
        return nil;
    } else {
        return ret;
    }
}


- (id)objForKeyPath:(NSString *)key {
    id ret = nil;
	
	if ([self isKindOfClass:[NSArray class]])
	{
		if ([(NSArray*)self count]==1) {
			self = [(NSArray*)self objectAtIndex:0];
		} else {
			return nil;
		}
	}	
    
    @try {
        ret = [self valueForKeyPath:key];
    }
    @catch (NSException *exception) {
        ret = nil;
    }
    
    if (!ret || [(NSNull *)ret isEqual:[NSNull null]]) {
        return nil;
    } else {
        return ret;
    }
}

- (NSInteger)length {
    return 0;
}

@end

@implementation NSString(ValueForKey)
- (id)objForKey:(NSString *)key {
    return nil;
}

- (id)objForKeyPath:(NSString *)key {
    return nil;
}
@end
