//
//  HGCategoryCollectionModel.m
//  Higirl
//
//  Created by jieli on 2017/4/26.
//  Copyright © 2017年 ___MEILISHUO___. All rights reserved.
//

#import "HGCategoryCollectionModel.h"
#import <NSObjectValue.h>
#import <ValueForKey.h>
#import "ImageModel.h"

#import "NSDictionary+HGTypeSafe.h"

@implementation HGCategoryCollectionModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super initWithJSONDic:json];
    if (self) {
        json = [json dictionaryValue] ?: @{};
        _collectionID = [json hg_stringForKey:@"collection_id"];
        _owner = [[HGCategoryCollectionUserModel alloc] initWithJSONDic:[json hg_dictionaryForKey:@"owner"]];
        _coverImage = [[ImageModel alloc] initWithJSONDic:[json hg_dictionaryForKey:@"cover_image"]];
        _title = [json hg_stringForKey:@"title"];
        _desc = [json hg_stringForKey:@"description"];
        _rankingText = [json hg_stringForKey:@"ranking_text"];
        _favoriteText = [json hg_stringForKey:@"favorite_text"];
        _goodsList = [HGCategoryCollectionGoodsModel objectsWithArrayOfDictionaries:[json hg_arrayForKey:@"goods"]];
        _goodsCountText = [json hg_stringForKey:@"goods_count_text"];
        _moreInfo = [json hg_dictionaryForKey:@"more_goods"];
        _url = [json hg_stringForKey:@"url"];
        _markURL = [json hg_stringForKey:@"mark_url"];
    }
    return self;
}

@end

@implementation HGCategoryCollectionUserModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super initWithJSONDic:json];
    if (self) {
        json = [json dictionaryValue] ?: @{};
        _nickName = [json hg_stringForKey:@"nick_name"];
        _avatarURL = [json hg_stringForKey:@"avatar"];
        _certificateName = [json hg_stringForKey:@"certificate_name"];
        _certificateIconURL = [json hg_stringForKey:@"certificate_icon"];
    }
    return self;
}

@end

@implementation HGCategoryCollectionGoodsModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super initWithJSONDic:json];
    if (self) {
        json = [json dictionaryValue] ?: @{};
        _goodsID = [json hg_stringForKey:@"goods_id"];
        _mainImage = [[ImageModel alloc] initWithJSONDic:[json hg_dictionaryForKey:@"main_image"]];
        _brandName = [json hg_stringForKey:@"brand_name"];
        _goodsPrice = [json hg_stringForKey:@"goods_price"];
        _salesText = [json hg_stringForKey:@"sales_text"];
        _goodsRepertory = [json hg_integerForKey:@"goods_repertory"];
    }
    return self;
}

- (CGSize)sizeForGoodsWithContrainedToWidth:(CGFloat)width;
{
    CGFloat imageHeight = width;
    if (self.mainImage.width > 0 && self.mainImage.height > 0) {
        imageHeight = width * self.mainImage.height / self.mainImage.width;
    }
    return CGSizeMake(width, imageHeight + 50);
}

@end
