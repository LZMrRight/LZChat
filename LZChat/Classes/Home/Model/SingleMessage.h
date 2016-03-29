//
//  SingleMessage.h
//  LZChat
//
//  Created by Mr.Right on 16/3/23.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleMessage : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *type;

/** cell高度 */
@property(nonatomic,assign) CGFloat cellHeight;
/** 是否隐藏时间 */
@property(nonatomic,assign,getter=isHideTime) BOOL hideTime;
@end
