//
//  LZLoginViewController.m
//  LZChat
//
//  Created by Mr.Right on 16/3/16.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "LZLoginViewController.h"
#import "LZRegisterViewController.h"
#import "LZDropdownMenu.h"

@interface LZLoginViewController () <UITextFieldDelegate>
@property(nonatomic,strong) UITextField *forgetPasswordTextField;
@property(nonatomic,strong) LZDropdownMenu *menu;
@property(nonatomic,assign) CGRect keyBoardRect;
@end

@implementation LZLoginViewController
static BOOL isKeyBoardShow = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  
}

- (IBAction)registerIn:(UIButton *)sender {
    LZRegisterViewController *registerVC = [[LZRegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
- (IBAction)forgetPassword:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UIButton *button = (UIButton *)sender;
    
    _forgetPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 100, 40)];
    _forgetPasswordTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    _forgetPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _forgetPasswordTextField.placeholder = @"请输入注册邮箱";
    _forgetPasswordTextField.delegate = self;
    
    _menu = [LZDropdownMenu menu];
    [_menu setContent:_forgetPasswordTextField];
    [_menu showFrom:button];
}

- (void)keyboardChangeFrame:(NSNotification *)no {
    
    isKeyBoardShow = YES;
    
    _keyBoardRect = [[[no userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (isKeyBoardShow) {
        [UIView animateWithDuration:1.f animations:^{
            keyWindow.y -= _keyBoardRect.size.height;
        }];
        isKeyBoardShow = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } else {
        [UIView animateWithDuration:1.f animations:^{
            keyWindow.y += _keyBoardRect.size.height;
        }];
        isKeyBoardShow = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.forgetPasswordTextField) {
        [self.menu dismiss];
        [AVUser requestPasswordResetForEmailInBackground:textField.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"请去邮箱验证"];
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱"];
                });
            }
        }];
    }
    
    return  YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.menu dismiss];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    if (isKeyBoardShow) {
        [UIView animateWithDuration:1.f animations:^{
            keyWindow.y -= _keyBoardRect.size.height;
        }];
        isKeyBoardShow = NO;
    }
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
