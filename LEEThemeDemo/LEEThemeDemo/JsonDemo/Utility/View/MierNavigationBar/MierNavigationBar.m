//
//  MierNavigationBar.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/9/12.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "MierNavigationBar.h"

#import "SDAutoLayout.h"

@interface MierNavigationBar ()

@property (nonatomic , strong ) UIView *lineView; //分隔线视图

@property (nonatomic , strong ) UILabel *titleLabel; //标题Label

@property (nonatomic , strong ) UIButton *backButton; //返回按钮

@property (nonatomic , strong ) UILabel *rightTitleLabel; //右标题Label

@property (nonatomic , strong ) UIView *titleView; //标题视图

@property (nonatomic , strong ) UIView *leftView; //左侧视图

@property (nonatomic , strong ) UIView *rightView; //右侧视图

@property (nonatomic , copy ) void (^titleBlock)();

@property (nonatomic , copy ) void (^leftBlock)();

@property (nonatomic , copy ) void (^rightBlock)();

@property (nonatomic , assign ) MierNavigationBarStyleType styleType;

@end

@interface UIViewController (MierNavigationBarViewControllerCategory)

@property (nonatomic , assign ) NSInteger navigationBarStyle;

@end

@implementation MierNavigationBar

- (void)dealloc{
    
    
}

+ (MierNavigationBar *)bar{
    
    return [[MierNavigationBar alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化子视图
        
        [self initSubView];
        
        //设置自动布局
        
        [self configAutoLayout];
        
    }
    return self;
}

- (void)initSubView{
    
    //标题视图
    
    _titleView = [[UIView alloc] init];
    
    [_titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTapAction)]];
    
    [self addSubview:_titleView];
    
    //左侧视图
    
    _leftView = [[UIView alloc] init];
    
    [_leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTapAction)]];
    
    [self addSubview:_leftView];
    
    //右侧视图
    
    _rightView = [[UIView alloc] init];
    
    [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTapAction)]];
    
    [self addSubview:_rightView];
    
}

- (void)configAutoLayout{

    _titleView.sd_layout
    .topSpaceToView(self , 20.0f)
    .centerXEqualToView(self)
    .widthIs(10.0f)
    .heightIs(44.0f);
    
    _leftView.sd_layout
    .topSpaceToView(self , 20.0f)
    .leftEqualToView(self)
    .widthIs(0.0f)
    .heightIs(44.0f);
    
    _rightView.sd_layout
    .topSpaceToView(self , 20.0f)
    .rightEqualToView(self)
    .widthIs(0.0f)
    .heightIs(44.0f);
}

- (MierNavigationBarConfigView)configLeftItemView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            [weakSelf.leftView addSubview:view];
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigBlock)configLeftItemAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            weakSelf.leftBlock = block;
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigString)configRightItemTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) {
            
            if (string) {
                
                weakSelf.rightTitleLabel = [[UILabel alloc] init];
                
                [weakSelf.rightTitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
                
                [weakSelf.rightTitleLabel setText:string];
                
                [weakSelf.rightView addSubview:weakSelf.rightTitleLabel];
                
                weakSelf.rightTitleLabel.sd_layout.heightRatioToView(weakSelf.rightView , 1);
                
                [weakSelf.rightTitleLabel setSingleLineAutoResizeWithMaxWidth:200.0f];
                
                [weakSelf.rightTitleLabel updateLayout];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigView)configRightItemView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            [weakSelf.rightView addSubview:view];
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigBlock)configRightItemAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            weakSelf.rightBlock = block;
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigString)configTitleItemTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) {
            
            if (string) {
                
                if (weakSelf.titleLabel) {
                
                    [weakSelf.titleLabel setText:string];
                    
                } else {
                    
                    weakSelf.titleLabel = [[UILabel alloc] init];
                    
                    [weakSelf.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
                    
                    [weakSelf.titleView addSubview:weakSelf.titleLabel];
                    
                    weakSelf.titleLabel.sd_layout.heightRatioToView(weakSelf.titleView , 1);
                    
                    [weakSelf.titleLabel setSingleLineAutoResizeWithMaxWidth:200.0f];
                    
                    [weakSelf.titleLabel setText:string];
                    
                    [weakSelf.titleLabel updateLayout];
                }
                
            }
            
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigView)configTitleItemView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            [weakSelf.titleView addSubview:view];
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigBlock)configTitleItemAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            weakSelf.titleBlock = block;
        }
        
        return weakSelf;
    };
    
}

- (MierNavigationBarConfigStyle)configStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(MierNavigationBarStyleType type){
        
        if (weakSelf) {
            
            weakSelf.styleType = type;
        }
        
        return weakSelf;
    };
    
}


