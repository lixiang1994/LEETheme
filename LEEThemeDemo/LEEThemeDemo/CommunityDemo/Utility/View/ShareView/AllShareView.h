
/*!
 *  @header AllShareView.h
 *          MierMilitaryNews
 *
 *  @brief  全部分享视图
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 miercn. All rights reserved.
 *  @version    16/4/19.
 */

#import <UIKit/UIKit.h>

typedef enum {
    
    ShareTypeToQQFriend = 0,//QQ好友
    
    ShareTypeToQZone,//QQ空间
    
    ShareTypeToTencetnwb,//腾讯微博
    
    ShareTypeToWechat,//微信好友
    
    ShareTypeToWechatTimeline,//微信朋友圈
    
    ShareTypeToSina,//新浪微博
    
} ShareType;

typedef enum {
    
    MoreTypeToTheme = 0, //更改按钮类型主题
    
    MoreTypeToReport, //更多按钮类型举报

    MoreTypeToFontSize, //更多按钮类型字体大小
    
    MoreTypeToCopyLink, //更改按钮类型复制链接
    
} MoreType;

@interface AllShareView : UIView

- (instancetype)initWithFrame:(CGRect)frame ShowMore:(BOOL)showMore;

- (instancetype)initWithFrame:(CGRect)frame ShowMore:(BOOL)showMore ShowReport:(BOOL)showReport;

@property (nonatomic , copy ) void (^OpenShareBlock)(ShareType type);

@property (nonatomic , copy ) void (^OpenMoreBlock)(MoreType type);

/** 显示 */

- (void)show;

@end
