//
//  BaseViewController.h
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/10.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MierNavigationBar.h"

#import "AppDelegate.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseViewController : UIViewController

@property (nonatomic , strong ) AppDelegate *appdelegate;

@property (nonatomic , strong ) UIWindow *mainWindow;

/**
 *  @brief  每个页面调用配置NavigationBar
 */
- (void)configNavigationBar;

/**
 *  @brief 设置主题
 */
- (void)configTheme;

@end
