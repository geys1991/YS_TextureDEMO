//
//  BaseModel.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/5.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "BaseModel.h"

#import "NSJSONSerialization+Extras.h"
#import <NSObjectValue.h>
#import <ValueForKey.h>

@implementation BaseModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        json = [json dictionaryValue] ?: @{};
        _ID = [[json objForKey:@"id"] stringValue] ?: @"";
    }
    return self;
}

- (instancetype)initWithJSON:(NSString*)json{
    NSDictionary *retDic=[NSJSONSerialization dictionaryWithString:json];
    return [self initWithJSONDic:retDic];
}

-(NSString *) toJSON{
    return @"{}";
}

+ (NSArray *)objectsWithArrayOfDictionaries:(NSArray *)list
{
    return [self objectsWithArrayOfDictionaries:list enumerateUsingBlock:nil];
}

+ (NSArray *)objectsWithArrayOfDictionaries:(NSArray *)array enumerateUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    NSMutableArray *objects = [NSMutableArray array];
    
    if (array && [array isKindOfClass:[NSArray class]]) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            // Create object
            id instance = nil;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                instance = [[self alloc] initWithJSONDic:obj];
            }
            
            // Call block
            if (block) {
                BOOL inStop = NO;
                block(instance, idx, &inStop);
                if (inStop) {
                    *stop = YES;
                    return;
                }
            }
            
            if (instance != nil) {
                [objects addObject:instance];
            }
        }];
    }
    
    return objects;
}


@end
