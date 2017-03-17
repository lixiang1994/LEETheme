
/*!
 *  @header LEECoolButton.m
 *
 *  @brief  LEE炫酷按钮
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */

#import "LEECoolButton.h"

@interface LEECoolButton ()

@property (nonatomic , strong ) CAShapeLayer *circleShape;

@property (nonatomic , strong ) CAShapeLayer *circleMask;

@property (nonatomic , strong ) CAShapeLayer *imageShape;

@property (nonatomic , strong ) CALayer *imageLayer;

@property (nonatomic , strong ) NSMutableArray *lineArray;

@end

@implementation LEECoolButton
{
    
    CAKeyframeAnimation *circleTransform;
    
    CAKeyframeAnimation *circleMaskTransform;
    
    CAKeyframeAnimation *lineStrokeStart;
    
    CAKeyframeAnimation *lineStrokeEnd;
    
    CAKeyframeAnimation *lineOpacity;
    
    CAKeyframeAnimation *imageTransform;
    
    UIImage *image;
    
    CGRect imageFrame;
    
}

@synthesize circleColor = _circleColor;
@synthesize lineColor = _lineColor;
@synthesize imageColorOn = _imageColorOn;
@synthesize imageColorOff = _imageColorOff;

+ (id)coolButtonWithImage:(UIImage *)image ImageFrame:(CGRect)imageFrame{
    
    LEECoolButton *button = [LEECoolButton buttonWithType:UIButtonTypeCustom];
    
    //设置图片
    
    [button configImage:image ImageFrame:imageFrame];
    
    //初始化Layer
    
    [button initLayers];
    
    //初始化动画
    
    [button initAnimations];
    
    //添加事件
    
    [button addTarget];
    
    return button;
}

#pragma mark - 设置图片

- (void)configImage:(UIImage *)img ImageFrame:(CGRect)imgFrame{
    
    image = img;
    
    imageFrame = imgFrame;
}

#pragma mark - 初始化Layer

- (void)initLayers{
    
    CGPoint imgCenterPoint = CGPointMake(imageFrame.origin.x + imageFrame.size.width / 2, imageFrame.origin.y + imageFrame.size.height / 2);
    
    CGRect lineFrame = CGRectMake(imageFrame.origin.x - imageFrame.size.width / 4, imageFrame.origin.y - imageFrame.size.height / 4 , imageFrame.size.width * 1.5, imageFrame.size.height * 1.5);
    
    //初始化 circle layer
    
    _circleShape = [CAShapeLayer layer];
    
    _circleShape.bounds = imageFrame;
    
    _circleShape.position = imgCenterPoint;
    
    _circleShape.path = [UIBezierPath bezierPathWithOvalInRect:imageFrame].CGPath;
    
    _circleShape.fillColor = self.circleColor.CGColor;
    
    _circleShape.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    
    [self.layer addSublayer:_circleShape];
    
    _circleMask = [CAShapeLayer layer];
    
    _circleMask.bounds = imageFrame;
    
    _circleMask.position = imgCenterPoint;
    
    _circleMask.fillRule = kCAFillRuleEvenOdd;
    
    _circleShape.mask = _circleMask;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:imageFrame];
    
    [maskPath addArcWithCenter:imgCenterPoint radius:0.1f startAngle:0.0f endAngle:M_PI * 2 clockwise:YES];
    
    _circleMask.path = maskPath.CGPath;
    
    //初始化 line layer
    
    _lineArray = [NSMutableArray array];
    
    struct CGPath *path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, lineFrame.origin.x + lineFrame.size.width / 2, lineFrame.origin.y + lineFrame.size.height / 2);
    
    CGPathAddLineToPoint(path, nil, lineFrame.origin.x + lineFrame.size.width / 2, lineFrame.origin.y);
    
    for (NSInteger i = 0; i < 5; i++) {
        
        CAShapeLayer *line = [CAShapeLayer layer];
        line.bounds = lineFrame;
        line.position = imgCenterPoint;
        line.masksToBounds = YES;
        line.actions = @{@"strokeStart" : [NSNull null] , @"strokeEnd" : [NSNull null]};
        line.strokeColor = self.lineColor.CGColor;
        line.lineWidth = 1.25f;
        line.miterLimit = 1.25f;
        line.path = path;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        line.strokeStart = 0.0f;
        line.strokeEnd = 0.0f;
        line.opacity = 0.0f;
        line.transform = CATransform3DMakeRotation(M_PI / 5 * (i * 2 + 1), 0.0, 0.0, 1.0);
        [self.layer addSublayer:line];
        
        [self.lineArray addObject:line];
    }
    
    CGPathRelease(path);
    
    //初始化 image layer
    
    _imageShape = [CAShapeLayer layer];
    
    _imageShape.bounds = imageFrame;
    
    _imageShape.position = imgCenterPoint;
    
    _imageShape.path = [UIBezierPath bezierPathWithRect:imageFrame].CGPath;
    
    _imageShape.fillColor = self.imageColorOff.CGColor;
    
    _imageShape.actions = @{@"fillColor": [NSNull null]};
    
    [self.layer addSublayer:_imageShape];
    
    if (image) {
        
        CALayer *imageMask = [CALayer layer];
        
        imageMask.contents = (__bridge id _Nullable)(image.CGImage);
        
        imageMask.bounds = imageFrame;
        
        imageMask.position = imgCenterPoint;
        
        _imageShape.mask = imageMask;
    }

}

