//
//  LZSingleChatTool.m
//  LZChat
//
//  Created by Mr.Right on 16/3/25.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZSingleChatTool.h"

@interface LZSingleChatTool ()
@property(nonatomic,strong) AVIMClient *client;
@end

@implementation LZSingleChatTool


#pragma mark - 内部方法
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setClientName:(NSString *)clientName {
    _clientName = [clientName copy];
    self.client = [[AVIMClient alloc]initWithClientId:_clientName];
}

#pragma mark - 外部方法

#pragma mark 发送与接收文本消息
/**
 *  给联系人发送消息
 *
 *  @param host    发送发
 *  @param contact 接受方
 */
- (void)sendMessagetoContact:(NSString *)contact WithTextMessage:(NSString *)message AndAttributes:(NSString *)type {
    // Host 打开 client
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        // host 建立了与 contact 的会话
        NSString *chatName = [NSString stringWithFormat:@"%@ 与 %@",_clientName,contact]; // 聊天名
        [self.client createConversationWithName: chatName clientIds:@[contact] callback:^(AVIMConversation *conversation, NSError *error) {
            // 发送方 发了一条消息给 接受方
            [conversation sendMessage:[AVIMTextMessage messageWithText: message attributes:@{@"type":type}] callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    LZLog(@"发送成功");
                } else if (error) {
                    LZLog(@"%@:发送失败",chatName);
                }
                
            }];
        }];
    }];
}
/**
 *  接收消息
 */
- (void)receiveTextMessageWithDegate:(id)delegate {
    // 客户端 创建了一个 clien
    self.client = [[AVIMClient alloc] initWithClientId:_clientName];
    
    // 设置 client 的 delegate，并实现 delegate 方法
    self.client.delegate = delegate;
    // 客户端  打开 client
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        // ...
        if (succeeded) {
            LZLog(@"%@接受消息配置成功",_clientName);
        }
    }];
}

#pragma mark -发送与接收语音消息
/**
 *  发送语音消息
 *
 *  @param contact 联系人
 *  @param message 语音消息
 */
- (void)sendMessagetoContact:(NSString *)contact WithAudioMessage:(NSString *)message AndAttributes:(NSString *)type {
    // Tom 打开 client
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        // Tom 建立了与 Jerry 的会话
        NSString *chatName = [NSString stringWithFormat:@"%@ 与 %@",_clientName,contact]; // 聊天名
        [self.client createConversationWithName:chatName clientIds:@[contact] callback:^(AVIMConversation *conversation, NSError *error) {
            // Tom 发了一首歌曲给 Jerry
//            AVFile *file = [AVFile fileWithURL:@"http://ac-lhzo7z96.clouddn.com/1427444393952"];
//            AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:@"听听人类的神曲~" file:file attributes:nil];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
            AVFile *file = [AVFile fileWithName:@"music.mp3" contentsAtPath:path];
            AVIMAudioMessage *audio = [AVIMAudioMessage messageWithText:message file: file attributes:@{@"type":type}];
            
            [conversation sendMessage:audio callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    LZLog(@"发送成功!");
                } else if (error) {
                    LZLog(@"发送语音失败:%@",error);
                }
            }];
        
        }];
    }];
}




@end
