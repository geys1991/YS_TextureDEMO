//
//  RYLocationManager.h
//  Higo
//
//  Created by Ryan on 14/10/23.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol RYLocationManagerDelegate <NSObject>
@optional
- (void)handleLocatingSucceed;
@optional
- (void)handleLocatingFailed;
@end

@interface RYLocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id<RYLocationManagerDelegate> delegate;

@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, assign) double lastLat;
@property (nonatomic, assign) double lastLon;
@property (nonatomic, copy) NSString *countryCode;

- (instancetype)init;
- (void)startLocation;

@end