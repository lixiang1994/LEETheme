//
//  MierNavigationBar.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/9/12.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@class MierNavigationBar;

typedef NS_ENUM(NSInteger, MierNavigationBarStyleType) {
    /** 米尔导航栏样式类型 正常 */
    MierNavigationBarStyleTypeNormal = 0,
    /** 米尔导航栏样式类型 蓝色 */
    MierNavigationBarStyleTypeBlue,
    /** 米尔导航栏样式类型 白色*/
    MierNavigationBarStyleTypeWhite,
};

typedef MierNavigationBar *(^MierNavigationBarConfigBlock)(void(^)());
typedef MierNavigationBar *(^MierNavigationBarConfigBool)(BOOL);
typedef MierNavigationBar *(^MierNavigationBarConfigView)(UIView *view);
typedef MierNavigationBar *(^MierNavigationBarConfigStyle)(MierNavigationBarStyleType type);
typedef MierNavigationBar *(^MierNavigationBarConfigString)(NSString *string);

@interface MierNavigationBar : UIView


/**
 *  设置左侧项视图
 */
@property (nonatomic , copy ) MierNavigationBarConfigView configLeftItemView;

/**
 *  设置左侧项点击事件
 */
@property (nonatomic , copy ) MierNavigationBarConfigBlock configLeftItemAction;

/**
 *  设置右侧项标题
 */
@property (nonatomic , copy ) MierNavigationBarConfigString configRightItemTitle;

/**
 *  设置右侧项视图
 */
@property (nonatomic , copy ) MierNavigationBarConfigView configRightItemView;

/**
 *  设置右侧项点击事件
 */
@property (nonatomic , copy ) MierNavigationBarConfigBlock configRightItemAction;


/**
 *  设置标题项标题
 */
@property (nonatomic , copy ) MierNavigationBarConfigString configTitleItemTitle;

/**
 *  设置标题项视图
 */
@property (nonatomic , copy ) MierNavigationBarConfigView configTitleItemView;

/**
 *  设置标题项点击事件
 */
@property (nonatomic , copy ) MierNavigationBarConfigBlock configTitleItemAction;

/**
 *  设置样式
 */
@property (nonatomic , copy ) MierNavigationBarConfigStyle configStyle;

+ (MierNavigationBar *)bar;

/**
 *  设置状态栏
 *
 *  @param vc 视图控制器
 */
+ (void)configStatusBar:(UIViewController *)vc;

/**
 *  显示
 *
 *  @param vc 视图控制器
 */
- (void)show:(UIViewController *)vc;

@end
