//
//  cameraPreviewView.h
//  testproject
//
//  Created by 马雪松 on 2018/3/2.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//
@import AVFoundation;
#import <UIKit/UIKit.h>

@interface cameraPreviewView : UIView

@property(nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
