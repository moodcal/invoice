//
//  VerifiedInvoiceCell.h
//  Invoice
//
//  Created by yanzheng on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"

@interface VerifiedInvoiceCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)configWithInvoice:(Invoice *)invoice;

@end
