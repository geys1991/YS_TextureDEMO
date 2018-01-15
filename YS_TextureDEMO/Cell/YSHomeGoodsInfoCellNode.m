//
//  YSHomeGoodsInfoCellNode.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/12.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSHomeGoodsInfoCellNode.h"

#import "YSHomeLocationTagContentNode.h"

@interface YSHomeGoodsInfoCellNode()

@property (nonatomic, strong) ASNetworkImageNode *goodInfoImageNode;

@property (nonatomic, strong) YSHomeLocationTagContentNode *locationContentNode;

@property (nonatomic, strong) ASImageNode *likeNode;
@property (nonatomic, strong) ASTextNode *goodsTitleNode;
@property (nonatomic, strong) ASTextNode *goodsSubTitleNode;
@property (nonatomic, strong) ASTextNode *goodsPriceinfoNode;

@end

@implementation YSHomeGoodsInfoCellNode

- (instancetype)init
{
    self = [super init];
    if ( self ) {
//        self.dataModel = model;
        [self setContent];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setContent
{
    self.goodInfoImageNode.URL = [NSURL URLWithString: @"https://pic.lehe.com/pic/_o/fa/f4/61395965196b9146d5a341ded687_564_338.cz.jpg_f3727384_s1_q1_90_750_4000.jpg"];
    [self.locationContentNode setLocationText: @"北京 中国"];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASLayoutSpec *goodImageSpec = [self goodSimpleInfoSpecWithConstrainedSize: constrainedSize];
    
    ASStackLayoutSpec *goodInfoLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical spacing: 0 justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsCenter children: @[goodImageSpec]];
    
    return goodInfoLayoutSpec;
}

#pragma mark - layout specs

- (ASLayoutSpec *)goodSimpleInfoSpecWithConstrainedSize:(ASSizeRange)constrainedSize
{
    // 图片
    CGFloat imageRatio = [self imageRatioFromSize: constrainedSize.max];
    ASRatioLayoutSpec *imageSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio: imageRatio child:self.goodInfoImageNode];
    
    // like btn
    self.likeNode.style.preferredSize = CGSizeMake(30, 30);
    ASInsetLayoutSpec *insetLikeSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake( INFINITY, INFINITY, 15, 10) child: self.likeNode];
    ASOverlayLayoutSpec *overlayGoodSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: imageSpec  overlay: insetLikeSpec];
    
    // location
    ASInsetLayoutSpec *insetLocationSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(INFINITY, 0, 15, INFINITY) child: self.locationContentNode];
    ASOverlayLayoutSpec *overlayLocationContentSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: overlayGoodSpec  overlay: insetLocationSpec];

    return overlayLocationContentSpec;
}

- (CGFloat)imageRatioFromSize:(CGSize)size {
    CGFloat imageHeight = 300;
    CGFloat imageRatio = imageHeight / size.width;
    return imageRatio;
}

#pragma mark - setter && getter

- (ASNetworkImageNode *)goodInfoImageNode
{
    if ( !_goodInfoImageNode ) {
        _goodInfoImageNode = [[ASNetworkImageNode alloc] init];
        _goodInfoImageNode.layerBacked = YES;
    }
    return _goodInfoImageNode;
}

- (YSHomeLocationTagContentNode *)locationContentNode
{
    if ( !_locationContentNode ) {
        _locationContentNode = [[YSHomeLocationTagContentNode alloc] init];
        _locationContentNode.layerBacked = YES;
    }
    return _locationContentNode;
}

- (ASImageNode *)likeNode
{
    if ( !_likeNode ) {
        _likeNode = [[ASImageNode alloc] init];
        _likeNode.image = [UIImage imageNamed: @"likehome"];
        _likeNode.layerBacked = YES;
    }
    return _likeNode;
}

- (ASTextNode *)goodsTitleNode
{
    if ( !_goodsTitleNode ) {
        _goodsTitleNode = [[ASTextNode alloc] init];
        _goodsTitleNode.layerBacked = YES;
    }
    return _goodsTitleNode;
}

- (ASTextNode *)goodsSubTitleNode
{
    if ( !_goodsSubTitleNode ) {
        _goodsSubTitleNode = [[ASTextNode alloc] init];
        _goodsSubTitleNode.layerBacked = YES;
    }
    return _goodsSubTitleNode;
}

- (ASTextNode *)goodsPriceinfoNode
{
    if ( !_goodsPriceinfoNode ) {
        _goodsPriceinfoNode = [[ASTextNode alloc] init];
        _goodsPriceinfoNode.layerBacked = YES;
    }
    return _goodsPriceinfoNode;
}

@end
