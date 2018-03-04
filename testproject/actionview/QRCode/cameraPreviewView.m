//
//  cameraPreviewView.m
//  testproject
//
//  Created by 马雪松 on 2018/3/2.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "cameraPreviewView.h"

@implementation cameraPreviewView

+(Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoPreviewLayer *) videoPreviewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
