//
//  LoadingView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "LoadingView.h"

#import "LoadingStyleCircleView.h"

#import "LoadingStyleNoDataView.h"

#import "LoadingStyleTitleView.h"

#import "LoadingStyleProgressView.h"

#import "LoadingStylePromptBarView.h"

@interface LoadingView ()

@property (nonatomic , assign ) id target;

@property (nonatomic , assign ) SEL action;

@property (nonatomic , assign ) LoadingViewStyle loadingViewStyle;//加载视图样式枚举

@property (nonatomic , strong ) LoadingStyleCircleView * loadingSCV;//圆形加载样式视图

@property (nonatomic , strong ) LoadingStyleNoDataView * loadingSNDV;//无数据样式视图

@property (nonatomic , strong ) LoadingStyleTitleView * loadingSTV;//文字标题样式视图

@property (nonatomic , strong ) LoadingStyleProgressView * loadingSPV;//进度条加载样式视图

@property (nonatomic , strong ) LoadingStylePromptBarView * loadingSPBV;//提示条样式视图

@end

@implementation LoadingView
{
    NSTimer *autoHideTimer;
}

- (void)dealloc{
    
    _loadingSCV = nil;
    
    _loadingSNDV = nil;
    
    _loadingSPV = nil;
    
    _loadingSTV = nil;
    
    _customView = nil;
    
    //移除自动隐藏timer
    
    if (autoHideTimer) {
        
        [autoHideTimer invalidate];
        
        autoHideTimer = nil;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame LoadingViewStyle:(LoadingViewStyle)loadingViewStyle{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initViewWithStyle:loadingViewStyle];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame LoadingViewStyle:(LoadingViewStyle)loadingViewStyle AddTarget:(id)target action:(SEL)action{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _target = target;
        
        _action = action;
        
        [self initViewWithStyle:loadingViewStyle];
    }
    
    return self;
}

+ (id)loadingViewStyleCircleWithFrame:(CGRect)frame{
    
    // 初始化圆形加载样式
    
    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:frame LoadingViewStyle:LoadingViewStyleCircle];
    
    return loadingView;
}

+ (id)loadingViewStyleNoDataWithFrame:(CGRect)frame AddTarget:(id)target action:(SEL)action{
    
    // 初始化无数据加载样式
    
    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:frame LoadingViewStyle:LoadingViewStyleNoData AddTarget:target action:action];
    
    return loadingView;
}

+ (id)loadingViewStyleTitleWithFrame:(CGRect)frame{
    
    // 初始化标题加载样式
    
    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:frame LoadingViewStyle:LoadingViewStyleTitle];
    
    return loadingView;
}

+ (id)loadingViewStyleCustomWithFrame:(CGRect)frame{
    
    // 初始化自定义加载样式
    
    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:frame LoadingViewStyle:LoadingViewStyleCustom];
    
    return loadingView;
}

+ (id)loadingViewStyleProgressWithFrame:(CGRect)frame{
    
    // 初始化进度条加载样式
    
    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:frame LoadingViewStyle:LoadingViewStyleProgress];
    
    return loadingView;
}

+ (id)loadingViewStylePromptBarWithFrame:(CGRect)frame{
    
    // 初始化提示条样式视图
    
    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:frame LoadingViewStyle:LoadingViewStylePromptBar];
    
    return loadingView;
}

#pragma mark - 根据样式初始化视图

