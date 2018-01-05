//
//  PersistenceHelper.h
//  Shake
//
//  Created by zhangluyi on 11-11-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersistenceHelper : NSObject {
    
}

+ (BOOL)setData:(id)obj forKey:(NSString *)key;
+ (id)dataForKey:(NSString *)key;
+ (void)removeForKey:(NSString *)key;

@end
