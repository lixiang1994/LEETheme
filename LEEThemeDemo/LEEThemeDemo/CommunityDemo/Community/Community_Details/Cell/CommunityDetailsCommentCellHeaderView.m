//
//  CommunityDetailsCommentCellHeaderView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/2.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsCommentCellHeaderView.h"

#import "SDAutoLayout.h"

@interface CommunityDetailsCommentCellHeaderView ()

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@property (nonatomic , strong ) UIView *leftLineView; //左分隔线视图

@property (nonatomic , strong ) UIView *rightLineView; //右分隔线视图

@end

@implementation CommunityDetailsCommentCellHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
        
        //设置主题
        
        [self configTheme];
        
    }
    
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //标题Label
    
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    [self.contentView addSubview:_titleLabel];
    
    //左分隔线视图
    
    _leftLineView = [[UIView alloc] init];
    
    _leftLineView.backgroundColor = LEEColorFromIdentifier([LEETheme currentThemeTag], common_bg_blue_4);
    
    [self.contentView addSubview:_leftLineView];
    
    //右分隔线视图
    
    _rightLineView = [[UIView alloc] init];
    
    _rightLineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f];
    
    [self.contentView addSubview:_rightLineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    self.sd_layout
    .widthIs(CGRectGetWidth([[UIScreen mainScreen] bounds]))
    .heightIs(50.0f);
    
    //标题Label
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView , 15)
    .topSpaceToView(self.contentView , 15)
    .heightIs(20);
    
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //左分隔线视图
    
    _leftLineView.sd_layout
    .leftSpaceToView(self.contentView , 15)
    .topSpaceToView(_titleLabel , 14.5f)
    .widthRatioToView(_titleLabel , 1)
    .heightIs(0.5f);
    
    //右分隔线视图
    
    _rightLineView.sd_layout
    .leftSpaceToView(_leftLineView , 0)
    .rightSpaceToView(self.contentView , 15)
    .topEqualToView(_leftLineView)
    .heightIs(0.5f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
}

#pragma mark - 设置标题

- (void)configTitle:(NSString *)title Count:(NSInteger)count{
    
    if (title) self.titleLabel.text = title;
    
    
}

@end
