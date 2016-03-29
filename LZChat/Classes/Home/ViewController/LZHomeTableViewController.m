//
//  LZHomeTableViewController.m
//  LZChat
//
//  Created by Mr.Right on 16/3/22.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <UMSocial.h>
#import "LZHomeTableViewController.h"
#import "LZLoginViewController.h"
#import "LZSingleChatViewController.h"

@interface LZHomeTableViewController ()

@end

@implementation LZHomeTableViewController

static NSString *cellIDE = @"homeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:(UIBarButtonItemStyleDone) target:self action:@selector(changeAccount)];
    
    self.tableView.rowHeight = 80;
}

#pragma mark - 聊天业务处理
/**
 *  注销用户
 */
- (void)changeAccount {
    self.view.window.rootViewController = [[LZLoginViewController alloc]init];
    [AVUser logOut];  //清除缓存用户对象
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        LZLog(@"清除新浪缓存用户response is %@",response);
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIDE];
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDE forIndexPath:indexPath];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *homeStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([LZSingleChatViewController class]) bundle:[NSBundle mainBundle]];
    LZSingleChatViewController *singleChatVC = [homeStoryBoard instantiateViewControllerWithIdentifier:@"LZSingleChatViewController"];

    [self.navigationController pushViewController:singleChatVC animated:YES];
}




@end
