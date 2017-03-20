//
//  NSString+MD5.m
//  Kpi
//
//  Created by yanzheng on 2016/11/3.
//  Copyright © 2016年 links. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MD5)

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)r:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}

+ (NSString *)r1 {
    return @"dsdfs2kgs234sdfsfdsfsllkj7c43c4489q23iklasdklwddopp23d00a20asdf";
}

+ (NSString *)r2 {
    return [@"8saa2sfb115b0c5" stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
}

+ (NSString *)r3 {
    return [@"3aab5d0d423423961ef23" stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
}

+ (NSString *)r4 {
    return [@"4dfe6764381b8sdfa3452cf87f43857sf" stringByReplacingCharactersInRange:NSMakeRange(2, 2) withString:@""];
}

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
