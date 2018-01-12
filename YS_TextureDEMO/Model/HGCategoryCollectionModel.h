//
//  HGCategoryCollectionModel.h
//  Higirl
//
//  Created by jieli on 2017/4/26.
//  Copyright © 2017年 ___MEILISHUO___. All rights reserved.
//

#import "BaseModel.h"
@class ImageModel;

@class HGCategoryCollectionUserModel;
@class HGCategoryCollectionGoodsModel;

@interface HGCategoryCollectionModel : BaseModel

@property (nonatomic, copy) NSString *collectionID;
@property (nonatomic, strong) HGCategoryCollectionUserModel *owner;
@property (nonatomic, strong) ImageModel *coverImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *rankingText;
@property (nonatomic, copy) NSString *favoriteText;
@property (nonatomic, copy) NSArray<HGCategoryCollectionGoodsModel *> *goodsList;
@property (nonatomic, copy) NSString *goodsCountText;
@property (nonatomic, copy) NSDictionary *moreInfo;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *markURL;

@end

@interface HGCategoryCollectionUserModel : BaseModel

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *certificateName;
@property (nonatomic, copy) NSString *certificateIconURL;

@end

@interface HGCategoryCollectionGoodsModel : BaseModel

@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, strong) ImageModel *mainImage;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *salesText;
@property (nonatomic, assign) NSInteger goodsRepertory;

- (CGSize)sizeForGoodsWithContrainedToWidth:(CGFloat)width;

@end
