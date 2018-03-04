//
//  requestViewController.m
//  testproject
//
//  Created by bocom on 2018/2/28.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "requestViewController.h"

@interface requestViewController ()
@property(nonatomic, strong) UITextView *textview;
@end

@implementation requestViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"request";
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadSubview];
    // Do any additional setup after loading the view.
}

- (void)loadSubview {
    UIButton *getBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    [getBtn setTitle:@"get请求" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(getRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVI_HEIGHT);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@(SCREEN_HEIGHT/8));
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    
    UIButton *postBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    [postBtn setTitle:@"post请求" forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVI_HEIGHT);
        make.left.equalTo(getBtn.mas_right);
        make.height.equalTo(@(SCREEN_HEIGHT/8));
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    
    _textview = [[UITextView alloc] init];
    [_textview setBackgroundColor: [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1.0]];
    [_textview setTextColor:[UIColor colorWithRed:0.23 green:0.69 blue:0.27 alpha:1.0]];
    [_textview setEditable:NO];
    [_textview.layer setCornerRadius:5];
    [_textview.layer setMasksToBounds:YES];
    [self.view addSubview:_textview];
    [_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(postBtn.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-5);
        make.width.equalTo(self.view.mas_width).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}
- (void)viewDidLayoutSubviews {
    if ([IOS_VERSION_ARRAY[0] intValue] >= 11) {
        [_textview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-self.view.safeAreaInsets.bottom - 5);
        }];
    }
}

- (void)getRequest{
    NSString *urlStr = @"https://liveapi.v114.com/getlikes";
    NSString *param = @"topic_id=596d5ff28a3b9518cc717c53";
    NSDictionary *dict = @{@"callback" : @"callback", @"url" : urlStr, @"param" : param};
    [self performSelectorOnMainThread:@selector(getRequestWithDict:) withObject:dict waitUntilDone:NO];
}

- (void)postRequest{
    NSString *urlStr = @"https://www.007ka.cn/interface/BCMCouponOrder/GetPhoneInfo.php";
    NSString *param = @"OrderInfo=3wgBrG9ktuDajqMDHYm/q1f65Iidu2BNPQ3%2B/pvblKlKLzx2eeTH4/d2dcDwjyJT";
    NSDictionary *dict = @{@"callback" : @"callback", @"url" : urlStr, @"param" : param};
    [self performSelectorOnMainThread:@selector(postRequestWithDict:) withObject:dict waitUntilDone:NO];
}

- (void)getRequestWithDict:(NSDictionary *) info{
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
    NSLog(@"%@", url.absoluteString);
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
//        NSLog(@"calback: %@", callbackStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_textview setText:callbackStr];
        });
    }];
    [sessionTask resume];
}

- (void)postRequestWithDict:(NSDictionary *) info{
    // 参数
    NSString *callback = info[@"callback"];
    NSString *param = info[@"param"];
    if (!param) {
        param = @"";
    }
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    // 拼装GET请求URL
    NSString *urlString = info[@"url"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //创建sessiontask
    NSLog(@"%@", url.absoluteString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
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
        //        NSLog(@"calback: %@", callbackStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_textview setText:callbackStr];
        });
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
