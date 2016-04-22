
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

typedef void(^LEEThemeConfigBlock)(id item);

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

@interface UIView (LEEThemeConfig)

/**
 *  设置主题
 *
 *  @param tag         主题标签
 *  @param configBlock 设置Block
 */
- (void)configThemeWithTag:(NSString *)tag ConfigBlock:(LEEThemeConfigBlock)configBlock;

/**
 *  设置主题
 *
 *  @param tag         主题标签
 *  @param configBlock 设置Block
 *  @param tags        兼容的其他主题标签
 */
- (void)configThemeWithTag:(NSString *)tag ConfigBlock:(LEEThemeConfigBlock)configBlock CompatibleTags:(NSString *)tags,...;

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






