//
//  CommunityHotCircleListView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityHotCircleListView.h"

#import "SDAutoLayout.h"

@interface CommunityHotCircleListView ()

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@property (nonatomic , strong ) UIButton *moreButton; //更多按钮

@property (nonatomic , strong ) UIScrollView *scrollView; //滑动视图

@end

@implementation CommunityHotCircleListView

- (void)dealloc{
    
    _titleLabel = nil;
    
    _moreButton = nil;
    
    _scrollView = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
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
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame));
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    //标题Label
    
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _titleLabel.text = @"最热圈子";
    
    [self addSubview:_titleLabel];
    
    //更多按钮
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_moreButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    
    [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    
    [_moreButton setImage:[UIImage imageNamed:@"find_combined_btn"] forState:UIControlStateNormal];
    
    [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    
    [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_moreButton];
    
    //滑动视图
    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.directionalLockEnabled = YES;
    
    [self addSubview:_scrollView];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    //标题Label
    
    _titleLabel.sd_layout
    .topSpaceToView(self , 15.0f)
    .leftSpaceToView(self , 15.0f)
    .widthIs(100.0f)
    .heightIs(20.0f);
    
    //更多按钮
    
    _moreButton.sd_layout
    .centerYEqualToView(self.titleLabel)
    .rightSpaceToView(self , 15.0f)
    .widthIs(50.0f)
    .heightIs(30.0f);
    
    //滑动视图
    
    _scrollView.sd_layout
    .topSpaceToView(self.titleLabel , 15.0f)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(110.0f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.moreButton.lee_theme.LeeConfigButtonTitleColor(common_font_color_5 , UIControlStateNormal);
}

#pragma mark - 设置数据

- (void)configDataArray:(NSArray<CommunityCircleModel *> *)dataArray{
    
    //清空原有选项
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    HotCircleItemView *lastItem = nil;
    
    for (CommunityCircleModel *model in dataArray) {
        
        HotCircleItemView *item = [[HotCircleItemView alloc] init];
        
        item.model = model;
        
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
        
        [self.scrollView addSubview:item];
        
        if (dataArray.firstObject == model) {
            
            item.sd_layout
            .topEqualToView(self.scrollView)
            .bottomEqualToView(self.scrollView)
            .leftSpaceToView(self.scrollView , 15.0f)
            .widthIs(64.0f);
            
        } else {
            
            item.sd_layout
            .topEqualToView(self.scrollView)
            .bottomEqualToView(self.scrollView)
            .leftSpaceToView(lastItem , 10.0f)
            .widthIs(64.0f);
        }
        
        lastItem = item;
    }
    
    [self.scrollView setupAutoContentSizeWithRightView:lastItem rightMargin:15.0f];
}

#pragma mark - 选项点击事件

- (void)itemAction:(UITapGestureRecognizer *)tap{
    
    HotCircleItemView *item = (HotCircleItemView *)tap.view;
    
    if (self.selectedBlock) self.selectedBlock(item.model);
}

#pragma mark - 更多按钮点击事件

- (void)moreButtonAction:(UIButton *)sender{
    
    if (self.moreBlock) self.moreBlock();
}

@end


@interface HotCircleItemView ()

@property (nonatomic , strong ) UIImageView *picImageView; //图片视图

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@property (nonatomic , strong ) UILabel *postCountLabel; //帖子数量Label

@end

@implementation HotCircleItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
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
    
    self.frame = CGRectMake(0, 0, 64.0f, 110.0f);
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    //图片视图
    
    _picImageView = [[UIImageView alloc] init];
    
    _picImageView.clipsToBounds = YES;
    
    _picImageView.contentMode = UIViewContentModeCenter;
    
    _picImageView.sd_cornerRadius = @(5.0f);
    
    _picImageView.layer.borderWidth = 1.0f;
    
    [self addSubview:_picImageView];
    
    //标题Label
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
    
    //帖子数量Label
    
    _postCountLabel = [[UILabel alloc] init];
    
    _postCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _postCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_postCountLabel];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    //图片视图
    
    _picImageView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .widthIs(64.0f)
    .heightIs(64.0f);
    
    //标题Label
    
    _titleLabel.sd_layout
    .topSpaceToView(self.picImageView , 6.0f)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(20.0f);
    
    //帖子数量Label
    
    _postCountLabel.sd_layout
    .topSpaceToView(self.titleLabel , 0.0f)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(20.0f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.picImageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_7);
    
    self.picImageView.layer.lee_theme.LeeConfigBorderColor(common_bg_color_5);
    
    self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
    
    self.postCountLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
}

#pragma mark - 设置数据

- (void)setModel:(CommunityCircleModel *)model{
    
    _model = model;
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:model.circleImageUrl]
                            placeholder:nil
                                options:YYWebImageOptionSetImageWithFadeAnimation
                               progress:nil
                              transform:^UIImage *(UIImage *image, NSURL *url) {
                                  
                                  image = [image imageByResizeToSize:CGSizeMake(45.0f, 45.0f) contentMode:UIViewContentModeScaleAspectFill];
                                  
                                  return image;
                              }
                             completion:nil];
    
    self.titleLabel.text = model.circleName;
    
    self.postCountLabel.text = [NSString stringWithFormat:@"%@帖子" , [self handlePostCount:model.postCount]];
}

#pragma mark - 处理帖子数

- (NSString *)handlePostCount:(NSInteger)postCount{
    
    if (postCount > 9999) {
        
        NSInteger wan = postCount / 10000;
        
        NSInteger qian = (postCount - wan * 10000) / 1000;
        
        if (qian && wan < 100) {
            
            return [NSString stringWithFormat:@"%ld.%ld万", wan , qian];
            
        } else {
            
            return [NSString stringWithFormat:@"%ld万", wan];
        }
        
    }
    
    return [NSString stringWithFormat:@"%ld" , postCount];
}

@end
