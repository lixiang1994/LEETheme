//
//  CommunityCommentCell.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCommentCell.h"

#import "SDAutoLayout.h"

#import "CorrelationStateManager.h"

#import "NameRankView.h"

#import "FontSizeManager.h"

#import "CommunityCommentModel.h"

#import "LEECoolButton.h"

#import "YYLabel+Extend.h"

#import "MierProgressHUD.h"

@interface CommunityCommentCell ()

@property (nonatomic , strong ) UIImageView *headImageView; //头像图片

@property (nonatomic , strong ) UIImageView *masterImageView; //楼主图标图片

@property (nonatomic , strong ) NameRankView *namerankView; //昵称等级视图

@property (nonatomic , strong ) UILabel *floorLabel; //楼层数Label

@property (nonatomic , strong ) UIView *replyCommentView; //回复评论视图

@property (nonatomic , strong ) YYLabel *replyCommentLabel; //回复评论Label

@property (nonatomic , strong ) YYLabel *contentLabel; //评论内容Label

@property (nonatomic , strong ) UILabel *timeLabel; //时间Label

@property (nonatomic , strong ) LEECoolButton *praiseButton; //赞按钮

@property (nonatomic , strong ) UIButton *readAllButton; //显示全部按钮

@property (nonatomic , strong ) UIButton *deleteButton; //删除按钮

@property (nonatomic , strong ) UIView *lineView;

@property (nonatomic , assign ) CGFloat leftMargin;

@end

@implementation CommunityCommentCell

- (void)dealloc{
    
    _headImageView = nil;
    
    _masterImageView = nil;
    
    _namerankView = nil;
    
    _floorLabel = nil;
    
    _replyCommentView = nil;
    
    _replyCommentLabel = nil;
    
    _contentLabel = nil;
    
    _timeLabel = nil;
    
    _praiseButton = nil;
    
    _readAllButton = nil;
    
    _deleteButton = nil;
    
    _lineView = nil;
    
    _model = nil;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    //[super setSelected:selected animated:animated];
}

#pragma mark - 初始化

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //添加通知
        
        [self addNotification];
        
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

#pragma mark - 添加通知

