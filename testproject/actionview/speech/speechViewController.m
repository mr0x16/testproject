//
//  speechViewController.m
//  testproject
//
//  Created by bocom on 2018/3/15.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "speechViewController.h"

@interface speechViewController ()

@property(nonatomic, strong) UITextView *textview;
@property(nonatomic, strong) UIButton *btnspeech;

@end

@implementation speechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadSubview];
    // Do any additional setup after loading the view.
}

- (void)loadSubview {
    
    _textview = [[UITextView alloc] init];
    _textview.delegate = self;
    [_textview setBackgroundColor: [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1.0]];
    [_textview setTextColor:[UIColor colorWithRed:0.23 green:0.69 blue:0.27 alpha:1.0]];
    [_textview setEditable:YES];
    [_textview.layer setCornerRadius:5];
    [_textview.layer setMasksToBounds:YES];
    _textview.keyboardAppearance = UIKeyboardAppearanceDefault;
    _textview.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textview];
    [_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5);
        make.height.equalTo(@(SCREEN_HEIGHT/2));
        make.width.equalTo(self.view.mas_width).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    _btnspeech = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btnspeech setTitle:@"阅读文本" forState:UIControlStateNormal];
    [_btnspeech addTarget:self action:@selector(speechtextcontent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnspeech];
    [_btnspeech mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SCREEN_HEIGHT/10));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)viewDidLayoutSubviews {
    if ([IOS_VERSION_ARRAY[0] intValue] >= 11) {
        [_textview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(self.view.safeAreaInsets.top + 5);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action

-(void) speechtextcontent {
    NSLog(@"点击");
    chineseSpeechSynthesizer *speech = [[chineseSpeechSynthesizer alloc] initWithSpeechString:_textview.text];
    [speech startvoice];
}

#pragma mark - textview delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
