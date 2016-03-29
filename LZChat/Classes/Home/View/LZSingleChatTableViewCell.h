//
//  LZSingleChatTableViewCell.h
//  LZChat
//
//  Created by Mr.Right on 16/3/23.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleMessage.h"

@interface LZSingleChatTableViewCell : UITableViewCell
@property(nonatomic,strong) SingleMessage *message;
@end
