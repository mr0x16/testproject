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
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) cameraPreviewView *campreview;
@property (nonatomic) mainViewController *mainVC;
@property (nonatomic) BOOL isRuning;
@end

@implementation qrcodeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"QRCode";
        
        self.videoSession = [[AVCaptureSession alloc] init];
        self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
        self.isRuning = NO;
//        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
//        if (!videoDevice) {
//            NSLog(@"后置摄像头无法打开,由于设备初始化失败");
//        } else {
//            NSError *error = nil;
//            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
//            AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
//            videoOutput.alwaysDiscardsLateVideoFrames = YES;
//            dispatch_queue_t queue;
//            queue = dispatch_queue_create("cameraQueue", NULL);
//            [videoOutput setSampleBufferDelegate:self queue:queue];
//            NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
//            NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
//            NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
//            [videoOutput setVideoSettings:videoSettings];
//            [_videoSession startRunning];
//
//            if (!videoInput) {
//                NSLog(@"后置摄像头无法打开,由于Input初始化失败,%@", error);
//            } else {
//                [_videoSession addInput:videoInput];
//                [_videoSession addOutput:videoOutput];
//            }
//        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    dispatch_async(self.sessionQueue, ^{
        [self configureSession];
    });
    self.campreview = [[cameraPreviewView alloc] init];
//    [self.campreview setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.campreview];
    [self.campreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
//    [_videoSession startRunning];
//    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_videoSession];
//    previewLayer.frame = CGRectMake(0, self.view.safeAreaInsets.top, SCREEN_WIDTH, SCREEN_HEIGHT - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom);
//    [self.view.layer addSublayer:previewLayer];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.campreview mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(self.view.safeAreaInsets.top);
//    }];
    self.campreview.videoPreviewLayer.session = self.videoSession;
    self.campreview.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if (!self.isRuning) {
        [self.videoSession startRunning];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.mainVC = (mainViewController *)self.sideMenuController;
    UINavigationController *navigationVC =(UINavigationController *)self.mainVC.rootViewController;
    //这个view应该是全屏的，去掉navigationbar
    navigationVC.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)configureSession {
    
    [self.videoSession beginConfiguration];
    self.videoSession.sessionPreset = AVCaptureSessionPresetPhoto;
    self.videoSession.sessionPreset = AVCaptureSessionPresetHigh;
    //初始化设备
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    if (!videoDevice) {
        videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    
    //初始化设备输入
    NSError *error = nil;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if ([self.videoSession canAddInput:videoDeviceInput]) {
        [self.videoSession addInput:videoDeviceInput];
    } else {
        NSLog(@"无法加入输入信息到session");
        [self.videoSession commitConfiguration];
        return;
    }
    
    AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.videoSession canAddOutput:photoOutput]) {
        photoOutput.highResolutionCaptureEnabled = YES;
        photoOutput.livePhotoCaptureEnabled = NO;
        photoOutput.depthDataDeliveryEnabled = NO;
        [self.videoSession addOutput:photoOutput];
    } else {
        NSLog(@"无法加入输出信息到session");
        [self.videoSession commitConfiguration];
        return;
    }
    [self.videoSession commitConfiguration];
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
