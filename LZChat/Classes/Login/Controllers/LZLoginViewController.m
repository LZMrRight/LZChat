//
//  LZLoginViewController.m
//  LZChat
//
//  Created by Mr.Right on 16/3/11.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZLoginViewController.h"

@interface LZLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)login:(UIButton *)sender {
    EMError *error = nil;
    
    [[EaseMob sharedInstance].chatManager registerNewAccount:self.accountTextField.text password:self.passwordTextField.text error:&error];
    if (!error) {
        NSLog(@"登陆成功");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
