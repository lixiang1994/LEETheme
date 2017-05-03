//
//  LEEBubble.h
//  LEEBubble
//
//  Created by 李响 on 16/8/15.
//  Copyright © 2016年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEEBubble : UIView

/**
 *  颜色
 */
@property (nonatomic , strong ) UIColor *color;

/**
 *  图片
 */
@property (nonatomic , strong ) UIImage *image;

/**
 *  父视图中可移动范围边距 默认为 0 0 0 0 (气泡默认可活动范围为父视图大小)
 */
@property (nonatomic , assign ) UIEdgeInsets edgeInsets;

/**
 *  点击气泡Block
 */
@property (nonatomic , copy ) void(^clickBubbleBlock)();

/**
 *  添加动画
 */
- (void)addAnimations;

@end
