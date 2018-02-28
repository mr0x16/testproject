//
//  requestViewController.m
//  testproject
//
//  Created by bocom on 2018/2/28.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "requestViewController.h"

@interface requestViewController ()

@end

@implementation requestViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"request";
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubview];
    NSString *urlStr = @"https://www.007ka.cn/interface/BCMCouponOrder/GetPhoneInfo.php";
    NSString *param = @"OrderInfo=3wgBrG9ktuDajqMDHYm/q1f65Iidu2BNPQ3%2B/pvblKlKLzx2eeTH4/d2dcDwjyJT";
    NSDictionary *dict = @{@"callback" : @"callback", @"url" : urlStr, @"param" : param};
    [self performSelectorOnMainThread:@selector(getRequestWithDict:) withObject:dict waitUntilDone:NO];
    // Do any additional setup after loading the view.
}

- (void)loadSubview {
    UIButton *getBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    [getBtn setTitle:@"get请求" forState:UIControlStateNormal];
    [self.view addSubview:getBtn];
}

- (void)getRequestWithDict:(NSDictionary *) info{
    for (NSString *key in info) {
        NSLog(@"key:%@ -- value:%@", key, info[key]);
    }
    // 参数
    NSString *callback = info[@"callback"];
    NSString *param = info[@"param"];
    // 拼装GET请求URL
    NSString *urlString = info[@"url"];
    if ([param length]>0) {
        urlString = [urlString stringByAppendingFormat:@"?%@",param];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    
    //创建sessiontask
    //    NSLog(@"%@", url.absoluteString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSString *callbackStr = @"";
        NSString *dataStr = @"";
        NSString *statusCode = @"";
        if (error != nil) {
            dataStr = [NSString stringWithFormat:@"%@", error];
        }else{
            if (data.length != 0) {
                dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                statusCode = [NSString stringWithFormat:@"%ld",httpResponse.statusCode];
            }
        }
        callbackStr = [NSString stringWithFormat:@"%@('%@','%@')",callback,statusCode,dataStr];
        NSLog(@"calback: %@", callbackStr);
    }];
    [sessionTask resume];
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
