//
//  qrcodeViewController.m
//  testproject
//
//  Created by bocom on 2018/3/1.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "qrcodeViewController.h"

@interface qrcodeViewController (){
    CGFloat campreviewWidth, campreviewHeight, pastbrightlevel;
}
@property (nonatomic , strong) AVCaptureSession *videoSession;
@property (nonatomic , strong) AVCaptureDevice *videoDevice;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) cameraPreviewView *campreview;
@property (nonatomic, strong) UIButton *btnClose, *btnqrChange, *btnAlbum, *btnLight;
@property (nonatomic) mainViewController *mainVC;
@property (nonatomic) BOOL isRuning, canDetect, isLight, isScan;
@property (nonatomic) AVCaptureMetadataOutput *photoOutput;
@property (nonatomic) qrCodeView *qrcodeview;

@end

@implementation qrcodeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"QRCode";
        
        self.videoSession = [[AVCaptureSession alloc] init];
        self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
        self.isRuning = NO;
        self.isLight = NO;
        self.canDetect = YES;
        self.isScan = YES;
    }
    
    return self;
}

#pragma mark - viewcontroller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    dispatch_async(self.sessionQueue, ^{
        [self configureSession];
    });
    [self loadSubview];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //在iOS11以上，将按钮放在安全区域中
    if ([IOS_VERSION_ARRAY[0] intValue] >= 11) {
        [self updateSubviewConstraints];
    }
    [self.view bringSubviewToFront:_btnClose];
    [self.view bringSubviewToFront:_btnqrChange];
    
    self.campreview.videoPreviewLayer.session = self.videoSession;
    self.campreview.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if (!self.isRuning) {
        [self.videoSession startRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    //进来时就要记录一下亮度值，否则disappear的时候pastbrightlevel没有值得话，会被set为0
    pastbrightlevel = [self getScreenBrightness];
    campreviewHeight = CGRectGetHeight(self.campreview.frame);
    self.mainVC = (mainViewController *)self.sideMenuController;
    UINavigationController *navigationVC =(UINavigationController *)self.mainVC.rootViewController;
    //这个view应该是全屏的，去掉navigationbar
    //去掉navigationvc的侧滑返回事件和mainvc的leftshow事件
    [navigationVC.interactivePopGestureRecognizer setEnabled:NO];
    navigationVC.navigationBar.hidden = YES;
    [_mainVC setLeftViewEnabled:NO];
    
    NSError *error = nil;
    //先lock一下
    [_videoDevice lockForConfiguration:&error];
    [_videoDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    //操作完成后，记得进行unlock。
    [_videoDevice unlockForConfiguration];
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self setScreenBrightnessWith:pastbrightlevel];
    [super viewDidDisappear:animated];
}

#pragma mark - about video's Session
- (void)configureSession {
    [self.videoSession beginConfiguration];
//    self.videoSession.sessionPreset = AVCaptureSessionPresetPhoto;
    self.videoSession.sessionPreset = AVCaptureSessionPresetHigh;
    //初始化设备
    _videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    if (!_videoDevice) {
        _videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    
    //初始化设备输入
    NSError *error = nil;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoDevice error:&error];
    if ([self.videoSession canAddInput:videoDeviceInput]) {
        [self.videoSession addInput:videoDeviceInput];
    } else {
        NSLog(@"无法加入输入信息到session");
        [self.videoSession commitConfiguration];
        return;
    }
    
    //初始化输出
    self.photoOutput = [[AVCaptureMetadataOutput alloc] init];//[[AVCapturePhotoOutput alloc] init];
    [self.photoOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    if ([self.videoSession canAddOutput:self.photoOutput]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoOutput.rectOfInterest = [self rectOfInterestByScanViewRect];
        });
        [self.videoSession addOutput:self.photoOutput];
        self.photoOutput.metadataObjectTypes = self.photoOutput.availableMetadataObjectTypes;
    } else {
        NSLog(@"无法加入输出信息到session");
        [self.videoSession commitConfiguration];
        return;
    }
    [self.videoSession commitConfiguration];
}

