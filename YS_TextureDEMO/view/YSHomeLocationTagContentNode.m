//
//  YSHomeLocationTagContentNode.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/15.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSHomeLocationTagContentNode.h"

@interface YSHomeLocationTagContentNode ()

@property (nonatomic, strong) ASImageNode *backgroundCornerImage;

@property (nonatomic, strong) ASImageNode *locationTagNode;

@property (nonatomic, strong) ASTextNode *locationTextNode;

@end

@implementation YSHomeLocationTagContentNode

- (instancetype)init
{
    self = [super init];
    if ( self ) {
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.6];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setLocationText:(NSString *)text
{
    self.locationTextNode.attributedText = [[NSAttributedString alloc] initWithString: text
                                                                           attributes: @{
                                                                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:11]
                                                                                         }];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *insetLocationTagSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(5, 5, 5, 5) child: self.locationTagNode];
    
    ASInsetLayoutSpec *insetLocationTextSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 5, 0, 5) child: self.locationTextNode];
    
    ASStackLayoutSpec *stackLocationSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionHorizontal
                                                                                   spacing: 0
                                                                            justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsCenter
                                                                                  children: @[insetLocationTagSpec, insetLocationTextSpec]];
    
    ASBackgroundLayoutSpec *backgroundCornerImage = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild: stackLocationSpec background: self.backgroundCornerImage];
    
    return backgroundCornerImage;
}

#pragma mark - setter && getter

-(ASImageNode *)backgroundCornerImage
{
    if ( !_backgroundCornerImage ) {
        _backgroundCornerImage = [[ASImageNode alloc] init];
        _backgroundCornerImage.layerBacked = YES;
        UIImage *cornerImage = [UIImage as_resizableRoundedImageWithCornerRadius: 2 cornerColor: [UIColor clearColor] fillColor: [[UIColor blackColor] colorWithAlphaComponent: 0.6]];
        _backgroundCornerImage.image = cornerImage;
    }
    return _backgroundCornerImage;
}

- (ASTextNode *)locationTextNode
{
    if ( !_locationTextNode ) {
        _locationTextNode = [[ASTextNode alloc] init];
        _locationTextNode.layerBacked = YES;
    }
    return _locationTextNode;
}

- (ASImageNode *)locationTagNode
{
    if ( !_locationTagNode ) {
        _locationTagNode = [[ASImageNode alloc] init];
        _locationTagNode.image = [UIImage imageNamed: @"localTag"];
        _locationTagNode.style.preferredSize = CGSizeMake(9, 12);
        _locationTagNode.layerBacked = YES;
    }
    return _locationTagNode;
}

@end
