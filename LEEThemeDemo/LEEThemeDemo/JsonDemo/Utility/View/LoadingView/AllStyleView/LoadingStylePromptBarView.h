//
//  LoadingStylePromptBarView.h
//  MierMilitaryNews
//
//  Created by 李响 on 15/11/10.
//  Copyright © 2015年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingStylePromptBarView : UIView

@property (nonatomic , copy ) NSString *title;//标题文字

@property (nonatomic , strong ) UIColor *barColor;//条颜色

//开启加载动画

- (void)startLoadingAnimation;

//停止加载动画

- (void)stopLoadingAnimation;

@end
