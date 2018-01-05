//
//  MLSCommonUtility.m
//  Pandora
//
//  Created by zhuxiaohu on 3/25/14.
//  Copyright (c) 2014 zhuxiaohu. All rights reserved.
//

#import "CommonUtility.h"


@implementation CommonUtility

#pragma mark - 正则验证
+ (BOOL)isValidMobilePhoneNumber:(NSString*)number
{

    NSString *pattern = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

+ (BOOL)isValidBankCardNumber:(NSString*)number
{
    static NSPredicate* checker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(\\d{16,19}|\\d{6}[- ]\\d{10,13}|\\d{4}[- ]\\d{4}[- ]\\d{8,11})$"];
    });
    return [checker evaluateWithObject:number];
}

+ (BOOL)isValidEmailAddress:(NSString*)email
{
    static NSPredicate* checker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    });
    return [checker evaluateWithObject:email];
}

+ (BOOL)isCheckUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma mark - 常用路径
+ (NSString*)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString*)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)ApplicationSupportPath
{
    return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark - 生成随机数
+ (CGFloat)getFloatRandom
{
    return (arc4random_uniform(99)+1)/100.0;
}

+ (NSInteger)getIntegerRandomBetweenMax:(NSInteger)max AndMin:(NSInteger)min
{
    if (max < min) {
        return 0;
    }
    NSInteger between = max-min;
    
    NSInteger random = arc4random()%between;
    
    return random+min;
}

+ (NSString*)getCFUUID
{
    CFUUIDRef msgid = CFUUIDCreate(nil);
    NSString *msgidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, msgid));
    CFRelease(msgid);
    
    return msgidString;
}

#pragma mark - 从xib文件创建实例
+ (id)loadObjectOfClass:(Class)aClass
{
    NSString *nibName = NSStringFromClass(aClass);
    return [CommonUtility loadObjectOfClass:aClass fromNib:nibName];
}

+ (id)loadObjectOfClass:(Class)aClass fromNib:(NSString *)nibName
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (id anObject in topLevelObjects) {
        if ([anObject isKindOfClass:aClass]) {
            return anObject;
        }
    }
    return nil;
}


#pragma mark - 图像截取
+ (UIImage *)captureView:(UIView*)subView
{
    
    CGSize pixelSizeOfImage = subView.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(pixelSizeOfImage, NO, 0.0);
    
    // 画图
    [subView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color andRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 杂项
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor colorWithRed:101/255.0f green:96/255.0f blue:116/255.0f alpha:1.000];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor colorWithRed:101/255.0f green:96/255.0f blue:116/255.0f alpha:1.000];
    
    CGFloat alpha = 1.0f;
    if ([cString length] == 8) {
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *alphaString = [cString substringWithRange:range];
        cString = [cString substringFromIndex:2];
        
        unsigned int alphaInt;
        [[NSScanner scannerWithString:alphaString] scanHexInt:&alphaInt];
        alpha = (float)alphaInt / 255.0f;
    }
    
    
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
                                                   lineSpace:(CGFloat) space
                                                        font:(UIFont *)font
                                                   alignment:(NSTextAlignment)alignment
{
    if (!string) {
        string = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [paragraphStyle setAlignment:alignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    return attributedString;
}

#pragma mark - 格式化时间戳
// 根据传入的时间戳和时间格式，格式化时间
+ (NSString *)transformTimestamp:(NSString *)timestamp withFormat:(NSString *)formatstr andTimeZome:(NSString *)timeZone
{
    NSTimeInterval intervale = [timestamp integerValue];
    
    NSDate *time = intervale>0 ? [NSDate dateWithTimeIntervalSince1970:intervale] : [NSDate date];
    
    NSString *dateString;
    if(formatstr == nil){
        dateString = [NSString stringWithFormat:@"%zd",[time timeIntervalSince1970]];
    } else {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:formatstr];
        
        if(timeZone != nil) {
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        }
        dateString = [dateFormat stringFromDate:time];
    }
    
    return dateString;
}

// 使用常用格式(yyyy年MM月dd日 HH:mm:ss)格式化时间
+ (NSString *)transformTimestampInNormalFormat:(NSString *)timestamp
{
    return [CommonUtility transformTimestamp:timestamp withFormat:@"yyyy-MM-dd" andTimeZome:nil];
}

+ (NSString *)transformTimestampSpecialFormat:(NSString *)timestamp
{
    NSString *retStr = nil;
    NSTimeInterval intervale = [timestamp integerValue];
    NSDate *refDate = intervale>0 ? [NSDate dateWithTimeIntervalSince1970:intervale] : [NSDate date];
    
    NSString * todayString = [[[NSDate date] description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    // 如果是今天
    if ([refDateString isEqualToString:todayString]) {
        retStr = [CommonUtility transformTimestamp:timestamp withFormat:@"HH:mm" andTimeZome:nil];
    } else {
        retStr = [CommonUtility transformTimestamp:timestamp withFormat:@"MM-dd" andTimeZome:nil];
    }
    return retStr;
}

+ (NSString*)imTimeStringWithDate:(NSDate*)date shortVersion:(BOOL)shortVersion
{
    if (! date) {
        return @"";
    }
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    
    NSDateComponents* now = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents* target = [calendar components:unit fromDate:date];
    
    NSInteger year = [now year] - [target year];
    
    if (year > 0) {
        if (year == 1) {
            if (shortVersion) {
                return @"去年";
            }
            else {
                return [NSString stringWithFormat:@"去年 %02ld-%02ld",(long)[target month],(long)[target day]];
            }
        }
        
        if (year == 2) {
            if (shortVersion) {
                return @"前年";
            }
            else {
                return [NSString stringWithFormat:@"前年 %02ld-%02ld",(long)[target month],(long)[target day]];
            }
        }
        
        if (shortVersion) {
            [NSString stringWithFormat:@"%ld年",(long)[target year]];
        }
        else {
            return [NSString stringWithFormat:@"%ld年 %ld月%ld日",(long)[target year],(long)[target month],(long)[target day]];
        }
        
        //        return [NSString stringWithFormat:@"%ld年前",(long)year];
    }
    NSInteger month = [now month] - [target month];
    if (month > 0) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"%02ld-%02ld",(long)[target month],(long)[target day]];
        }else{
            return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",(long)[target month],(long)[target day],(long)[target hour],(long)[target minute]];
        }
    }
    NSInteger day = [now day] - [target day];
    if (day == 0) {
        NSInteger hour = [now hour] - [target hour];
        if (hour == 0) {
            NSInteger minute = [now minute] - [target minute];
            if (minute <= 1) {
                return @"刚刚";
            }else if (minute <= 10){
                return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
            }
        }
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)[target hour],(long)[target minute]];
    }
    if (day == 1) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"昨天"];
        }else{
            return [NSString stringWithFormat:@"昨天 %02ld:%02ld",(long)[target hour],(long)[target minute]];
        }
    }
    if (day == 2) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"前天"];
        }else{
            return [NSString stringWithFormat:@"前天 %02ld:%02ld",(long)[target hour],(long)[target minute]];
        }
        
    }
    if (day > 2) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"%02ld-%02ld",(long)[target month],(long)[target day]];
        }else{
            return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",(long)[target month],(long)[target day],(long)[target hour],(long)[target minute]];
        }
    }
    
    
    return nil;
}

