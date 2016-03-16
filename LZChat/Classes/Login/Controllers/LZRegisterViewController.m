//
//  LZRegisterViewController.m
//  LZChat
//
//  Created by Mr.Right on 16/3/16.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZRegisterViewController.h"



@interface LZRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImagrView;
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passAgainLabel;
@end

@implementation LZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview: self.backgroundImagrView atIndex:0];
    
}

- (IBAction)login:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAndLogin:(UIButton *)sender {
    if (self.accountLabel.text.length && self.emailLabel.text.length && self.passwordLabel.text.length && [self.passwordLabel.text isEqualToString:self.passAgainLabel.text]) {
        AVUser *user = [AVUser user];
        user.username = self.accountLabel.text;
        user.password = self.passwordLabel.text;
        user.email = self.emailLabel.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜注册成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if (error.code == 202) {
                    [SVProgressHUD showErrorWithStatus:@"账号有邮箱已经注册过"];
                }
                LZLog(@"注册注册失败:%@", error);
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请核对密码或输入正确的邮箱" message: nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
        [alert show];
    }
}


- (void)messageSign {
//    if (!sender.selected) {
    if(1){
        [AVOSCloud requestSmsCodeWithPhoneNumber:self.accountLabel.text callback:^(BOOL succeeded, NSError *error) {
            // 发送失败可以查看 error 里面提供的信息
            if (succeeded) {
                LZLog(@"成功发送短信");
//                sender.selected = YES;
            }
            
            if (error) {
                LZLog(@"%@",error);
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册验证码发送错误" message: nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                [alert show];
            }
        }];
    } else {
        [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.accountLabel.text smsCode:self.passwordLabel.text block:^(AVUser *user, NSError *error) {
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜您注册成功!" message: nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                [alert show];
//                sender.selected = NO;
                
            } else {
                LZLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入正确的验证码" message: nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                [alert show];
            }
        }];
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
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
