//
//  HGHomeCollectionCellNode.m
//  HIGO
//
//  Created by geys1991 on 2017/12/28.
//  Copyright © 2017年 ___HIGO___. All rights reserved.
//

#import "HGHomeCollectionCellNode.h"
#import "HGCategoryCollectionModel.h"
#import "HGHomeFeedModel.h"
#import "HGHeaderGoodslistCellNode.h"
#import "HGASNetworkImageManager.h"
#import "ImageModel.h"

#import "UIImage+makeCircularImage.h"

static const CGFloat kInnerPadding = 5.0f;

@interface HGHomeCollectionCellNode()<ASCollectionDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) HGCategoryCollectionModel *dataModel;
@property (nonatomic, strong) HGHomeFeedModel *feedModel;


@property (nonatomic, strong) ASNetworkImageNode *authorAvatarNode;
@property (nonatomic, strong) ASNetworkImageNode *certificateIconNode;
@property (nonatomic, strong) ASTextNode *authorNickNameNode;
@property (nonatomic, strong) ASTextNode *certificateNameNode;
@property (nonatomic, strong) ASTextNode *favoriteTextNode;

@property (nonatomic, strong) ASNetworkImageNode *albumImageNode;
@property (nonatomic, strong) ASTextNode *albumContentNumberNode;
@property (nonatomic, strong) ASTextNode *albumTitleNode;
@property (nonatomic, strong) ASTextNode *albumSubTitleNode;
@property (nonatomic, strong) ASImageNode *shadowImageNode;


@property (nonatomic, strong) ASCollectionNode *goodsCollectionNode;

@end

@implementation HGHomeCollectionCellNode

- (instancetype)initWithCollectionModel:(HGCategoryCollectionModel *)model;
{
    self = [super init];
    if ( self ) {
        self.dataModel = model;
        self.automaticallyManagesSubnodes = YES;
        [self setContent];
    }
    return self;
}

- (void)setContent
{
    self.authorNickNameNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataModel.owner.nickName ? : @""];
    self.certificateNameNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataModel.owner.certificateName ? : @""];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.dataModel.rankingText ?: @"" ,self.dataModel.favoriteText ?: @""]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, self.dataModel.rankingText.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:NSMakeRange(self.dataModel.rankingText.length, attributedString.length - self.dataModel.rankingText.length)];

    self.favoriteTextNode.attributedText = attributedString;
    
    self.authorAvatarNode.URL = [NSURL URLWithString:self.dataModel.owner.avatarURL];
    self.certificateIconNode.URL = [NSURL URLWithString:self.dataModel.owner.certificateIconURL];

    self.albumImageNode.URL = [NSURL URLWithString:self.dataModel.coverImage.middleImagePath];
    
    NSMutableAttributedString *countAttribute = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat: @"  %@  ", self.dataModel.goodsCountText]
                                                                                       attributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:11]}];
    self.albumContentNumberNode.attributedText = countAttribute;
    
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString: self.dataModel.title
                                                                                             attributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    
    NSMutableAttributedString *subTitleAttributeString = [[NSMutableAttributedString alloc] initWithString: self.dataModel.desc
                                                                                             attributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}];
    
    self.albumTitleNode.attributedText = titleAttributeString;
    self.albumSubTitleNode.attributedText = subTitleAttributeString;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSMutableArray *childLayouts = [[NSMutableArray alloc] init];
    [childLayouts addObject: [self userInfoLayoutSpec]];
    
//    ASInsetLayoutSpec *spaceInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(10, 0, 0, 0) child:<#(nonnull id<ASLayoutElement>)#>]
    
    
    [childLayouts addObject: [self albumInfoLayoutSpec]];
    [childLayouts addObject: [self goodsInfoLayoutSpec]];
    
    ASStackLayoutSpec *homeCollectionLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                                          spacing: 0
                                                                                   justifyContent: ASStackLayoutJustifyContentStart
                                                                                       alignItems: ASStackLayoutAlignItemsStretch
                                                                                         children: childLayouts];
    return homeCollectionLayoutSpec;
}

