//
//  MierFaceInputView.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/31.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "MierFaceInputView.h"

#import "SDAutoLayout.h"

#import "YYLabel+Extend.h"

@interface MierFaceInputView ()<UIScrollViewDelegate>

@property (nonatomic , strong ) UIScrollView *scrollView;

@property (nonatomic , strong ) UIPageControl *pageControl;

@property (nonatomic , strong ) NSDictionary *infoDic;

@property (nonatomic , strong ) NSMutableDictionary *buttonDic;

@property (nonatomic , strong ) NSMutableArray *pageViewArray;


@property (nonatomic , strong ) UIButton *deleteButton; //删除按钮

@end

@implementation MierFaceInputView

{
    
    NSInteger lineMaxNumber; //最大行数
    
    NSInteger singleMaxCount; //单行最大个数
    
}

-(void)dealloc{
    
    _scrollView.delegate = nil;
    
    _scrollView = nil;
    
    _pageControl = nil;
    
    _infoDic = nil;
    
    _buttonDic = nil;
    
    _pageViewArray = nil;
    
}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
                      InfoDic:(NSDictionary *)infoDic
                MaxLineNumber:(NSInteger)maxLineNumber
               MaxSingleCount:(NSInteger)maxSingleCount{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _infoDic = infoDic;
        
        _buttonDic = [NSMutableDictionary dictionary];
        
        _pageViewArray = [NSMutableArray array];
        
        lineMaxNumber = maxLineNumber;
        
        singleMaxCount = maxSingleCount;
        
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

- (instancetype)initWithFrame:(CGRect)frame{
    
    return [self initWithFrame:frame InfoDic:nil MaxLineNumber:0 MaxSingleCount:0];
}

#pragma mark - 初始化数据

- (void)initData{
    
    //非空判断 设置默认数据
    
    if (!_infoDic) {
        
        NSMutableDictionary *tempInfoDic = [NSMutableDictionary dictionary];
        
        [tempInfoDic setObject:@{@"titles" : faceGreenNameArray , @"images" : faceGreenImageArray} forKey:@(0)];
        
        [tempInfoDic setObject:@{@"titles" : faceWhiteNameArray , @"images" : faceWhiteImageArray} forKey:@(1)];
        
        _infoDic = tempInfoDic;
    }
    
    lineMaxNumber = lineMaxNumber > 0 ? lineMaxNumber : 2;
    
    singleMaxCount = singleMaxCount > 0 ? singleMaxCount : 3;
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //初始化滑动视图
    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _scrollView.delegate = self;
    
    _scrollView.bounces = YES;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    
    //初始化pageControl
    
    _pageControl = [[UIPageControl alloc] init];
    
    _pageControl.currentPage = 0;
    
    _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    _pageControl.userInteractionEnabled = NO;
    
    [self addSubview:_pageControl];
    
    //循环初始化表情按钮
    
    for (NSString *key in _infoDic) {
        
        NSDictionary *info = _infoDic[key];
        
        NSArray *titles = info[@"titles"];
        
        NSArray *images = info[@"images"];
        
        //初始化页视图
        
        UIView *pageView = [[UIView alloc] init];
        
        [_scrollView addSubview:pageView];
        
        [_pageViewArray addObject:pageView];
        
        //初始化按钮
        
        NSMutableArray *buttonArray = [NSMutableArray array];
        
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
           
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setImage:[UIImage imageNamed:images[idx]] forState:UIControlStateNormal];
            
            [button setTitle:title forState:UIControlStateNormal];
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:0.0f]];
            
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [pageView addSubview:button];
            
            [buttonArray addObject:button];
        }];
        
        [_buttonDic setObject:buttonArray forKey:@([_pageViewArray indexOfObject:pageView])];
    }
    
    //设置总页数
    
    _pageControl.numberOfPages = _pageViewArray.count > 1 ? _pageViewArray.count : 0;
 
    //初始化删除按钮
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_deleteButton setImage:[[UIImage imageNamed:@"face_input_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_deleteButton];
    
}


#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //使用SDAutoLayout循环布局分享按钮
    
    [_pageViewArray enumerateObjectsUsingBlock:^(UIView *pageView, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSArray *buttonArray = _buttonDic[@([_pageViewArray indexOfObject:pageView])];
        
        //布局页视图
        
        if (idx == 0) {
            
            pageView.sd_layout
            .leftSpaceToView(_scrollView , 0)
            .topSpaceToView(_scrollView , 0)
            .widthIs(self.width)
            .heightIs(0);
            
        } else {
            
            pageView.sd_layout
            .leftSpaceToView(_pageViewArray[idx - 1] , 0)
            .topSpaceToView(_scrollView , 0)
            .widthIs(self.width)
            .heightIs(0);
        }

        for (UIButton *button in buttonArray) {
            
            button.sd_layout
            .heightEqualToWidth();
        }
        
        [pageView setupAutoMarginFlowItems:[buttonArray copy] withPerRowItemsCount:singleMaxCount itemWidth:40 verticalMargin:15 verticalEdgeInset:10 horizontalEdgeInset:20];
        
    }];
    
    //滑动视图
    
    _scrollView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthRatioToView(self , 1)
    .bottomSpaceToView(self , 30.0f);
    
    [_scrollView setupAutoContentSizeWithRightView:_pageViewArray.lastObject rightMargin:0.0f];
    
    //pageControl
    
    _pageControl.sd_layout
    .leftSpaceToView(self , 30)
    .rightSpaceToView(self , 30)
    .topSpaceToView(_scrollView , 0.0f)
    .heightIs(10.0f);
    
    //删除按钮
    
    _deleteButton.sd_layout
    .bottomSpaceToView(self , 10.0f)
    .rightSpaceToView(self , 15.0f)
    .widthIs(40)
    .heightIs(30);
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.deleteButton.tintColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
}

#pragma mark - 表情按钮点击事件

- (void)faceButtonAction:(UIButton *)sender{
    
    if (self.selectedFaceBlock) {
        
        self.selectedFaceBlock(sender.titleLabel.text);
    }
    
}

#pragma mark - 删除按钮点击事件

- (void)deleteButtonAction{
    
    if (self.deleteBlock) {
        
        self.deleteBlock();
    }
    
}

#pragma mark - 删除按钮启用

- (void)deleteButtonEnable:(BOOL)enable{
    
    self.deleteButton.enabled = enable;
    
    if (enable) {

        self.deleteButton.tintColor = LEEColorFromIdentifier([LEETheme currentThemeTag], common_bg_blue_4);
        
    } else {
        
        self.deleteButton.tintColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //通过最终的偏移量offset值 来确定pageControl当前应该显示第几页
    
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
    
}


@end
