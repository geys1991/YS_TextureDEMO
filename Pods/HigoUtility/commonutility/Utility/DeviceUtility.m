//
//  DeviceUtility.m
//
//  Created by zhaojunwei on 2/20/14.
//  Modified by taowang on 2014-03-06.
//  Copyright (c) 2014 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceUtility.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "sys/utsname.h"

@implementation DeviceUtility

+ (CGFloat)iosVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSInteger)iosMajorVersion
{
    static int majorVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* version = [[UIDevice currentDevice] systemVersion];
        majorVersion = [[version componentsSeparatedByString:@"."][0] intValue];
    });
    return majorVersion;
}

+ (BOOL)isiOS5
{
    return [self iosMajorVersion] == 5;
}

+(BOOL)isiOS7
{
    return [self iosMajorVersion] == 7;
}

+ (BOOL)isiOSGreaterThan7
{
    return [self iosMajorVersion] >= 7;
}

+ (BOOL)isiOSGreaterThan8
{
    return [self iosMajorVersion] >= 8;
}

+ (NSString*)carrierName
{
    static NSString *carrierName = nil;
    if (carrierName == nil) {
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        carrierName = [[carrier carrierName] copy];
    }
    return carrierName;
}


+ (BOOL)isRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(currentMode)] &&
        [UIScreen mainScreen].currentMode.size.width == 640
        )
    {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)is3Dot5InchesScreen
{
    return ([[UIScreen mainScreen] bounds].size.height == 480); // 3.5寸屏幕有两种分辨率，用480判断
}

+ (BOOL)isFourInchesScreen
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)is4Dot7InchesScreen
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)is5Dot5InchesScreen
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)multiplierScale
{
    return [self screenWidth]/320.0;
}

+ (CGFloat)multiplierAdaptPlus
{
    return [self is5Dot5InchesScreen] ? 1.5:1;
}

+ (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (NSString*)deviceName
{
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch 2",    // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch 3",    // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch 4",    // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch 6",
                              
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone 3G",       // (3G)
                              @"iPhone2,1" :@"iPhone 3GS",      // (3GS)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",
                              @"iPhone8,2" :@"iPhone 6S Plus",
                              
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad 3",          // (3rd Generation)
                              @"iPad3,4"   :@"iPad 4",          // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini",       // 3rd Generation iPad Mini - Wifi (model A1599)
                              };
    }
    
    NSString* code = [self deviceString];
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        } else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        } else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}

+ (BOOL)isIPhone6
{
    static BOOL sharedIsIPhone6;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *platform = [self platform];
        sharedIsIPhone6 = [@[@"iPhone7,1", @"iPhone7,2", @"iPhone8,1", @"iPhone8,2"] containsObject:platform];
    });
    return sharedIsIPhone6;
}

+ (BOOL)isStandardIphone6 {
    return ([self isIPhone6] &&
            [[UIScreen mainScreen] bounds].size.height == 667.0 &&
            [self isiOSGreaterThan8] &&
            [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale);
}

+ (BOOL)isStandardIphone6Plus {
    return ([self isIPhone6] &&
            [[UIScreen mainScreen] bounds].size.height == 736.0 &&
            [self isiOSGreaterThan8] &&
            [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale);
}

+ (BOOL)isZoomedIphone6 {
    return ([self isIPhone6] &&
            [[UIScreen mainScreen] bounds].size.height == 568.0 &&
            [self isiOSGreaterThan8] &&
            [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale);
}

+ (BOOL)isZoomedIphone6Plus {
    return ([self isIPhone6] &&
            [[UIScreen mainScreen] bounds].size.height == 667.0 &&
            [self isiOSGreaterThan8] &&
            [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale);
}


+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine];
    free(machine);
    return platform;
}


@end