- (void)initViewWithStyle:(LoadingViewStyle)loadingViewStyle{
    
    self.hidden = YES;
    
    self.clipsToBounds = YES;
    
    _loadingViewStyle = loadingViewStyle;
    
    switch (loadingViewStyle) {
            
        case LoadingViewStyleCircle:
            
            //圆形加载样式
            
            [self addSubview:self.loadingSCV];
            
            break;
            
        case LoadingViewStyleNoData:
            
            //无数据加载样式
            
            self.loadingSNDV.target = _target;
            
            self.loadingSNDV.action = _action;
            
            [self addSubview:self.loadingSNDV];
            
            break;
            
        case LoadingViewStyleTitle:
            
            //标题样式
            
            [self addSubview:self.loadingSTV];
            
            break;
            
        case LoadingViewStyleCustom:
            
            //自定义视图样式
            
            if (self.customView) {
                
                [self addSubview:self.customView];
            }
            
            break;
            
        case LoadingViewStyleProgress:
            
            //环形进度条视图样式
            
            [self addSubview:self.loadingSPV];
            
            break;
            
        case LoadingViewStylePromptBar:
            
            //提示条视图样式
            
            [self addSubview:self.loadingSPBV];
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 显示加载视图

- (void)showLoadingView{
    
    self.hidden = NO;
}

#pragma mark - 隐藏加载视图

- (void)hiddenLoadingView{
    
    self.hidden = YES;
}

#pragma mark - 重写Hidden方法

- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    
    switch (_loadingViewStyle) {
            
        case LoadingViewStyleCircle:
            
            //通过判断是否隐藏 来判断是否开启动画
            
            if (hidden) {
                
                [_loadingSCV stopLoadingAnimation];
                
            }else {
                
                [_loadingSCV startLoadingAnimation];
            }
            
            _loadingSCV.hidden = hidden;
            
            break;
            
        case LoadingViewStyleNoData:
            
            _loadingSNDV.hidden = hidden;
            
            break;
            
        case LoadingViewStyleTitle:
            
            _loadingSTV.hidden = hidden;
            
            break;
            
        case LoadingViewStyleCustom:
            
            _customView.hidden = hidden;
            
            break;
            
        case LoadingViewStyleProgress:
            
            //通过判断是否隐藏 来判断是否开启动画
            
            if (hidden) {
                
                [_loadingSPV stopLoadingAnimation];
                
            } else {
                
                [_loadingSPV startLoadingAnimation];
            }
            
            _loadingSPV.hidden = hidden;
            
            break;
            
        case LoadingViewStylePromptBar:
            
            //通过判断是否隐藏 来判断是否开启动画
            
            if (hidden) {
                
                [_loadingSPBV stopLoadingAnimation];
                
                self.userInteractionEnabled = YES;
                
            } else {
                
                [_loadingSPBV startLoadingAnimation];
                
                self.userInteractionEnabled = NO;
            }
            
            _loadingSPBV.hidden = hidden;
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 获取标题文字

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    switch (_loadingViewStyle) {
            
        case LoadingViewStyleCircle:
            
            self.loadingSCV.title = title;
            
            break;
            
        case LoadingViewStyleNoData:
            
            self.loadingSNDV.title = title;
            
            break;
            
        case LoadingViewStyleTitle:
            
            self.loadingSTV.title = title;
            
            break;
            
        case LoadingViewStyleCustom:
            
            break;
            
        case LoadingViewStyleProgress:
            
            self.loadingSPV.title = title;
            
            break;
            
        case LoadingViewStylePromptBar:
            
            self.loadingSPBV.title = title;
            
            break;
            
        default:
            break;
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_loadingSCV) {
        
        _loadingSCV.frame = self.frame;
        
        _loadingSCV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    if (_loadingSNDV) {
        
        _loadingSNDV.frame = self.frame;
        
        _loadingSNDV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    if (_loadingSTV) {
        
        _loadingSTV.frame = self.frame;
        
        _loadingSTV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    if (_loadingSPV) {
        
        _loadingSPV.frame = self.frame;
        
        _loadingSPV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
}


#pragma mark ---LazyLoading

- (LoadingStyleCircleView *)loadingSCV{
    
    if (!_loadingSCV) {
        
        _loadingSCV = [[LoadingStyleCircleView alloc]initWithFrame:self.frame];
        
        _loadingSCV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    return _loadingSCV;
}

- (LoadingStyleNoDataView *)loadingSNDV{
    
    if (!_loadingSNDV) {
        
        _loadingSNDV = [[LoadingStyleNoDataView alloc]initWithFrame:self.frame];
        
        _loadingSNDV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    return _loadingSNDV;
}

- (LoadingStyleTitleView *)loadingSTV{
    
    if (!_loadingSTV) {
        
        _loadingSTV = [[LoadingStyleTitleView alloc]initWithFrame:self.frame];
        
        _loadingSTV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    return _loadingSTV;
}

- (LoadingStyleProgressView *)loadingSPV{
    
    if (!_loadingSPV) {
        
        _loadingSPV = [[LoadingStyleProgressView alloc]initWithFrame:self.frame];
        
        _loadingSPV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    return _loadingSPV;
}

- (LoadingStylePromptBarView *)loadingSPBV{
    
    if (!_loadingSPBV) {
        
        _loadingSPBV = [[LoadingStylePromptBarView alloc]initWithFrame:self.frame];
        
        _loadingSPBV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
    }
    
    return _loadingSPBV;
}

#pragma mark ======= 常用方法

//清除所有加载视图

- (void)removeAllLoadingView{
    
    [self hiddenLoadingView];
    
    //清空视图
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //全部置为空
    
    if (_loadingSCV) {
        
        _loadingSCV = nil;
    }
    
    if (_loadingSNDV) {
        
        _loadingSNDV = nil;
    }
    
    if (_loadingSPV) {
        
        _loadingSPV = nil;
    }
    
    if (_loadingSTV) {
        
        _loadingSTV = nil;
    }
    
    if (_loadingSPBV) {
        
        _loadingSPBV = nil;
    }
    
    if (_customView) {
        
        _customView = nil;
    }
    
    if (_title) {
        
        _title = nil;
    }
    
}

- (void)showLoadingProgress{
    
    //清空原有加载视图
    
    [self removeAllLoadingView];
    
    //创建圆形进度条样式加载视图
    
    [self initViewWithStyle:LoadingViewStyleProgress];
    
    //显示加载视图
    
    [self showLoadingView];
}

- (void)showLoadingProgressWithText:(NSString *)title{
    
    //清空原有加载视图
    
    [self removeAllLoadingView];
    
    //创建圆形进度条样式加载视图
    
    [self initViewWithStyle:LoadingViewStyleProgress];
    
    self.title = title;
    
    //显示加载视图
    
    [self showLoadingView];
}

- (void)showLoadingNoDataWithText:(NSString *)title AddTarget:(id)target action:(SEL)action{
    
    
    //清空原有加载视图
    
    [self removeAllLoadingView];
    
    //创建无数据样式加载视图
    
    _target = target;
    
    _action = action;
    
    [self initViewWithStyle:LoadingViewStyleNoData];
    
    self.title = title;
    
    //显示加载视图
    
    [self showLoadingView];
}

- (void)showLoadingText:(NSString *)title{
    
    //清空原有加载视图
    
    [self removeAllLoadingView];
    
    //创建文字样式加载视图
    
    [self initViewWithStyle:LoadingViewStyleTitle];
    
    self.title = title;
    
    //显示加载视图
    
    [self showLoadingView];
}

- (void)showLoadingPromptBarWithText:(NSString *)title AutoHideTime:(NSTimeInterval)time{
    
    //清空原有加载视图
    
    [self removeAllLoadingView];
    
    //移除自动隐藏timer
    
    if (autoHideTimer) {
        
        [autoHideTimer invalidate];
        
        autoHideTimer = nil;
    }
    
    //创建提示条样式视图
    
    [self initViewWithStyle:LoadingViewStylePromptBar];
    
    self.title = title;
    
    //显示加载视图
    
    [self showLoadingView];
    
    autoHideTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(autoHideTimerAction:) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:autoHideTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - 自动隐藏事件

- (void)autoHideTimerAction:(NSTimer *)timer{
    
    // 清空原有加载视图
    
    [self removeAllLoadingView];
    
    [timer invalidate];
}

@end
