//
//  chineseSpeechSynthesizer.h
//  testproject
//
//  Created by bocom on 2018/3/20.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define SPEECH_SPEED 0.5
#define LANGUAGE_TYPE @"zh-CN"
@interface chineseSpeechSynthesizer : NSObject <AVSpeechSynthesizerDelegate>
@property(nonatomic, strong) AVSpeechSynthesisVoice *voice;
@property(nonatomic, strong) AVSpeechSynthesizer *synthesizer;
- (id)initWithSpeechString:(NSString *)speechString;
- (void)startvoice;
@end
