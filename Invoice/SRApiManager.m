//
//  SRApiManager.m
//  Kpi
//
//  Created by yanzheng on 2016/9/27.
//  Copyright © 2016年 links. All rights reserved.
//

#import "SRApiManager.h"

@implementation SRApiManager

- (id)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

+ (SRApiManager *)sharedInstance
{
    static dispatch_once_t pred;
    static SRApiManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SRApiManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)updateHeaderToken:(NSString *)token {
    [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
}

- (void)updateHeaderCompanyID:(NSString *)companyID {
    [self.sessionManager.requestSerializer setValue:companyID forHTTPHeaderField:@"comid"];
}

@end