#pragma mark - 初始化动画

- (void)initAnimations{
    
    circleTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    circleMaskTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    lineStrokeStart = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    
    lineStrokeEnd = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    
    lineOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    imageTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    //设置 circle transform animation
    
    circleTransform.duration = 0.333f; // 0.0333 * 10
    
    circleTransform.values = @[
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0,  0.0,  1.0)],    //  0/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5,  0.5,  1.0)],    //  1/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,  1.0,  1.0)],    //  2/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,  1.2,  1.0)],    //  3/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3,  1.3,  1.0)],    //  4/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.37, 1.37, 1.0)],    //  5/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,  1.4,  1.0)],    //  6/10
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,  1.4,  1.0)]     // 10/10
                              ];
    
    circleTransform.keyTimes = @[
                                @(0.0),    //  0/10
                                @(0.1),    //  1/10
                                @(0.2),    //  2/10
                                @(0.3),    //  3/10
                                @(0.4),    //  4/10
                                @(0.5),    //  5/10
                                @(0.6),    //  6/10
                                @(1.0)     // 10/10
                                ];
    
    circleMaskTransform.duration = 0.333f; // 0.0333 * 10
    
    CGFloat imageWidth = imageFrame.size.width;
    
    CGFloat imageHeight = imageFrame.size.height;
    
    circleMaskTransform.values = @[
                                  [NSValue valueWithCATransform3D:CATransform3DIdentity],                                                  //  0/10
                                  [NSValue valueWithCATransform3D:CATransform3DIdentity],                                                  //  2/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 1.25,  imageHeight * 1.25,  1.0)],   //  3/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 2.688, imageHeight * 2.688, 1.0)],   //  4/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 3.923, imageHeight * 3.923, 1.0)],   //  5/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 4.375, imageHeight * 4.375, 1.0)],   //  6/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 4.731, imageHeight * 4.731, 1.0)],   //  7/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 5.0,   imageHeight * 5.0,   1.0)],   //  9/10
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(imageWidth * 5.0,   imageHeight * 5.0,   1.0)]    // 10/10
                                  ];
                                  
    circleMaskTransform.keyTimes = @[
                                    @(0.0),    //  0/10
                                    @(0.2),    //  2/10
                                    @(0.3),    //  3/10
                                    @(0.4),    //  4/10
                                    @(0.5),    //  5/10
                                    @(0.6),    //  6/10
                                    @(0.7),    //  7/10
                                    @(0.9),    //  9/10
                                    @(1.0)     // 10/10
                                    ];
    
    
    //设置 line stroke animation
    
    lineStrokeStart.duration = 0.6f; //0.0333 * 18
    
    lineStrokeStart.values = @[
                              @(0.0),    //  0/18
                              @(0.0),    //  1/18
                              @(0.18),   //  2/18
                              @(0.2),    //  3/18
                              @(0.26),   //  4/18
                              @(0.32),   //  5/18
                              @(0.4),    //  6/18
                              @(0.6),    //  7/18
                              @(0.71),   //  8/18
                              @(0.89),   // 17/18
                              @(0.92)    // 18/18
                              ];
    
    lineStrokeStart.keyTimes = @[
                                @(0.0),    //  0/18
                                @(0.056),  //  1/18
                                @(0.111),  //  2/18
                                @(0.167),  //  3/18
                                @(0.222),  //  4/18
                                @(0.278),  //  5/18
                                @(0.333),  //  6/18
                                @(0.389),  //  7/18
                                @(0.444),  //  8/18
                                @(0.944),  // 17/18
                                @(1.0),    // 18/18
                                ];
    
    lineStrokeEnd.duration = 0.6; //0.0333 * 18
    
    lineStrokeEnd.values = @[
                            @(0.0),    //  0/18
                            @(0.0),    //  1/18
                            @(0.32),   //  2/18
                            @(0.48),   //  3/18
                            @(0.64),   //  4/18
                            @(0.68),   //  5/18
                            @(0.92),   // 17/18
                            @(0.92)    // 18/18
                            ];
    
    lineStrokeEnd.keyTimes = @[
                              @(0.0),    //  0/18
                              @(0.056),  //  1/18
                              @(0.111),  //  2/18
                              @(0.167),  //  3/18
                              @(0.222),  //  4/18
                              @(0.278),  //  5/18
                              @(0.944),  // 17/18
                              @(1.0),    // 18/18
                              ];
    
    lineOpacity.duration = 1.0; //0.0333 * 30
    
    lineOpacity.values = @[
                          @(1.0),    //  0/30
                          @(1.0),    // 12/30
                          @(0.0)     // 17/30
                          ];
    
    lineOpacity.keyTimes = @[
                            @(0.0),    //  0/30
                            @(0.4),    // 12/30
                            @(0.567)   // 17/30
                            ];
    
    
    //设置 image transform animation
    
    imageTransform.duration = 1.0f; //0.0333 * 30
    
    imageTransform.values = @[
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0,   0.0,   1.0)],  //  0/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0,   0.0,   1.0)],  //  3/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,   1.2,   1.0)],  //  9/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25,  1.25,  1.0)],  // 10/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,   1.2,   1.0)],  // 11/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9,   0.9,   1.0)],  // 14/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.875, 0.875, 1.0)],  // 15/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.875, 0.875, 1.0)],  // 16/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9,   0.9,   1.0)],  // 17/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.013, 1.013, 1.0)],  // 20/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.025, 1.025, 1.0)],  // 21/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.013, 1.013, 1.0)],  // 22/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.96,  0.96,  1.0)],  // 25/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95,  0.95,  1.0)],  // 26/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.96,  0.96,  1.0)],  // 27/30
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.99,  0.99,  1.0)],  // 29/30
                             [NSValue valueWithCATransform3D:CATransform3DIdentity]                       // 30/30
                             ];
    
    imageTransform.keyTimes = @[
                               @(0.0),    //  0/30
                               @(0.1),    //  3/30
                               @(0.3),    //  9/30
                               @(0.333),  // 10/30
                               @(0.367),  // 11/30
                               @(0.467),  // 14/30
                               @(0.5),    // 15/30
                               @(0.533),  // 16/30
                               @(0.567),  // 17/30
                               @(0.667),  // 20/30
                               @(0.7),    // 21/30
                               @(0.733),  // 22/30
                               @(0.833),  // 25/30
                               @(0.867),  // 26/30
                               @(0.9),    // 27/30
                               @(0.967),  // 29/30
                               @(1.0)     // 30/30
                               ];
    
}

