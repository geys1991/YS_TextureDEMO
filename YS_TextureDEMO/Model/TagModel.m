//
//  TagModel.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/15.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "TagModel.h"
#import "NSDictionary+HGTypeSafe.h"
#import <NSObjectValue.h>

@implementation TagModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    if (self = [super initWithJSONDic:json]) {
        json = [json dictionaryValue] ?: @{};
        _tagName = [json hg_stringForKey:@"name"];
        _url = [json hg_stringForKey:@"url"];
        _isHot = [json hg_boolForKey:@"is_hot"];
    }
    return self;
}

@end
