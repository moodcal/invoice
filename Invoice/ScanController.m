//
//  ScanController.m
//  Invoice
//
//  Created by zeppo on 2017/3/15.
//  Copyright © 2017年 links. All rights reserved.
//

#import "ScanController.h"
#import <AVFoundation/AVFoundation.h>

/*
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-280)/2
#define LEFT (SCREEN_WIDTH-280)/2

#define kScanRect CGRectMake(LEFT, TOP, 280, 280)

@interface ScanController () <AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic,strong) UIView *blackLoadingView;

@end

@implementation ScanController

- (void)dealloc
{
    DLog(@"-------------------dealloc");
}

- (UIView *)blackLoadingView
{
    if (!_blackLoadingView) {
        _blackLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, self.view.width, self.view.height-75)];
        _blackLoadingView.backgroundColor = [UIColor clearColor];
        
        BlackLoadingView *loadingView = [[BlackLoadingView alloc] init];
        loadingView.center = CGPointMake(_blackLoadingView.width/2, _blackLoadingView.height/2);
        [_blackLoadingView addSubview:loadingView];
    }
    return _blackLoadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configView];
    
    [self setCropRect:kScanRect];
    
    [self setupCamera];
    //[self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
}

-(void)configView{
    self.view.backgroundColor = [UIColor blackColor];
    UIView *view = [UIUtil drawLineInView:self.view frame:CGRectMake(20, 25, 40, 40) color:[UIColor colorWithHex:0x000000 alpha:0.8]];
    view.layer.cornerRadius = view.height/2;
    
    UIImage *image = [UIImage imageNamed:@"index-Back"];
    UIImageView *imageView = [UIUtil drawCustomImgViewInView:self.view frame:CGRectMake(0, 0, image.size.width, image.size.height) imageName:@"index-Back"];
    imageView.center = view.center;
    
    UIButton *button = [UIUtil drawButtonInView:self.view frame:CGRectMake(view.left-10, view.top-10, view.width+20, view.height+20) iconName:@"" target:self action:@selector(clickBack)];
    button.backgroundColor = [UIColor clearColor];
    
    imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    [UIUtil drawLabelMutiLineInView:self.view frame:CGRectMake(imageView.left, imageView.bottom+20, imageView.width, 0) font:[UIFont systemFontOfSize:14] text:@"将二维码放入扫描框内，即可自动扫描" isCenter:YES color:[UIColor whiteColor]];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 280, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (_session != nil && timer != nil) {
        [_session startRunning];
        [timer setFireDate:[NSDate date]];
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 280, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 280, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 280/SCREEN_WIDTH;
    CGFloat height = 280/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {

        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        DLog(@"扫描结果：%@",stringValue);//01,04,3100162320,80893920,236.75,20170125,54877368153269129828,5F49,
        
        if (stringValue.length > 0) {
            NSArray *array = [stringValue componentsSeparatedByString:@","];
            
            if (array.count >= 6) {
                
                //停止扫描
                [_session stopRunning];
                [timer setFireDate:[NSDate distantFuture]];
                
                if (!self.blackLoadingView.superview) {
                    [self.view addSubview:self.blackLoadingView];
                }
                
                AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:array[2] forKey:@"ticket_code"];
                [params setObject:array[3] forKey:@"ticket_no"];
                [params setObject:array[4] forKey:@"money"];
                [params setObject:[NSString stringWithFormat:@"%@-%@-%@",[array[5] substringWithRange:NSMakeRange(0, 4)],[array[5] substringWithRange:NSMakeRange(4, 2)],[array[5] substringWithRange:NSMakeRange(6, 2)]] forKey:@"invoice_date"];
                [params appendInfo];
                [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
                [sessionManager POST:ApiMethodInvoicsCreate parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"response: %@", jsonStr);
                    
                    [self.blackLoadingView removeFromSuperview];
                    
                    if ([[responseObject objectForKey:@"success"] boolValue]) {
                        InvoiceDetailController *controller = [[InvoiceDetailController alloc] init];
                        controller.invoice = [Invoice yy_modelWithDictionary:[responseObject objectForKey:@"invoice"]];
                        self.navigationController.navigationBar.hidden = NO;
                        [self.navigationController pushViewController:controller animated:NO];
                        
                    } else {
                        DLog(@"request error");
                        
                        [self.view showInfo:@"请求失败" autoHidden:YES];
                        
                        [_session startRunning];
                        [timer setFireDate:[NSDate date]];
                        
                        if ([[responseObject objectForKey:@"error_code"] integerValue] == 401) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    DLog(@"error: %@", error);
                    [self.blackLoadingView removeFromSuperview];
                    
                    [self.view showInfo:@"请求失败" autoHidden:YES];
                    
                    [_session startRunning];
                    [timer setFireDate:[NSDate date]];
                }];
            } else {
                DLog(@"无扫描信息");
            }
            
        } else {
            DLog(@"无扫描信息");
        }
        
    } else {
        DLog(@"无扫描信息");
    }
    
}

- (void)clickBack
{
    if (timer) {
        [timer invalidate];//不能放到dealloc里面，会导致dealloc不执行
        timer = nil;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
