//
//  qrcodeViewController.m
//  testproject
//
//  Created by bocom on 2018/3/1.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "qrcodeViewController.h"

@interface qrcodeViewController ()

@end

@implementation qrcodeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"QRCode";
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
