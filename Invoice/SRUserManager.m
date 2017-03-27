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
        self.CurrentUserPhone = [SAMKeychain passwordForService:@"invoice" account:@"CurrentUserPhone"];
        self.token = [SAMKeychain passwordForService:@"invoice" account:self.CurrentUserPhone];
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

- (void)signupWithName:(NSString *)phone password:(NSString *)password code:(NSString *)code success:(void (^)())success fail:(void (^)(NSString *))fail {
//    NSString *encrypedPassword = [RSA encryptString:password publicKey:SRRSAPublicKey];
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:code forKey:@"code"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    
    [sessionManager POST:ApiMethodUserSignup parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES) {
            self.token = [responseObject objectForKey:@"token"];
            [[SRApiManager sharedInstance] updateHeaderToken:self.token];
            NSError *error = nil;
            [SAMKeychain setPassword:phone forService:@"invoice" account:@"CurrentUserPhone" error:&error];
            DLog(@"error: %@", error);
            [SAMKeychain setPassword:self.token forService:@"invoice" account:phone];
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

- (void)completeUserProfile:(NSString *)email company:(NSString *)company code:(NSString *)code success:(void (^)())success fail:(void (^)(NSString *))fail {    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:code forKey:@"company_code"];
    [params setObject:company forKey:@"company_name"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    
    [sessionManager POST:ApiMethodUserProfile parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES) {
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

- (void)signinWithName:(NSString *)name password:(NSString *)password success:(void (^)())success fail:(void (^)(NSString *))fail {
//    NSString *encrypedPassword = [RSA encryptString:password publicKey:SRRSAPublicKey];
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    
    
    [sessionManager POST:ApiMethodUserSignin parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES) {
            self.token = [responseObject objectForKey:@"token"];
            [[SRApiManager sharedInstance] updateHeaderToken:self.token];
            NSError *error = nil;
            [SAMKeychain setPassword:name forService:@"invoice" account:@"CurrentUserPhone" error:&error];
            DLog(@"error: %@", error);
            [SAMKeychain setPassword:self.token forService:@"invoice" account:name];
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
