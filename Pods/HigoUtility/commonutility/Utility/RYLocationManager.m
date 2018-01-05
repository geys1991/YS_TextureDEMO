//
//  RYLocationManager.m
//  Higo
//
//  Created by Ryan on 14/10/23.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "RYLocationManager.h"
#import "DeviceUtility.h"

@implementation RYLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 100.0;
        _locationManager.delegate = self;
        
        self.city = @"";
        self.country = @"";
        self.name = @"";
        self.street = @"";
        self.lastLat = 0.0;
        self.lastLon = 0.0;
    }
    return self;
}

- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        if ([DeviceUtility isiOSGreaterThan8]) {
            SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
                [self.locationManager respondsToSelector:requestSelector]) {
                ((void (*)(id, SEL))[self.locationManager methodForSelector:requestSelector])(self.locationManager, requestSelector);
                [self.locationManager startUpdatingLocation];
            } else {
                [self.locationManager startUpdatingLocation];
            }
        } else {
            [self.locationManager startUpdatingLocation];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(handleLocatingFailed)]) {
            [_delegate handleLocatingFailed];
        }
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *newLocation = [locations lastObject];
    double lat = newLocation.coordinate.latitude;
    double lon = newLocation.coordinate.longitude;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {

        } else if (placemarks.count==0){
            self.lastLat = lat;
            self.lastLon = lon;
            self.country = @"";
            self.city = @"";
            self.name = @"";
            self.street = @"";
            self.countryCode = @"";
            if ([self.delegate respondsToSelector:@selector(handleLocatingFailed)]) {
                [self.delegate handleLocatingFailed];
            }
        } else {
            CLPlacemark *placeMark = [placemarks firstObject];
            NSDictionary *adressDic = placeMark.addressDictionary;
            self.lastLat = lat;
            self.lastLon = lon;
            self.country = [adressDic objectForKey:@"Country"];
            self.city = [adressDic objectForKey:@"State"];
            self.name = [adressDic objectForKey:@"Name"];
            self.street = [adressDic objectForKey:@"Street"];
            self.countryCode = [adressDic objectForKey:@"CountryCode"];
            if ([self.delegate respondsToSelector:@selector(handleLocatingSucceed)]) {
                [self.delegate handleLocatingSucceed];
            }
        }
    }];
    
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // stop the location manager.
    [manager stopUpdatingLocation];
    
    NSString *errorString = @"";
    
    switch([error code]) {
        case kCLErrorDenied:                                                        //Access denied by user
            errorString = @"RYLocationManager: Access to Location Services denied by user";
            break;
        case kCLErrorLocationUnknown:                                               //Probably temporary...
            errorString = @"RYLocationManager: Location data unavailable";
            break;
        default:
            errorString = @"RYLocationManager: An unknown error has occurred";
            break;
    }
    NSLog(@"locationManager error%@", errorString);
    if (_delegate && [_delegate respondsToSelector:@selector(handleLocatingFailed)]) {
        [_delegate handleLocatingFailed];
    }
}

@end
