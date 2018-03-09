//
//  AppDelegate.m
//  testproject
//
//  Created by 马雪松 on 2018/2/26.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    NSNumber *showshotalert;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenShot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    ViewController *rootVC = [[ViewController alloc] init];
    leftViewController *leftVC = [[leftViewController alloc] init];
    rightViewController *rightVC = [[rightViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    LGSideMenuController *mainvc = [[LGSideMenuController alloc] initWithRootViewController:navigationController leftViewController:leftVC rightViewController:rightVC];
    
    mainvc.rightViewEnabled = NO;
    mainvc.leftViewWidth = SCREEN_WIDTH*3/5;
    mainvc.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;

//    mainvc.rightViewWidth = 100.0;
//    mainvc.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;

    mainvc.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
//    mainvc.rootViewCoverColorForRightView = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.05];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainvc;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

- (void)takeScreenShot:(NSNotification *)info {
    if (![showshotalert boolValue]) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"截屏了~" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
    }];
    [alert addAction:action];
    [_window.rootViewController presentViewController:alert animated:YES completion:^{
        NSLog(@"正在截屏");
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
