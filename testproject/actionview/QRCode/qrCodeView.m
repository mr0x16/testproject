//
//  qrCodeView.m
//  testproject
//
//  Created by bocom on 2018/3/6.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "qrCodeView.h"

@implementation qrCodeView {
    NSString *qrStr;
}
- (id) initWithInfo:(NSString *)qrinfo {
    self = [super init];
    qrStr = @"";
    if (self) {
        qrStr = qrinfo;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
         [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void) layoutSubviews {
    CIFilter *qrfilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrfilter setDefaults];
    NSData *qrdata = [qrStr dataUsingEncoding:NSUTF8StringEncoding];
    [qrfilter setValue:qrdata forKeyPath:@"inputMessage"];
    CIImage *ciImg = [qrfilter outputImage];
    UIImage *qrimg = [self resizeCIimage:ciImg WithSize:self.bounds.size];
    UIImageView *qrimgview = [[UIImageView alloc] initWithImage:qrimg];
    [qrimgview setFrame:self.bounds];//CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:qrimgview];
}

- (UIImage *)resizeCIimage:(CIImage *)ciimg WithSize:(CGSize )size {
    UIImage *reImg = [[UIImage alloc] init];
    if (ciimg) {
        CGRect extent = CGRectIntegral(ciimg.extent);
        CGFloat scale_width = size.width/CGRectGetWidth(extent);
        CGFloat scale_height = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scale_width;
        size_t height = CGRectGetHeight(extent) * scale_height;
        
        int bitmapSize;
        int bytesPerRow;
        bytesPerRow   = (width * 4);
        bitmapSize     = (bytesPerRow * height);
        
        unsigned char *bitmap = malloc( bitmapSize );
        
        CGColorSpaceRef colorspaceref = CGColorSpaceCreateDeviceRGB();
        CGContextRef contentref = CGBitmapContextCreate(bitmap, width, height, 8, bytesPerRow, colorspaceref, kCGImageAlphaNoneSkipLast);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imgref = [context createCGImage:ciimg fromRect:extent];
        CGContextSetInterpolationQuality(contentref, kCGInterpolationNone);
        CGContextScaleCTM(contentref, scale_width, scale_height);
        CGContextDrawImage(contentref, extent, imgref);
        
        CGImageRef imagerefResize = CGBitmapContextCreateImage(contentref);
        CGContextRelease(contentref);
        CGImageRelease(imgref);
        reImg = [UIImage imageWithCGImage:imagerefResize];
    }
    return reImg;
}

- (void)event:(UITapGestureRecognizer *)gesture {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:qrStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//
//}


@end
