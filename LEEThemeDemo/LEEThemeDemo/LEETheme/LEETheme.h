
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

/** 添加主题设置 -> 格式: .LeeAddTheme(@@"tag" , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTagAndBlock LeeAddTheme;
/** 添加多标签主题设置 -> 格式: .LeeAddThemes(@@[tag1 , tag2] , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToTagsAndBlock LeeAddThemes;
/** 设置主题更改动画时长 -> 格式: .LeeAddTheme(@@"" , ^(id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigThemeToFloat LeeChangeThemeAnimationDuration;

@end

@interface UIView (LEEThemeConfigView)

@property (nonatomic , strong ) LEEThemeConfigModel *lee_theme;

@end

@interface UIButton (LEEThemeConfigButton)

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






