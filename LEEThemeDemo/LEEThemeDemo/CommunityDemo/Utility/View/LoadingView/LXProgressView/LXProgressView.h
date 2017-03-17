//
//  LXProgressView.h
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, LXProgressIndicatorStyle) {
    
    LXProgressIndicatorStyleNormal = 0,
    
    LXProgressIndicatorStyleLarge = 1,
};

@interface LXProgressView : UIView

@property (assign, nonatomic) LXProgressIndicatorStyle progressIndicatorStyle;

@property (strong, nonatomic) UIColor *strokeColor;

- (instancetype)initWithProgressIndicatorStyle:(LXProgressIndicatorStyle)style;

- (void)startProgressAnimating;

- (void)stopProgressAnimating;

@end
