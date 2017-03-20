//
//  NSString+MD5.h
//  Kpi
//
//  Created by yanzheng on 2016/11/3.
//  Copyright © 2016年 links. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)md5;
- (NSString *)urlencode;

+ (NSString *)r:(NSUInteger)length;
+ (NSString *)r1;
+ (NSString *)r2;
+ (NSString *)r3;
+ (NSString *)r4;

@end
