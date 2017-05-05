//
//  CommunityPostCell.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityPostCell.h"

#import "SDAutoLayout.h"

#import "NameRankView.h"

#import "CommunityPostCellPhotosView.h"

#import "YYLabel+Extend.h"

@interface CommunityPostCell ()

@property (nonatomic , strong ) UIView *backGroundView; //背景视图

@property (nonatomic , strong ) UIImageView *circleImageView; //圈子图片视图

@property (nonatomic , strong ) UILabel *circleNameLabel; //圈子名称Label

@property (nonatomic , strong ) UIImageView *headImageView; //头像视图

@property (nonatomic , strong ) NameRankView *nameRankView; //名字等级视图

@property (nonatomic , strong ) YYLabel *titleLabel; //标题Label

@property (nonatomic , strong ) YYLabel *contentLabel; //内容摘要Label

@property (nonatomic , strong ) CommunityPostCellPhotosView *photosView; //图片视图

@property (nonatomic , strong ) UILabel *commentCountLabel; //评论数Label

@property (nonatomic , strong ) UILabel *lookCountLabel; //浏览数Label

@property (nonatomic , strong ) UIImageView *locationImageView; //位置图标视图

@property (nonatomic , strong ) UILabel *locationLabel; //位置Label

@property (nonatomic , strong ) UILabel *timeLabel; //时间Label

@end

