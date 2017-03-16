//
//  CommunityPostCellPhotosView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityPostCellPhotosView.h"

#import "SDAutoLayout.h"

@interface CommunityPostCellPhotosView ()

@property (nonatomic , strong ) UIView *threeImageView; //三张图片视图

@property (nonatomic , strong ) UIImageView *bigImageView; //大图片视图

@property (nonatomic , strong ) UILabel *imageCountLabel; //图片数量Label

@end

@implementation CommunityPostCellPhotosView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化数据
        
        [self initData];
        
        // 初始化子视图
        
        [self initSubview];
        
        // 设置自动布局
        
        [self configAutoLayout];
        
        // 设置主题模式
        
        [self configTheme];

    }
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    // 三张图片视图
    
    _threeImageView = [[UIView alloc] init];
    
    [self addSubview:_threeImageView];
    
    for (NSInteger i = 0; i < 3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        
        [self.threeImageView addSubview:imageView];
        
        imageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
        
        imageView.sd_layout
        .topEqualToView(self.threeImageView)
        .bottomEqualToView(self.threeImageView);
    }
    
    // 图片数量Label 
    
    _imageCountLabel = [[UILabel alloc] init];
    
    _imageCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    _imageCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _imageCountLabel.textColor = [UIColor whiteColor];
    
    [self.threeImageView.subviews.lastObject addSubview:_imageCountLabel];
    
    // 大图图片视图
    
    _bigImageView = [[UIImageView alloc] init];
    
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
   
    _bigImageView.clipsToBounds = YES;
    
    [self addSubview:_bigImageView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 三张图片视图
    
    _threeImageView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .autoHeightRatio(0.3f);
    
    [_threeImageView setupAutoWidthFlowItems:self.threeImageView.subviews withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:5.0f verticalEdgeInset:0 horizontalEdgeInset:0];
    
    // 图片数量Label
    
    _imageCountLabel.sd_layout
    .bottomSpaceToView(self.imageCountLabel.superview , 0.0f)
    .rightSpaceToView(self.imageCountLabel.superview , 0.0f)
    .heightIs(20.0f);
    
    [_imageCountLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 大图图片视图
    
    _bigImageView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .widthRatioToView(self , 0.68f)
    .autoHeightRatio(0.75f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.bigImageView.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
}

#pragma mark - 设置图片Url

- (void)configImageUrlArray:(NSArray *)imageUrlArray ImageCount:(NSInteger)imageCount{
    
    //设置图片数量 (大于3张显示)
    
    self.imageCountLabel.hidden = imageCount > 3 ? NO : YES;
    
    self.imageCountLabel.text = [NSString stringWithFormat:@"  %ld图  " , imageCount];
    
    //根据图片Url数量显示加载图片
    
    switch (imageUrlArray.count) {
        
        case 0:
            
            self.hidden = YES;
            
            [self clearAutoHeigtSettings];
            
            self.sd_layout.heightIs(0.0f);
            
            break;
            
        case 1:
            
            self.hidden = NO;
            
            self.threeImageView.hidden = YES;
            
            self.bigImageView.hidden = NO;
            
            [self setupAutoHeightWithBottomView:self.bigImageView bottomMargin:0.0f];
            
            [self.bigImageView setImageWithURL:[NSURL URLWithString:imageUrlArray.firstObject] options:YYWebImageOptionSetImageWithFadeAnimation];
            
            break;
            
        default:
            
            self.hidden = NO;
            
            self.threeImageView.hidden = NO;
            
            self.bigImageView.hidden = YES;
            
            [self setupAutoHeightWithBottomView:self.threeImageView bottomMargin:0.0f];
            
            [self.threeImageView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
               
                imageView.image = nil;
                
                if (idx < imageUrlArray.count) {
                    
                    imageView.hidden = NO;
                    
                    [imageView setImageWithURL:[NSURL URLWithString:imageUrlArray[idx]] options:YYWebImageOptionSetImageWithFadeAnimation];
                    
                } else {
                    
                    imageView.hidden = YES;
                }
                
            }];
            
            break;
    }
    
}

@end
