//
//  AppDelegate.m
//  LZChat
//
//  Created by Mr.Right on 16/3/11.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LZLoginViewController.h"
#import <UMSocial.h>
#import <UMSocialSinaSSOHandler.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId: kLeanCloudAppID
                      clientKey:kLeanCloudAppKey];
    // 跟踪应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIWindow *window = [[UIWindow alloc]initWithFrame: [UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    self.window  = window;
    LZLoginViewController *loginVC = [[LZLoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    
    // 配置 HUD
    [self configHUD];
    
    // 配置友盟
    [self configUmen];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result) {
        if (result == FALSE) {
            LZLog(@"result:%d",result);
        }
    }
    
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}

#pragma mark 私有方法
- (void)configHUD {
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
}

- (void)configUmen {
    [UMSocialData setAppKey:kUmenAppkey];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppkey secret:kSinaAppSecret RedirectURL:kSinaRedirectURL];
}

@end
