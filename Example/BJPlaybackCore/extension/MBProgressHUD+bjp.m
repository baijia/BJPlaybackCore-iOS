//
//  MBProgressHUD+bjp.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/3/17.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import "MBProgressHUD+bjp.h"

@implementation MBProgressHUD (bjp)

+ (void)bjp_showMessageThenHide:(NSString *)msg toView:(UIView *)view onHide:(void (^)())onHide {
    [self bjp_showMessageThenHide:msg toView:view yOffset:0 onHide:onHide];
}

+ (void)bjp_showMessageThenHide:(NSString *)msg
                         toView:(UIView *)view  yOffset:(CGFloat)offset
                         onHide:(void (^)())onHide;
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) {
        NSAssert(0, @" no view");

    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    if (hud == nil) {
        NSAssert(0, @"hud is nil");
    }
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.detailsLabelText = msg;
    
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    [hud setUserInteractionEnabled:false];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    hud.yOffset = offset;
    // 2秒之后再消失
    int hideInterval = 5;
    [hud hide:YES afterDelay:hideInterval];
    
    if (onHide){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            onHide();
        });
    }
}

+ (MBProgressHUD*)bjp_showLoading:(NSString*)msg toView:(UIView *)view yOffset:(CGFloat)offset
{
    if (view == nil)
        return nil;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    if (hud == nil) {
        return hud;
    }
    hud.detailsLabelText = msg;
    hud.yOffset = offset;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    //[hud setUserInteractionEnabled:false];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}


+ (MBProgressHUD*)bjp_showLoading:(NSString*)msg toView:(UIView *)view
{
    return [MBProgressHUD bjp_showLoading:msg toView:view yOffset:0];
}

+ (void)bjp_closeLoadingView:(UIView *)toView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:toView];
    if (hud) {
        [hud hide:YES];
    }
}


@end
