//
//  LZSingleChatViewController.m
//  LZChat
//
//  Created by Mr.Right on 16/3/22.
//  Copyright © 2016年 lizheng. All rights reserved.
//
#define _contactIDD @"text2"

#import "LZSingleChatViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "LZLoginViewController.h"
#import "LZSingleChatTableViewCell.h"
#import "SingleMessage.h"
#import "LZSingleChatTool.h"
#import "LZRecorderTool.h"
#import "LZPlayerForRecorder.h"

#import <WebKit/WebKit.h>

#import <objc/runtime.h>

@interface LZSingleChatViewController () <AVIMClientDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) LZSingleChatTool *singleChatTool;
@property(nonatomic,strong) LZRecorderTool *recorder;
@property(nonatomic,strong) LZPlayerForRecorder *player;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomTool;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *didSendVioceButton;


@end

@implementation LZSingleChatViewController
static NSString *other = @"other";
static NSString *me = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听键盘
    self.messageTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 初始化
    [self congigInitial];
    
//    [self createDataSource1];
    
}

/**
 *  初始化
 */
- (void)congigInitial {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"接收消息" style:(UIBarButtonItemStyleDone) target:self action:@selector(tomSendMessageToJerry)];
    
    self.navigationItem.title = _contactID;
    self.contactID = _contactIDD;
    
    LZSingleChatTool *tool = [[LZSingleChatTool alloc]init];
    tool.clientName = [AVUser currentUser].username;
    self.singleChatTool = tool;
    [self receiveMessage];
    
    // 发语音按钮常态隐藏
    self.didSendVioceButton.hidden = YES;
    
    // 初始化录音器
    _recorder = [[LZRecorderTool alloc]init];
    _player = [[LZPlayerForRecorder alloc]init];
}
/**
 *  构造数据源
 *
 *  @param mes  聊天消息文本
 *  @param type  消息编码 :@"0"为自己,@"1"为他人
 */
- (void)createDataSourceWithTextMessage:(NSString *)mes andType:(NSString *)type{
    SingleMessage *message = [[SingleMessage alloc]init];
    SingleMessage *messageBefore = [self.dataSource lastObject];
    
    //    NSDateFormatter *formaYes = [[NSDateFormatter alloc]init];
    //    [formaYes setDateFormat:@"dd"];
    //    NSString *time = [formaYes stringFromDate:[nsda]]
    NSDateFormatter *forma = [[NSDateFormatter alloc]init];
    [forma setDateFormat:@"hh-mm-ss"];
    NSString *time = [forma stringFromDate:[NSDate date]];
    
    message.text = mes;
    message.time = time;
    message.type = type;
    message.hideTime  = ([message.time isEqualToString:messageBefore.time]) ? YES : NO;

    [self.dataSource addObject:message];
    [self.tableView reloadData];
    
    [self performSelector:@selector(reload) withObject:self afterDelay:0.5f];
}

- (void)reload {
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
/**
 *  加载基础数据
 */
- (void)createDataSource1 {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    
    SingleMessage *message = nil;
    for (NSDictionary *subDic in plistArr) {
        SingleMessage *singleMessage = [[SingleMessage alloc]init];
        [singleMessage setValuesForKeysWithDictionary:subDic];
        singleMessage.hideTime  = ([singleMessage.time isEqualToString:message.time]) ? YES : NO;
        message = singleMessage;
        
        [self.dataSource addObject:singleMessage];
    }
}

#pragma mark - 聊天工具条事件处理
/**
 *  即将发语音
 */
- (IBAction)sendVoice:(UIButton *)sender {
    static BOOL isSelected = YES;
    if (isSelected) {
        self.didSendVioceButton.hidden = NO;
        [self.messageTextField resignFirstResponder];
        isSelected = NO;
    } else {
        self.didSendVioceButton.hidden = YES;
        isSelected = YES;
    }
}
/**
 *  发添加事物
 */
- (IBAction)addAddtion:(id)sender {
}
/**
 *  发表情
 */
- (IBAction)showMotion:(id)sender {
}
/**
 *  发语音
 */
- (IBAction)didSendVioce:(UIButton *)sender {
    [self.singleChatTool sendMessagetoContact:self.contactID WithAudioMessage:@"music" AndAttributes:@"audio"];
//    [self.singleChatTool receiveTextMessageWithDegate:self];
}

#pragma mark AVIM 业务
/**
 *  发送聊天文本消息
 */
- (void)sendMessageWithMessage:(NSString *)message {
    [self.singleChatTool sendMessagetoContact:self.contactID WithTextMessage:message AndAttributes:@"text"];
}
/**
 *  接受聊天信息
 */
- (void)receiveMessage {
    [self.singleChatTool receiveTextMessageWithDegate:self];
}

#pragma mark - AVIMClientDelegate
// 接收消息的回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    if ([message.attributes[@"type"] isEqualToString:@"text"]) {
        [self createDataSourceWithTextMessage:message.text andType:@"1"];
    } else if ([message.attributes[@"type"] isEqualToString:@"audio"]) {
        [self createDataSourceWithTextMessage:message.text andType:@"1"];
        self.player.filePath = message.file.url;
        LZLog(@"%@", message.file.url);
        [self.player startPlay];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 设置 cellIDE
    SingleMessage *message = self.dataSource[indexPath.row];
    
    NSString *cellIDE = ([message.type intValue] == 0) ? me : other;
    
    LZSingleChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDE];
    
    cell.message = message;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SingleMessage *message = self.dataSource[indexPath.row];
    
//    if ( (indexPath.row == self.dataSource.count - 1) && (self.dataSource.count!= 0) ) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
//    }

    return message.cellHeight;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    if (indexpath.row < 0) {
    } else {
        [self.tableView scrollToRowAtIndexPath: indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}


#pragma mark - 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.messageTextField.text.length) {
        [self createDataSourceWithTextMessage:self.messageTextField.text andType:@"0"];
        [self sendMessageWithMessage:textField.text];

        self.messageTextField.text = nil;
        return YES;
        
    } else {
        return NO;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate - 解决手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{

    [self.messageTextField resignFirstResponder];

    return YES;
}


#pragma mark - 键盘通知处理
/**
 *  键盘即将显示
 */
- (void)keyBoardWillShow:(NSNotification *)note{
    
    double aniDuring = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect KeyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat ty = - KeyboardRect.size.height;
    [UIView animateWithDuration:aniDuring animations:^{
        self.view.y += ty;
    }];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    if (indexpath.row < 0) {
    } else {
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
/**
 *  键盘即将退出
 */
- (void)keyBoardWillHide:(NSNotification *)note{
    
    double aniDuring = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect KeyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat ty = - KeyboardRect.size.height;
    [UIView animateWithDuration:aniDuring animations:^{
        self.view.y -= ty;
    }];
}

#pragma mark - 懒加载
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
