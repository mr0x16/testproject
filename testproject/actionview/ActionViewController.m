//
//  ActionViewController.m
//  testproject
//
//  Created by bocom on 2018/2/27.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController (){
    NSInteger typeNum;
}

@end

@implementation ActionViewController

- (id)initWithType:(NSInteger )type {
    self = [super init];
    if (self) {
        typeNum = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%ld",typeNum];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
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
