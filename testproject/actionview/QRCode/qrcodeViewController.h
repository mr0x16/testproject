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
@interface qrcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate>

@end
