//
//  SRUserManager.m
//  Kpi
//
//  Created by yanzheng on 2016/9/27.
//  Copyright © 2016年 links. All rights reserved.
//

#import "SRUserManager.h"
#import "SRApiManager.h"
#import "RSA.h"
#import "NSString+MD5.h"
#import "NSMutableDictionary+Signature.h"

#define SRRSAPublicKey @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCYbX4FpDQEBAQUAA4GH6B5LQZ1qVfvP6pEGmsWrCQneSqGSIb3NADC9tjX1Wz4il1a7ABiQKBgQCh8LSvJdGWXVCwq9JNi3u/LD5tK5SFrvAMlon6FQyBsz7KjQgLmekhlNkA8ZRaIMGwr9M47iOivtveYi0Iz1V26ybieMSSYKPQik90UwEhCHJJp5YZfodElH/bTPgqwIDAQAB\n-----END PUBLIC KEY-----"

@implementation SRUserManager

- (id)init
{
    self = [super init];
    if (self) {
        self.currentUserName = [SAMKeychain passwordForService:@"kpi" account:@"CurrentUserName"];
        self.token = [SAMKeychain passwordForService:@"kpi" account:self.currentUserName];
        if (self.token) {
            [[SRApiManager sharedInstance] updateHeaderToken:self.token];
        }
    }
    return self;
}

+ (SRUserManager *)sharedInstance
{
    static dispatch_once_t pred;
    static SRUserManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SRUserManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)signinWithName:(NSString *)name password:(NSString *)password success:(void (^)())success fail:(void (^)(NSString *))fail {
    NSString *encrypedPassword = [RSA encryptString:password publicKey:SRRSAPublicKey];
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"name"];
    [params setObject:encrypedPassword forKey:@"password"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    
    
    [sessionManager POST:ApiMethodUserSignin parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES) {
            self.token = [responseObject objectForKey:@"token"];
            [[SRApiManager sharedInstance] updateHeaderToken:self.token];
            NSError *error = nil;
            [SAMKeychain setPassword:name forService:@"kpi" account:@"CurrentUserName" error:&error];
            DLog(@"error: %@", error);
            [SAMKeychain setPassword:self.token forService:@"kpi" account:name];
            success();
        } else {
            NSString *errMsg = [responseObject objectForKey:@"error_msg"];
            DLog(@"signin error: %@", errMsg);
            fail(errMsg);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
        fail(@"网络错误");
    }];
}

- (void)signout {
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager POST:ApiMethodUserSignout parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
}

@end
