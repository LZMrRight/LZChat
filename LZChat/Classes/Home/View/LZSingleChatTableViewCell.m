//
//  LZSingleChatTableViewCell.m
//  LZChat
//
//  Created by Mr.Right on 16/3/23.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZSingleChatTableViewCell.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@interface LZSingleChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *textButton;

@end

@implementation LZSingleChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 设置时间文本
    self.timeLabel.text =  self.message.time;
    
    // 设置聊天信息
    self.textButton.titleLabel.numberOfLines = 0;

}

- (void)setMessage:(SingleMessage *)message {
    _message = message;
    
    // 时间处理
    if (message.hideTime) { // 隐藏时间
        self.timeLabel.hidden = YES;
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    } else { // 显示时间
        self.timeLabel.text = message.time;
        self.timeLabel.hidden = NO;
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(21);
        }];
    }
    
    // 处理显示的消息文字
    // 设置按钮的文字
    [self.textButton setTitle:self.message.text forState:UIControlStateNormal];
    [self.textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    // 强制更新
    [self layoutIfNeeded];
    
    // 计算文字的尺寸
    CGRect textRect = [self.message.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.timeLabel.font} context:nil];
    
    // 设置按钮的宽度就是titleLabel的宽度
    if (textRect.size.width <= 200) {
        [self.textButton updateConstraints:^(MASConstraintMaker *make) {
            CGFloat buttonW =  textRect.size.width + 30;
            
            make.width.equalTo(buttonW);
        }];
        [self layoutIfNeeded];

    }

    // 设置按钮的高度就是titleLabel的高度
    [self.textButton updateConstraints:^(MASConstraintMaker *make) {
        CGFloat buttonH = self.textButton.titleLabel.frame.size.height + 30;
        if (buttonH < 60) {
            buttonH = 60;
        }
        
        make.height.equalTo(buttonH);
    }];
    
    // 强制更新
    [self layoutIfNeeded];
    
    // 计算当前cell的高度
    CGFloat buttonMaxY = CGRectGetMaxY(self.textButton.frame);
    CGFloat iconMaxY = CGRectGetMaxY(self.iconImageView.frame);
    self.message.cellHeight = MAX(buttonMaxY, iconMaxY) + 10;
}

@end
