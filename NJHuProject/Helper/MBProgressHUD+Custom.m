//
//  MBProgressHUD+Custom.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "MBProgressHUD+Custom.h"

@implementation MBProgressHUD (Custom)

#pragma mark - Public Method
// 快速显示一条提示信息
+ (void)showAutoMessage:(NSString *)message {
    [self showAutoMessage:message ToView:nil];
}

// 自动消失提示，无图
+ (void)showAutoMessage:(NSString *)message ToView:(UIView *)view {
    [self showMessage:message ToView:view RemainTime:1.f Model:MBProgressHUDModeText];
}

#pragma mark - Private Method
+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time Model:(MBProgressHUDMode)model {
    if (view == nil) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15.f];
    hud.mode = model;   // 模式
    hud.removeFromSuperViewOnHide = YES;    // 隐藏时候从父控件中移除
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;  // 代表需要蒙版效果
    [hud hideAnimated:YES afterDelay:time]; // X秒之后再消失
}

@end