- (void)addNotification{
    
    
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.leftMargin = 15.0f;
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //头像视图
    
    _headImageView = [[UIImageView alloc] init];
    
    _headImageView.backgroundColor = [UIColor clearColor];
    
    _headImageView.userInteractionEnabled = YES;
    
    [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewAction)]];
    
    [self.contentView addSubview:_headImageView];
    
    //楼主图标图片
    
    _masterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_circle_details_floorhost"]];
    
    _masterImageView.hidden = YES;
    
    [self.contentView addSubview:_masterImageView];
    
    //昵称等级视图
    
    _namerankView = [[NameRankView alloc] init];
    
    _namerankView.backgroundColor = [UIColor clearColor];
    
    [_namerankView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewAction)]];
    
    [self.contentView addSubview:_namerankView];
    
    //楼层数Label
    
    _floorLabel = [[UILabel alloc] init];
    
    _floorLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:12.0f]];
    
    [self.contentView addSubview:_floorLabel];
    
    //回复评论视图
    
    _replyCommentView = [[UIView alloc] init];
    
    _replyCommentView.clipsToBounds = YES;
    
    _replyCommentView.layer.borderWidth = 0.5f;
    
    [self.contentView addSubview:_replyCommentView];
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    parser.emoticonMapper = [YYLabel faceMapper];
    
    //回复评论Label
    
    _replyCommentLabel = [[YYLabel alloc] init];
    
    _replyCommentLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:15.0f]];
    
    _replyCommentLabel.numberOfLines = 0;
    
    _replyCommentLabel.textParser = parser;
    
    _replyCommentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    _replyCommentLabel.displaysAsynchronously = YES; //开启异步绘制
    
    [self.replyCommentView addSubview:_replyCommentLabel];
    
    //内容Label
    
    _contentLabel = [[YYLabel alloc] init];
    
    _contentLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:15.0f]];
    
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.textParser = parser;
    
    _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    _contentLabel.displaysAsynchronously = NO; //开启异步绘制
    
    [self.contentView addSubview:_contentLabel];
    
    //查看全部按钮
    
    _readAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _readAllButton.titleLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:15.0f]];
    
    _readAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_readAllButton addTarget:self action:@selector(readAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_readAllButton setTitle:@"查看全文" forState:UIControlStateNormal];
    
    [self.contentView addSubview:_readAllButton];
    
    //时间Label
    
    _timeLabel = [[UILabel alloc] init];
    
    _timeLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:12.0f]];
    
    [self.contentView addSubview:_timeLabel];
    
    //删除按钮
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _deleteButton.hidden = YES;
    
    _deleteButton.titleLabel.font = self.timeLabel.font;
    
    _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [self.contentView addSubview:_deleteButton];
    
    //初始化赞按钮
    
    _praiseButton = [LEECoolButton coolButtonWithImage:nil ImageFrame:CGRectMake(47, 6, 16, 16)];
    
    _praiseButton.imageOn = [UIImage imageNamed:@"drawer_digg_btn_pressed"];
    
    _praiseButton.imageOff = [UIImage imageNamed:@"drawer_digg_btn_normal"];
    
    _praiseButton.circleColor = [UIColor colorWithRed:52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
    
    _praiseButton.lineColor = [UIColor colorWithRed:41/255.0f green:128/255.0f blue:185/255.0f alpha:1.0f];
    
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    _praiseButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [_praiseButton addTarget:self action:@selector(praiseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_praiseButton];
    
    //lineVew
    
    _lineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_lineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //头像视图
    
    _headImageView.sd_layout
    .leftSpaceToView(self.contentView, self.leftMargin)
    .topSpaceToView(self.contentView, 15.0f)
    .heightIs(30.0f)
    .widthEqualToHeight();
    
    self.headImageView.layer.cornerRadius = 30.0f / 2;
    self.headImageView.layer.masksToBounds = YES;
    
    //楼主图标图片
    
    _masterImageView.sd_layout
    .leftEqualToView(self.headImageView)
    .bottomEqualToView(self.headImageView)
    .widthRatioToView(self.headImageView , 1)
    .heightIs(10.0f);
    
    //昵称等级视图
    
    _namerankView.sd_layout
    .leftSpaceToView(self.headImageView, 10.0f)
    .topEqualToView(self.headImageView).offset(4.0f)
    .heightIs(20.0f);
    
    //楼层数Label
    
    _floorLabel.sd_layout
    .rightSpaceToView(self.contentView, 15.0f)
    .centerYEqualToView(self.namerankView)
    .heightIs(30.0f);
    
    [self.floorLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    //回复评论视图
    
    _replyCommentView.sd_layout
    .topSpaceToView(self.namerankView, 10.0f)
    .leftEqualToView(self.namerankView)
    .rightSpaceToView(self.contentView, 15.0f)
    .heightIs(0.0f);
    
    _replyCommentLabel.sd_layout
    .topSpaceToView(self.replyCommentView, 10.0f)
    .leftSpaceToView(self.replyCommentView , 10.0f)
    .rightSpaceToView(self.replyCommentView, 10.0f)
    .bottomSpaceToView(self.replyCommentView , 10.0f);
    
    //评论内容
    
    _contentLabel.sd_layout
    .topSpaceToView(self.replyCommentView, 10.0f)
    .leftEqualToView(self.replyCommentView)
    .rightSpaceToView(self.contentView, 15.0f)
    .heightIs(0.0f);
    
    //查看全部按钮
    
    _readAllButton.sd_layout
    .leftEqualToView(self.namerankView)
    .topSpaceToView(self.contentLabel, 0.0f)
    .widthIs(200)
    .heightIs(30.0);
    
    //时间
    
    _timeLabel.sd_layout
    .leftEqualToView(self.namerankView)
    .topSpaceToView(self.readAllButton, 5.0f)
    .autoHeightRatio(0);
    
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200.0f];
    
    _deleteButton.sd_layout
    .leftSpaceToView(self.timeLabel , 5.0f)
    .centerYEqualToView(self.timeLabel)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    _praiseButton.sd_layout
    .rightSpaceToView(self.contentView, 15.0f)
    .centerYEqualToView(self.timeLabel)
    .widthIs(65.0f)
    .heightIs(30.0f);
    
    _praiseButton.titleLabel.sd_layout
    .rightSpaceToView(self.praiseButton , 20.0f);
    
    [self.praiseButton.titleLabel setSingleLineAutoResizeWithMaxWidth:60];
    
    _lineView.sd_layout
    .leftEqualToView(self.headImageView)
    .rightSpaceToView(self.contentView, 15.0f)
    .topSpaceToView(self.praiseButton, 15.0f)
    .heightIs(0.5f);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.backgroundColor  = [UIColor clearColor];
    
    self.selectedBackgroundView.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
    
    self.lineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
    
    self.headImageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.floorLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.timeLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.praiseButton.lee_theme.LeeConfigButtonTitleColor(common_font_color_4, UIControlStateNormal);
    
    self.replyCommentView.layer.lee_theme.LeeConfigBorderColor(common_bar_divider1);
    
    self.replyCommentView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.replyCommentLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.contentLabel.lee_theme.LeeConfigTextColor(common_font_color_3);
    
    self.contentLabel.backgroundColor = [UIColor clearColor];
    
    self.deleteButton.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4, UIControlStateNormal);
    
    self.readAllButton.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4, UIControlStateNormal);
}

