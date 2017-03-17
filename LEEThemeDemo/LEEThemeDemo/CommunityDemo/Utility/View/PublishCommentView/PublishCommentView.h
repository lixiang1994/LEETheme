//
//  PublishCommentView.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/7/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PublishCommentBlock)(NSString *text);

typedef void(^PublishCommentAndContextBlock)(NSString *text , id context);

@interface PublishCommentView : UIView

@property (nonatomic , copy ) PublishCommentBlock publishCommentBlock; //发表评论Block

@property (nonatomic , copy ) PublishCommentAndContextBlock publishCommentAndContextBlock; //发表评论Block

/**
 *  设置占位符文字
 *
 *  @param text 占位符文字
 */
- (void)configPlaceHolderWithText:(NSString *)text;

/**
 *  设置上下文 (用来传递一个对象)
 *
 *  @param context 上下文
 */
- (void)configContext:(id)context;

/**
 *  清空内容
 */
- (void)clear;

/**
 *  显示
 */
- (void)show;

/**
 *  隐藏
 */
- (void)hide;

@end
