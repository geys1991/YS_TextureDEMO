//
//  YSHomeGoodsModel.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/15.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSHomeGoodsModel.h"
#import "ImageModel.h"
#import "NSDictionary+HGTypeSafe.h"
#import <NSObjectValue.h>
#import "TagModel.h"

@implementation YSHomeGoodsModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super initWithJSONDic:json];
    if (self) {
        json = [json dictionaryValue] ?: @{};
        _goodsID = [json hg_stringForKey:@"goods_id"];
        _mainImage = [[ImageModel alloc] initWithJSONDic:[json hg_dictionaryForKey:@"main_image"]];
        _brandName = [json hg_stringForKey:@"brand_name"];
        _goodsName = [json hg_stringForKey:@"goods_name"];
        _goodsDesc = [json hg_stringForKey:@"goods_desc"];
        _goodsPrice = [json hg_stringForKey:@"goods_price"];
        _finalPrice = [json hg_stringForKey:@"final_price"] ?: @"";
        _location = [json hg_stringForKey:@"location"];
        _isFavorite = [json hg_boolForKey:@"is_favorite"];
        _favoriteCount = [json hg_integerForKey:@"favorite_count"];
        _tags = [TagModel objectsWithArrayOfDictionaries:[json hg_arrayForKey:@"tags"]];
        _url = [json hg_stringForKey:@"url"];
        _daysSales = [json hg_stringForKey:@"days_sales"]?: @"";
        
        //local extension property
        CGSize contentSize = CGSizeZero;
        contentSize = [_location boundingRectWithSize: CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                              options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes: @{NSFontAttributeName: [UIFont systemFontOfSize: 10]}
                                              context: nil ].size;
        
        
        
        _loationTestWidth = contentSize.width;
        _priceAttributedString = [self configurePriceAttributedString];
    }
    return self;
}

- (NSMutableAttributedString *)configurePriceAttributedString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@",_finalPrice, _daysSales]];
    [attributedString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next" size: 16]} range:NSMakeRange(0, _finalPrice.length + 1)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 255 green:102 blue:102 alpha:102]} range:NSMakeRange(0, _finalPrice.length + 1)];
    [attributedString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 10]} range:NSMakeRange(_finalPrice.length + 1, attributedString.length - _finalPrice.length - 1)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 153 green:153 blue:153 alpha: 1]} range:NSMakeRange(_finalPrice.length + 1, attributedString.length - _finalPrice.length - 1)];
    return attributedString;
}


@end
