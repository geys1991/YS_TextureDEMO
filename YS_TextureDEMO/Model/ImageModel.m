//
//  HigoImageInfo.m
//  Higo
//
//  Created by bailu on 8/20/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "ImageModel.h"
#import "NSDictionary+HGTypeSafe.h"
#import <NSObjectValue.h>

@implementation ImageModel

- (instancetype)initWithJSONDic:(NSDictionary *)json
{
    self = [super initWithJSONDic:json];
    if (self) {
        json = [json dictionaryValue] ?: @{};
        self.ID = [json hg_stringForKey:@"image_id"];
        _originImagePath = [json hg_stringForKey:@"image_original"];
        _middleImagePath = [json hg_stringForKey:@"image_middle"];
        if (!_middleImagePath) {
            _middleImagePath = _originImagePath;
        }
        _posterImagePath = [json hg_stringForKey:@"image_poster"];
        if (!_posterImagePath) {
            _posterImagePath = _originImagePath;
        }
        _thumbnailImagePath = [json hg_stringForKey:@"image_thumbnail"];
        if (!_thumbnailImagePath) {
            _thumbnailImagePath = _originImagePath;
        }
        
        _width = [json hg_floatForKey:@"image_width"];
        _height = [json hg_floatForKey:@"image_height"];
        
        _tags = [json hg_arrayForKey:@"tags"];
        _labels = [json hg_arrayForKey:@"label"];
    }
    return self;
}

- (NSDictionary *)unparseJSONDic
{
    NSDictionary *retDic = @{@"image_id": self.ID ?: @"",
                             @"image_original" : self.originImagePath ?: @"",
                             @"image_thumbnail" : self.thumbnailImagePath ?: @"",
                             @"image_middle" : self.middleImagePath ?: @"",
                             @"image_poster" : self.posterImagePath ?: @"",
                             @"image_width" : [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:self.width]],
                             @"image_height": [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:self.height]]};
    return retDic;
}

@end
