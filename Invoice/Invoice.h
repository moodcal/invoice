//
//  Invoice.h
//  Invoice
//
//  Created by yanzheng on 2017/3/20.
//  Copyright © 2017年 links. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invoice : NSObject

@property (nonatomic, copy) NSString *check_code;
@property (nonatomic, assign) NSInteger invoice_id;
@property (nonatomic, assign) NSInteger inspect_status;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *invoice_date;
@property (nonatomic, copy) NSString *purchaser_name;
@property (nonatomic, copy) NSString *seller_name;
@property (nonatomic, copy) NSString *taxpayer_no;
@property (nonatomic, copy) NSString *ticket_code;
@property (nonatomic, copy) NSString *ticket_no;

@end
