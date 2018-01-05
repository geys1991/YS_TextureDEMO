//
//  BaseModel.h
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/5.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, copy) NSString* ID;

- (instancetype)initWithJSONDic:(NSDictionary*)json;
- (instancetype)initWithJSON:(NSString*)json;
- (NSString*)toJSON;

+ (NSArray *)objectsWithArrayOfDictionaries:(NSArray *)list;


@end