#pragma mark - 音频转换

#define HEADER_FILEPATH [[NSBundle mainBundle] pathForResource:@"appleilbcHeader" ofType:@"head"]
+ (void)chageStandardFile:(NSString *)srcPath toAppleFile:(NSString *)desPath
{
    
    NSMutableData *appleIlbcHeaderData = [NSMutableData dataWithContentsOfFile:HEADER_FILEPATH];
    
    NSMutableData *appleILBC = [NSMutableData data];
    //添加头
    [appleILBC appendData:appleIlbcHeaderData];
    
    //添加body,用于计算音频数据段长度
    NSData *bodyData = [NSData dataWithContentsOfFile:srcPath];
    
    //添加长度
    NSInteger length = 0;
    length = 1 + [bodyData length];
    length = ntohl(length);
    [appleILBC appendBytes:&length length:4];
    
    //添加flag
    int flagBytes = 1;
    flagBytes = ntohl(flagBytes);
    [appleILBC appendBytes:&flagBytes length:4];
    
    //添加body
    [appleILBC appendData:bodyData];
    
    [appleILBC writeToFile:desPath atomically:NO];
}

+ (void)changeAppleFile:(NSString *)srcPath toStandardFile:(NSString *)desPath
{
    NSMutableData *appleIlbcData = [NSMutableData dataWithContentsOfFile:srcPath];
    NSInteger length = [appleIlbcData length];
    if (length < 4096)
        return;
    NSRange range = NSMakeRange(4096, length - 4096);
    NSData *standardData = [appleIlbcData subdataWithRange:range];
    
    [standardData writeToFile:desPath atomically:NO];
}

#pragma mark - DES 加密/解密

+ (NSData *)desData:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op
{
    char buffer [1024] ;
    memset(buffer, 0, sizeof(buffer));
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          
                                          kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          [keyString UTF8String],
                                          
                                          kCCKeySizeDES,
                                          
                                          NULL,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          1024,
                                          
                                          &bufferNumBytes);
    if(cryptStatus == kCCSuccess) {
        NSData *returnData =  [NSData dataWithBytes:buffer length:bufferNumBytes];
        return returnData;
    }
    return nil;
    
}

#pragma mark - BASE64

