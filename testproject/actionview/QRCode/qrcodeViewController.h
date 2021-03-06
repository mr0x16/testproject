//
//  qrcodeViewController.h
//  testproject
//
//  Created by bocom on 2018/3/1.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "marco.h"
#import "cameraPreviewView.h"
#import "masonry.h"
#import "UIViewController+LGSideMenuController.h"
#import "mainViewController.h"
#import "grayLayerView.h"
#import "qrCodeView.h"
#import "AppDelegate.h"

@interface qrcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

typedef NS_ENUM(NSUInteger, Identify_Res) {
    SUCCESS = 1,
    UnKnow = 2,
    No_Access = -1
    
};

@end
