//
//  NSString+Utility.m
//  Higirl
//
//  Created by silvon on 15-4-1.
//  Copyright (c) 2015年 ___MEILISHUO___. All rights reserved.
//

#import "NSString+Utility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utility)

- (BOOL)higoContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

- (NSString *)stringValue
{
    return self;
}

#pragma mark - trim
- (NSString *)trimTagCode
{
    return [[self trimSpace] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",。.，?？！!"]];
}

- (NSString *)trimSpace
{
    if (self && [self isKindOfClass:[NSString class]] && [self length] > 0) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return self;
}

- (NSString *)trimSpaceAndNewline
{
    if (self && [self isKindOfClass:[NSString class]] && [self length] > 0) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return self;
}

- (BOOL)isEmptyAfterTrimed
{
    return [[self trimSpaceAndNewline] length] == 0;
}

#pragma mark - 数字内容判断
- (BOOL) isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

-(BOOL) isNumeric
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    return [nf numberFromString:self] != nil;
}

#pragma mark - md5生成
- (NSString *)md5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 外包矩形
- (CGSize)boundingRectWithFont:(UIFont*)font andSize:(CGSize)size
{
    CGSize contentSize = CGSizeZero;
    contentSize = [self boundingRectWithSize:size
                                     options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil].size;
    
    return contentSize;
}

- (CGSize)boundingRectWithFont:(UIFont*)font lineSpacing:(CGFloat)lineSpace andSize:(CGSize)size
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    CGRect paragraphRect =[attributedString boundingRectWithSize:size
                                   options:(NSStringDrawingTruncatesLastVisibleLine |
                                            NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingUsesFontLeading)
                                   context:nil];
    return paragraphRect.size;
}

- (id)objectFromJSONValue
{
    NSError *error;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary*)jsonObject;
        } else if ([jsonObject isKindOfClass:[NSArray class]]) {
            return (NSArray*)jsonObject;
        }
    } 
    return nil;
}

@end
