//
//  Profile.h
//  
//
//  Created by yanzheng on 2017/3/20.
//
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface Profile : NSObject

@property (nonatomic, strong) Company *company;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;

@end
