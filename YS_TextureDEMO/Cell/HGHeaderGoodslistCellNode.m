//
//  HGHeaderGoodslistCellNode.m
//  HIGO
//
//  Created by geys1991 on 2017/12/29.
//  Copyright © 2017年 ___HIGO___. All rights reserved.
//

#import "HGHeaderGoodslistCellNode.h"
#import "HGASNetworkImageManager.h"
#import "HGCategoryCollectionModel.h"
#import "ImageModel.h"


@interface HGHeaderGoodslistCellNode ()

@property (nonatomic, strong) HGCategoryCollectionGoodsModel *dataInfo;

@property (nonatomic, strong) ASNetworkImageNode *goodInfoImageNode;
@property (nonatomic, strong) ASTextNode *brandNameNode;
@property (nonatomic, strong) ASTextNode *priceNode;

@end

@implementation HGHeaderGoodslistCellNode

-(instancetype)initWithGoodsInfo:(HGCategoryCollectionGoodsModel *)model
{
    self = [super init];
    if ( self ) {
        self.dataInfo = model;
        [self setContent];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setContent
{
    self.goodInfoImageNode.URL = [NSURL URLWithString: self.dataInfo.mainImage.posterImagePath];
    self.brandNameNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataInfo.brandName];
    self.priceNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataInfo.goodsPrice];
}

#pragma mark - layout

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *goodInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 5, 0, 0) child: [self imageSpecWithSize: constrainedSize]];
    ASInsetLayoutSpec *brandInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(5, 0, 0, 0) child: self.brandNameNode];
    ASInsetLayoutSpec *priceInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(3, 0, 0, 0) child: self.priceNode];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical spacing:0 justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsCenter children: @[goodInsetSpec, brandInsetSpec, priceInsetSpec]];
    return stackSpec;
}

- (ASLayoutSpec *)imageSpecWithSize:(ASSizeRange)constrainedSize {
    
    CGFloat imageRatio = [self imageRatioFromSize:constrainedSize.max];
    ASRatioLayoutSpec *imagePlace = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:imageRatio child:self.goodInfoImageNode];
    return imagePlace;
}

- (CGFloat)imageRatioFromSize:(CGSize)size {
    CGFloat imageHeight = size.height;
    CGFloat imageRatio = imageHeight / size.width;
    
    return 1;
}

#pragma mark - setter && getter

-(ASNetworkImageNode *)goodInfoImageNode
{
    if ( !_goodInfoImageNode ) {
        _goodInfoImageNode = [[ASNetworkImageNode alloc] init];
//        _goodInfoImageNode.style.preferredSize = CGSizeMake(80, 80);
        _goodInfoImageNode.layerBacked = YES;
    }
    return _goodInfoImageNode;
}

-(ASTextNode *)brandNameNode
{
    if ( !_brandNameNode ) {
        _brandNameNode = [[ASTextNode alloc] init];
        _brandNameNode.layerBacked = YES;
    }
    return _brandNameNode;
}

-(ASTextNode *)priceNode
{
    if ( !_priceNode ) {
        _priceNode = [[ASTextNode alloc] init];
        _priceNode.layerBacked = YES;
    }
    return _priceNode;
}

@end
