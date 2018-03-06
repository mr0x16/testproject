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
    }
    return self;
}

- (void) layoutSubviews {
    CIFilter *qrfilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrfilter setDefaults];
    NSData *qrdata = [qrStr dataUsingEncoding:NSUTF8StringEncoding];
    [qrfilter setValue:qrdata forKeyPath:@"inputMessage"];
    CIImage *ciImg = [qrfilter outputImage];
    UIImageView *qrimgview = [[UIImageView alloc] initWithImage:[UIImage imageWithCIImage:ciImg]];
    [qrimgview setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:qrimgview];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//
//}


@end
