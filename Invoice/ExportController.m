//
//  ExportController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import "ExportController.h"

@interface ExportController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)startAction:(id)sender;
- (IBAction)endAction:(id)sender;

- (IBAction)sendAction:(id)sender;
@end

@implementation ExportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startButton.layer.cornerRadius = 4;
    self.endButton.layer.cornerRadius = 4;
}

- (IBAction)startAction:(id)sender {
}

- (IBAction)endAction:(id)sender {
}

- (IBAction)sendAction:(id)sender {
}
@end
