//
//  LoadingStylePromptBarView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/11/10.
//  Copyright © 2015年 miercn. All rights reserved.
//

#import "LoadingStylePromptBarView.h"

@interface LoadingStylePromptBarView ()

@property (nonatomic , strong ) UILabel *titleLabel;//标题Label

@property (nonatomic , strong ) UIView *promptBarView;//提示条视图

@end

@implementation LoadingStylePromptBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

#pragma mark - 获取标题

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    _titleLabel.text = title;
}

#pragma mark - 获取bar颜色

- (void)setBarColor:(UIColor *)barColor{
    
    _barColor = barColor;
    
    _promptBarView.backgroundColor = [barColor colorWithAlphaComponent:0.7f];
}

//开启加载动画

- (void)startLoadingAnimation{
    
    //清空原有提示条视图
    
    if (_promptBarView) {
        
        [_promptBarView.layer removeAllAnimations];
        
        [_promptBarView removeFromSuperview];
        
        [_titleLabel removeFromSuperview];
        
        _titleLabel = nil;
        
        _promptBarView = nil;
    }
    
    self.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        if (weakSelf) {
            
             weakSelf.promptBarView.frame = CGRectMake(0, 0, CGRectGetWidth(weakSelf.promptBarView.frame) , CGRectGetHeight(weakSelf.promptBarView.frame));
        }
        
    }];
    
}

//停止加载动画

- (void)stopLoadingAnimation{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        if (weakSelf) {
            
            weakSelf.promptBarView.frame = CGRectMake(0, -35, CGRectGetWidth(weakSelf.promptBarView.frame) , CGRectGetHeight(weakSelf.promptBarView.frame));
        }
        
    } completion:^(BOOL finished) {
        
        if (weakSelf) {
            
            [weakSelf.titleLabel removeFromSuperview];
            
            [weakSelf.promptBarView removeFromSuperview];
            
            weakSelf.userInteractionEnabled = NO;
        }
        
    }];
    
}

#pragma mark - LazyLoading

- (UIView *)promptBarView{
    
    if (!_promptBarView) {
        
        //初始化提示条视图
        
        _promptBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -35, CGRectGetWidth(self.frame) , 35)];
        
        _promptBarView.backgroundColor = [[UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] Identifier:common_bg_blue_4] colorWithAlphaComponent:0.8f];
        
        _promptBarView.clipsToBounds = YES;
        
        [self addSubview:_promptBarView];
        
        //初始化标题Label
        
        _titleLabel = [[UILabel alloc]initWithFrame:_promptBarView.bounds];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _titleLabel.text = self.title;
        
        [_promptBarView addSubview:_titleLabel];
    }
    
    return _promptBarView;
}

@end
