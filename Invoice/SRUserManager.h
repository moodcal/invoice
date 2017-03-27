//
//  SRUserManager.h
//  Kpi
//
//  Created by yanzheng on 2016/9/27.
//  Copyright © 2016年 links. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRApiManager.h"

@interface SRUserManager : NSObject
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *CurrentUserPhone;

+ (SRUserManager *)sharedInstance;
- (void)signinWithName:(NSString *)name password:(NSString *)password success:(void (^)())success fail:(void (^)(NSString *message))fail;
- (void)signupWithName:(NSString *)name password:(NSString *)password code:(NSString *)code success:(void (^)())success fail:(void (^)(NSString *))fail;
- (void)completeUserProfile:(NSString *)email company:(NSString *)company code:(NSString *)code success:(void (^)())success fail:(void (^)(NSString *))fail;

- (void)signout;

@end
