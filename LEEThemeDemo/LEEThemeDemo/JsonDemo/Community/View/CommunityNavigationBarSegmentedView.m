//
//  CommunityNavigationBarSegmentedView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/24.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityNavigationBarSegmentedView.h"

#import "SDAutoLayout.h"

@interface CommunityNavigationBarSegmentedView ()

@property (nonatomic , strong ) UIView *itemView; //选项视图

@property (nonatomic , strong ) UIView *lineView; //下划线视图

@property (nonatomic , strong ) NSMutableArray *buttonArray;//按钮数组

@end

@implementation CommunityNavigationBarSegmentedView

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
        
        //加载数据
        
        [self loadData];
        
    }
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
 
    _dataArray = @[@"精华" , @"最新"];
    
    _buttonArray = [NSMutableArray array];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //选项视图
    
    _itemView = [[UIView alloc] init];
    
    [self addSubview:_itemView];
    
    //分隔线视图
    
    _lineView = [[UIView alloc] init];
    
    [self addSubview:_lineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //选项视图
    
    _itemView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(110.0f)
    .heightIs(44.0f);
    
    //分隔线视图
    
    _lineView.sd_layout
    .xIs(0)
    .bottomEqualToView(self)
    .widthIs(44.0f)
    .heightIs(2.0f);
    
    [self setupAutoWidthWithRightView:self.itemView rightMargin:0.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.lineView.lee_theme.LeeConfigBackgroundColor(common_bg_blue_4);
}

#pragma mark - 加载数据

- (void)loadData{
    
    //循环初始化布局选项
    
    for (NSString *title in self.dataArray) {
        
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [item setTitle:title forState:UIControlStateNormal];
        
        [item.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemView addSubview:item];
        
        [self.buttonArray addObject:item];
        
        item.lee_theme.LeeConfigButtonTitleColor(common_font_color_1 , UIControlStateNormal);
        
        item.sd_layout.widthIs(44.0f).heightIs(44.0f);
    }
    
    [self.itemView setupAutoMarginFlowItems:self.buttonArray withPerRowItemsCount:self.buttonArray.count itemWidth:44.0f verticalMargin:0.0f verticalEdgeInset:0.0f horizontalEdgeInset:0.0f];
    
    //默认选中下标
    
    self.selectIndex = 0;
}

#pragma mark - 获取选中的下标

- (void)setSelectIndex:(NSInteger)selectIndex{
    
    _selectIndex = selectIndex;
    
    //设置选项样式
    
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if (idx == selectIndex) {
            
            item.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4 , UIControlStateNormal);
            
        } else {
            
            item.lee_theme.LeeConfigButtonTitleColor(common_font_color_1 , UIControlStateNormal);
        }
        
    }];
    
    //设置下划线位置
    
    [UIView beginAnimations:@"" context:NULL];
    
    [UIView setAnimationDuration:0.1f];
    
    self.lineView.sd_layout.xIs([self.buttonArray[selectIndex] left]);
    
    [UIView commitAnimations];
}

#pragma mark - 选项点击事件

- (void)itemAction:(UIButton *)sender{
    
    self.selectIndex = [self.buttonArray indexOfObject:sender];
    
    if (self.didSelectItemBlock) self.didSelectItemBlock(self.selectIndex);
}

@end
