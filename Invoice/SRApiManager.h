//
//  SRApiManager.h
//  Kpi      b
//zP<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>˘˘>>>>>>><<<<<<<<.....DSFXGHJM,.
//  Created by yanzheng on 2016/9/27.
//  Copyright © 2016年 links. All rights reserved.
//

#ifdef DEBUG
#define ApiHost @"http://10.38.12.109:8088"
//#define ApiHost @"http://10.38.12.97"
#else
//#define ApiHost @"http://10.38.42.45:8086"
#define ApiHost @"https://app.haipingx.cn"
#endif

#define ApiMethodInvoicsList (ApiHost @"/invoices/list")
#define ApiMethodInvoicsCreate (ApiHost @"/invoices/create")
#define ApiMethodInvoicsSingle (ApiHost @"/invoices/single")
#define ApiMethodInvoicsSearch (ApiHost @"/invoices/search")
#define ApiMethodInvoicsBindImage (ApiHost @"/invoices/bind_image")
#define ApiMethodInvoicsExport (ApiHost @"/invoices/export")
#define ApiMethodInvoicsVerify (ApiHost @"/invoices/verify")

#define ApiMethodUserSignup (ApiHost @"/users/signup")
#define ApiMethodUserSignin (ApiHost @"/users/signin")
#define ApiMethodUserSignout (ApiHost @"/users/signout")
#define ApiMethodUserProfile (ApiHost @"/users/profile")
#define ApiMethodUserGetProfile (ApiHost @"/users/get_profile")
#define ApiMethodUserPassword (ApiHost @"/users/password")
#define ApiMethodUserCode (ApiHost @"/users/code")
#define ApiMethodChangePhone (ApiHost @"/users/modifyPhone")

#define ApiMethodInvoicesUpload (ApiHost @"/invoices/upload")


#import <Foundation/Foundation.h>

@interface SRApiManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

+ (SRApiManager *)sharedInstance;

- (void)updateHeaderToken:(NSString *)token;
- (void)updateHeaderCompanyID:(NSString *)companyID;

@end
