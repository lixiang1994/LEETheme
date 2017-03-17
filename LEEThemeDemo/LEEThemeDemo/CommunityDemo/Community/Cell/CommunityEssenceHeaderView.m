//
//  CommunityEssenceHeaderView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityEssenceHeaderView.h"

#import "SDAutoLayout.h"

@interface CommunityEssenceHeaderView ()

@property (nonatomic , strong ) UIView *topLineView;

@property (nonatomic , strong ) UILabel *titleLabel;

@property (nonatomic , strong ) UIView *bottomLineView;

@end

@implementation CommunityEssenceHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //初始化数据
        
        [self initData];
        
        //初始化视图
        
        [self initSubView];
        
        //设置自动布局
        
        [self configAutoLayout];
        
        //设置主题模式
        
        [self configTheme];
        
    }
    
    return self;
}

#pragma mark - 初始化数据

-(void)initData{
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame));
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    //顶部分隔线
    
    _topLineView = [UIView new];
    
    [self.contentView addSubview:_topLineView];
    
    //初始化标题Label
    
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_titleLabel];
    
    //底部分隔线
    
    _bottomLineView = [UIView new];
    
    [self.contentView addSubview:_bottomLineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    _topLineView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(0.5f);
    
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView , 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .widthIs(100.0f)
    .heightIs(20.0f);
    
    _bottomLineView.sd_layout
    .yIs(50.0f)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(0.5f);
}


#pragma mark - 设置主题

- (void)configTheme{
    
    self.contentView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.topLineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.bottomLineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
}

#pragma mark - 设置数据

- (void)configTitle:(NSString *)title{
    
    if (title) self.titleLabel.text = title;
}

@end
