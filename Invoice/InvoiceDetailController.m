//
//  InvoiceDetailController.m
//  Invoice
//
//  Created by zeppo on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import "InvoiceDetailController.h"

@interface InvoiceDetailController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,LKActionSheetDelegate>
@property (nonatomic,strong) UIView *blackLoadingView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) id <SDWebImageOperation> webImageOperation;
@end

@implementation InvoiceDetailController

- (void)dealloc
{
    //取消图片下载
    [self.webImageOperation cancel];

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"index-Back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    
//    self.mutableDictionary = @{
//                        @"ticket_code":@"3100162320",
//                        @"ticket_no":@"80893920",
//                        @"invoice_date":@"2017-02-02",
//                        @"money":@"236.75",
//                        @"image_url":@"",
//                        };
    
    UILabel *label = [UIUtil drawLabelInView:self.view frame:CGRectMake(20, 64+20, self.width-20, 18) font:[UIFont systemFontOfSize:18] text:[NSString stringWithFormat:@"发票号码：%@",self.invoice.ticket_no] isCenter:NO color:[UIColor colorWithHex:0x333333 alpha:1]];
    
    label = [UIUtil drawLabelInView:self.view frame:CGRectMake(20, label.bottom+15, self.width-20, 18) font:[UIFont systemFontOfSize:18] text:[NSString stringWithFormat:@"发票代码：%@",self.invoice.ticket_code] isCenter:NO color:[UIColor colorWithHex:0x333333 alpha:1]];
    
    label = [UIUtil drawLabelInView:self.view frame:CGRectMake(20, label.bottom+15, self.width-20, 18) font:[UIFont systemFontOfSize:18] text:[NSString stringWithFormat:@"开票日期：%@",self.invoice.invoice_date] isCenter:NO color:[UIColor colorWithHex:0x333333 alpha:1]];
    
    label = [UIUtil drawLabelInView:self.view frame:CGRectMake(20, label.bottom+15, self.width-20, 18) font:[UIFont systemFontOfSize:18] text:[NSString stringWithFormat:@"金        额：%@",self.invoice.money] isCenter:NO color:[UIColor colorWithHex:0x333333 alpha:1]];
    
    if ([self.invoice.image_url length] > 0) {
        
        UIImage *image = [UIImage imageNamed:@"tab-saoyisao"];
        float width = self.view.width-20*2;
        float height = image.size.height*width/image.size.width;
        
        UIImageView *imageView = [UIUtil drawCustomImgViewInView:self.view frame:CGRectMake(20, label.bottom+20, width, height) imageName:@"tab-saoyisao"];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        //下载照片
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        self.webImageOperation = [manager downloadImageWithURL:[NSURL URLWithString:self.invoice.image_url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //显示当前进度
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                DLog(@"-request fail:%@-",error.description);
            } else {
                imageView.image = image;
            }
            
        }];
        
        
        UIButton *button = [UIUtil drawButtonInView:imageView frame:imageView.bounds iconName:@"" target:self action:@selector(clickViewPhoto)];
        button.backgroundColor = [UIColor clearColor];
        
        
    } else {
        UIImage *image = [UIImage imageNamed:@"tab-saoyisao"];
        float width = self.view.width-20*2;
        float height = image.size.height*width/image.size.width;
        
        UIImageView *imageView = [UIUtil drawCustomImgViewInView:self.view frame:CGRectMake(20, label.bottom+20, width, height) imageName:@"tab-saoyisao"];
        self.imageView = imageView;
        imageView.userInteractionEnabled = YES;
        [UIUtil drawLineInView:imageView frame:imageView.bounds color:[UIColor colorWithHex:0x000000 alpha:0.3]];

        image = [UIImage imageNamed:@"index-upload"];
        UIImageView *imageView2 = [UIUtil drawCustomImgViewInView:imageView frame:CGRectMake((imageView.width-image.size.width)/2, (imageView.height-image.size.height)/2, image.size.width, image.size.height) imageName:@"index-upload"];

        [UIUtil drawLabelInView:imageView frame:CGRectMake(0, imageView2.bottom+10, imageView.width, 18) font:[UIFont systemFontOfSize:16] text:@"上传发票照片" isCenter:YES color:[UIColor whiteColor]];
        
        UIButton *button = [UIUtil drawButtonInView:imageView frame:imageView.bounds iconName:@"" target:self action:@selector(clickUpload)];
        button.backgroundColor = [UIColor clearColor];
    }

}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickUpload
{
    LKActionSheet *actionSheet = [[LKActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取照片", nil];
    [actionSheet showInView:self.view];
}

- (void)processImage:(UIImage *)image
{
    UIImage *dataImage = [[UIImageUtil sharedInstance] processImage:image];
    if (dataImage) {
        
        if (!self.blackLoadingView.superview) {
            [self.view addSubview:self.blackLoadingView];
        }
        
        AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(dataImage, 1.0)] forKey:@"img_base64"];
        [params appendInfo];
        [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
        [sessionManager POST:ApiMethodInvoicesUpload parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"response: %@", jsonStr);
            
            [self.blackLoadingView removeFromSuperview];
            
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                
                NSString *imageUrl = [responseObject objectForKey:@"image_url"];
                
                AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[NSNumber numberWithInteger:self.invoice.invoice_id] forKey:@"invoice_id"];
                [params setObject:imageUrl forKey:@"image_url"];
                [params appendInfo];
                [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
                [sessionManager POST:ApiMethodInvoicsBindImage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"response: %@", jsonStr);
                    
                    [self.blackLoadingView removeFromSuperview];
                    
                    if ([[responseObject objectForKey:@"success"] boolValue]) {
                        
                        self.invoice.image_url = imageUrl;
                        
                        float top = self.imageView.top;
                        [self.imageView removeFromSuperview];
                        
                        UIImage *image = [UIImage imageNamed:@"tab-saoyisao"];
                        float width = self.view.width-20*2;
                        float height = image.size.height*width/image.size.width;
                        
                        UIImageView *imageView = [UIUtil drawCustomImgViewInView:self.view frame:CGRectMake(20, top, width, height) imageName:@"tab-saoyisao"];
                        imageView.userInteractionEnabled = YES;
                        imageView.image = dataImage;
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.clipsToBounds = YES;

                        UIButton *button = [UIUtil drawButtonInView:imageView frame:imageView.bounds iconName:@"" target:self action:@selector(clickViewPhoto)];
                        button.backgroundColor = [UIColor clearColor];
                        
                    } else {
                        DLog(@"request error");
                        
                        [self.view showInfo:@"请求失败" autoHidden:YES];
                        
                        if ([[responseObject objectForKey:@"error_code"] integerValue] == 401) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    DLog(@"error: %@", error);
                    [self.blackLoadingView removeFromSuperview];
                    
                    [self.view showInfo:@"请求失败" autoHidden:YES];
                    
                }];
                
            } else {
                DLog(@"request error");
                
                [self.view showInfo:@"请求失败" autoHidden:YES];
                
                if ([[responseObject objectForKey:@"error_code"] integerValue] == 401) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"error: %@", error);
            [self.blackLoadingView removeFromSuperview];
            
            [self.view showInfo:@"请求失败" autoHidden:YES];

        }];

        
        
    } else {
        //不支持转换
        [self.view showInfo:@"图片格式不支持" autoHidden:YES];
    }
}

- (void)clickViewPhoto
{
    ViewPhotoController *viewPhotoController = [[ViewPhotoController alloc] init];
    viewPhotoController.photoArray = @[self.invoice.image_url];
    viewPhotoController.currentIdx = 0;
    [self addChildViewController:viewPhotoController];
    viewPhotoController.view.frame = self.view.bounds;
    [self.view addSubview:viewPhotoController.view];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imagePick = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    //处理图片
    [self processImage:imagePick];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LKActionSheetDelegate
- (void)actionSheet:(LKActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = sourceType;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = sourceType;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}


@end
