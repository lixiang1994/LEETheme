//
//  CommunityPostImageView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/31.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityPostImageView.h"

#import "SDAutoLayout.h"

@interface CommunityPostImageView ()

@property (nonatomic , strong ) UIView *floatView; //浮层视图

@property (nonatomic , strong ) UIButton *deleteButton; //移除按钮

@end

@implementation CommunityPostImageView

- (void)dealloc{
    
    _floatView = nil;
    
    _deleteButton = nil;
}

- (instancetype)initWithImage:(UIImage *)image{
    
    self = [super initWithImage:image];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.userInteractionEnabled = YES;
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
        
        //设置主题模式
        
        [self configTheme];
        
    }
    return self;
}

#pragma mark - 初始化数据

-(void)initData{
 
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

#pragma mark - 初始化子视图

-(void)initSubview{
    
    //浮层视图
    
    _floatView = [[UIView alloc] init];
    
    _floatView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    
    _floatView.hidden = YES;
    
    [self addSubview:_floatView];
    
    // 移除按钮
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _deleteButton.alpha = 0.8f;
    
    _deleteButton.sd_cornerRadiusFromWidthRatio = @0.5;
    
    [_deleteButton setImage:[UIImage imageNamed:@"community_post_image_remove"] forState:UIControlStateNormal];
    
    [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.floatView addSubview:_deleteButton];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    //浮层视图
    
    _floatView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    // 移除按钮
    
    _deleteButton.sd_layout
    .centerXEqualToView(self.floatView)
    .centerYEqualToView(self.floatView)
    .widthIs(48.0f)
    .heightIs(48.0f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (self.floatView.hidden) {
        
        self.floatView.hidden = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.floatView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            
        } completion:^(BOOL finished) {
            
        }];
        
        self.deleteButton.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
        
        [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:3.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.deleteButton.alpha = 1.0f;
            
            self.deleteButton.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.floatView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
            self.deleteButton.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            self.floatView.hidden = YES;
        }];
        
    }
    
}

#pragma mark - 删除按钮点击事件

- (void)deleteButtonAction:(UIButton *)sender{

    if (self.deleteBlock) self.deleteBlock(self);
}

@end