@implementation CommunityPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    
    // 背景视图
    
    _backGroundView = [[UIView alloc] init];
    
    [self.contentView addSubview:_backGroundView];
    
    // 圈子图片视图
    
    _circleImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_circleImageView];
    
    // 圈子名称Label
    
    _circleNameLabel = [[UILabel alloc] init];
    
    _circleNameLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _circleNameLabel.textColor = [UIColor whiteColor];
    
    _circleNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.circleImageView addSubview:_circleNameLabel];
    
    // 头像视图
    
    _headImageView = [[UIImageView alloc] init];
    
    _headImageView.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    [self.backGroundView addSubview:_headImageView];
    
    // 名字等级视图
    
    _nameRankView = [[NameRankView alloc] init];
    
    _nameRankView.fontSize = 16.0f;
    
    _nameRankView.backgroundColor = [UIColor clearColor];
    
    [self.backGroundView addSubview:_nameRankView];
    
    self.nameRankView.maxWidth = self.width - 70.0f; //设置最大宽度 防止昵称过长导致布局错乱
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    parser.emoticonMapper = [YYLabel faceMapper];
    
    // 标题Label
    
    _titleLabel = [[YYLabel alloc] init];
    
    _titleLabel.numberOfLines = 0;
    
    _titleLabel.textParser = parser;
    
    _titleLabel.displaysAsynchronously = NO; //开启异步绘制
    
    [self.backGroundView addSubview:_titleLabel];
    
    // 内容摘要Label
    
    _contentLabel = [[YYLabel alloc] init];
    
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.textParser = parser;
    
    _contentLabel.displaysAsynchronously = NO; //开启异步绘制
    
    [self.backGroundView addSubview:_contentLabel];
    
    // 图片视图
    
    _photosView = [[CommunityPostCellPhotosView alloc] init];
    
    [self.backGroundView addSubview:_photosView];
    
    // 评论数Label
    
    _commentCountLabel = [[UILabel alloc] init];
    
    _commentCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.backGroundView addSubview:_commentCountLabel];
    
    // 浏览数Label
    
    _lookCountLabel = [[UILabel alloc] init];
    
    _lookCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.backGroundView addSubview:_lookCountLabel];
    
    // 位置图标视图
    
    _locationImageView = [[UIImageView alloc] init];
    
    _locationImageView.image = [UIImage imageNamed:@"find_circle_smallic_place"];
    
    _locationImageView.contentMode = UIViewContentModeCenter;
    
    [self.backGroundView addSubview:_locationImageView];
    
    // 位置Label
    
    _locationLabel = [[UILabel alloc] init];
    
    _locationLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.backGroundView addSubview:_locationLabel];
    
    // 时间Label
    
    _timeLabel = [[UILabel alloc]init];
    
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.backGroundView addSubview:_timeLabel];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    _backGroundView.sd_layout
    .topSpaceToView(self.contentView , 0.0f)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    // 圈子图片视图
    
    _circleImageView.sd_layout
    .topSpaceToView(self.contentView , 5.0f)
    .rightSpaceToView(self.contentView , 5.0f)
    .widthIs(66.0f)
    .heightIs(24.0f);
    
    // 圈子名称Label
    
    _circleNameLabel.sd_layout
    .topEqualToView(self.circleImageView)
    .leftSpaceToView(self.circleImageView , 5.0f)
    .rightSpaceToView(self.circleImageView , 2.0f)
    .bottomEqualToView(self.circleImageView);

    // 头像视图

    _headImageView.sd_layout
    .topSpaceToView(self.backGroundView , 25.0f)
    .leftSpaceToView(self.backGroundView , 15.0f)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    // 名字等级视图
    
    _nameRankView.sd_layout
    .centerYEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView , 10.0f)
    .heightIs(20.0f);
    
    // 标题Label
    
    _titleLabel.sd_layout
    .topSpaceToView(self.headImageView , 15.0f)
    .leftSpaceToView(self.backGroundView , 15.0f)
    .rightSpaceToView(self.backGroundView , 15.0f)
    .heightIs(0.0f);
    
    // 内容摘要Label
    
    _contentLabel.sd_layout
    .topSpaceToView(self.titleLabel , 10.0f)
    .leftSpaceToView(self.backGroundView , 15.0f)
    .rightSpaceToView(self.backGroundView , 15.0f)
    .heightIs(0.0f);
    
    // 图片视图
    
    _photosView.sd_layout
    .topSpaceToView(self.contentLabel , 10.0f)
    .leftSpaceToView(self.backGroundView , 15.0f)
    .rightSpaceToView(self.backGroundView , 15.0f)
    .heightIs(0.0f);
    
    // 评论数Label
    
    _commentCountLabel.sd_layout
    .topSpaceToView(self.photosView , 10.0f)
    .leftSpaceToView(self.backGroundView , 15.0f)
    .heightIs(20.0f);
    
    [_commentCountLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 浏览数Label
    
    _lookCountLabel.sd_layout
    .topEqualToView(self.commentCountLabel)
    .leftSpaceToView(self.commentCountLabel , 10.0f)
    .heightIs(20.0f);
    
    [_lookCountLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 位置图标
    
    _locationImageView.sd_layout
    .centerYEqualToView(self.commentCountLabel)
    .leftSpaceToView(self.lookCountLabel , 10.0f)
    .widthIs(12.0f)
    .heightIs(12.0f);
    
    // 位置Label
    
    _locationLabel.sd_layout
    .topEqualToView(self.commentCountLabel)
    .leftSpaceToView(self.locationImageView , 2.0f)
    .heightIs(20.0f);
    
    [_locationLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 时间Label
    
    _timeLabel.sd_layout
    .topEqualToView(self.commentCountLabel)
    .rightSpaceToView(self.backGroundView , 15.0f)
    .heightIs(20.0f);
    
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    [self.backGroundView setupAutoHeightWithBottomView:self.timeLabel bottomMargin:15.0f];
    
    [self setupAutoHeightWithBottomView:self.backGroundView bottomMargin:10.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.selectedBackgroundView.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.backGroundView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.headImageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
    
    self.contentLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.commentCountLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.lookCountLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.locationLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.timeLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
}

#pragma mark - 获取数据

-(void)setModel:(CommunityListModel *)model{
    
    if (_model != model) {
        
        _model = model;
    }
    
    if (model) {
        
        //设置数据
        
        [self configDataWithModel:model];
    }
    
}

- (void)setIsShowCircle:(BOOL)isShowCircle{
    
    _isShowCircle = isShowCircle;
    
    if (isShowCircle) {
        
        if (self.circleImageView.hidden) self.circleImageView.hidden = NO;
        
        if (self.circleNameLabel.hidden) self.circleNameLabel.hidden = NO;
        
    } else {
        
        if (!self.circleImageView.hidden) self.circleImageView.hidden = YES;
        
        if (!self.circleNameLabel.hidden) self.circleNameLabel.hidden = YES;
    }
    
}

#pragma mark - 设置数据

- (void)configDataWithModel:(CommunityListModel *)model{
    
    self.circleImageView.image = [self handleCircleImage:model.circleGroupId.integerValue];
    
    self.circleNameLabel.text = model.circleName;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.authorHeadImage]
                      placeholder:nil
                          options:YYWebImageOptionSetImageWithFadeAnimation
                         progress:nil
                        transform:^UIImage *(UIImage *image, NSURL *url) {
                            
                            return image;
                        }
                       completion:nil];
    
    NSString *rankName = [RankManager rankNameArray][model.authorLevel.integerValue - 1];
    
    NSString *rankImageUrl = [RankManager rankImageArray][model.authorLevel.integerValue - 1];
    
    [self.nameRankView configWithName:model.authorName LevelImage:rankImageUrl LevelName:rankName];
    
    //设置标题
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:model.title];
    
    titleString.lineSpacing = 8.0f;
    
    titleString.font = [UIFont boldSystemFontOfSize:16.0f];
    
    titleString.color = LEEColorFromIdentifier([LEETheme currentThemeTag], common_font_color_1);
    
    self.titleLabel.attributedText = titleString;
    
    [YYLabel configTextLayoutWithLabel:self.titleLabel MaxRows:2 MaxSize:CGSizeMake(self.width - 30, MAXFLOAT)];
    
    self.titleLabel.sd_layout.heightIs(self.titleLabel.textLayout.textBoundingSize.height);
    
    //设置摘要内容
    
    if (model.abstract && ![model.abstract isEqualToString:@""]) {
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:model.abstract];
        
        contentString.lineSpacing = 7.0f;
        
        contentString.font = [UIFont systemFontOfSize:14.0f];
        
        contentString.color = LEEColorFromIdentifier([LEETheme currentThemeTag], common_font_color_4);
        
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
    
    if (!model.location || [model.location isEqualToString:@""]) {
        
        self.locationImageView.hidden = YES;
        
        self.locationLabel.hidden = YES;
        
    } else {
        
        self.locationImageView.hidden = NO;
        
        self.locationLabel.hidden = NO;
        
        self.locationLabel.text = model.location;
    }
    
    self.timeLabel.text = model.collectTime ? model.collectTime : model.timeString;
}

#pragma mark - 处理圈子图片

- (UIImage *)handleCircleImage:(NSInteger)circleGroupId{
    
    UIImage *image = nil;
    
    switch (circleGroupId) {
        
        case 3:
            
            image = [UIImage imageNamed:@"find_circle_flag_blue"];
            
            break;
            
        case 4:
            
            image = [UIImage imageNamed:@"find_circle_flag_orange"];
            
            break;
            
        case 5:
            
            image = [UIImage imageNamed:@"find_circle_flag_green"];
            
            break;
            
        case 6:
            
            image = [UIImage imageNamed:@"find_circle_flag_mier_a"];
            
            break;
            
        case 7:
            
            image = [UIImage imageNamed:@"find_circle_flag_mier_b"];
            
            break;
            
        default:
            
            image = [UIImage imageNamed:@"find_circle_flag_blue"];
            
            break;
    }
    
    return image;
}

@end
