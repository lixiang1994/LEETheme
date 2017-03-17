//
//  CommunityCircleListCell.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleListCell.h"

#import "SDAutoLayout.h"

@interface CommunityCircleListCell ()

@property (nonatomic , strong ) UIView *containerView; //容器视图

@property (nonatomic , strong ) UIImageView *picImageView; //图片视图

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@property (nonatomic , strong ) UILabel *postCountLabel; //帖子数量Label

@end

@implementation CommunityCircleListCell

- (void)dealloc{
    
    _model = nil;
    
    _containerView = nil;
    
    _picImageView = nil;
    
    _titleLabel = nil;
    
    _postCountLabel = nil;
}

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

- (void)initData{
    
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = 5.0f;
    
    self.layer.shouldRasterize = YES;
    
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.drawsAsynchronously = YES;
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //容器视图
    
    _containerView = [[UIView alloc] init];
    
    [self.contentView addSubview:_containerView];
    
    //图片视图
    
    _picImageView = [[UIImageView alloc] init];
    
    _picImageView.clipsToBounds = YES;
    
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.containerView addSubview:_picImageView];
    
    //标题Label
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.containerView addSubview:_titleLabel];
    
    //帖子数量Label
    
    _postCountLabel = [[UILabel alloc] init];
    
    _postCountLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.containerView addSubview:_postCountLabel];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 容器视图
    
    _containerView.sd_layout
    .centerXEqualToView(self.contentView)
    .centerYEqualToView(self.contentView)
    .heightIs(40.0f);
    
    // 图片视图
    
    _picImageView.sd_layout
    .centerYEqualToView(self.containerView)
    .leftEqualToView(self.containerView)
    .widthIs(35.0f)
    .heightIs(35.0f);
    
    // 标题Label
    
    _titleLabel.sd_layout
    .topEqualToView(self.containerView)
    .leftSpaceToView(self.picImageView , 5.0f)
    .heightIs(20.0f);
    
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:self.width - 50.0f];
    
    // 帖子数量Label
    
    _postCountLabel.sd_layout
    .topSpaceToView(self.titleLabel , 0.0f)
    .leftEqualToView(self.titleLabel)
    .heightIs(20.0f);
    
    [_postCountLabel setSingleLineAutoResizeWithMaxWidth:self.width - 50.0f];

    [self.containerView setupAutoWidthWithRightView:self.titleLabel rightMargin:5.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
    
    self.postCountLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
}

#pragma mark - 设置数据

- (void)setModel:(CommunityCircleModel *)model{
    
    _model = model;
    
    [self.picImageView setImageURL:[NSURL URLWithString:model.circleImageUrl]];
    
    self.titleLabel.text = model.circleName;
    
    self.postCountLabel.text = [NSString stringWithFormat:@"帖子%ld" , model.postCount];
}

@end
