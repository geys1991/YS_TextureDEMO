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
#import "ImageModel.h"

static const CGFloat kInnerPadding = 10.0f;

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

@property (nonatomic, strong) ASCollectionNode *goodsCollectionNode;

@end

@implementation HGHomeCollectionCellNode
{
    CGSize _elementSize;
}

- (instancetype)initWithCollectionModel:(HGCategoryCollectionModel *)model;
{
    self = [super init];
    if ( self ) {
        _elementSize =  CGSizeMake(100, 140);
        self.dataModel = model;
        self.automaticallyManagesSubnodes = YES;
        [self setContent];
    }
    return self;
}

- (instancetype)initWithFeedModel:(HGHomeFeedModel *)model
{
    self = [super init];
    if ( self ) {
        _elementSize =  CGSizeMake(100, 140);
        self.feedModel = model;
        self.automaticallyManagesSubnodes = YES;
        
        self.authorNickNameNode.attributedText = @"";
        self.certificateNameNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataModel.owner.certificateName];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.dataModel.rankingText ?: @"" ,self.dataModel.favoriteText ?: @""]];
        [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 255 green:102 blue:102 alpha:1]} range:NSMakeRange(0, self.dataModel.rankingText.length)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 255 green:153 blue:153 alpha:1]} range:NSMakeRange(self.dataModel.rankingText.length, attributedString.length - self.dataModel.rankingText.length)];
        
        self.favoriteTextNode.attributedText = attributedString;
        self.authorAvatarNode.URL = [NSURL URLWithString:self.dataModel.owner.avatarURL  ? : @"" ];
        self.certificateIconNode.URL = [NSURL URLWithString:self.dataModel.owner.certificateIconURL   ? : @""];
        
        self.albumImageNode.URL = [NSURL URLWithString:
//                                   self.dataModel.coverImage.middleImagePath  ? :
                                   @"https://pic.lehe.com/pic/_o/65/80/4ca26c4a246f709f79b5640ac43f_750_700.cz.jpg_78232895_s1_q1_90_750_4000.jpg" ];
        
    }
    return self;
}

- (void)setContent
{
    self.authorNickNameNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataModel.owner.nickName ? : @""];
    self.certificateNameNode.attributedText = [[NSAttributedString alloc] initWithString: self.dataModel.owner.certificateName ? : @""];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.dataModel.rankingText ?: @"" ,self.dataModel.favoriteText ?: @""]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 255 green:102 blue:102 alpha:1]} range:NSMakeRange(0, self.dataModel.rankingText.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 255 green:153 blue:153 alpha:1]} range:NSMakeRange(self.dataModel.rankingText.length, attributedString.length - self.dataModel.rankingText.length)];

    self.favoriteTextNode.attributedText = attributedString;
    self.authorAvatarNode.URL = [NSURL URLWithString:self.dataModel.owner.avatarURL];
    self.certificateIconNode.URL = [NSURL URLWithString:self.dataModel.owner.certificateIconURL];

    self.albumImageNode.URL = [NSURL URLWithString:self.dataModel.coverImage.middleImagePath];

}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSMutableArray *childLayouts = [[NSMutableArray alloc] init];
    [childLayouts addObject: [self userInfoLayoutSpec]];
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
    return 10;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize elementSize = _elementSize;
    
    return ^{
        HGHeaderGoodslistCellNode *goodElementNode = [[HGHeaderGoodslistCellNode alloc] init];
        goodElementNode.style.preferredSize = elementSize;
        return goodElementNode;
    };
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
    
    ASStackLayoutSpec *nickNameSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                              spacing: 2
                                                                       justifyContent: ASStackLayoutJustifyContentStart
                                                                           alignItems: ASStackLayoutAlignItemsStretch
                                                                             children: @[self.authorNickNameNode, self.certificateNameNode]];
    nickNameSpec.style.flexShrink = 1.0;
    nickNameSpec.style.flexGrow = 1.0;
    [childLayouts addObject: nickNameSpec];
    
    [childLayouts addObject: self.favoriteTextNode];
    
    ASStackLayoutSpec *headStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionHorizontal
                                                                               spacing: 10
                                                                        justifyContent: ASStackLayoutJustifyContentStart
                                                                            alignItems: ASStackLayoutAlignItemsCenter
                                                                              children: childLayouts];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 10, 0, 10) child: headStackSpec];;
}

