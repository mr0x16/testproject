//
//  ViewController.m
//  testproject
//
//  Created by 马雪松 on 2018/2/26.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Simple Project";
//        [self.view setBackgroundColor:[UIColor blackColor]];
        self.view.backgroundColor = [UIColor whiteColor];
        
        // -----
        
        // -----
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
//                                                                                  style:UIBarButtonItemStylePlain
//                                                                                 target:self
//                                                                                 action:@selector(showRightView)];
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
//    UIView *redV = [[UIView alloc] init];
//    [redV setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:redV];
//    [redV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.width.equalTo(@100);
//        make.height.equalTo(@100);
//    }];
//
//    UIView *greenV = [[UIView alloc] init];
//    [greenV setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:greenV];
//    [greenV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.width.equalTo(@100);
//        make.height.equalTo(@100);
//    }];
//    CGFloat PI_FACTOR = 3.1415926/180;
//    greenV.transform = CGAffineTransformMake(cos(PI_FACTOR*5)+1, sin(PI_FACTOR*5), -sin(PI_FACTOR*5)+1, cos(PI_FACTOR*5)+1, 0, 0);
//    greenV.transform = CGAffineTransformMake(cos(PI_FACTOR*45), 0, 0, cos(PI_FACTOR*45), 0, 0);
    
}

- (void) viewWillAppear:(BOOL)animated {
    mainViewController *mainVC = (mainViewController *)self.sideMenuController;
    UINavigationController *navigationVC =(UINavigationController *)mainVC.rootViewController;
    if (navigationVC.navigationBar.isHidden) {
        navigationVC.navigationBar.hidden = NO;
    }
}

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
