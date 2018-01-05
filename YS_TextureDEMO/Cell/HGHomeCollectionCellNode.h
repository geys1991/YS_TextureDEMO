//
//  HGHomeCollectionCellNode.h
//  HIGO
//
//  Created by geys1991 on 2017/12/28.
//  Copyright © 2017年 ___HIGO___. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class HGCategoryCollectionModel;
@class HGHomeFeedModel;

@interface HGHomeCollectionCellNode : ASCellNode

//- (instancetype)initWithFeedModel:(HGHomeFeedModel *)model;

- (instancetype)initWithCollectionModel:(HGCategoryCollectionModel *)model;

@end
