//
//  CommunityCircleDetailsHeaderView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleDetailsHeaderView.h"

#import "SDAutoLayout.h"

@interface CommunityCircleDetailsHeaderView ()

@property (nonatomic , strong ) UIImageView *picImageView; // 图片视图

@property (nonatomic , strong ) UIButton *backButton; //返回按钮

@property (nonatomic , strong ) UIView *contentView; // 内容视图

@property (nonatomic , strong ) UIImageView *iconImageView; // 图标图片视图

@property (nonatomic , strong ) UILabel *titleLabel; // 标题Label

@property (nonatomic , strong ) UILabel *describeLabel; // 描述Label

@property (nonatomic , strong ) UIButton *postButton; // 发帖按钮

@property (nonatomic , strong ) UIView *bottomLineView; //底部分隔线

@end

@implementation CommunityCircleDetailsHeaderView

- (void)dealloc{
    
    _picImageView = nil;
    
    _contentView = nil;
    
    _iconImageView = nil;
    
    _titleLabel = nil;
    
    _describeLabel = nil;
    
    _postButton = nil;
    
    _bottomLineView = nil;
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
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //图片视图
    
    _picImageView = [[UIImageView alloc] init];
    
    _picImageView.clipsToBounds = YES;
    
    _picImageView.userInteractionEnabled = YES;
    
    _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:_picImageView];
    
    //返回按钮
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backButton.hidden = YES;
    
    [_backButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    
    _backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    _backButton.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picImageView addSubview:_backButton];
    
    //内容视图
    
    _contentView = [[UIView alloc] init];
    
    [self addSubview:_contentView];
    
    //图标
    
    _iconImageView = [[UIImageView alloc] init];
    
    _iconImageView.sd_cornerRadiusFromWidthRatio = @0.5f;
    
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_iconImageView];
    
    //标题Label
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_titleLabel];
    
    //描述Label
    
    _describeLabel = [[UILabel alloc] init];
    
    _describeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.contentView addSubview:_describeLabel];
    
    //发帖按钮
    
    _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _postButton.sd_cornerRadius = @5.0f;
    
    [_postButton setTitle:@"发帖" forState:UIControlStateNormal];
    
    [_postButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    [_postButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_postButton];
    
    //底部分隔线
    
    _bottomLineView = [UIView new];
    
    [self addSubview:_bottomLineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    _picImageView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(120.0f);
    
    _backButton.sd_layout
    .topSpaceToView(self.picImageView , 5.0f)
    .leftSpaceToView(self.picImageView , 5.0f)
    .widthIs(40.0f)
    .heightIs(40.0f);
    
    _contentView.sd_layout
    .topSpaceToView(self.picImageView , 0.0f)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(70.0f);
    
    _iconImageView.sd_layout
    .topSpaceToView(self.picImageView , - 10.0f)
    .leftSpaceToView(self , 15.0f)
    .widthIs(60.0f)
    .heightIs(60.0f);
    
    _postButton.sd_layout
    .topSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .widthIs(60.0f)
    .heightIs(30.0f);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.iconImageView , 10.0f)
    .topSpaceToView(self.contentView , 10.0f)
    .rightSpaceToView(self.postButton , 1.0f)
    .heightIs(20.0f);
    
    _describeLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel , 0.0f)
    .widthRatioToView(self.titleLabel , 1)
    .heightIs(20.0f);
    
    _bottomLineView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.contentView , 0.0f)
    .heightIs(10.0f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.picImageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.contentView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
    
    self.describeLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.postButton.lee_theme.LeeConfigBackgroundColor(common_bg_blue_4);

    self.bottomLineView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
}

#pragma mark - 返回按钮

- (void)backButtonAction:(UIButton *)sender{
    
    if (self.backBlock) self.backBlock();
}

#pragma mark - 发帖按钮

- (void)postButtonAction:(UIButton *)sender{
    
    if (self.openPostBlock) self.openPostBlock();
}

#pragma mark - 设置

- (void)configPicImageUrl:(NSString *)picImageUrl
             IconImageUrl:(NSString *)iconImageUrl
                    Title:(NSString *)title
                 Describe:(NSString *)describe{
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:picImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:iconImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    
    self.titleLabel.text = title;
    
    self.describeLabel.text = describe;
}

@end
