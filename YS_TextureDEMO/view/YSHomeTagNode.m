//
//  YSHomeTagNode.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/16.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSHomeTagNode.h"
#import "TagModel.h"

@interface YSHomeTagNode ()

@property (nonatomic, strong) ASImageNode *borderImageNode;

@property (nonatomic, strong) ASButtonNode *tagNode;

@end

@implementation YSHomeTagNode

- (instancetype)initWithTagModel:(TagModel *)tagModel
{
    self = [super init];
    if ( self ) {
        [self.tagNode setTitle: tagModel.tagName withFont: [UIFont systemFontOfSize: 10] withColor: [UIColor blackColor] forState: UIControlStateNormal];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *insetTagNodeSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(3, 3, 3, 3) child: self.tagNode];

    ASBackgroundLayoutSpec *backgroundBorderImageSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild: insetTagNodeSpec background: self.borderImageNode];
    
    return backgroundBorderImageSpec;
}

-(ASImageNode *)borderImageNode
{
    if ( !_borderImageNode ) {
        _borderImageNode = [[ASImageNode alloc] init];
        
        UIImage *backgroundHiglightedImage = [UIImage as_resizableRoundedImageWithCornerRadius: 3
                                                                                   cornerColor: [UIColor whiteColor]
                                                                                     fillColor: [UIColor whiteColor]
                                                                                   borderColor: [UIColor lightGrayColor]
                                                                                   borderWidth: 0.5];
        
        _borderImageNode.image = backgroundHiglightedImage;
    }
    return _borderImageNode;
}

- (ASButtonNode *)tagNode
{
    if ( !_tagNode ) {
        _tagNode = [[ASButtonNode alloc] init];
    }
    return _tagNode;
}

@end
