//
//  HigoImageInfo.h
//  Higo
//
//  Created by bailu on 8/20/14.
//  Updated by jieli on 4/21/16.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "BaseModel.h"

@interface ImageModel : BaseModel

@property (nonatomic, copy) NSString *originImagePath;
@property (nonatomic, copy) NSString *thumbnailImagePath;
@property (nonatomic, copy) NSString *middleImagePath;
@property (nonatomic, copy) NSString *posterImagePath;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSArray *labels;

- (NSDictionary *)unparseJSONDic;

@end
