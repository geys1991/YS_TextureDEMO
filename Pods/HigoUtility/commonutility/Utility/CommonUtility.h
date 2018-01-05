//
//  CommonUtility.h
//  Pandora
//
//  Created by zhuxiaohu on 3/25/14.
//  Copyright (c) 2014 zhuxiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface CommonUtility : NSObject

/**
 *  手机号验证
 *
 */
+ (BOOL)isValidMobilePhoneNumber:(NSString *)number;

//正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;

/**
 *  银行卡号验证
 *
 */
+ (BOOL)isValidBankCardNumber:(NSString *)number;

/**
 *  Email验证
 *
 */
+ (BOOL)isValidEmailAddress:(NSString *)email;
/**
 *  身份证验证
 *
 */
+ (BOOL)isCheckUserIdCard: (NSString *) idCard;

/**
 * 用户产生文件，iTunes备份和恢复的时候会包括此目录;app/Documents
 *
 */
+ (NSString *)documentPath;

/**
 * 缓存文件，比如数据库缓存、下载缓存；iTunes不会备份此目录，此目录下文件不会在应用退出删除;app/Library/Caches
 * 比app/tmp时间长，tmp文件夹app退出是就有可能清理；
 * caches文件夹在系统清理磁盘空间时会清理。
 */
+ (NSString *)cachePath;

/**
 * 应用支持数据,如：配置文件、模板文件；iTunes会备份此目录;app/Library/Application support/
 *
 */
+ (NSString *)ApplicationSupportPath;

/**
 *  获取0到1之间的随机数，0.01到0.99之间
 *
 */
+ (CGFloat)getFloatRandom;

/**
 *  从min到(max-1)之间的随机整数
 *
 *  @return     如果min大于max就返回0
 */
+ (NSInteger)getIntegerRandomBetweenMax:(NSInteger)max AndMin:(NSInteger)min;

/**
 *  获取随机CFUUID字符串
 *
 */
+ (NSString *)getCFUUID;

/**
 *  从类名相同命名的xib文件创建实例
 *
 *  @param      aClass      待创建实例的类
 *
 *  @return     创建的实例
 */
+ (id)loadObjectOfClass:(Class)aClass;

/**
 *  从指定xib文件创建实例
 *
 *  @param      aClass      待创建实例的类
 *  @param      nibName     nib文件名
 *  @return     创建的实例
 */
+ (id)loadObjectOfClass:(Class)aClass fromNib:(NSString *)nibName;

/**
 *  截屏
 *
 *  @param      subView     需要截屏的View
 *  @return     图像
 */
+ (UIImage *)captureView:(UIView*)subView;

+ (UIImage *)imageWithColor:(UIColor *)color andRect:(CGRect)rect;


/**
 *  颜色值转换 UIColor，比如：#FF9900、0XFF9900 等颜色字符串，转换为 UIColor 对象
 *
 *  @param      aImage      16进制的颜色字符串
 *  @return     转换后的UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  可控制行间距的字符串
 *
 *  @param      string      文本内容
 *  @param      space       行间距
 *  @param      font        字体
 *  @param      alignment   对齐方式
 *  @return     AttributedString
 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
                                                   lineSpace:(CGFloat)space
                                                        font:(UIFont *)font
                                                   alignment:(NSTextAlignment)alignment;

/**
 *  根据传入的时间戳和时间格式，格式化时间 PS: 常用时间格式：@"yyyy年MM月dd日 HH:mm:ss"；@"yyyy-MM-dd HH:mm:ss"
 *
 *  @param      timestamp    时间戳，为0时表示当前时间
 *  @param      formatstr    时间格式，为空返回当前时间戳
 *  @param      timeZone     ([NSTimeZone systemTimeZone]获得当前时区字符串)
 *
 *  @return     格式化后时间
 */
+ (NSString *)transformTimestamp:(NSString *)timestamp withFormat:(NSString *)formatstr andTimeZome:(NSString *)timeZone;

/**
 *  根据传入的时间戳，使用格式（yyyy年MM月dd日 HH:mm:ss）格式化时间
 *
 *  @param      timestamp    时间戳，为0时表示当前时间
 *
 *  @return     返回格式为yyyy年MM月dd日 HH:mm:ss的时间串
 */
+ (NSString *)transformTimestampInNormalFormat:(NSString *)timestamp;


/**
 *  根据传入的时间戳，使用格式（MM-dd 或 HH:mm）格式化时间
 *
 *  @param      timestamp    时间戳,为0时表示当前时间
 *
 *  @return     如果是今天返回格式为HH:mm，否则返回格式MM-dd
 */
+ (NSString *)transformTimestampSpecialFormat:(NSString *)timestamp;

+(NSString*)imTimeStringWithDate:(NSDate*)date shortVersion:(BOOL)shortVersion;

/**
 *  转换音频格式：普通模式->苹果格式
 *
 *  @param      srcPath    普通格式路径
 *  @param      desPath    苹果格式路径
 */
+ (void)chageStandardFile:(NSString *)srcPath toAppleFile:(NSString *)desPath;

/**
 *  转换音频格式：普通模式->苹果格式
 *
 *  @param      srcPath    苹果格式路径
 *  @param      desPath    普通格式路径
 */
+ (void)changeAppleFile:(NSString *)srcPath toStandardFile:(NSString *)desPath;


/**
 *  DES加密或解密
 *
 *  @param      data       待加密/解密的数据
 *  @param      keyString  是密码（一般是8位）
 *  @param      op         表示加密/解密(kCCEncrypt/kCCDecrypt)
 *  @return     解密/加密后的结果
 */
+ (NSData *)desData:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op;



/**
 *  将字符串编码为base64
 *
 *  @param      str        待转换的字符串
 *
 *  @return     转换后的字符串
 */
+ (NSString *)base64encodeString:(NSString *)str;

/**
 *  将二进制编码为base64
 *
 *  @param      data       待转换的二进制数据
 *
 *  @return     转换后的字符串
 */
// + (NSString *)base64encodeData:(NSData *)data;

/**
 *  将base64串解码，返回string
 *
 *  @param      base64str  待转换的base64串
 *
 *  @return     转换后的字符串
 */
+ (NSString *)stringBase64Decode:(NSString *)base64str;


/**
 *  将base64串解码，返回data
 *
 *  @param      base64str   待转换的base64串
 *
 *  @return     转换后的字符串
 */
//+ (NSData *)dataBase64Decode:(NSString *)base64str;

/**
 *  返回距离传入时间戳与当前时间的间隔
 *
 *  @param      timestamp   时间戳，为0时表示当前时间
 *
 *  @return     刚刚（30分钟以内）、半小时前、1小时前、2小时前、1天前、具体时间
 */
+ (NSString *)descriptionForInterval:(NSInteger)timestamp;

/**
 *  获取两地之间的距离描述
 *
 *  @param      distance   两地之间距离
 *
 *  @return     身边，米，公里，百里外，千里外
 */
+ (NSString *)descriptionForDistance:(NSInteger)distance;

/**
 *  判断给定时期是星期几
 *
 *  @param      theDate    日期
 *
 *  @return
 */
+ (NSString*)weekdayForDate:(NSDate *)theDate;

/**
 *  获取当前时间，格式为yyyy-MM-dd HH:mm:ss
 *
 *  @return     当前日期
 */
+ (NSString*)getCurrentTime;


+ (NSString*)descriptionForCtime:(NSString*)ctime;

// 超过9999, 转为W，保留一位小数
+ (NSString *)formatInterToWan:(NSInteger)num;

//only for test
+(void)test;
@end
