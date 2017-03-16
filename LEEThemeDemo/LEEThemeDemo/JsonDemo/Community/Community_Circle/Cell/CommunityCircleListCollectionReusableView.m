//
//  CommunityCircleListCollectionReusableView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleListCollectionReusableView.h"

#import "SDAutoLayout.h"

@interface CommunityCircleListCollectionReusableView ()

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@end

@implementation CommunityCircleListCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    
}

#pragma mark - 初始化子视图

-(void)initSubview{
    
    //标题Label
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self addSubview:_titleLabel];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    //标题Label
    
    _titleLabel.sd_layout
    .topSpaceToView(self , 10.0f)
    .leftSpaceToView(self , 15.0f)
    .rightSpaceToView(self , 15.0f)
    .heightIs(40.0f);
}

#pragma mark - 设置主题

-(void)configTheme{
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_3);
}

#pragma mark - 设置标题

- (void)configTitle:(NSString *)title{
    
    if (title) self.titleLabel.text = title;
}

@end
