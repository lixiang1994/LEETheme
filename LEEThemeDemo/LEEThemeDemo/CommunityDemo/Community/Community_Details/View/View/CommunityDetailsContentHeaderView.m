//
//  CommunityDetailsContentHeaderView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/7.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsContentHeaderView.h"

#import "SDAutoLayout.h"

#import "NameRankView.h"

#import "YYLabel+Extend.h"

@interface CommunityDetailsContentHeaderView  ()

@property (nonatomic , strong ) UIImageView *headImageView; //头像视图

@property (nonatomic , strong ) NameRankView *nameRankView; //名字等级视图

@property (nonatomic , strong ) UIImageView *locationImageView; //位置图标视图

@property (nonatomic , strong ) UILabel *locationLabel; //位置Label

@property (nonatomic , strong ) YYLabel *titleLabel; //标题Label

@property (nonatomic , strong ) UIButton *followButton; //关注按钮

@end

@implementation CommunityDetailsContentHeaderView

- (instancetype)init
{
    self = [super init];
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
    
    // 头像视图
    
    _headImageView = [[UIImageView alloc] init];
    
    _headImageView.userInteractionEnabled = YES;
    
    _headImageView.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUserHome)]];
    
    [self addSubview:_headImageView];
    
    // 名字等级视图
    
    _nameRankView = [[NameRankView alloc] init];
    
    _nameRankView.fontSize = 14.0f;
    
    _nameRankView.backgroundColor = [UIColor clearColor];
    
    [_nameRankView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUserHome)]];
    
    [self addSubview:_nameRankView];
    
    // 位置图标视图
    
    _locationImageView = [[UIImageView alloc] init];
    
    _locationImageView.image = [UIImage imageNamed:@"find_circle_smallic_place"];
    
    _locationImageView.contentMode = UIViewContentModeCenter;
    
    [self addSubview:_locationImageView];
    
    // 位置Label
    
    _locationLabel = [[UILabel alloc] init];
    
    _locationLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self addSubview:_locationLabel];
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    parser.emoticonMapper = [YYLabel faceMapper];
    
    // 标题Label
    
    _titleLabel = [[YYLabel alloc] init];
    
    _titleLabel.numberOfLines = 0;
    
    _titleLabel.textParser = parser;
    
    _titleLabel.displaysAsynchronously = YES; //开启异步绘制
    
    [self addSubview:_titleLabel];
    
    // 关注按钮
    
    UIColor *blueColor = LEEColorFromIdentifier([LEETheme currentThemeTag], common_bg_blue_4);
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _followButton.layer.cornerRadius = 5.0f;
    
    _followButton.clipsToBounds = YES;
    
    [_followButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_followButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [_followButton setBackgroundImage:[UIImage imageWithColor:blueColor] forState:UIControlStateNormal];
    
    [_followButton setBackgroundImage:[UIImage imageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3f]] forState:UIControlStateSelected];
    
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    
    [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_followButton];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    // 头像视图
    
    _headImageView.sd_layout
    .topSpaceToView(self , 15.0f)
    .leftSpaceToView(self , 15.0f)
    .widthIs(40.0f)
    .heightIs(40.0f);
    
    // 名字等级视图
    
    _nameRankView.sd_layout
    .topEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView , 10.0f)
    .heightIs(20.0f);
    
    //位置图标
    
    _locationImageView.sd_layout
    .topSpaceToView(self.nameRankView , 8.0f)
    .leftEqualToView(self.nameRankView)
    .widthIs(12.0f)
    .heightIs(12.0f);
    
    // 位置Label
    
    _locationLabel.sd_layout
    .leftSpaceToView(self.locationImageView , 2.0f)
    .centerYEqualToView(self.locationImageView)
    .heightIs(20.0f);
    
    [_locationLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    //关注按钮
    
    _followButton.sd_layout
    .rightSpaceToView(self , 15.0f)
    .centerYEqualToView(self.headImageView)
    .widthIs(68.0f)
    .heightIs(28.0f);
    
    // 标题Label
    
    _titleLabel.sd_layout
    .topSpaceToView(self.headImageView , 30.0f)
    .leftSpaceToView(self , 15.0f)
    .rightSpaceToView(self , 15.0f)
    .heightIs(0.0f);
    
    [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:15.0f];
}

#pragma mark - 设置主题

-(void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.headImageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_2);
    
    self.locationLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
}

#pragma mark - 打开用户主页

- (void)openUserHome{
    
    if (self.openUserHomeBlock) {
        
        self.openUserHomeBlock();
    }
    
}

