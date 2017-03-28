//
//  company.m
//  Invoice
//
//  Created by yanzheng on 2017/3/28.
//  Copyright © 2017年 links. All rights reserved.
//

#import "Company.h"

@implementation Company

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _company_id = [dic[@"id"] integerValue];
    return YES;
}

@end