#pragma mark - delegate

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return [self.dataModel.goodsList count];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ^{
        HGHeaderGoodslistCellNode *goodElementNode = [[HGHeaderGoodslistCellNode alloc] initWithGoodsInfo: [self.dataModel.goodsList objectAtIndex: indexPath.row]];
        return goodElementNode;
    };
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HGCategoryCollectionGoodsModel *goodModel = [self.dataModel.goodsList objectAtIndex: indexPath.row];
    
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    CGSize itemSize = [goodModel sizeForGoodsWithContrainedToWidth: r.size.width / 3.0f];
    return ASSizeRangeMake(itemSize, itemSize);
}

#pragma mark - init spec

- (ASLayoutSpec *)userInfoLayoutSpec
{
    NSMutableArray *childLayouts = [[NSMutableArray alloc] init];
    
    self.authorAvatarNode.style.preferredSize  = CGSizeMake(30, 30);
    self.authorAvatarNode.style.layoutPosition = CGPointMake(10, 12);
    self.certificateIconNode.style.preferredSize  = CGSizeMake(15, 15);
    self.certificateIconNode.style.layoutPosition = CGPointMake(30, 30);
    ASAbsoluteLayoutSpec *userAvatarImageSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingSizeToFit children: @[self.authorAvatarNode, self.certificateIconNode]];
    [childLayouts addObject: userAvatarImageSpec];
    
    ASInsetLayoutSpec *nickNameInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(10, 0, 0, 0) child: self.authorNickNameNode];
    
    ASStackLayoutSpec *nickNameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                              spacing: 0
                                                                       justifyContent: ASStackLayoutJustifyContentStart
                                                                           alignItems: ASStackLayoutAlignItemsStretch
                                                                             children: @[nickNameInsetSpec, self.certificateNameNode]];
    nickNameSpec.style.flexShrink = 1.0;
    nickNameSpec.style.flexGrow = 1.0;
    [childLayouts addObject: nickNameSpec];
    
    ASCenterLayoutSpec *favoriteSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions: ASCenterLayoutSpecCenteringY
                                                                                  sizingOptions: ASCenterLayoutSpecSizingOptionMinimumY
                                                                                          child: self.favoriteTextNode];
    [childLayouts addObject: favoriteSpec];
    
    ASStackLayoutSpec *headStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionHorizontal
                                                                               spacing: 10
                                                                        justifyContent: ASStackLayoutJustifyContentStart
                                                                            alignItems: ASStackLayoutAlignItemsCenter
                                                                              children: childLayouts];
    
    ASInsetLayoutSpec *headInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 10, 0, 10) child: headStackSpec];
    headInsetSpec.style.spacingAfter = 10;
    
    return headInsetSpec;
}

- (ASLayoutSpec *)albumInfoLayoutSpec
{
    self.albumImageNode.style.preferredSize = CGSizeMake(self.frame.size.width, 250);
    // count
    UIEdgeInsets insets = UIEdgeInsetsMake(10, INFINITY, INFINITY, 10);
    ASInsetLayoutSpec *albumContentNumberSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child: self.albumContentNumberNode];
    ASOverlayLayoutSpec *albumInfoSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: self.albumImageNode overlay: albumContentNumberSpec];
    
    // shadow
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    self.shadowImageNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(r.size.width), ASDimensionMake(150));
    ASInsetLayoutSpec *shadowImageInsetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(INFINITY, 0, 0, 0) child: self.shadowImageNode];
    ASOverlayLayoutSpec *shadowImageOverLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: albumInfoSpec overlay: shadowImageInsetLayoutSpec];
    
    // title
    ASInsetLayoutSpec *titleInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 20, 0, 20) child: self.albumTitleNode];
    ASInsetLayoutSpec *subTitleInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 20, 15, 20) child: self.albumSubTitleNode];
    ASStackLayoutSpec *titleStackLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                                      spacing: 5
                                                                               justifyContent: ASStackLayoutJustifyContentCenter
                                                                                   alignItems: ASStackLayoutAlignItemsCenter
                                                                                     children: @[titleInsetSpec, subTitleInsetSpec]];
    ASInsetLayoutSpec *insetTitleSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(INFINITY, 0, 0, 0) child: titleStackLayoutSpec];
    
    ASOverlayLayoutSpec *titleOverLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: shadowImageOverLayoutSpec overlay: insetTitleSpec];

    return titleOverLayoutSpec;
}

