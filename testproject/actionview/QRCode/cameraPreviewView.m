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

- (void) layoutSubviews {
    //取景框的蒙版
//    CGFloat test = FINDER_SCALE;
    grayLayerView *layerview = [[grayLayerView alloc] initWidthScale:FINDER_SCALE];
    [self addSubview:layerview];
    [layerview setBackgroundColor:[UIColor clearColor]];
    [layerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
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
