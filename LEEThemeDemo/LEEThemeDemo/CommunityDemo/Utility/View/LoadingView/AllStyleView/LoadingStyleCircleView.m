//
//  LoadingStyleCircleView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "LoadingStyleCircleView.h"

@interface LoadingStyleCircleView ()

@property (nonatomic , strong ) UIImageView *circleImageView;//圆形图片视图

@property (nonatomic , strong ) UILabel *titleLabel;//标题Label

@property (nonatomic , strong ) UIImageView *titleImageView;//标题图片视图

@end

@implementation LoadingStyleCircleView

-(void)dealloc{
    
    _circleImageView = nil;
    
    _titleLabel = nil;
    
    _titleImageView = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化圆形图片视图
        
        _circleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 50 , 50 )];
        
        _circleImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2 - 40 );
        
        _circleImageView.backgroundColor = [UIColor clearColor];
        
        _circleImageView.image = [[UIImage imageNamed:@"loadingcircleimage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        _circleImageView.tintColor = [UIColor lightGrayColor];
        
        [self addSubview:_circleImageView];
        
        //初始化标题Label
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,  _circleImageView.frame.origin.y + CGRectGetHeight(_circleImageView.frame) + 10, CGRectGetWidth(self.frame), 30)];
        
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        _titleLabel.textColor = [UIColor lightGrayColor];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _circleImageView.frame = CGRectMake(0 , 0 , 50 , 50 );
    
    _circleImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2 - 40 );
    
    _titleLabel.frame = CGRectMake(0 ,  _circleImageView.frame.origin.y + CGRectGetHeight(_circleImageView.frame) + 10, CGRectGetWidth(self.frame), 30);
    
}

#pragma mark ---获取标题

-(void)setTitle:(NSString *)title{
    
    if (_title != title) {
        
        _title = title;
        
    }
    
    _titleLabel.text = title;
    
}



#pragma mark ---开启加载动画

- (void)startLoadingAnimation{
    
    [_circleImageView.layer addAnimation:[self rotationGear:M_PI * 6.0f] forKey:@"Rotation"];
    
}

#pragma mark ---停止加载动画

- (void)stopLoadingAnimation{
    
    [_circleImageView.layer removeAnimationForKey:@"Rotation"];
    
}


#pragma mark ---旋转动画

-(CABasicAnimation *)rotationGear:(float)degree{
    
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: degree ];
    
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    rotationAnimation.duration = 2;
    
    rotationAnimation.repeatCount = 100000;//设置到最大的整数值
    
    rotationAnimation.cumulative = NO;
    
    rotationAnimation.removedOnCompletion = NO;
    
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    return rotationAnimation;
    
}

@end