#pragma mark - 添加事件

- (void)addTarget{
    
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [self addTarget:self action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    
    [self addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
}

- (void)touchDown:(id)sender{
    
    self.layer.opacity = 0.4f;
}

- (void)touchUpInside:(id)sender{
    
    self.layer.opacity = 1.0f;
}

- (void)touchDragExit:(id)sender{
    
    self.layer.opacity = 1.0f;
}

- (void)touchDragEnter:(id)sender{
    
    self.layer.opacity = 0.4f;
}

- (void)touchCancel:(id)sender{
    
    self.layer.opacity = 1.0f;
}

#pragma mark - getter

- (UIColor *)circleColor{
    
    if (!_circleColor) _circleColor = [UIColor colorWithRed:255/255.0f green:172/255.0f blue:51/255.0f alpha:1.0f];
    
    return _circleColor;
}

- (UIColor *)lineColor{
    
    if (!_lineColor) _lineColor = [UIColor colorWithRed:250/255.0f green:120/255.0f blue:68/255.0f alpha:1.0f];
 
    return _lineColor;
}

- (UIColor *)imageColorOn{
    
    if (!_imageColorOn) _imageColorOn = [UIColor colorWithRed:255/255.0f green:172/255.0f blue:52/255.0f alpha:1.0f];
    
    return _imageColorOn;
}

- (UIColor *)imageColorOff{
    
    if (!_imageColorOff) _imageColorOff = [UIColor colorWithRed:136/255.0f green:153/255.0f blue:166/255.0f alpha:1.0f];
    
    return _imageColorOff;
}

#pragma mark - setter

- (void)setSelected:(BOOL)selected{

    BOOL isEqual = self.selected != selected;
    
    [super setSelected:selected];
    
    if (isEqual) {
        
        if (selected){
        
            self.imageShape.fillColor = self.imageColorOn.CGColor;
        
            if (_imageLayer) self.imageLayer.contents = (__bridge id _Nullable)(self.imageOn.CGImage);
            
        } else {
            
            [self deselect];
        }
        
    }

}

- (void)setCircleColor:(UIColor *)circleColor{
    
    _circleColor = circleColor;
    
    self.circleShape.fillColor = circleColor.CGColor;
}

- (void)setLineColor:(UIColor *)lineColor{
    
    _lineColor = lineColor;
    
    for (CAShapeLayer *line in self.lineArray) {
        
        line.strokeColor = lineColor.CGColor;
    }
    
}

- (void)setImageColorOn:(UIColor *)imageColorOn{
    
    _imageColorOn = imageColorOn;
    
    if (self.selected) self.imageShape.fillColor = imageColorOn.CGColor;
}

- (void)setImageColorOff:(UIColor *)imageColorOff{
    
    _imageColorOff = imageColorOff;
    
    if (!self.selected) self.imageShape.fillColor = imageColorOff.CGColor;
}

- (void)setImageOn:(UIImage *)imageOn{
    
    _imageOn = imageOn;
    
    [self.imageShape removeFromSuperlayer];
    
    if (self.selected) self.imageLayer.contents = (__bridge id _Nullable)(imageOn.CGImage);
}

- (void)setImageOff:(UIImage *)imageOff{
    
    _imageOff = imageOff;
    
    [self.imageShape removeFromSuperlayer];
    
    if (!self.selected) self.imageLayer.contents = (__bridge id _Nullable)(imageOff.CGImage);
}

- (void)setDuration:(double)duration{
    
    _duration = duration;
    
    circleTransform.duration = 0.333 * duration; // 0.0333 * 10
    
    circleMaskTransform.duration = 0.333 * duration; // 0.0333 * 10
    
    lineStrokeStart.duration = 0.6 * duration; //0.0333 * 18
    
    lineStrokeEnd.duration = 0.6 * duration; //0.0333 * 18
    
    lineOpacity.duration = 1.0 * duration; //0.0333 * 30
    
    imageTransform.duration = 1.0 * duration; //0.0333 * 30
}

#pragma mark - 选中

- (void)select{
    
    self.selected = YES;
    
    self.imageShape.fillColor = self.imageColorOn.CGColor;
    
    if (_imageLayer) self.imageLayer.contents = (__bridge id _Nullable)(self.imageOn.CGImage);
    
    //添加动画
    
    [CATransaction begin];
    
    [self.circleShape addAnimation:circleTransform forKey:@"transform"];
    
    [self.circleMask addAnimation:circleMaskTransform forKey:@"transform"];
    
    [self.imageShape addAnimation:imageTransform forKey:@"transform"];
    
    if (_imageLayer) [self.imageLayer addAnimation:imageTransform forKey:@"transform"];
    
    for (CAShapeLayer *line in self.lineArray) {
        
        [line addAnimation:lineStrokeStart forKey:@"strokeStart"];
        
        [line addAnimation:lineStrokeEnd forKey:@"strokeEnd"];
        
        [line addAnimation:lineOpacity forKey:@"opacity"];
    }
    
    [CATransaction commit];
}

#pragma mark - 未选中

- (void)deselect{
    
    self.selected = NO;
    
    self.imageShape.fillColor = self.imageColorOff.CGColor;
    
    if (_imageLayer) self.imageLayer.contents = (__bridge id _Nullable)(self.imageOff.CGImage);
    
    //移除所有动画
    
    [self.circleShape removeAllAnimations];
    
    [self.circleMask removeAllAnimations];
    
    [self.imageShape removeAllAnimations];
    
    if (_imageLayer) [self.imageLayer removeAllAnimations];
    
    for (CAShapeLayer *line in self.lineArray) {
        
        [line removeAllAnimations];
    }
    
}

- (void)dealloc{
    
    _lineArray = nil;
}

#pragma mark - LazyLoading

- (CALayer *)imageLayer{
    
    if (!_imageLayer) {
        
        _imageLayer = [CALayer layer];
        
        _imageLayer.bounds = imageFrame;
        
        _imageLayer.position = CGPointMake(imageFrame.origin.x + imageFrame.size.width / 2, imageFrame.origin.y + imageFrame.size.height / 2);
        
        [self.layer addSublayer:_imageLayer];
    }
    
    return _imageLayer;
}

@end
