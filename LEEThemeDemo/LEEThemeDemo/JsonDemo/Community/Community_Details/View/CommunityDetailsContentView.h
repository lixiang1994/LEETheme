//
//  CommunityDetailsContentView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityDetailsAPI.h"

typedef void(^LoadedFinishBlock)();

@interface CommunityDetailsContentView : UIView

@property (nonatomic , strong ) CommunityDetailsAPI *api;

@property (nonatomic , copy ) LoadedFinishBlock loadedFinishBlock;//加载完成Block

@property (nonatomic , copy ) void (^updateHeightBlock)(); //更新高度Block

@property (nonatomic , copy ) void (^openUserHomeBlock)(); //打开用户主页Block

@property (nonatomic , copy ) void (^deleteBlock)(); //删除Block

@property (nonatomic , strong ) CommunityDetailsModel *model; //社区详情数据模型


/**
 释放处理 (用于清空一些会导致强引用的东东)
 */
- (void)releaseHandle;

/**
 更新webview高度 (大量图片加载时高度会有不准确的情况 所以需要在滑动tableview时更新高度)
 */
- (void)updateWebViewHeight;

@end
