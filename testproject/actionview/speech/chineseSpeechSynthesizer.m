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
    MPVolumeView *volumeView;
    UISlider* volumeViewSlider;
    float systemVolume;
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
    volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 40, 40)];
    volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    [volumeViewSlider setHidden:YES];
    // retrieve system volume
    systemVolume = [[AVAudioSession sharedInstance] outputVolume];
//    NSLog(@"%f",systemVolume);
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:VOICE_VOLUME animated:NO];
    
    // send UI control event to make the change effect right now.
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
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

-(void) speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
//    NSLog(@"voice is finished");
    [volumeViewSlider setValue:systemVolume animated:NO];
}
@end
