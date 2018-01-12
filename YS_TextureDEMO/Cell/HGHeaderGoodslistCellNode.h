//
//  HGHeaderGoodslistCellNode.h
//  HIGO
//
//  Created by geys1991 on 2017/12/29.
//  Copyright © 2017年 ___HIGO___. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class HGCategoryCollectionGoodsModel;

@interface HGHeaderGoodslistCellNode : ASCellNode

-(instancetype)initWithGoodsInfo:(HGCategoryCollectionGoodsModel *)model;

@end