- (void)setModel:(CommunityCommentModel *)model{
    
    _model = model;
    
    if (!model) return;
    
    //设置头像
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.userImg] options:YYWebImageOptionSetImageWithFadeAnimation];
    
    //设置楼层数
    
    self.floorLabel.text = model.floor;
    
    [self.floorLabel updateLayout];
    
    //设置名字和等级
    
    [self.namerankView configWithName:model.userName Level:model.userLevel];
    
    self.namerankView.maxWidth = self.width - 60.0f - self.floorLabel.width - 20.0f; //设置最大宽度 防止昵称过长导致布局错乱
    
    //当前未赞状态时 查询数据库
    
    if (!model.isPraise) {
        
        model.isPraise = [CorrelationStateManager checkType:CorrelationTypeCommunityComment State:CorrelationStatePraise Identifier:self.model.commentId];
    }
    
    //更新点赞数
    
    [self updatePraiseCount];
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])  - (self.leftMargin + 30.0f + 10.0f) - 15.0f, 10000);
    
    //设置所回复评论
    
    if (model.replysArray.count){
        
        NSDictionary *info = model.replysArray.lastObject;
        
        NSMutableAttributedString *replyCommentString = [[NSMutableAttributedString alloc] init];
        
        [replyCommentString appendString:info[@"userName"]];
        
        [replyCommentString appendString:@":\n"];
        
        [replyCommentString appendString:info[@"content"]];
        
        replyCommentString.font = [UIFont systemFontOfSize:14.0f];
        
        replyCommentString.color = [UIColor grayColor];
        
        replyCommentString.lineSpacing = 8.0f;
        
        self.replyCommentLabel.attributedText = replyCommentString;
        
        [YYLabel configTextLayoutWithLabel:self.replyCommentLabel MaxRows:0 MaxSize:CGSizeMake(contentSize.width - 20.0f, contentSize.height)];
        
        if (self.replyCommentLabel.textLayout.rowCount > 4 && !self.model.isShowAllReply) {
         
            self.replyCommentLabel.numberOfLines = 4;
            
            NSMutableAttributedString *moreString = [[NSMutableAttributedString alloc] initWithString:@" 更多"];
            
            moreString.font = [UIFont systemFontOfSize:14.0f];
            
            moreString.color = [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] Identifier:common_bg_blue_4];
            
            moreString.lineSpacing = 8.0f;
            
            __weak typeof(self) weakSelf = self;
            
            [moreString setTextHighlightRange:NSMakeRange(0, moreString.string.length) color:moreString.color backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                if (weakSelf) {
                    
                    weakSelf.model.isShowAllReply = YES;
                    
                    if (weakSelf.reloadCellBlock) weakSelf.reloadCellBlock();
                }
                
            }];
            
            //删除多余文字 拼接"更多"
            
            [replyCommentString deleteCharactersInRange:NSMakeRange(self.replyCommentLabel.textLayout.visibleRange.length - moreString.length, self.replyCommentLabel.textLayout.range.length - self.replyCommentLabel.textLayout.visibleRange.length + moreString.length)];
            
            [replyCommentString appendAttributedString:moreString];
            
            self.replyCommentLabel.attributedText = replyCommentString;
            
        } else {
            
            self.replyCommentLabel.numberOfLines = 0;
        }
        
        self.replyCommentView.hidden = NO;
        
        self.replyCommentView.sd_layout
        .topSpaceToView(self.namerankView, 10.0f)
        .heightIs(self.replyCommentLabel.textLayout.textBoundingSize.height + 20.0f);
        
    } else {
        
        self.replyCommentView.hidden = YES;
        
        [self.replyCommentView clearAutoHeigtSettings];
        
        self.replyCommentView.sd_layout
        .topSpaceToView(self.namerankView, 0.0f)
        .heightIs(0.0f);
    }
    
    //设置评论内容
    
    NSMutableAttributedString *commentContentString = [[NSMutableAttributedString alloc] initWithString:model.commentContent];
    
    commentContentString.font = [UIFont systemFontOfSize:16.0f];
    
    commentContentString.color = [UIColor darkGrayColor];
    
    commentContentString.lineSpacing = 8.0f;
    
    self.contentLabel.attributedText = commentContentString;
    
    //获取评论内容高度 判断是否显示全部评论内容
    
    [YYLabel configTextLayoutWithLabel:self.contentLabel MaxRows:0 MaxSize:contentSize];
    
    if (self.contentLabel.textLayout.rowCount > 8 && !self.model.isShowAllContent){
        
        self.contentLabel.numberOfLines = 8;
        
        self.readAllButton.hidden = NO;
        
        self.timeLabel.sd_layout
        .topSpaceToView(self.readAllButton , 5.0f);
        
    } else {
     
        self.contentLabel.numberOfLines = 0;
        
        self.readAllButton.hidden = YES;
        
        self.timeLabel.sd_layout
        .topSpaceToView(self.contentLabel , 10.0f);
    }
    
    self.contentLabel.sd_layout.heightIs(self.contentLabel.textLayout.textBoundingSize.height);
    
    //设置时间
    
    self.timeLabel.text = model.publishTime;
    
    //判断删除按钮是否显示
    
    if ([model.userId isEqualToString:@"当前用户Id"]) {
        
        if (model.checkState != 2) {
            
            self.deleteButton.hidden = NO;
            
        } else {
            
            self.deleteButton.hidden = YES;
        }
        
    } else {
        
        self.deleteButton.hidden = YES;
    }
    
    [self updateLayoutWithCellContentView:self.contentView];
    
    //检测是否赞
    
    [self checkPraise];
}

