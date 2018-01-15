//
//  YSHomeGoodsModel.h
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/15.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "BaseModel.h"

@class ImageModel;
@class TagModel;

@interface YSHomeGoodsModel : BaseModel

@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, strong) ImageModel *mainImage;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *finalPrice;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, copy) NSArray<TagModel *> *tags;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *daysSales;

//local extension property
@property (nonatomic, copy) NSMutableAttributedString *priceAttributedString;
@property (nonatomic, assign) CGFloat loationTestWidth;

@end
