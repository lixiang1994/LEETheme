//
//  NameRankView.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/3/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RankManager.h"

@interface NameRankView : UIView

/**
 *  字体大小
 */
@property (nonatomic , assign ) CGFloat fontSize;

/**
 *  最大宽度
 */
@property (nonatomic , assign ) CGFloat maxWidth;

/**
 *  设置
 *
 *  @param name  昵称
 *  @param level 等级
 */
- (void)configWithName:(NSString *)name Level:(NSInteger)level;

/**
 *  设置
 *
 *  @param name       昵称
 *  @param levelImage 等级图片Url
 *  @param levelName  等级名称
 */
- (void)configWithName:(NSString *)name LevelImage:(NSString *)levelImage LevelName:(NSString *)levelName;

@end
