//
//  HGASNetworkImageManager.h
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/10.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AsyncDisplayKit/ASImageProtocols.h>

@interface HGASNetworkImageManager : NSObject <ASImageCacheProtocol, ASImageDownloaderProtocol>

+ (instancetype)shareInstance;

@end
