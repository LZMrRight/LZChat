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
#import "LZTabBarController.h"
#import <UMSocial.h>
@interface LZLoginViewController () <UITextFieldDelegate,LZDropdownMenuDelegate>
@property(nonatomic,strong) UITextField *forgetPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property(nonatomic,strong) LZDropdownMenu *menu;
@property(nonatomic,assign) CGRect keyBoardRect;
@end

@implementation LZLoginViewController
static BOOL isKeyBoardShow = NO;

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  
}
/**
 *  登陆
 */
- (IBAction)login:(id)sender {
    
    [SVProgressHUD showWithStatus:@"登陆中..."];
    
    if (self.accountLabel.text.length && self.accountLabel.text) {
        
        [AVUser logInWithUsernameInBackground: self.accountLabel.text password: self.passwordLabel.text block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                [SVProgressHUD dismiss];
                LZTabBarController *tabC = [[LZTabBarController alloc]init];
                self.view.window.rootViewController = tabC;
            } else {
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
                LZLog(@"%@",error);
            }
        }];

    } else {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名或密码"];
    }
    
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
    _menu.delegate = self;
    [_menu setContent:_forgetPasswordTextField];
    [_menu showFrom:button];
}
/**
 *  监听键盘的状态
 */
- (void)keyboardChangeFrame:(NSNotification *)no {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isKeyBoardShow = YES;
        _keyBoardRect = [[[no userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    });
    
    if (isKeyBoardShow) {
        [self showKeyBoard];
    } else {
        [self dismissKeyBoard];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.forgetPasswordTextField) {
        [textField resignFirstResponder];
        [self frethPasswordByEmail:textField.text];
    }
    
    return  YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.menu dismiss];
    [self.view endEditing:YES];
}
/**
 *  键盘退出了
 */
- (void)dismissKeyBoard {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!isKeyBoardShow) {
        [UIView animateWithDuration:0.5f animations:^{
            keyWindow.y += _keyBoardRect.size.height;
        }];
    }
    isKeyBoardShow = YES;
}
/**
 *  键盘显示了
 */
- (void)showKeyBoard {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (isKeyBoardShow) {
        [UIView animateWithDuration:0.5f animations:^{
            keyWindow.y -= _keyBoardRect.size.height;
        }];
    }
    isKeyBoardShow = NO;

}
#pragma mark - 聊天业务处理
- (void)frethPasswordByEmail:(NSString *)text {
    [AVUser requestPasswordResetForEmailInBackground:text block:^(BOOL succeeded, NSError *error) {
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

#pragma mark - 第三方登陆
- (IBAction)sinaLogin:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            LZLog(@"新浪授权登陆: username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            // 用新浪微博注册
            AVUser *user = [AVUser user];
            user.username = snsAccount.usid;
            user.password = snsAccount.accessToken;
            [[AVUser currentUser] setObject:snsAccount.iconURL forKey:@"userIcon"];
            [[AVUser currentUser] setObject:snsAccount.userName forKey:@"userName"];
            [[AVUser currentUser] saveInBackground];
            
            // 用新浪微博登陆
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {// 第一次注册并且成功
                    LZTabBarController *tabC = [[LZTabBarController alloc]init];
                    self.view.window.rootViewController = tabC;
                } else {
                    if (error.code == 202) {// 不是第一次用新浪微博登陆
                        [SVProgressHUD showWithStatus:@"登陆中,请稍后..."];
                        [AVUser logInWithUsernameInBackground: snsAccount.usid password: snsAccount.accessToken block:^(AVUser *user, NSError *error) {
                            [SVProgressHUD dismiss];
                            if (user != nil) {
                                LZTabBarController *tabC = [[LZTabBarController alloc]init];
                                self.view.window.rootViewController = tabC;
                            } else {
                                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
                                LZLog(@"%@",error);
                            }
                        }];
                    } else { // 第三方登陆失败
                        [SVProgressHUD showErrorWithStatus:@"登陆失败"]; 
                        LZLog(@"第三方登陆失败:%@", error);
                    }
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
            // 清楚新浪缓存
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                LZLog(@"清除新浪缓存用户response is %@",response);
            }];
            
            LZLog(@"注册失败:%u", response.responseCode);
        }
    });
}


#pragma mark - LZDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(LZDropdownMenu *)menu {
    [self.view endEditing:YES];
//    isKeyBoardShow = NO;
//    [self dismissKeyBoard];
}
- (void)dropdownMenuDidShow:(LZDropdownMenu *)menu {
//    isKeyBoardShow = YES;
//    [self showKeyBoard];
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