#pragma mark - 关注按钮点击事件

- (void)followButtonAction:(UIButton *)sender{
    /*
    __weak typeof(self) weakSelf = self;
    
    [[UserManager shareManager] followUserId:self.model.authorId IsCancel:sender.selected ResultBlock:^(BOOL success) {
        
        if (weakSelf) {
            
            if (success) {
                
                if (sender.selected) {
                    
                    [MierProgressHUD showMessage:@"已取消"];
                    
                } else {
                    
                    [MierProgressHUD showMessage:@"关注成功"];
                }
                
                sender.selected = !sender.selected;
                
                switch (weakSelf.model.followState) {
                        
                    case 0:
                        
                        weakSelf.model.followState = 1; //无关系 改为关注对方
                        
                        [weakSelf.followButton setTitle:@"已关注" forState:UIControlStateSelected];
                        
                        break;
                        
                    case 1:
                        
                        weakSelf.model.followState = 0; //如果自己关注了对方 则改为无关系
                        
                        break;
                        
                    case 2:
                        
                        weakSelf.model.followState = 3; //对方关注了自己 改为互相关注
                        
                        [weakSelf.followButton setTitle:@"互相关注" forState:UIControlStateSelected];
                        
                        break;
                        
                    case 3:
                        
                        weakSelf.model.followState = 2; //如果双方相互关注 则改为对方关系自己
                        
                        break;
                        
                    default:
                        break;
                }
                
            } else {
                
                if (sender.selected) {
                    
                    [MierProgressHUD showMessage:@"取消失败 稍后重试"];
                    
                } else {
                    
                    [MierProgressHUD showMessage:@"关注失败 稍后重试"];
                }
                
            }
            
        }
        
    }];
    */
}

#pragma mark - 设置数据

- (void)setModel:(CommunityDetailsModel *)model{
    
    _model = model;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.authorHeadImage]
                            placeholder:nil
                                options:YYWebImageOptionSetImageWithFadeAnimation
                               progress:nil
                              transform:^UIImage *(UIImage *image, NSURL *url) {
                                  image = [image imageByResizeToSize:CGSizeMake(40, 40)];
                                  return [image imageByRoundCornerRadius:20];
                              }
                             completion:nil];
    
    NSString *rank = model.authorLevel;
    
    NSString *rankName = [RankManager rankNameArray][rank.integerValue - 1];
    
    NSString *rankImageUrl = [RankManager rankImageArray][rank.integerValue - 1];
    
    [self.nameRankView configWithName:model.authorName LevelImage:rankImageUrl LevelName:rankName];
    
    self.nameRankView.maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 70.0f - 80.0f; //设置最大宽度 防止昵称过长导致布局错乱
    
    if (!model.location || [model.location isEqualToString:@""]) {
        
        self.locationImageView.hidden = YES;
        
        self.locationLabel.hidden = YES;
        
    } else {
        
        self.locationImageView.hidden = NO;
        
        self.locationLabel.hidden = NO;
        
        self.locationLabel.text = model.location;
    }
    
    //设置标题
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:model.title];
    
    titleString.lineSpacing = 8.0f;
    
    titleString.font = [UIFont boldSystemFontOfSize:20.0f];
    
    titleString.color = LEEColorFromIdentifier([LEETheme currentThemeTag], common_font_color_1);
    
    self.titleLabel.attributedText = titleString;
    
    [YYLabel configTextLayoutWithLabel:self.titleLabel MaxRows:2 MaxSize:CGSizeMake(self.width - 30, MAXFLOAT)];
    
    self.titleLabel.sd_layout.heightIs(self.titleLabel.textLayout.textBoundingSize.height);
    
    switch (model.followState) {
            
        case 0:
            
            // 不存在关注关系
            
            self.followButton.hidden = NO;
            
            self.followButton.selected = NO;
            
            break;
        case 1:
            
            // 已关注对方
            
            self.followButton.hidden = NO;
            
            self.followButton.selected = YES;
            
            [self.followButton setTitle:@"已关注" forState:UIControlStateSelected];
            
            break;
        case 2:
            
            // 对方关注了自己 自己没关注对方
            
            self.followButton.hidden = NO;
            
            self.followButton.selected = NO;
            
            break;
        case 3:
            
            // 相互关注
            
            self.followButton.hidden = NO;
            
            self.followButton.selected = YES;
            
            [self.followButton setTitle:@"互相关注" forState:UIControlStateSelected];
            
            break;
        case 4:
            
            // 自己
            
            self.followButton.hidden = YES;
            
            break;
        default:
            break;
    }
    
}

@end
