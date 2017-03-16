//
//  LXProgressView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "LXProgressView.h"

static const CFTimeInterval DURATION = 2;
static const CGFloat WIDTH_NORMAL = 22;
static const CGFloat HEIGHT_NORMAL = 22;
static const CGFloat LINE_WIDTH_NORMAL = 1;

static const CGFloat WIDTH_BIG = 48;
static const CGFloat HEIGHT_BIG = 48;
static const CGFloat LINE_WIDTH_BIG = 2;

#define kDefaultStrokeColor [UIColor lightGrayColor]

@interface LXProgressView ()

@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (strong, nonatomic) CABasicAnimation *rotateAnimation;

@property (strong, nonatomic) CABasicAnimation *strokeAnimatinStart;

@property (strong, nonatomic) CABasicAnimation *strokeAnimatinEnd;

@property (strong, nonatomic) CAAnimationGroup *animationGroup;

@end


@implementation LXProgressView

- (instancetype)initWithProgressIndicatorStyle:(LXProgressIndicatorStyle)style {
    
    switch (style) {
            
        case 0:self =  [self initWithFrame:CGRectMake(0, 0, WIDTH_NORMAL, HEIGHT_NORMAL)];
            
            self.progressIndicatorStyle = LXProgressIndicatorStyleNormal;
            
            break;
            
        case 1: self = [self initWithFrame:CGRectMake(0, 0, WIDTH_BIG, HEIGHT_BIG)];
            
            self.progressIndicatorStyle = LXProgressIndicatorStyleLarge;
            
            break;
            
    }
    return self;
}

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, 0, WIDTH_NORMAL, HEIGHT_NORMAL)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer addSublayer:self.progressLayer];
        
    }
    return self;
}

#pragma mark ---设置样式

- (void)setProgressIndicatorStyle:(LXProgressIndicatorStyle)progressIndicatorStyle {
    _progressIndicatorStyle = progressIndicatorStyle;
    
    switch (_progressIndicatorStyle) {
            
        case 0:
            break;
        case 1:
        {
            self.progressLayer.bounds = CGRectMake(0, 0, WIDTH_BIG, HEIGHT_BIG);
            
            self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH_BIG/2, HEIGHT_BIG/2) radius:(WIDTH_BIG-LINE_WIDTH_BIG) /2 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES].CGPath;
            
            self.progressLayer.lineWidth = LINE_WIDTH_BIG;
            
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark ---设置颜色

- (void)setStrokeColor:(UIColor *)strokeColor {
    
    _strokeColor = strokeColor;
    
    self.progressLayer.strokeColor = strokeColor.CGColor;
    
}

#pragma mark ---绘制进度条

- (CAShapeLayer *)progressLayer {
    
    if (!_progressLayer) {
        
        _progressLayer = [CAShapeLayer layer];
        
        _progressLayer.bounds = CGRectMake(0, 0, WIDTH_NORMAL, HEIGHT_NORMAL);
        
        _progressLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WIDTH_NORMAL/2, HEIGHT_NORMAL/2) radius:(WIDTH_NORMAL-LINE_WIDTH_NORMAL) /2 startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
        
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        
        _progressLayer.lineWidth = LINE_WIDTH_NORMAL;
        
        _progressLayer.strokeColor = kDefaultStrokeColor.CGColor;
        
        _progressLayer.strokeEnd = 0;
        
        _progressLayer.strokeStart = 0;
        
        _progressLayer.lineCap = kCALineCapRound;
        
    }
    
    return _progressLayer;
}

#pragma mark ---旋转动画

- (CABasicAnimation *)rotateAnimation {
    
    if (!_rotateAnimation) {
        
        _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _rotateAnimation.fromValue = @0;
        
        _rotateAnimation.toValue = @(2*M_PI);
        
        _rotateAnimation.duration = DURATION/2;
        
        _rotateAnimation.repeatCount = HUGE;
        
        _rotateAnimation.removedOnCompletion = NO;
        
    }
    
    return _rotateAnimation;
}

#pragma mark ---进度条动画开始

- (CABasicAnimation *)strokeAnimatinStart {
    
    if (!_strokeAnimatinStart) {
        
        _strokeAnimatinStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        
        _strokeAnimatinStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        _strokeAnimatinStart.duration = DURATION/2;
        
        _strokeAnimatinStart.fromValue = @0;
        
        _strokeAnimatinStart.toValue = @0.95;
        
        _strokeAnimatinStart.beginTime = 1;
        
        _strokeAnimatinStart.removedOnCompletion = NO;
        
        _strokeAnimatinStart.fillMode = kCAFillModeForwards;
        
        _strokeAnimatinStart.repeatCount = HUGE;
        
    }
    
    return _strokeAnimatinStart;
}

#pragma mark ---进度条动画结束

- (CABasicAnimation *)strokeAnimatinEnd {
    
    if (!_strokeAnimatinEnd) {
        
        _strokeAnimatinEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        _strokeAnimatinEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        _strokeAnimatinEnd.duration = DURATION;
        
        _strokeAnimatinEnd.fromValue = @0;
        
        _strokeAnimatinEnd.toValue = @0.95;
        
        _strokeAnimatinEnd.removedOnCompletion = NO;
        
        _strokeAnimatinEnd.fillMode = kCAFillModeForwards;
        
        _strokeAnimatinEnd.repeatCount = HUGE;
        
        
    }
    
    return _strokeAnimatinEnd;
}


#pragma mark ---创建动画组

- (CAAnimationGroup *)animationGroup {
    
    if (!_animationGroup) {
        
        _animationGroup = [CAAnimationGroup animation];
        
        _animationGroup.animations = @[self.strokeAnimatinStart, self.strokeAnimatinEnd];
        
        _animationGroup.repeatCount = HUGE;
        
        _animationGroup.duration = DURATION;
        
    }
    
    return _animationGroup;
}

#pragma mark ---开启动画

- (void)startProgressAnimating {
    
    [self.progressLayer addAnimation:self.animationGroup forKey:@"group"];
    
    [self.progressLayer addAnimation:self.rotateAnimation forKey:@"rotate"];
    
}

#pragma mark ---停止动画

- (void)stopProgressAnimating {
    
    if (self.rotateAnimation && self.animationGroup) {
        
        [self.progressLayer removeAllAnimations];
        
    }
    
}





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
