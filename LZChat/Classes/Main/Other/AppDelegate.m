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
#import "LZTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc]initWithFrame: [UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor grayColor];
    self.window  = window;
    
    [self configAVCloudWithLaunchOptions:launchOptions];
    
    // 配置 HUD
    [self configHUD];
    
    // 配置友盟
    [self configUmen];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *absoluteString = [url absoluteString];
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result) {
        if (result == FALSE) {
            LZLog(@"result:%d",result);
        }
    }
    
    if ([absoluteString hasPrefix:@"MyAppText://"]) {
        LZLog(@"sourceApplication%@",sourceApplication);
        LZLog(@"%@",absoluteString);
        LZLog(@"annotation%@",annotation);
        NSString *urlString = [absoluteString stringByReplacingOccurrencesOfString:@"MyAppText://" withString:@""];
        NSArray *parameArr = [urlString componentsSeparatedByString:@"&"];
        NSString *address = parameArr[2];
        LZLog(@"%@",[address stringByRemovingPercentEncoding]);
        return YES;
    }
    
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSString *urlString = [url absoluteString];
    
    LZLog(@"%@",urlString);
    
    return YES;
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

- (void)configAVCloudWithLaunchOptions:(NSDictionary*)launchOptions {
    //    如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId: kLeanCloudAppID
                      clientKey:kLeanCloudAppKey];
    // 跟踪应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // 设置接受离线消息的方式
    [AVIMClient setUserOptions:@{
                                 AVIMUserOptionUseUnread: @(iSReceiveMessageBYSelf)
                                 }];
    
    // 切换合适的主窗口
    AVUser *user =  [AVUser currentUser];
    if (user) {
        self.window.rootViewController = [[LZTabBarController alloc]init];
        [self.window makeKeyAndVisible];
    } else {
        self.window.rootViewController = [[LZLoginViewController alloc] init];
        [self.window makeKeyAndVisible];
    }

}

@end
