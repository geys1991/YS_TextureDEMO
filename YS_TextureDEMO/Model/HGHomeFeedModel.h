//
//  HGHomeFeedModel.h
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/5.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, HGHomeFeedType)
{
    /**
     *  未知类型（在UI上不予展示）
     */
    HGHomeFeedTypeUnknown,
    /**
     *  Banner
     */
    HGHomeFeedTypeBanner,
    /**
     *  秒杀
     */
    HGHomeFeedTypeSeckill,
    /**
     *  专辑
     */
    HGHomeFeedTypeCollection,
    /**
     *  商品
     */
    HGHomeFeedTypeGoods,
};

@class YSHomeGoodsModel;

@interface HGHomeFeedModel : BaseModel

@property (nonatomic, assign, readonly) HGHomeFeedType feedType;
@property (nonatomic, copy) NSArray *feedItems;
@property (nonatomic, copy) NSDictionary *feedItem;
@property (nonatomic, strong) YSHomeGoodsModel *goods;

@end
