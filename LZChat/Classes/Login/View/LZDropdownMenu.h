//
//  LZDropdownMenu.h
//  LZChat
//
//  Created by Mr.Right on 16/3/16.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZDropdownMenu;

@protocol LZDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(LZDropdownMenu *)menu;

- (void)dropdownMenuDidShow:(LZDropdownMenu *)menu;
@end

@interface LZDropdownMenu : UIView
@property (nonatomic, weak) id<LZDropdownMenuDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