- (void)show:(UIViewController *)vc{
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64.0f);
    
    [vc.view addSubview:self];
    
    //设置样式类型
    
    vc.navigationBarStyle = self.styleType;
    
    //添加主题设置 用于主题变更时更新状态栏样式
    
    vc.lee_theme.LeeAddCustomConfigs(@[DAY , NIGHT] , ^(UIViewController * item){
       
        [MierNavigationBar configStatusBar:item];
    });
    
    //标题视图
    
    if (self.titleView.subviews.count) {
        
        [self.titleView setupAutoWidthWithRightView:self.titleView.subviews.firstObject rightMargin:0.0f];
    }
    
    //左侧视图
    
    if (self.leftView.subviews.count) {
        
        [self.leftView setupAutoWidthWithRightView:self.leftView.subviews.firstObject rightMargin:15.0f];
    
    } else {
        
        if (self.leftBlock) {
        
            //返回按钮
            
            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [_backButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
            
            [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.leftView addSubview:_backButton];
            
            _backButton.sd_layout
            .leftEqualToView(self.leftView)
            .topEqualToView(self.leftView)
            .bottomEqualToView(self.leftView)
            .widthIs(50.0f);
            
            [self.leftView setupAutoWidthWithRightView:_backButton rightMargin:15.0f];
        }
        
    }
    
    //右侧视图
    
    if (self.rightView.subviews.count) {
        
        [self.rightView setupAutoWidthWithRightView:self.rightView.subviews.lastObject rightMargin:15.0f];
    }
    
    [self updateLayout];
    
    //设置样式
    
    switch (self.styleType) {
            
        case MierNavigationBarStyleTypeNormal:
            
            self.backgroundColor = [UIColor clearColor];
            
            if (self.titleLabel) self.titleLabel.textColor = [UIColor whiteColor];
            
            if (self.rightTitleLabel) self.rightTitleLabel.textColor = [UIColor whiteColor];
            
            break;
        
        case MierNavigationBarStyleTypeBlue:
            
            self.lee_theme.LeeConfigBackgroundColor(common_nav_bg_color1);
            
            if (self.titleLabel) self.titleLabel.textColor = [UIColor whiteColor];
            
            if (self.rightTitleLabel) self.rightTitleLabel.textColor = [UIColor whiteColor];
            
            break;
            
        case MierNavigationBarStyleTypeWhite:
            
            self.lee_theme.LeeConfigBackgroundColor(common_nav_bg_color2);
            
            if (self.titleLabel) self.titleLabel.lee_theme.LeeConfigTextColor(common_font_color_1);
            
            if (self.backButton) [self.backButton setImage:[UIImage imageNamed:@"infor_leftbackicon_nav_nor"] forState:UIControlStateNormal];
            
            if (self.rightTitleLabel) self.rightTitleLabel.lee_theme.LeeConfigTextColor(common_font_color_9);
            
            self.lineView.lee_theme.LeeConfigBackgroundColor(common_nav_bg_divider);
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 标题视图点击事件

- (void)titleViewTapAction{
    
    if (self.titleBlock) self.titleBlock();
}

#pragma mark - 左侧视图点击事件

- (void)leftViewTapAction{
    
    if (self.leftBlock) self.leftBlock();
}

#pragma mark - 右侧视图点击事件

- (void)rightViewTapAction{
    
    if (self.rightBlock) self.rightBlock();
}

#pragma mark - 返回按钮点击事件

- (void)backButtonAction:(UIButton *)sender{
    
    if (self.leftBlock) self.leftBlock();
}

#pragma mark - LazyLoading

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [UIView new];
        
        [self addSubview:_lineView];
        
        _lineView.sd_layout
        .bottomEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0.5f);
    }
    
    return _lineView;
}

#pragma mark - 设置状态栏

+ (void)configStatusBar:(UIViewController *)vc{
    
    NSInteger type = vc.navigationBarStyle;
    
    switch (type) {
        
        case MierNavigationBarStyleTypeNormal:
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            break;
            
        case MierNavigationBarStyleTypeBlue:
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            break;
            
        case MierNavigationBarStyleTypeWhite:
            
            if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                
            } else {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }
            
            break;
            
        default:
            break;
    }
    
}

@end

@implementation UIViewController (MierNavigationBarViewControllerCategory)

- (NSInteger)navigationBarStyle{
    
    id type = objc_getAssociatedObject(self, _cmd);
    
    return type ? [type integerValue] : NSNotFound;
}

- (void)setNavigationBarStyle:(NSInteger)type{
    
    if (self) objc_setAssociatedObject(self, @selector(navigationBarStyle), @(type) , OBJC_ASSOCIATION_ASSIGN);
}

@end
