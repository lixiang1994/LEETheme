//
//  BaseViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/10.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    //设置状态栏 (根据导航栏显示类型 显示状态栏样式)
    
    [MierNavigationBar configStatusBar:self];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = NO;
    
    //不自动留出空白
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置默认背景颜色
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    //隐藏UINavigationBar
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.mainWindow = [UIApplication sharedApplication].delegate.window;
    
    [self configNavigationBar];
}

- (void)configNavigationBar{
    
}

- (void)configTheme{
    
}

#pragma mark - 设置竖屏

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    //清空内存中的图片缓存
    
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}


@end