- (ASLayoutSpec *)goodsInfoLayoutSpec
{
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    self.goodsCollectionNode.style.preferredSize = CGSizeMake(r.size.width, 200);
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    ASInsetLayoutSpec *goodsListCollectionSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child: self.goodsCollectionNode];
    
    return goodsListCollectionSpec;
}

#pragma mark - setter && getter

- (ASNetworkImageNode *)authorAvatarNode
{
    if ( !_authorAvatarNode ) {
        _authorAvatarNode = [[ASNetworkImageNode alloc] init];
        _authorAvatarNode.style.preferredSize = CGSizeMake(30, 30);
        _authorAvatarNode.layerBacked = YES;
        [_authorAvatarNode setImageModificationBlock:^UIImage * _Nullable(UIImage * _Nonnull image) {
            CGSize size =CGSizeMake(30, 30);
            return [image makeCircularImageWithSize: size];
        }];
    }
    return _authorAvatarNode;
}

- (ASNetworkImageNode *)certificateIconNode
{
    if ( !_certificateIconNode ) {
        _certificateIconNode = [[ASNetworkImageNode alloc] init];
        _certificateIconNode.style.preferredSize = CGSizeMake(13, 13);
        _certificateIconNode.layerBacked = YES;
    }
    return _certificateIconNode;
}

- (ASTextNode *)authorNickNameNode
{
    if ( !_authorNickNameNode ) {
        _authorNickNameNode = [[ASTextNode alloc] init];
        _authorNickNameNode.maximumNumberOfLines = 1;
        _authorNickNameNode.style.flexShrink =1.0f;
        _authorNickNameNode.layerBacked = YES;
    }
    return _authorNickNameNode;
}

- (ASTextNode *)certificateNameNode
{
    if ( !_certificateNameNode ) {
        _certificateNameNode = [[ASTextNode alloc] init];
        _certificateNameNode.layerBacked = YES;
    }
    return _certificateNameNode;
}

- (ASTextNode *)favoriteTextNode
{
    if ( !_favoriteTextNode ) {
        _favoriteTextNode = [[ASTextNode alloc] init];
        _favoriteTextNode.layerBacked = YES;
    }
    return _favoriteTextNode;
}

- (ASNetworkImageNode *)albumImageNode
{
    if ( !_albumImageNode ) {
        _albumImageNode = [[ASNetworkImageNode alloc] init];
        _albumImageNode.layerBacked = YES;
    }
    return _albumImageNode;
}

- (ASTextNode *)albumContentNumberNode
{
    if ( !_albumContentNumberNode ) {
        _albumContentNumberNode = [[ASTextNode alloc] init];
        _albumContentNumberNode.layerBacked = YES;
        _albumContentNumberNode.backgroundColor = [UIColor lightGrayColor];
    }
    return _albumContentNumberNode;
}

-(ASImageNode *)shadowImageNode
{
    if ( !_shadowImageNode ) {
        _shadowImageNode = [[ASImageNode alloc] init];
        _shadowImageNode.layerBacked = YES;
        _shadowImageNode.image = [UIImage imageNamed: @"index_shadow"];
    }
    return _shadowImageNode;
}

- (ASTextNode *)albumTitleNode
{
    if ( !_albumTitleNode ) {
        _albumTitleNode = [[ASTextNode alloc] init];
        _albumTitleNode.layerBacked = YES;
    }
    return _albumTitleNode;
}

- (ASTextNode *)albumSubTitleNode
{
    if ( !_albumSubTitleNode ) {
        _albumSubTitleNode = [[ASTextNode alloc] init];
        _albumSubTitleNode.layerBacked = YES;
    }
    return _albumSubTitleNode;
}

- (ASCollectionNode *)goodsCollectionNode
{
    if ( !_goodsCollectionNode ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect r = [ UIScreen mainScreen ].applicationFrame;
//        flowLayout.itemSize = CGSizeMake(r.size.width / 3.0f, r.size.width / 3.0f);
        flowLayout.minimumInteritemSpacing = kInnerPadding;
        
        _goodsCollectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
        _goodsCollectionNode.delegate = self;
        _goodsCollectionNode.dataSource = self;
    }
    return _goodsCollectionNode;
}

@end
