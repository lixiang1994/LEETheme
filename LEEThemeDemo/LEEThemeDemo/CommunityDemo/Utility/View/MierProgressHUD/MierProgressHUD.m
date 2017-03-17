/*!
 *  @header MierProgressHUD.m
 *          MierMilitaryNews
 *
 *  @brief  透明指示层
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 miercn. All rights reserved.
 *  @version    16/3/28.
 */


#import "MierProgressHUD.h"

// 背景视图的宽度/高度

#define BGVIEW_WIDTH 100.0f

// 文字大小

#define TEXT_SIZE    16.0f

@implementation MierProgressHUD

+ (instancetype)sharedHUD {
    
    static MierProgressHUD *hud;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{

        hud = [[MierProgressHUD alloc] initWithWindow:[MierProgressHUD getMainWindow]];        
    });
    
    return hud;
}

+ (void)showStatus:(MierProgressHUDStatus)status text:(NSString *)text {
    
    [[MierProgressHUD getMainWindow] showStatus:status text:text];
}

#pragma mark - 推荐方法

+ (void)showMessage:(NSString *)text {
    
    [[MierProgressHUD getMainWindow] showMessage:text];
}

+ (void)showInfoMsg:(NSString *)text {
    
    [[MierProgressHUD getMainWindow] showStatus:MierProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [[MierProgressHUD getMainWindow] showStatus:MierProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [[MierProgressHUD getMainWindow] showStatus:MierProgressHUDStatusSuccess text:text];
}

+ (void)showAddFavorites:(NSString *)text{
    
    [[MierProgressHUD getMainWindow] showStatus:MierProgressHUDStatusStar text:text];
}

+ (void)showRemoveFavorites:(NSString *)text{
    
    [[MierProgressHUD getMainWindow] showStatus:MierProgressHUDStatusHollowStar text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [[MierProgressHUD getMainWindow] showStatus:MierProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    
    [[MierProgressHUD sharedHUD] hide:YES];
}

+ (UIWindow *)getMainWindow{
    
    return [[UIApplication sharedApplication].delegate window];
}

@end
