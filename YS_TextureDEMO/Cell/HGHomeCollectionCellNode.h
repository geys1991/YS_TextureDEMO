//
//  HGHomeCollectionCellNode.h
//  YS_TextureDEMO
//
//  Created by geys1991 on 2017/12/28.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class HGCategoryCollectionModel;
@class HGHomeFeedModel;

@interface HGHomeCollectionCellNode : ASCellNode

- (instancetype)initWithCollectionModel:(HGCategoryCollectionModel *)model;

@end
