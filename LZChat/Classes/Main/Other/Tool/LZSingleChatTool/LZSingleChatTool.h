//
//  LZSingleChatTool.h
//  LZChat
//
//  Created by Mr.Right on 16/3/25.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZSingleChatTool : NSObject

@property(nonatomic,copy) NSString *clientName;

/**
 *  发送消息
 *
 *  @param contact 接收方
 *  @param message 消息内容
 *  @param type    消息类型
 */
- (void)sendMessagetoContact:(NSString *)contact WithTextMessage:(NSString *)message AndAttributes:(NSString *)type;
/**
 *  从外部接收消息
 *
 *  @param delegate 传入接收消息的 delegate
 */
- (void)receiveTextMessageWithDegate:(id)delegate;

/**
 *  发送语音消息
 *
 *  @param contact 联系人
 *  @param message 消息
 *  @param type    消息类型
 */
- (void)sendMessagetoContact:(NSString *)contact WithAudioMessage:(NSString *)message AndAttributes:(NSString *)type;
@end
