//
//  NameRankView.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/3/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "NameRankView.h"

#import "SDAutoLayout.h"

#import "FontSizeManager.h"

@interface NameRankView ()

@property (nonatomic, strong ) UILabel *nameLabel;

@property (nonatomic, strong ) UIView *rankLineView;

@property (nonatomic, strong ) UIImageView *rankImageView;

@property (nonatomic, strong ) UILabel *rankLabel;

@end

@implementation NameRankView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _nameLabel = nil;
    
    _rankLineView = nil;
    
    _rankImageView = nil;
    
    _rankLabel = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubview];
        
        [self configAutoLayout];
        
        [self configTheme];

    }
    return self;
}

#pragma mark - 初始化子视图

-(void)initSubview{
    
    self.nameLabel = [[UILabel alloc] init];
    
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.nameLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:14.0f]];
    
    [self addSubview:self.nameLabel];
    
    
    self.rankLineView = [[UIView alloc] init];
    
    [self addSubview:self.rankLineView];
    
    
    self.rankImageView = [[UIImageView alloc] init];
    
    self.rankImageView.clipsToBounds = YES;
    
    [self addSubview:self.rankImageView];
    
    
    self.rankLabel = [[UILabel alloc] init];
    
    self.rankLabel.textAlignment = NSTextAlignmentLeft;
    
    self.rankLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:14.0f]];
    
    [self addSubview:self.rankLabel];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f);
    
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:400.0f];
    
    self.rankLineView.sd_layout
    .leftSpaceToView(self.nameLabel, 6.0f)
    .centerYEqualToView(self.nameLabel)
    .heightIs([FontSizeManager textFontSizeForDefault:14.0f])
    .widthIs(0.5f);
    
    self.rankImageView.sd_layout
    .leftSpaceToView(self.rankLineView, 6.0f)
    .centerYEqualToView(self.nameLabel)
    .widthIs([FontSizeManager textFontSizeForDefault:14.0f])
    .heightIs([FontSizeManager textFontSizeForDefault:14.0f]);
    
    self.rankLabel.sd_layout
    .leftSpaceToView(self.rankImageView, 4.0f)
    .centerYEqualToView(self.nameLabel);
    
    [self.rankLabel setSingleLineAutoResizeWithMaxWidth:150.0f];
    
    [self setupAutoHeightWithBottomView:self.nameLabel bottomMargin:0.0f];
    
    [self setupAutoWidthWithRightView:self.rankLabel rightMargin:0.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.nameLabel.lee_theme.LeeConfigTextColor(common_bg_blue_4);
    
    self.rankLineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
    
    self.rankLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
}

#pragma mark - 设置字体大小

- (void)setFontSize:(CGFloat)fontSize{
    
    _fontSize = fontSize;
    
    self.nameLabel.font = [UIFont systemFontOfSize:fontSize];
    
    self.rankLineView.sd_layout
    .heightIs(fontSize);
    
    self.rankImageView.sd_layout
    .widthIs(fontSize)
    .heightIs(fontSize);
    
    self.rankLabel.font = [UIFont systemFontOfSize:fontSize];
}

#pragma mark - 设置最大宽度

- (void)setMaxWidth:(CGFloat)maxWidth{

    _maxWidth = maxWidth;
    
    [self.rankLineView updateLayout];
    
    [self.rankLabel updateLayout];
    
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:maxWidth - 6.0f - self.rankLineView.width - 6.0f - self.rankImageView.width - 4.0f - self.rankLabel.width - 5.0f];
    
    [self.nameLabel updateLayout];
}

#pragma mark - 设置文字

- (void)configWithName:(NSString *)name Level:(NSInteger)level{
    
    NSString *levelImage = nil;
    
    NSString *levelName = nil;
    
    if (level <= [RankManager rankNameArray].count && level > 0){
        
        levelImage = [RankManager rankImageArray][level - 1];
        
        levelName = [RankManager rankNameArray][level - 1];
    }
    
    [self configWithName:name LevelImage:levelImage LevelName:levelName];
}

- (void)configWithName:(NSString *)name LevelImage:(NSString *)levelImage LevelName:(NSString *)levelName{
    
    if (name) self.nameLabel.text = name;
    
    if (levelImage) {
        
        self.rankImageView.sd_layout.widthIs(self.rankImageView.height);
        
        self.rankLabel.sd_layout.leftSpaceToView(self.rankImageView , 4.0f);
        
        [self.rankImageView setImageWithURL:[NSURL URLWithString:levelImage] options:YYWebImageOptionSetImageWithFadeAnimation];
        
    } else {
        
        self.rankImageView.sd_layout.widthIs(0.0f);
    
        self.rankLabel.sd_layout.leftSpaceToView(self.rankImageView , 0.0f);
    }
    
    if (levelName) self.rankLabel.text = [NSString stringWithFormat:@"%@", levelName];
}

@end
