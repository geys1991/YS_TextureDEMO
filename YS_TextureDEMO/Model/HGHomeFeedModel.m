//
//  HGHomeFeedModel.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/5.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "HGHomeFeedModel.h"
#import "NSJSONSerialization+Extras.h"
#import <NSObjectValue.h>
#import <ValueForKey.h>
#import "NSDictionary+HGTypeSafe.h"


@implementation HGHomeFeedModel

+ (NSDictionary *)homeFeedTypeMap
{
    return @{@"banner" : @(HGHomeFeedTypeBanner),
             @"seconds_kill" : @(HGHomeFeedTypeSeckill),
             @"collection" : @(HGHomeFeedTypeCollection),
             @"goods" : @(HGHomeFeedTypeGoods)};
}

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super initWithJSONDic:json];
    if (self) {
        NSString *type = [json hg_stringForKey:@"type"];
        if ([[[[self class] homeFeedTypeMap] allKeys] containsObject:type]) {
            _feedType = [[[[self class] homeFeedTypeMap] objectForKey:type] integerValue];
            if([json hg_arrayForKey:@"items"].count){
                _feedItems = [json hg_arrayForKey:@"items"];
                if (_feedItems.count) {
                    _feedItem = [_feedItems firstObject];
                }
            }
            else if([json hg_dictionaryForKey:@"item"]){
                _feedItem = [json hg_dictionaryForKey:@"item"];
            }
        }
        else{
            _feedType = HGHomeFeedTypeUnknown;
        }
    }
    return self;
}


@end
