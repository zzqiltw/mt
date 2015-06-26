//
//  ZQViewController.m
//  MT
//
//  Created by zzqiltw on 14-12-26.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ZQViewController.h"
#import "ZQTranslateViewController.h"
#import "ZQNavigationButton.h"

@interface ZQViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)cn2En:(ZQNavigationButton *)sender;

- (IBAction)en2Cn:(ZQNavigationButton *)sender;

- (IBAction)ocrTest:(id)sender;


@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}


- (IBAction)cn2En:(ZQNavigationButton *)sender {
    [self pushToTranslateVC:TranslateTypeCn2En];
}

- (IBAction)en2Cn:(ZQNavigationButton *)sender {
    [self pushToTranslateVC:TranslateTypeEn2Cn];
}

- (IBAction)ocrTest:(id)sender {
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    //判断是否有摄像头
//    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
//    {
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSData *imgData = UIImageJPEGRepresentation(image, 0.0001);
    NSString* encodeResult = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    encodeResult = [encodeResult stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *httpUrl = @"http://apis.baidu.com/apistore/idlocr/ocr";
    NSString *httpArg = [NSString stringWithFormat:@"fromdevice=iPhone&clientip=10.10.10.0&detecttype=LocateRecognize&languagetype=CHN_ENG&imagetype=1&image=%@", encodeResult];
    [self request: httpUrl withHttpArg: httpArg];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSURL *url = [NSURL URLWithString: httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"POST"];
    [request addValue: @"dfd35e6ce265322a3129da6005dc1a8c" forHTTPHeaderField: @"apikey"];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [HttpArg dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
}


- (void)pushToTranslateVC:(TranslateType)type
{
    ZQTranslateViewController *vc = [[ZQTranslateViewController alloc] init];
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
