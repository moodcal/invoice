//
//  company.h
//  Invoice
//
//  Created by yanzheng on 2017/3/28.
//  Copyright © 2017年 links. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic, assign) NSInteger company_id;
@property (nonatomic, copy) NSString *company_code;
@property (nonatomic, copy) NSString *name;

@end
