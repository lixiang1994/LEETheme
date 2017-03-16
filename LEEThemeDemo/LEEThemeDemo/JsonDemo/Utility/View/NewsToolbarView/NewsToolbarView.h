//
//  NewsToolbarView.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/8.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsToolbarView;

typedef NS_ENUM(NSInteger, NewsToolbarStyleType) {
    /** 资讯工具栏样式类型 默认 */
    NewsToolbarStyleTypeNormal,
    /** 资讯工具栏样式类型 图库*/
    NewsToolbarStyleTypeGallery,
};

typedef NewsToolbarView *(^NewsToolbarConfigBlock)(void(^)());
typedef NewsToolbarView *(^NewsToolbarConfigBool)(BOOL);
typedef NewsToolbarView *(^NewsToolbarConfigStyle)(NewsToolbarStyleType type);
typedef NewsToolbarView *(^NewsToolbarConfigString)(NSString *string);

@interface NewsToolbarView : UIView

/**
 *  设置编辑项
 */
@property (nonatomic , copy ) NewsToolbarConfigBlock configEditItem;

/**
 *  设置评论项
 */
@property (nonatomic , copy ) NewsToolbarConfigBlock configCommentItem;

/**
 *  设置收藏项
 */
@property (nonatomic , copy ) NewsToolbarConfigBlock configFavItem;

/**
 *  设置分享项
 */
@property (nonatomic , copy ) NewsToolbarConfigBlock configShareItem;

/**
 *  设置举报项
 */
@property (nonatomic , copy ) NewsToolbarConfigBlock configReportItem;

/**
 *  设置编辑项提示语
 */
@property (nonatomic , copy ) NewsToolbarConfigString configEditItemTitle;

/**
 *  设置评论项评论数
 */
@property (nonatomic , copy ) NewsToolbarConfigString configCommentItemTitle;

/**
 *  设置收藏项状态
 */
@property (nonatomic , copy ) NewsToolbarConfigBool configFavItemState;

/**
 *  设置样式
 */
@property (nonatomic , copy ) NewsToolbarConfigStyle configStyle;

+ (NewsToolbarView *)toolbar;

/**
 *  显示
 */
- (void)show;

@end
