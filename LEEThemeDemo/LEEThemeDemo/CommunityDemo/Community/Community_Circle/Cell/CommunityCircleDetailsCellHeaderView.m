//
//  CommunityCircleDetailsCellHeaderView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleDetailsCellHeaderView.h"

#import "SDAutoLayout.h"

@interface CommunityCircleDetailsCellHeaderView ()

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@property (nonatomic , strong ) UIView *leftLineView; //左分隔线视图

@property (nonatomic , strong ) UIView *rightLineView; //右分隔线视图

@property (nonatomic , strong ) CommunityCircleDetailsCellHeaderSortView *sortView; //排序视图

@end

@implementation CommunityCircleDetailsCellHeaderView

- (void)dealloc{
    
    _titleLabel = nil;
    
    _leftLineView = nil;
    
    _rightLineView = nil;
    
    _sortView = nil;
}

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
    
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    _titleLabel.isAttributedContent = YES;
    
    [self.contentView addSubview:_titleLabel];
    
    //左分隔线视图
    
    _leftLineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_leftLineView];
    
    //右分隔线视图
    
    _rightLineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_rightLineView];
    
    //排序视图
    
    _sortView = [[CommunityCircleDetailsCellHeaderSortView alloc] init];
    
    _sortView.hidden = YES;
    
    [self.contentView addSubview:_sortView];
    
    __weak typeof(self) weakSelf = self;
    
    _sortView.selectedNewestBlock = ^(){
        
        if (weakSelf && weakSelf.selectedNewestBlock) {
            
            weakSelf.selectedNewestBlock();
        }
        
    };
    
    _sortView.selectedLastReplyBlock = ^(){
        
        if (weakSelf && weakSelf.selectedLastReplyBlock) {
            
            weakSelf.selectedLastReplyBlock();
        }
        
    };
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    self.sd_layout
    .widthIs(CGRectGetWidth([[UIScreen mainScreen] bounds]))
    .heightIs(50.0f);
    
    //标题Label
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView , 15)
    .centerYEqualToView(self.contentView)
    .heightIs(20);
    
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200.0f];
    
    //左分隔线视图
    
    _leftLineView.sd_layout
    .leftSpaceToView(self.contentView , 0.0f)
    .bottomSpaceToView(self.contentView , 0.0f)
    .widthRatioToView(_titleLabel , 1)
    .heightIs(0.5f);
    
    //右分隔线视图
    
    _rightLineView.sd_layout
    .leftSpaceToView(_leftLineView , 0)
    .rightSpaceToView(self.contentView , 0.0f)
    .topEqualToView(_leftLineView)
    .heightIs(0.5f);
    
    //排序视图
    
    _sortView.sd_layout
    .centerYEqualToView(_titleLabel)
    .rightSpaceToView(self.contentView , 15)
    .heightIs(30);

}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.contentView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
    
    self.leftLineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
    
    self.rightLineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
}

#pragma mark - 设置数据

- (void)configPostCount:(NSInteger)postCount WithIsShowSort:(BOOL)isShowSort{
    
    UIColor *blueColor = [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:common_bg_blue_4];
    
    NSString *postCountString = [NSString stringWithFormat:@"%ld" , postCount];
    
    NSMutableAttributedString *postCountAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@条帖子" , postCountString]];
    
    [postCountAttrString setAttributes:@{NSForegroundColorAttributeName : blueColor} range:[postCountAttrString.string rangeOfString:postCountString]];
    
    self.titleLabel.attributedText = postCountAttrString;
    
    [self.titleLabel updateLayout];
    
    self.sortView.hidden = !isShowSort;
}

#pragma mark - 选中最新发表

- (void)selectedNewest{
    
    [self.sortView selectedNewest];
}

#pragma mark -选中最后回复

- (void)selectedLastReply{
    
    [self.sortView selectedLastReply];
}

@end

@interface CommunityCircleDetailsCellHeaderSortView ()

@property (nonatomic , strong ) UIButton *newestButton; //最新发表按钮

@property (nonatomic , strong ) UIButton *lastReplyButton; //最后回复按钮

@property (nonatomic , strong ) UIView *lineView; //分隔线视图

@end

@implementation CommunityCircleDetailsCellHeaderSortView

- (void)dealloc{
    
    _newestButton = nil;
    
    _lastReplyButton = nil;
    
    _lineView = nil;
}

- (instancetype)init
{
    self = [super init];
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
    
    self.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    self.layer.borderWidth = 0.5f;
    
    self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor;
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //最新发表按钮
    
    _newestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_newestButton setTitle:@"最新发表" forState:UIControlStateNormal];
    
    [_newestButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [_newestButton addTarget:self action:@selector(newestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _newestButton.selected = YES;
    
    [self addSubview:_newestButton];
    
    //分隔线视图
    
    _lineView = [[UIView alloc] init];
    
    _lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f];
    
    [self addSubview:_lineView];
    
    //最后回复按钮
    
    _lastReplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_lastReplyButton setTitle:@"最后回复" forState:UIControlStateNormal];
    
    [_lastReplyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [_lastReplyButton addTarget:self action:@selector(lastReplyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _lastReplyButton.selected = NO;
    
    [self addSubview:_lastReplyButton];
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //最新发表按钮
    
    _newestButton.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .widthIs(80);
    
    //分隔线视图
    
    _lineView.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(_newestButton , 0)
    .widthIs(0.5f)
    .heightRatioToView(self , 0.7f);
    
    //最后回复按钮
    
    _lastReplyButton.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftSpaceToView(_lineView , 0)
    .widthIs(80);
    
    [self setupAutoWidthWithRightView:self.lastReplyButton rightMargin:0.0f];
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    UIColor *blueColor = [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:common_bg_blue_3];
    
    _newestButton.lee_theme
    .LeeAddButtonTitleColor(DAY , [UIColor darkGrayColor] , UIControlStateNormal)
    .LeeAddButtonTitleColor(NIGHT , [UIColor darkGrayColor] , UIControlStateNormal)
    .LeeAddButtonTitleColor(DAY , blueColor , UIControlStateSelected)
    .LeeAddButtonTitleColor(NIGHT , blueColor , UIControlStateSelected);
    
    _lastReplyButton.lee_theme
    .LeeAddButtonTitleColor(DAY , [UIColor darkGrayColor] , UIControlStateNormal)
    .LeeAddButtonTitleColor(NIGHT , [UIColor darkGrayColor] , UIControlStateNormal)
    .LeeAddButtonTitleColor(DAY , blueColor , UIControlStateSelected)
    .LeeAddButtonTitleColor(NIGHT , blueColor , UIControlStateSelected);
    
}

#pragma mark - 最新发表按钮点击事件

- (void)newestButtonAction:(UIButton *)sender{
    
    if (!sender.isSelected) {
        
        [self selectedNewest];
        
        if (self.selectedNewestBlock) self.selectedNewestBlock();
    }
    
}

#pragma mark - 最后回复按钮点击事件

- (void)lastReplyButtonAction:(UIButton *)sender{
    
    if (!sender.isSelected) {
        
        [self selectedLastReply];
        
        if (self.selectedLastReplyBlock) self.selectedLastReplyBlock();
    }
    
}

- (void)selectedNewest{
    
    _newestButton.selected = YES;
    
    _lastReplyButton.selected = NO;
    
}

- (void)selectedLastReply{
    
    _lastReplyButton.selected = YES;
    
    _newestButton.selected = NO;
}

@end
