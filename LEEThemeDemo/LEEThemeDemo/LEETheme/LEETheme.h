
/*!
 *  @header LEETheme.h
 *          LEEThemeDemo
 *
 *  @brief  LEE主题管理
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LEEThemeConfigModel;

typedef void(^LEEThemeConfigBlock)(id item);
typedef LEEThemeConfigModel *(^LEEConfigThemeToFloat)(CGFloat number);
typedef LEEThemeConfigModel *(^LEEConfigThemeToColor)(NSString *tag , UIColor *color);
typedef LEEThemeConfigModel *(^LEEConfigThemeToImage)(NSString *tag , UIImage *image);
typedef LEEThemeConfigModel *(^LEEConfigThemeToString)(NSString *tag , NSString *string);
typedef LEEThemeConfigModel *(^LEEConfigThemeToTagAndBlock)(NSString *tag , LEEThemeConfigBlock);
typedef LEEThemeConfigModel *(^LEEConfigThemeToTagsAndBlock)(NSArray *tags , LEEThemeConfigBlock);

/*
 
 *********************************************************************************
 *
 * 在使用LEETheme的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ    : 可以添加SDAutoLayout群 497140713 在这里找到我(LEE)
 * Email : applelixiang@126.com
 * GitHub: https://github.com/lixiang1994/LEETheme
 * 简书:    http://www.jianshu.com/users/a6da0db100c8
 *
 *********************************************************************************
 
 */

@interface LEETheme : NSObject

/**
 *  启动主题
 *
 *  @param tag 主题标签
 */
+ (void)startTheme:(NSString *)tag;

/**
 *  当前主题标签
 *
 *  @return 主题标签 tag
 */
+ (NSString *)currentThemeTag;

@end

@interface LEEThemeConfigModel : NSObject

/** 添加自定义设置 -> 格式: .LeeAddCustomConfig(@@"tag" , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTagAndBlock LeeAddCustomConfig;
/** 添加多标签自定义设置 -> 格式: .LeeAddCustomConfigs(@@[tag1 , tag2] , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTagsAndBlock LeeAddCustomConfigs;

/** Color */

/** 添加渲染颜色设置 -> 格式: .LeeAddTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddTintColor;
/** 添加文本颜色设置 -> 格式: .LeeAddTextColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddTextColor;
/** 添加bar渲染颜色设置 -> 格式: .LeeAddBarTintColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBarTintColor;
/** 添加边框颜色设置 -> 格式: .LeeAddBorderColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBorderColor;
/** 添加阴影颜色设置 -> 格式: .LeeAddShadowColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddShadowColor;
/** 添加背景颜色设置 -> 格式: .LeeAddBackgroundColor(@@"tag" , UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToColor LeeAddBackgroundColor;



/** Image */

/** 添加图片设置 -> 格式: .LeeAddImage(@@"tag" , UIImage) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToImage LeeAddImage;
/** 添加图片设置 -> 格式: .LeeAddImageName(@@"tag" , @"lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddImageName;
/** 添加图片设置 -> 格式: .LeeAddImagePath(@@"tag" , @"var/XXX/XXXX/lee.png") */
@property (nonatomic , copy , readonly ) LEEConfigThemeToString LeeAddImagePath;


/** 设置主题更改过渡动画时长 -> 格式: .LeeChangeThemeAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToFloat LeeChangeThemeAnimationDuration;

@end

@interface NSObject (LEEThemeConfigObject)

@property (nonatomic , strong ) LEEThemeConfigModel *lee_theme;

@end




/*
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *                 神兽保佑
 *                 代码无BUG!
 */


@interface UIColor (LEEThemeColor)

+ (UIColor *)leeTheme_ColorWithHexString:(NSString *)hexString;

@end



