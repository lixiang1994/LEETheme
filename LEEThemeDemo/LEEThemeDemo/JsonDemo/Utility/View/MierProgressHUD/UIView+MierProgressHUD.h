
/*!
 *  @header UIView+MierProgressHUD.h
 *          MierMilitaryNews
 *
 *  @brief  透明指示层
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 miercn. All rights reserved.
 *  @version    16/3/28.
 */

#import <UIKit/UIKit.h>

@interface UIView (MierProgressHUD)

typedef NS_ENUM(NSInteger, MierProgressHUDStatus) {
    
    /** 成功 */
    MierProgressHUDStatusSuccess,
    
    /** 失败 */
    MierProgressHUDStatusError,
    
    /** 提示 */
    MierProgressHUDStatusInfo,
    
    /** 星标 */
    MierProgressHUDStatusStar,
    
    /** 空心星标 */
    MierProgressHUDStatusHollowStar,
    
    /** 等待 */
    MierProgressHUDStatusWaitting
    
};

/** 在 view 上添加一个 HUD */
- (void)showStatus:(MierProgressHUDStatus)status text:(NSString *)text;

#pragma mark - 建议使用的方法

/** 在 view 上添加一个只显示文字的 HUD */
- (void)showMessage:(NSString *)text;

/** 在 view 上添加一个提示`信息`的 HUD */
- (void)showInfoMsg:(NSString *)text;

/** 在 view 上添加一个提示`失败`的 HUD */
- (void)showFailure:(NSString *)text;

/** 在 view 上添加一个提示`成功`的 HUD */
- (void)showSuccess:(NSString *)text;

/** 在 view 上添加一个提示`收藏成功`的 HUD */
- (void)showAddFavorites:(NSString *)text;

/** 在 view 上添加一个提示`取消收藏`的 HUD */
- (void)showRemoveFavorites:(NSString *)text;

/** 在 view 上添加一个提示`等待`的 HUD, 需要手动关闭 */
- (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
- (void)hide;


@end
