//
//  HGHeaderGoodslistCellNode.h
//  HIGO
//
//  Created by geys1991 on 2017/12/29.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class HGCategoryCollectionGoodsModel;

@interface HGHeaderGoodslistCellNode : ASCellNode

-(instancetype)initWithGoodsInfo:(HGCategoryCollectionGoodsModel *)model;

@end
