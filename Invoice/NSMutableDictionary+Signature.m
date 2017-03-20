//
//  NSMutableDictionary+Signature.m
//  Kpi
//
//  Created by yanzheng on 2016/11/3.
//  Copyright © 2016年 links. All rights reserved.
//

#import "NSMutableDictionary+Signature.h"
#import "NSString+MD5.h"
#import <sys/utsname.h>

@implementation NSMutableDictionary (Signature)

- (NSMutableDictionary *)appendInfo {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *sv = [[UIDevice currentDevice] systemVersion];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *appVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (!appVersion) {
        appVersion = @"unknown";
    }

    // add common params
    [self setObject:@"ios" forKey:@"p"];
    [self setObject:sv forKey:@"sv"];
    [self setObject:appVersion forKey:@"av"];
    [self setObject:machineName forKey:@"m"];
    [self setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000] forKey:@"ts"];
    
    return self;
}

- (NSString *)signature {
    NSMutableArray *sortedKeys = self.allKeys.mutableCopy;
    [sortedKeys sortUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sortedStrs = [NSMutableArray array];
    NSString *keyvalueStr;
    for (NSString *key in sortedKeys) {
        NSObject *value = [self objectForKey:key];
        keyvalueStr = [NSString stringWithFormat:@"%@=%@", key, value];
        [sortedStrs addObject:keyvalueStr];
    }
    NSString *joinedStr = [sortedStrs componentsJoinedByString:@"&"];

    NSString *signKey = [NSString r1];
    signKey = [signKey stringByAppendingString:[NSString r2]];
    signKey = [signKey stringByAppendingString:[NSString r4]];
    signKey = [signKey stringByAppendingString:[NSString r3]];
    NSString *newKey = [signKey stringByReplacingCharactersInRange:NSMakeRange(20, 1) withString:@""];
    newKey = [newKey stringByReplacingCharactersInRange:NSMakeRange(16, 1) withString:@""];
    joinedStr = [joinedStr stringByAppendingString:newKey];
    
    return joinedStr.md5.uppercaseString;
}

@end