+ (NSString *)base64encodeString:(NSString *)str
{
    
    if ([str length] == 0)
        
        return @"";
    
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}


+ (NSString *)stringBase64Decode:(NSString *)base64str
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64str options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}


// 获取当前时间
+ (NSString*)getCurrentTime
{
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:nowUTC];
    
}


+ (NSString *)descriptionForInterval:(NSInteger)timestamp
{
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now < timestamp) return @"穿越";
    
    NSTimeInterval timeInterval = now - timestamp;
    
    if (timestamp == 0) {
        timeInterval = 0;
    }
    
    NSInteger year = timeInterval / 3600 / 24 / 365;
    NSInteger day = timeInterval / 3600 / 24;
    NSInteger hour = timeInterval / 3600;
    NSInteger minute = ((int)timeInterval % 3600) / 60;
    
    if (year >= 1 || day >= 1) {
        
        return @"1天前";
    }
    
    if (hour >= 2) {
        NSString *finalDate = @"2小时前";
        
        return finalDate;
    }
    
    if (hour >= 1 && hour < 2) {
        NSString *finalDate = @"1小时前";
        
        return finalDate;
    }
    
    if (minute > 30 && minute <= 60) {
        NSString *finalDate = @"半小时前";
        
        return finalDate;
    }
    
    if (minute <= 30) {
        NSString *finalDate = @"刚刚";
        
        return finalDate;
    }
    
    return nil;
}

+ (NSString*)descriptionForCtime:(NSString*)ctime
{
    NSDate* ctimeDate = [NSDate dateWithTimeIntervalSince1970:[ctime doubleValue]];
    NSTimeInterval intervalToNow = (-1) * [ctimeDate timeIntervalSinceNow];
    NSString* intervalString;
    if (intervalToNow < 60) {
        intervalString = [NSString stringWithFormat:@"%.0f秒前",intervalToNow];
    } else if (intervalToNow < 60 * 60) {
        intervalString = [NSString stringWithFormat:@"%.0f分钟前",intervalToNow/60];
    } else if (intervalToNow < 60 * 60 * 24) {
        intervalString = [NSString stringWithFormat:@"%.0f小时前",intervalToNow/60/60];
    } else {
        intervalString = [CommonUtility transformTimestampInNormalFormat:ctime];
    }
    return intervalString;
}

// 获取两地之间的距离描述
+ (NSString *)descriptionForDistance:(NSInteger)distance
{
    if (distance > 0 && distance < 10) {
        return @"身边";
    }
    
    if (distance >= 10 && distance < 1000) {
        return [NSString stringWithFormat:@"%ld米", (long)distance];
    }
    if (distance >= 1000 && distance < 1000*100) {
        CGFloat newDistance = distance/1000.0;
        return [NSString stringWithFormat:@"%0.1f公里", newDistance];
    }
    if (distance >= 100*1000 && distance < 1000*1000) {
        return [NSString stringWithFormat:@"百里外"];
    }
    if (distance >= 1000*1000) {
        return [NSString stringWithFormat:@"千里外"];
    }
    return nil;
}

// 获取星期几
+ (NSString*)weekdayForDate:(NSDate *)theDate
{
    NSString* weekDayString;
    
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:theDate];
    NSInteger weekday = [weekdayComponents weekday];
    
    switch (weekday) {
        case 1:
            weekDayString = @"星期日";
            break;
            
        case 2:
            weekDayString = @"星期一";
            break;
            
        case 3:
            weekDayString = @"星期二";
            break;
            
        case 4:
            weekDayString = @"星期三";
            break;
            
        case 5:
            weekDayString = @"星期四";
            break;
            
        case 6:
            weekDayString = @"星期五";
            break;
            
        case 7:
            weekDayString = @"星期六";
            break;
            
        default:
            return nil;
            break;
    }
    
    return weekDayString;
}

+ (NSString *)formatInterToWan:(NSInteger)num
{
    if (num <= 9999) {
        return [@(num) stringValue];
    } else {
        CGFloat fNum = num/1000;
        num = (fNum +0.5);// 加0.5取整，相当于四舍五入，
        // 从k转到万
        fNum = num/10;
        return [@(fNum) stringValue];
    }
    
}












































+(void)test
{
    NSLog(@"%d",[CommonUtility isValidBankCardNumber:@"123456789012345789"]);
    NSLog(@"%d",[CommonUtility isValidBankCardNumber:@"1234-5678-9012345789"]);
    NSLog(@"%d",[CommonUtility isValidBankCardNumber:@"123456-789012345789"]);
    NSLog(@"%d",[CommonUtility isValidBankCardNumber:@"1234-5678-9012-345789"]);
    NSLog(@"%d",[CommonUtility isValidBankCardNumber:@"1234 5678 9012345789"]);
}








@end
