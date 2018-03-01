
//
//  marco.h
//  testproject
//
//  Created by bocom on 2018/2/28.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#ifndef marco_h
#define marco_h
//
//#ifdef DEBUG
//
//#define NSLog(format, ...)   fprintf(stderr, "<%s : %d> %s\n",                                           \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
//__LINE__, __func__);                                                        \
//(NSLog)((format), ##__VA_ARGS__);                                           \
//fprintf(stderr, "-------\n");
//
//#else
//
//#define NSL(format, ...)    ;
//
//#endif

#ifdef DEBUG
#define NSLog(format, ...)   fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");
#else
#define NSLog(...)
#define debugMethod()
#endif

#define IOS_VERSION_ARRAY [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAVI_HEIGHT 64

#endif /* marco_h */