- (ASLayoutSpec *)albumInfoLayoutSpec
{
    self.albumImageNode.style.preferredSize = CGSizeMake(self.frame.size.width, 250);
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, INFINITY, INFINITY, 10);
    ASInsetLayoutSpec *albumContentNumberSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child: self.albumContentNumberNode];
    
    ASOverlayLayoutSpec *albumInfoSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild: self.albumImageNode overlay: albumContentNumberSpec];
    
    return albumInfoSpec;
}

- (ASLayoutSpec *)goodsInfoLayoutSpec
{
    self.goodsCollectionNode.style.preferredSize = CGSizeMake(self.frame.size.width, 140);
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 0, 0, 10);
    ASInsetLayoutSpec *goodsListCollectionSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child: self.goodsCollectionNode];
    
    return goodsListCollectionSpec;
}

#pragma mark - setter && getter

-(ASNetworkImageNode *)authorAvatarNode
{
    if ( !_authorAvatarNode ) {
        _authorAvatarNode = [[ASNetworkImageNode alloc] init];
        _authorAvatarNode.style.preferredSize = CGSizeMake(30, 30);
        _authorAvatarNode.layerBacked = YES;
    }
    return _authorAvatarNode;
}

-(ASNetworkImageNode *)certificateIconNode
{
    if ( !_certificateIconNode ) {
        _certificateIconNode = [[ASNetworkImageNode alloc] init];
        _certificateIconNode.style.preferredSize = CGSizeMake(13, 13);
        _certificateIconNode.layerBacked = YES;
    }
    return _certificateIconNode;
}
-(ASTextNode *)authorNickNameNode
{
    if ( !_authorNickNameNode ) {
        _authorNickNameNode = [[ASTextNode alloc] init];
        _authorNickNameNode.maximumNumberOfLines = 1;
        _authorNickNameNode.style.flexShrink =1.0f;
        _authorNickNameNode.layerBacked = YES;
    }
    return _authorNickNameNode;
}
-(ASTextNode *)certificateNameNode
{
    if ( !_certificateNameNode ) {
        _certificateNameNode = [[ASTextNode alloc] init];
        _certificateNameNode.layerBacked = YES;
    }
    return _certificateNameNode;
}
-(ASTextNode *)favoriteTextNode
{
    if ( !_favoriteTextNode ) {
        _favoriteTextNode = [[ASTextNode alloc] init];
        _favoriteTextNode.layerBacked = YES;
    }
    return _favoriteTextNode;
}

-(ASNetworkImageNode *)albumImageNode
{
    if ( !_albumImageNode ) {
        _albumImageNode = [[ASNetworkImageNode alloc] init];
        _albumImageNode.layerBacked = YES;
    }
    return _albumImageNode;
}


-(ASTextNode *)albumContentNumberNode
{
    if ( !_albumContentNumberNode ) {
        _albumContentNumberNode = [[ASTextNode alloc] init];
        
        _albumContentNumberNode.layerBacked = YES;
    }
    return _albumContentNumberNode;
}
-(ASTextNode *)albumTitleNode
{
    if ( !_albumTitleNode ) {
        _albumTitleNode = [[ASTextNode alloc] init];
        _albumTitleNode.layerBacked = YES;
    }
    return _albumTitleNode;
}
-(ASTextNode *)albumSubTitleNode
{
    if ( !_albumSubTitleNode ) {
        _albumSubTitleNode = [[ASTextNode alloc] init];
        _albumSubTitleNode.layerBacked = YES;
    }
    return _albumSubTitleNode;
}

-(ASCollectionNode *)goodsCollectionNode
{
    if ( !_goodsCollectionNode ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = _elementSize;
        flowLayout.minimumInteritemSpacing = kInnerPadding;
        
        _goodsCollectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
        _goodsCollectionNode.delegate = self;
        _goodsCollectionNode.dataSource = self;
    }
    return _goodsCollectionNode;
}


@end