- (CGRect)rectOfInterestByScanViewRect{
    CGFloat width = CGRectGetWidth(self.campreview.frame);
    CGFloat height = CGRectGetHeight(self.campreview.frame);
    
    CGFloat x = (height - FINDER_SCALE*width)/2/height;////(width - 2*SCREEN_WIDTH)/2/height;
    CGFloat y = (width - FINDER_SCALE*width)/2/width;;
    
    CGFloat w = FINDER_SCALE*width/height;
    CGFloat h = FINDER_SCALE*width/width;
    
    return CGRectMake(x, y, w, h);
}
#pragma mark - button & other action
- (void) hideView {
//    NSLog(@"dismiss!");
    UINavigationController *navigationVC =(UINavigationController *)_mainVC.rootViewController;
    //将navigationbar添加回来
    //启用navigationvc的侧滑事件、启用mainvc的leftshow事件
    [navigationVC.interactivePopGestureRecognizer setEnabled:YES];
    navigationVC.navigationBar.hidden = NO;
    [_mainVC setLeftViewEnabled:YES];
    [navigationVC popViewControllerAnimated:YES];
//    [self popoverPresentationController];
}

- (void) showPhotoAlbum {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"can't open photo album!");
        return;
    }
    UIImagePickerController *photoalbumVC = [[UIImagePickerController alloc] init];
    
    photoalbumVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 4.设置代理
    photoalbumVC.delegate = self;
    
    //push出这个控制器
    [self presentViewController:photoalbumVC animated:YES completion:nil];
}

- (void) switchLight {
    NSString *lightBtnImageName = @"";
    if (self.isLight) {
        lightBtnImageName = @"light_off";
    } else {
        lightBtnImageName = @"light_on";
    }
    self.isLight = !self.isLight;
    [self operateTorchWithSwitch:self.isLight];
    [self.btnLight setBackgroundImage:[UIImage imageNamed:lightBtnImageName] forState:UIControlStateNormal];
}
- (void) operateTorchWithSwitch:(BOOL) state{
    if ([_videoDevice hasTorch]) {
        NSError *error = nil;
        BOOL locked = [_videoDevice lockForConfiguration:&error];
        if (locked) {
            if (state) {
                _videoDevice.torchMode = AVCaptureTorchModeOn;
            } else {
                _videoDevice.torchMode = AVCaptureTorchModeOff;
            }
            [_videoDevice unlockForConfiguration];
        }
    } else {
        NSLog(@"该设备目前无法使用闪光灯。");
    }
}

- (void) changeMode{
    self.isScan = !self.isScan;
    self.canDetect = self.isScan;
    if (!self.isScan) {
        pastbrightlevel = [self getScreenBrightness];
        [self setScreenBrightnessWith:0.8];
        if (self.qrcodeview) {
            [self.qrcodeview setHidden:NO];
        } else {
            self.qrcodeview = [[qrCodeView alloc] initWithInfo:@"https://t.me/Mr0x16"];
            [_qrcodeview setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.qrcodeview];
            [self.qrcodeview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.campreview.mas_centerX);
                make.centerY.equalTo(self.campreview.mas_centerY);
                make.width.equalTo(self.campreview.mas_width).multipliedBy(FINDER_SCALE);
                make.height.equalTo(self.campreview.mas_width).multipliedBy(FINDER_SCALE);
            }];
        }
    
    } else {
        [self setScreenBrightnessWith:pastbrightlevel];
        [self.qrcodeview setHidden:YES];
    }
    [self setNeedsFocusUpdate];
}

