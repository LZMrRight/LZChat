//
//  LZTabBarController.m
//  LZChat
//
//  Created by Mr.Right on 16/3/17.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZTabBarController.h"
#import "LZNavigationController.h"
#import "LZHomeTableViewController.h"
#import "LZMeTableViewController.h"

@interface LZTabBarController ()

@end

@implementation LZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVc:[[LZHomeTableViewController alloc] init] title:@"首页" image:@"tabbar_useralhome" selectedImage:@"tabbar_useralhome_click"];
    
    [self setupChildVc:[[LZMeTableViewController alloc] init] title:@"我" image:@"tabbar_me" selectedImage:@"tabbar_me_click"];

}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
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
