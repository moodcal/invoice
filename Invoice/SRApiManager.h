//
//  SRApiManager.h
//  Kpi      b
//zP<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>˘˘>>>>>>><<<<<<<<.....DSFXGHJM,.
//  Created by yanzheng on 2016/9/27.
//  Copyright © 2016年 links. All rights reserved.
//

#ifdef DEBUG
#define ApiHost @"http://10.38.42.45:8086"
//#define ApiHost @"http://10.38.12.97"
#else
//#define ApiHost @"http://10.38.42.45:8086"
#define ApiHost @"https://app.haipingx.cn"
#endif

#define ApiMethodDashboardIncome (ApiHost @"/dashboard/income")
#define ApiMethodDashboardProfit (ApiHost @"/dashboard/profit")
#define ApiMethodDashboardCost (ApiHost @"/dashboard/cost")
#define ApiMethodDashboardHistory (ApiHost @"/dashboard/history")
#define ApiMethodUserSignin (ApiHost @"/users/signin")
#define ApiMethodUserSignout (ApiHost @"/users/signout")
#define ApiMethodIndexesRates (ApiHost @"/indexes/rates")
#define ApiMethodIndexesRate (ApiHost @"/indexes/rate")
#define ApiMethodAdminAppVersion (ApiHost @"/admin/app_version")
#define ApiMethodCompaniesList (ApiHost @"/companies/list")
#define ApiMethodProjects (ApiHost @"/projects/list")
#define ApiMethodProjectDetail (ApiHost @"/projects/detail")

#import <Foundation/Foundation.h>

@interface SRApiManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

+ (SRApiManager *)sharedInstance;

- (void)updateHeaderToken:(NSString *)token;
- (void)updateHeaderCompanyID:(NSString *)companyID;

@end
