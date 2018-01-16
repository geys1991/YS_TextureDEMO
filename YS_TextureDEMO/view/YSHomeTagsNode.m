//
//  YSHomeTagsNode.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/15.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSHomeTagsNode.h"
#import "TagModel.h"
#import "YSHomeTagNode.h"

@interface YSHomeTagsNode ()

@end

@implementation YSHomeTagsNode

- (instancetype)initWithTagsContentWithTagsArray:(NSArray *)tags
{
    self = [super init];
    if ( self ) {
        self.automaticallyManagesSubnodes = YES;
        
        __weak typeof(self) weakSelf = self;
        self.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            return [strongSelf setTagsContentWithTagsArray: tags];
        };
    }
    return self;
}

- (ASLayoutSpec *)setTagsContentWithTagsArray:(NSArray *)tags
{
    if ( tags.count > 0 ) {
        __block NSMutableArray *tagsSpec = [[NSMutableArray alloc] init];
        @weakify(self)
        [tags enumerateObjectsUsingBlock:^(TagModel * tag, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            YSHomeTagNode *tagLabel = [self createTagButtonWithTag:tag index:idx];
            ASInsetLayoutSpec *insetTagLabelSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(0, 0, 0, 5) child: tagLabel];
            [tagsSpec addObject: insetTagLabelSpec];
        }];
        
        ASStackLayoutSpec *stackTagsLabelSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionHorizontal
                                                                                        spacing: 0
                                                                                 justifyContent: ASStackLayoutJustifyContentSpaceAround alignItems: ASStackLayoutAlignItemsCenter
                                                                                       children: tagsSpec];
        return stackTagsLabelSpec;
    }else{
        return [[ASLayoutSpec alloc] init];
    }
}

- (YSHomeTagNode *)createTagButtonWithTag:(TagModel *)tagModel index:(NSInteger)index
{
    YSHomeTagNode *tagNode = [[YSHomeTagNode alloc] initWithTagModel: tagModel];
    return tagNode;
}

@end
