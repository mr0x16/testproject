//
//  metalViewController.m
//  testproject
//
//  Created by bocom on 2018/3/27.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "metalViewController.h"

@interface metalViewController () {
    id<MTLDevice> device;
    id<MTLCommandQueue> queue;
    MTKView *mtkView;
}

@end

@implementation metalViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Metal";
        device = MTLCreateSystemDefaultDevice();
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (device) {
        NSLog(@"metal device has init");
        queue = device.newCommandQueue;
    }
    mtkView = [[MTKView alloc] init];
    [mtkView setDevice:device];
    [self.view addSubview:mtkView];
    [mtkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(2*SCREEN_HEIGHT/3));
        make.width.equalTo(@(2*SCREEN_WIDTH/3));
    }];
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
    static const float vertexArrayData[] = {
        0.0, 0.5, 0.0, 1.0,
        -0.5, -0.25, 0.0, 1.0,
        0.5, -0.25, 0.0, 1.0
    };
    id<MTLBuffer> vertexBuffer = [device newBufferWithBytes:vertexArrayData length:sizeof(vertexArrayData) options:0];
    UIImage *image = [UIImage imageNamed:@"pooh"];
    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice:device];
    NSError *error;
    id<MTLTexture> sourceTexture = [loader newTextureWithCGImage:image.CGImage options:nil error:&error];
    
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
