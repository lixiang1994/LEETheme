//
//  LoadingView.h
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 加载视图样式
 */

typedef enum : NSUInteger  {
    
    /**
     *  @brief  圆形加载样式
     */
    
    LoadingViewStyleCircle,
    
    /**
     *  @brief  无数据样式
     */
    
    LoadingViewStyleNoData,
    
    /**
     *  @brief  标题文字样式
     */
    
    LoadingViewStyleTitle,
    
    /**
     *  @brief  自定义样式
     */
    
    LoadingViewStyleCustom,
    
    /**
     *  @brief  环形进度条样式
     */
    
    LoadingViewStyleProgress,
    
    /**
     *  @brief  提示条样式
     */
    
    LoadingViewStylePromptBar
    
    
} LoadingViewStyle;


@interface LoadingView : UIView

@property (nonatomic , copy ) NSString *title;//标题文字 (如果不设置标题文字 默认显示标题视图)

@property (nonatomic , strong ) UIView *customView;//自定义视图


-(instancetype)initWithFrame:(CGRect)frame LoadingViewStyle:(LoadingViewStyle)loadingViewStyle;

-(instancetype)initWithFrame:(CGRect)frame LoadingViewStyle:(LoadingViewStyle)loadingViewStyle AddTarget:(id)target action:(SEL)action;

//初始化圆形加载样式视图

+(id)loadingViewStyleCircleWithFrame:(CGRect)frame;

//初始化无数据加载样式视图

+(id)loadingViewStyleNoDataWithFrame:(CGRect)frame AddTarget:(id)target action:(SEL)action;

//初始化标题加载样式视图

+(id)loadingViewStyleTitleWithFrame:(CGRect)frame;

//初始化自定义加载样式视图

+(id)loadingViewStyleCustomWithFrame:(CGRect)frame;

//初始化环形进度条加载样式视图

+(id)loadingViewStyleProgressWithFrame:(CGRect)frame;

//初始化提示条样式视图

+(id)loadingViewStylePromptBarWithFrame:(CGRect)frame;

//显示加载视图

- (void)showLoadingView;

//隐藏加载视图

- (void)hiddenLoadingView;


#pragma mark ==========常用方法

- (void)showLoadingProgress;

- (void)showLoadingProgressWithText:(NSString *)title;

- (void)showLoadingNoDataWithText:(NSString *)title AddTarget:(id)target action:(SEL)action;

- (void)showLoadingText:(NSString *)title;

- (void)showLoadingPromptBarWithText:(NSString *)title AutoHideTime:(NSTimeInterval) time;


@end
