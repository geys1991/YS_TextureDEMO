//
//  HGHeaderGoodslistCellNode.m
//  HIGO
//
//  Created by geys1991 on 2017/12/29.
//  Copyright © 2017年 ___HIGO___. All rights reserved.
//

#import "HGHeaderGoodslistCellNode.h"

@interface HGHeaderGoodslistCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *goodInfoImageNode;
@property (nonatomic, strong) ASTextNode *brandNameNode;
@property (nonatomic, strong) ASTextNode *priceNode;

@end

@implementation HGHeaderGoodslistCellNode

-(instancetype)init
{
    self = [super init];
    if ( self ) {
        [self setContent];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setContent
{
    NSArray *jpgs = @[@"https://pic.lehe.com/pic/_o/a1/cb/374ed3a528cb6dd9f5f017a2e9cc_750_750.cz.jpg_c8f6a2d9_s1_375_2000.jpg",
                      @"https://pic.lehe.com/pic/_o/7a/89/0614f0a525894a978544ce1fbb14_750_750.cz.jpg_61897fcb_s1_375_2000.jpg",
                      @"https://pic.lehe.com/pic/_o/95/c6/f3bd6728275038bd8892c5e69c02_750_600.cz.jpg_cd42c1f5_s1_q1_90_750_4000.jpg",
                      @"https://pic.lehe.com/pic/_o/81/1a/f56a1ddbba9777aab7ec40e7d73a_750_750.cz.jpg_702984ea_s1_375_2000.jpg",
                      @"https://pic.lehe.com/pic/_o/0b/1a/b2626ec529510fb3c7ba477e293c_800_800.cz.jpg_e1936aba_s1_q1_90_750_4000.jpg"];
    
    int x = arc4random() % [jpgs count];
    
    self.goodInfoImageNode.URL = [NSURL URLWithString: [jpgs objectAtIndex: x]];
    
    self.brandNameNode.attributedText = [[NSAttributedString alloc] initWithString: @"dasadi"];
    self.priceNode.attributedText = [[NSAttributedString alloc] initWithString: @"100000"];
}

#pragma mark - layout

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *goodInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(5, 10, 5, 10) child: self.goodInfoImageNode];
    ASInsetLayoutSpec *brandInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(5, 10, 5, 10) child: self.brandNameNode];
    ASInsetLayoutSpec *priceInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(5, 10, 5, 10) child: self.priceNode];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical spacing:0 justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsCenter children: @[goodInsetSpec, brandInsetSpec, priceInsetSpec]];
    return stackSpec;
}

#pragma mark - setter && getter

-(ASNetworkImageNode *)goodInfoImageNode
{
    if ( !_goodInfoImageNode ) {
        _goodInfoImageNode = [[ASNetworkImageNode alloc] init];
        _goodInfoImageNode.style.preferredSize = CGSizeMake(80, 80);
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
