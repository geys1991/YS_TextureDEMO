//
//  TagModel.h
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/15.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "BaseModel.h"

@interface TagModel : BaseModel

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isHot;

@end