#pragma mark - 是否楼主

- (void)setIsMaster:(BOOL)isMaster{
    
    _isMaster = isMaster;
    
    self.masterImageView.hidden = !isMaster;
}

#pragma mark - 更新点赞数

- (void)updatePraiseCount{
    
    //设置点赞数 并做超限处理
    
    NSInteger praiseCount = self.model.praiseCount;
    
    NSString *praiseCountString = nil;
    
    if (praiseCount > 9999) {
        
        NSInteger wan = praiseCount / 10000;
        
        NSInteger qian = (praiseCount - wan * 10000) / 1000;
        
        if (qian && wan < 100) {
            
            praiseCountString = [NSString stringWithFormat:@"%ld.%ld万", wan , qian];
            
        } else {
            
            praiseCountString = [NSString stringWithFormat:@"%ld万", wan];
        }
        
    } else {
        
        praiseCountString = [NSString stringWithFormat:@"%ld" , praiseCount];
    }
    
    [self.praiseButton setTitle:praiseCountString forState:UIControlStateNormal];
}

#pragma mark - 头像视图点击事件

- (void)headImageViewAction{
    
    if (self.openUserHomeBlock){
        
        self.openUserHomeBlock(self.model);
    }
    
}

#pragma mark - 检测点赞状态

- (void)checkPraise{
    
    self.praiseButton.selected = self.model.isPraise;
    
    //设置点赞按钮文字颜色
    
    if (self.praiseButton.selected) {
        
        self.praiseButton.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4, UIControlStateNormal);
        
    } else {
        
        self.praiseButton.lee_theme.LeeConfigButtonTitleColor(common_font_color_4, UIControlStateNormal);
    }
    
}

#pragma mark - 点赞

- (void)praiseClick{
    
    [self praiseButtonAction:self.praiseButton];
}

#pragma mark - 赞按钮点击事件

- (void)praiseButtonAction:(LEECoolButton *)sender{
    
    if (self.model.isPraise){
        
        [MierProgressHUD showMessage:@"您已经顶过该评论了!"];
        
        return;
    }
    
    if (!sender.selected) {
        
        [sender select];
        
        sender.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4, UIControlStateNormal);
        
        if (self.praiseBlock){
            
            self.praiseBlock(self.model , self);
        }
        
    }
    
}

#pragma mark - 显示全部钮点击事件

- (void)readAllButtonAction:(id)sender{
    
    //显示全部评论内容
    
    self.model.isShowAllContent = YES;
    
    if (self.reloadCellBlock){
        
        self.reloadCellBlock();
    }
    
}

#pragma mark - 删除按钮点击事件

- (void)deleteButtonAction:(id)sender{
    
    if (self.deleteBlock) {
        
        self.deleteBlock(self.model);
    }
    
}

@end
