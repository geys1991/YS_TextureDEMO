//
//  HGASNetworkImageManager.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/10.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "HGASNetworkImageManager.h"

#import <SDWebImageManager.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface HGASWebImageOperation : NSObject <SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic, nullable) SDWebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic, nullable) NSOperation *cacheOperation;

@end

@implementation HGASWebImageOperation

- (void)setCancelBlock:(nullable SDWebImageNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    @synchronized(self) {
        self.cancelled = YES;
        if (self.cacheOperation) {
            [self.cacheOperation cancel];
            self.cacheOperation = nil;
        }
        if (self.cancelBlock) {
            self.cancelBlock();
            self.cancelBlock = nil;
        }
    }
}

@end

@interface HGASNetworkImageManager () 

@end

@implementation HGASNetworkImageManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static HGASNetworkImageManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[HGASNetworkImageManager alloc] init];
    });
    return manager;
}

#pragma mark - ASImageCacheProtocol

- (void)cachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion
{
    if (ASDisplayNodeThreadIsMain() && callbackQueue == dispatch_get_main_queue()) {
        completion(nil);
    } else {
        dispatch_async(callbackQueue, ^{
            completion(nil);
        });
    }
}

- (void)cachedImageWithURLs:(NSArray<NSURL *> *)URLs callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion
{
    [self cachedImageWithURL: [URLs lastObject]
               callbackQueue: callbackQueue
                  completion:^(id<ASImageContainerProtocol>  _Nullable imageFromCache) {
                      if ( imageFromCache.asdk_image == nil && URLs.count > 1 ) {
                          [self cachedImageWithURLs: [URLs subarrayWithRange: NSMakeRange(0, URLs.count - 1)]
                                      callbackQueue: callbackQueue
                                         completion: completion];
                      }else{
                          completion(imageFromCache);
                      }
                  }];
}

#pragma mark - ASImageDownloaderProtocol

-(id)downloadImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue downloadProgress:(ASImageDownloaderProgress)downloadProgress completion:(ASImageDownloaderCompletion)completion
{
    HGASWebImageOperation * operation = nil;
    operation = [[SDWebImageManager sharedManager] loadImageWithURL: nil options: SDWebImageRetryFailed progress: nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if ( completion ) {
            completion(image, error, operation);
        }
    }];
    
    return operation;
}

-(void)cancelImageDownloadForIdentifier:(id)downloadIdentifier
{
    HGASWebImageOperation *operation = downloadIdentifier;
    if ( ![operation isKindOfClass: [HGASWebImageOperation class]] ) {
        return;
    }else{
        [operation cancel];
    }
}


@end
