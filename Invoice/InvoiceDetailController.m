//
//  InvoiceDetailController.m
//  Invoice
//
//  Created by zeppo on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import "InvoiceDetailController.h"

@interface InvoiceDetailController ()

@end

@implementation InvoiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"index-Back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
