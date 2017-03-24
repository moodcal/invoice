//
//  Invoice.m
//  Invoice
//
//  Created by yanzheng on 2017/3/20.
//  Copyright © 2017年 links. All rights reserved.
//

#import "Invoice.h"

@implementation Invoice

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _invoice_id = [dic[@"id"] integerValue];
    return YES;
}

@end
