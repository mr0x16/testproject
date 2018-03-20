//
//  chineseSpeechSynthesizer.m
//  testproject
//
//  Created by bocom on 2018/3/20.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "chineseSpeechSynthesizer.h"
@interface chineseSpeechSynthesizer() {
    NSString *speechcontent;
    AVAudioEngine *audioengine;
}

@end

@implementation chineseSpeechSynthesizer

- (id) initWithSpeechString:(NSString *)speechString {
    self = [super init];
    if (self) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:LANGUAGE_TYPE];
        self.synthesizer.delegate = self;
        audioengine = [[AVAudioEngine alloc] init];
        speechcontent = speechString;
    }
    return self;
}

- (void)startvoice {
    //In the begining, there are someting wrong with synthesizer. console area show this message "[TTS] TTSPlaybackCreate unable to initialize dynamics: -3000", speaker work well in simulator but cloudn't work in real phone, so I search at google and find out this page(https://stackoverflow.com/questions/40270738/avspeechsynthesizer-does-not-speak-after-using-sfspeechrecognizer). Finally following code solve my issue.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:@"AVAudioSessionCategoryPlayback" error:&error];
    if (error) {
        NSLog(@"set audio session category error");
        return;
    } else {
        [audioSession setMode:@"AVAudioSessionModeDefault" error:&error];
        if (error) {
            NSLog(@"set audio session mode error");
            return;
        }
    }
    
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];//This property is deprecated -- use MPVolumeView for volume control instead.mpc.volume = 0;
    //end
    __weak typeof(self) weakself = self;
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speechcontent];
        utterance.voice = weakself.voice;
        utterance.rate = SPEECH_SPEED;
        utterance.preUtteranceDelay = 0;
        [weakself.synthesizer speakUtterance:utterance];
    });
}

@end