- (void) setScreenBrightnessWith:(CGFloat) level{
    CGFloat orilevel = [UIScreen mainScreen].brightness;
    if (orilevel == level) {
        return;
    }
    [[UIScreen mainScreen] setBrightness:level];
//    __block CGFloat orilevel = [UIScreen mainScreen].brightness;
//    orilevel = 0.01*(int)(orilevel/0.01);
//    level = 0.01*(int)(level/0.01);
//    //level值不合法或者和当前亮度一致是直接返回
//    if (orilevel == level || level < 0 || level > 1) {
//        return;
//    }
//    int signsymbol = floor(fabs(level-orilevel)/(level-orilevel));
//    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (level == orilevel) {
//            [timer invalidate];
//        }
//        orilevel += signsymbol*0.1;
//        [[UIScreen mainScreen] setBrightness:orilevel];
//    }];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0001 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (fabs(level - orilevel) < 0.02) {
//            [timer invalidate];
//        }
//        orilevel += signsymbol*0.01;
//        [[UIScreen mainScreen] setBrightness:orilevel];
//    }];
//    [timer fire];
}

- (CGFloat) getScreenBrightness{
    return [[UIScreen mainScreen] brightness];
}

#pragma mark - load&update Subview
- (void) loadSubview {
    self.campreview = [[cameraPreviewView alloc] init];
    //    [self.campreview setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.campreview];
    [self.campreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClose setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.btnClose addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnClose];
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@(SCREEN_WIDTH/12));
        make.height.equalTo(@(SCREEN_WIDTH/12));
    }];
    
    self.btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnAlbum setBackgroundImage:[UIImage imageNamed:@"photoalbum"] forState:UIControlStateNormal];
    [self.btnAlbum addTarget:self action:@selector(showPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnAlbum];
    [self.btnAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.mas_top).offset(-5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@(SCREEN_WIDTH/12));
        make.height.equalTo(@(SCREEN_WIDTH/12));
    }];
    
    self.btnqrChange = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnqrChange setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [self.btnqrChange addTarget:self action:@selector(changeMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnqrChange];
    [self.btnqrChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.equalTo(@(SCREEN_WIDTH/10));
        make.height.equalTo(@(SCREEN_WIDTH/10));
    }];
    
    self.btnLight = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *lightBtnImageName = @"";
    if (self.isLight) {
        lightBtnImageName = @"light_on";
    } else {
        lightBtnImageName = @"light_off";
    }
    [self.btnLight setBackgroundImage:[UIImage imageNamed:lightBtnImageName] forState:UIControlStateNormal];
    [self.btnLight addTarget:self action:@selector(switchLight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLight];
    [self.btnLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(3*SCREEN_HEIGHT/4));
        make.width.equalTo(@(SCREEN_WIDTH/10));
        make.height.equalTo(@(SCREEN_WIDTH/10));
    }];
}

- (void) updateSubviewConstraints {
    [self.btnClose mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(self.view.safeAreaInsets.top);
    }];
    
    [self.btnqrChange mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-self.view.safeAreaInsets.bottom);
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    AVMetadataObjectType typeobject = [[metadataObjects firstObject] type];
    AVMetadataMachineReadableCodeObject *resobject = [metadataObjects lastObject];
    
    if (resobject == nil || !_canDetect) return;
    // 只要扫描到结果就会调用
    if (_canDetect && typeobject == AVMetadataObjectTypeQRCode) {
        NSString *message = resobject.stringValue;
        _canDetect = NO;
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"扫描结果" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"OK Action");
            _canDetect = YES;
            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertcontroller addAction:okAction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    //用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    __block NSString *resultStr = @"";
    if ([feature count] > 0) {
        CIQRCodeFeature *result = feature[0];
        // 2.3取出探测到的数据
        //    for (CIQRCodeFeature *result in feature) {
        //         NSLog(@"%@",result.messageString);
        //    }
        resultStr = result.messageString;
    } else {
        resultStr = @"识别失败!";
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"识别结果" message:resultStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        NSLog(@"OK Action");
            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertcontroller addAction:okAction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }];
}
#pragma mark - MemoryWarning
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
