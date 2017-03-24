//
//  InvoiceCell.m
//  Invoice
//
//  Created by yanzheng on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import "InvoiceCell.h"

@implementation InvoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 10;
}

- (void)configWithInvoice:(Invoice *)invoice {
    self.dateLabel.text = invoice.invoice_date;
    self.amountLabel.text = [NSString stringWithFormat:@"%@", invoice.money];
    self.invoiceNumberLabel.text = invoice.ticket_no;
    self.invoiceCodeLabel.text = invoice.ticket_code;
}

@end
