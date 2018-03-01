//
//  qrcodeViewController.m
//  testproject
//
//  Created by bocom on 2018/3/1.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "qrcodeViewController.h"

@interface qrcodeViewController ()
@property (nonatomic , strong) AVCaptureSession *videoSession;
@end

@implementation qrcodeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"QRCode";
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        _videoSession = [[AVCaptureSession alloc] init];
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        if (!videoDevice) {
            NSLog(@"后置摄像头无法打开,由于设备初始化失败");
        } else {
            NSError *error = nil;
            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
            AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
            videoOutput.alwaysDiscardsLateVideoFrames = YES;
            dispatch_queue_t queue;
            queue = dispatch_queue_create("cameraQueue", NULL);
            [videoOutput setSampleBufferDelegate:self queue:queue];
            NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
            NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
            NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
            [videoOutput setVideoSettings:videoSettings];
            [_videoSession startRunning];
            
            if (!videoInput) {
                NSLog(@"后置摄像头无法打开,由于Input初始化失败,%@", error);
            } else {
                [_videoSession addInput:videoInput];
                [_videoSession addOutput:videoOutput];
            }
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_videoSession startRunning];
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_videoSession];
    previewLayer.frame = CGRectMake(0, self.view.safeAreaInsets.top, SCREEN_WIDTH, SCREEN_HEIGHT - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom);
    [self.view.layer addSublayer:previewLayer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
