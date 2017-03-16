//
//  CommunityUserPostCell.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/15.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityUserPostCell.h"

#import "SDAutoLayout.h"

#import "CommunityPostCellPhotosView.h"

#import "YYLabel+Extend.h"

@interface CommunityUserPostCell ()

@property (nonatomic , strong ) YYLabel *titleLabel; //标题Label

@property (nonatomic , strong ) YYLabel *contentLabel; //内容摘要Label

@property (nonatomic , strong ) CommunityPostCellPhotosView *photosView; //图片视图

@property (nonatomic , strong ) UILabel *commentCountLabel; //评论数Label

@property (nonatomic , strong ) UILabel *lookCountLabel; //浏览数Label

@property (nonatomic , strong ) UIButton *deleteButton; //删除按钮

@property (nonatomic , strong ) UILabel *timeLabel; //时间Label

@property (nonatomic , strong ) UIView *bottomLineView; //底部分隔线

@end

@implementation CommunityUserPostCell

- (void)dealloc{
    
    _model = nil;
    
    _titleLabel = nil;
    
    _contentLabel = nil;
    
    _photosView = nil;
    
    _commentCountLabel = nil;
    
    _lookCountLabel = nil;
    
    _deleteButton = nil;
    
    _timeLabel = nil;
    
    _bottomLineView = nil;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame));
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    parser.emoticonMapper = [YYLabel faceMapper];
    
    // 标题Label
    
    _titleLabel = [[YYLabel alloc] init];
    
    _titleLabel.numberOfLines = 0;
    
    _titleLabel.textParser = parser;
    
    _titleLabel.displaysAsynchronously = YES; //开启异步绘制
    
    [self.contentView addSubview:_titleLabel];
    
    // 内容摘要Label
    
    _contentLabel = [[YYLabel alloc] init];
    
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.textParser = parser;
    
    _contentLabel.displaysAsynchronously = YES; //开启异步绘制
    
    [self.contentView addSubview:_contentLabel];
    
    // 图片视图
    
    _photosView = [[CommunityPostCellPhotosView alloc] init];
    
    [self.contentView addSubview:_photosView];
    
    // 评论数Label
    
    _commentCountLabel = [[UILabel alloc] init];
    
    _commentCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.contentView addSubview:_commentCountLabel];
    
    // 浏览数Label
    
    _lookCountLabel = [[UILabel alloc] init];
    
    _lookCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.contentView addSubview:_lookCountLabel];
    
    //删除按钮
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _deleteButton.hidden = YES;
    
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [self.contentView addSubview:_deleteButton];
    
    // 时间Label
    
    _timeLabel = [[UILabel alloc]init];
    
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.contentView addSubview:_timeLabel];
    
    //底部分隔线
    
    _bottomLineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_bottomLineView];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    // 标题Label
    
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView , 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(0.0f);
    
    // 内容摘要Label
    
    _contentLabel.sd_layout
    .topSpaceToView(self.titleLabel , 10.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(0.0f);
    
    // 图片视图
    
    _photosView.sd_layout
    .topSpaceToView(self.contentLabel , 10.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(0.0f);
    
    // 评论数Label
    
    _commentCountLabel.sd_layout
    .topSpaceToView(self.photosView , 10.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .heightIs(20.0f);
    
    [_commentCountLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 浏览数Label
    
    _lookCountLabel.sd_layout
    .topEqualToView(self.commentCountLabel)
    .leftSpaceToView(self.commentCountLabel , 10.0f)
    .heightIs(20.0f);
    
    [_lookCountLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 删除按钮
    
    _deleteButton.sd_layout
    .leftSpaceToView(self.lookCountLabel , 10.0f)
    .centerYEqualToView(self.lookCountLabel)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    // 时间Label
    
    _timeLabel.sd_layout
    .topEqualToView(self.commentCountLabel)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(20.0f);
    
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    //底部分隔线
    
    _bottomLineView.sd_layout
    .topSpaceToView(self.timeLabel, 15.0f)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(10.0f);
    
    [self setupAutoHeightWithBottomView:self.bottomLineView bottomMargin:0.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.selectedBackgroundView.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
    
    self.contentLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.commentCountLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.lookCountLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.deleteButton.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4, UIControlStateNormal);
    
    self.timeLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.bottomLineView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
}

#pragma mark - 获取数据

- (void)setModel:(CommunityListModel *)model{
    
    if (_model != model) {
        
        _model = model;
    }
    
    if (model) {
        
        //设置数据
        
        [self configDataWithModel:model];
    }
    
}

#pragma mark - 设置数据

-(void)configDataWithModel:(CommunityListModel *)model{
    
    //设置标题
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:model.title];
    
    titleString.lineSpacing = 8.0f;
    
    titleString.font = [UIFont boldSystemFontOfSize:16.0f];
    
    titleString.color = [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:common_font_color_1];
    
    self.titleLabel.attributedText = titleString;
    
    [YYLabel configTextLayoutWithLabel:self.titleLabel MaxRows:2 MaxSize:CGSizeMake(self.width - 30, MAXFLOAT)];
    
    self.titleLabel.sd_layout.heightIs(self.titleLabel.textLayout.textBoundingSize.height);
    
    //设置摘要内容
    
    if (model.abstract && ![model.abstract isEqualToString:@""]) {
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:model.abstract];
        
        contentString.lineSpacing = 7.0f;
        
        contentString.font = [UIFont systemFontOfSize:14.0f];
        
        contentString.color = [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:common_font_color_4];
        
        self.contentLabel.attributedText = contentString;
        
        [YYLabel configTextLayoutWithLabel:self.contentLabel MaxRows:3 MaxSize:CGSizeMake(self.width - 30, MAXFLOAT)];
        
        self.contentLabel.sd_layout
        .topSpaceToView(self.titleLabel , 10.0f)
        .heightIs(self.contentLabel.textLayout.textBoundingSize.height);
        
    } else {
        
        self.contentLabel.sd_layout.topSpaceToView(self.titleLabel , 0.0f).heightIs(0.0f);
    }
    
    [self.photosView configImageUrlArray:model.photoList ImageCount:model.photoCount];
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld评论" , model.commentCount];
    
    self.lookCountLabel.text = [NSString stringWithFormat:@"%ld浏览" , model.lookCount];
    
    self.timeLabel.text = model.timeString;
    
    //判断删除按钮是否显示
    
    if ([model.authorId isEqualToString:@"当前用户Id"]) {
        
        self.deleteButton.hidden = NO;
        
    } else {
        
        self.deleteButton.hidden = YES;
    }
    
}

#pragma mark - 删除按钮点击事件

- (void)deleteButtonAction:(id)sender{
    
    if (self.deleteBlock) {
        
        self.deleteBlock(self.model);
    }
    
}

@end
