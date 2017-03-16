//
//  LoadingStyleProgressView.h
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingStyleProgressView : UIView

@property (nonatomic , copy ) NSString *title;//标题文字

//开启加载动画

- (void)startLoadingAnimation;

//停止加载动画

- (void)stopLoadingAnimation;

@end
