
/*!
 *  @header LEECoolButton.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEE炫酷按钮
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */

#import <UIKit/UIKit.h>

@interface LEECoolButton : UIButton

/** 圆圈颜色 */
@property (nonatomic , strong ) UIColor *circleColor;

/** 线条颜色 */
@property (nonatomic , strong ) UIColor *lineColor;

//========================

/** 选中图片颜色 */
@property (nonatomic , strong ) UIColor *imageColorOn;

/** 未选中图片颜色 */
@property (nonatomic , strong ) UIColor *imageColorOff;

//== 图片 与 图片颜色二选一 ==

/** 选中图片 */
@property (nonatomic , strong ) UIImage *imageOn;

/** 未选中图片 */
@property (nonatomic , strong ) UIImage *imageOff;

//========================

/** 动画时长 */
@property (nonatomic , assign ) double duration;

/**
 *  初始化炫酷按钮
 *
 *  @param image      图片
 *  @param imageFrame 图片frame
 *
 *  @return 按钮对象
 */
+ (id)coolButtonWithImage:(UIImage *)image ImageFrame:(CGRect)imageFrame;

/**
 *  选中
 */
- (void)select;

/**
 *  未选中
 */
- (void)deselect;

@end
