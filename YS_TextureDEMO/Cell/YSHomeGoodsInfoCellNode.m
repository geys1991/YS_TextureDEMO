//
//  YSHomeGoodsInfoCellNode.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/12.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSHomeGoodsInfoCellNode.h"
#import "YSHomeLocationTagContentNode.h"
#import "YSHomeTagsNode.h"
#import "YSHomeGoodsModel.h"
#import "ImageModel.h"

@interface YSHomeGoodsInfoCellNode()

@property (nonatomic, strong) ASNetworkImageNode *goodInfoImageNode;

@property (nonatomic, strong) YSHomeLocationTagContentNode *locationContentNode;

@property (nonatomic, strong) ASImageNode *likeNode;
@property (nonatomic, strong) ASTextNode *goodsTitleNode;
@property (nonatomic, strong) ASTextNode *goodsSubTitleNode;
@property (nonatomic, strong) ASTextNode *goodsPriceinfoNode;

@property (nonatomic, strong) YSHomeTagsNode *tagsContentNode;

@property (nonatomic, strong) YSHomeGoodsModel *goodsModel;

@end

@implementation YSHomeGoodsInfoCellNode

- (instancetype)initWithGoodsModel:(YSHomeGoodsModel *)goodsModel
{
    self = [super init];
    if ( self ) {
        self.goodsModel = goodsModel;
        [self setContent];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setContent
{
    self.goodInfoImageNode.URL = [NSURL URLWithString: self.goodsModel.mainImage.middleImagePath];

    NSAttributedString *titleAttributeString = [[NSAttributedString alloc] initWithString: self.goodsModel.brandName
                                                                               attributes: @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next" size: 16],
                                                                                             NSForegroundColorAttributeName : [UIColor blackColor]
                                                                                             }];
    
    self.goodsTitleNode.attributedText = titleAttributeString;
    
    NSAttributedString *subTitleAttributeString = [[NSAttributedString alloc] initWithString: self.goodsModel.goodsName
                                                                                  attributes: @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next" size: 16],
                                                                                                NSForegroundColorAttributeName : [UIColor blackColor]
                                                                                                }];
    
    self.goodsSubTitleNode.attributedText = subTitleAttributeString;
    
    NSString *price = self.goodsModel.finalPrice;
    NSString *scale = self.goodsModel.daysSales;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@", price ?: @"", scale ?: @""]];
    [attributedString addAttributes: @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next" size: 16]}
                              range: NSMakeRange(0, price.length + 1)];
    [attributedString addAttributes: @{NSForegroundColorAttributeName : [UIColor blackColor]}
                              range: NSMakeRange(0, price.length + 1)];
    [attributedString addAttributes: @{NSFontAttributeName : [UIFont systemFontOfSize: 13]}
                              range: NSMakeRange(price.length + 1, attributedString.length - price.length - 1)];
    [attributedString addAttributes: @{NSForegroundColorAttributeName : [UIColor lightGrayColor]}
                              range: NSMakeRange(price.length + 1, attributedString.length - price.length - 1)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment: NSTextAlignmentCenter];
    [attributedString addAttribute: NSParagraphStyleAttributeName
                             value: paragraphStyle
                             range: NSMakeRange(0, attributedString.length)];
    
    self.goodsPriceinfoNode.attributedText = attributedString;
    
    [self.locationContentNode setLocationText: self.goodsModel.location];
    
    if ( self.goodsModel.tags.count > 0 ) {
        self.tagsContentNode = [[YSHomeTagsNode alloc] initWithTagsContentWithTagsArray: self.goodsModel.tags];
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSMutableArray *arraySpec = [[NSMutableArray alloc] init];
    
    ASLayoutSpec *goodImageSpec = [self goodSimpleInfoSpecWithConstrainedSize: constrainedSize];
    ASLayoutSpec *goodTitleSpec = [self goodTitlesSpecWithConstrainedSize: constrainedSize];
    
    [arraySpec addObject: goodImageSpec];
    [arraySpec addObject: goodTitleSpec];
    
    if ( self.goodsModel.tags.count > 0 ) {
        self.tagsContentNode.style.height = ASDimensionMake(30);
        ASInsetLayoutSpec *insetTagsContentSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 0, 0, 0)
                                                                                         child: self.tagsContentNode];
        
        [arraySpec addObject: insetTagsContentSpec];
    }
    
    ASStackLayoutSpec *stackGoodInfoLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                         spacing: 0
                                                                                  justifyContent: ASStackLayoutJustifyContentStart
                                                                                      alignItems: ASStackLayoutAlignItemsCenter
                                                                                        children: arraySpec];
    return stackGoodInfoLayoutSpec;
}

#pragma mark - layout specs

- (ASLayoutSpec *)goodSimpleInfoSpecWithConstrainedSize:(ASSizeRange)constrainedSize
{
    // 图片
    CGFloat imageRatio = [self imageRatioFromSize: constrainedSize.max];
    ASRatioLayoutSpec *imageSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio: imageRatio child:self.goodInfoImageNode];
    
    // like btn
    self.likeNode.style.preferredSize = CGSizeMake(25, 25);
    self.likeNode.style.alignSelf = ASStackLayoutAlignSelfEnd;
    
    ASInsetLayoutSpec *insetLikeSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake( 3, 3, 3, 10) child: self.likeNode];

    // space
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.style.flexGrow = 1;
    
    // location
    ASInsetLayoutSpec *insetLocationSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 0, 0, 0) child: self.locationContentNode];
    
    ASStackLayoutSpec *stackGoodsSimpleSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionHorizontal spacing: 0 justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsCenter children: @[insetLocationSpec, spacer,  insetLikeSpec]];
    
    ASInsetLayoutSpec *insetGoodsSimpleSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(INFINITY, 0, 15, 0) child: stackGoodsSimpleSpec];
    
    ASOverlayLayoutSpec *overlayGoodSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: imageSpec  overlay: insetGoodsSimpleSpec];
    
    return overlayGoodSpec;
}

- (ASLayoutSpec *)goodTitlesSpecWithConstrainedSize:(ASSizeRange)constrained
{
    ASInsetLayoutSpec *insetTitleSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake( 10, 20, 0, 20) child: self.goodsTitleNode];
    ASInsetLayoutSpec *insetSubTitleSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake( 5, 20, 0, 20) child: self.goodsSubTitleNode];
    ASInsetLayoutSpec *insetPriceSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake( 5, 20, 0, 20) child: self.goodsPriceinfoNode];
    
    ASStackLayoutSpec *stackGoodInfoSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                                   spacing: 0
                                                                            justifyContent: ASStackLayoutJustifyContentStart
                                                                                alignItems: ASStackLayoutAlignItemsCenter
                                                                                  children: @[insetTitleSpec, insetSubTitleSpec, insetPriceSpec]];
    return stackGoodInfoSpec;
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
        _goodsSubTitleNode.maximumNumberOfLines = 1;
        _goodsSubTitleNode.truncationMode = NSLineBreakByTruncatingTail;
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

- (YSHomeTagsNode *)tagsContentNode
{
    if ( !_tagsContentNode ) {
        _tagsContentNode = [[YSHomeTagsNode alloc] init];
//        _tagsContentNode.style.preferredSize = 
        _tagsContentNode.layerBacked = YES;
    }
    return _tagsContentNode;
}

@end
