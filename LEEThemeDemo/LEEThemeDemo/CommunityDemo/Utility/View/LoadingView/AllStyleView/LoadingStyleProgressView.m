//
//  LoadingStyleProgressView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "LoadingStyleProgressView.h"

#import "LXProgressView.h"

@interface LoadingStyleProgressView ()

@property (nonatomic , strong ) UIImageView *circleImageView;//圆形图片视图

@property (nonatomic , strong ) UILabel *titleLabel;//标题Label

@property (nonatomic , strong ) UIImageView *titleImageView;//标题图片视图

@end

@implementation LoadingStyleProgressView

-(void)dealloc{
    
    _circleImageView = nil;
    
    _titleLabel = nil;
    
    _titleImageView = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *images = [NSMutableArray array];
        
        for (NSInteger i = 1 ; i < 14; i ++) {
            
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"no_network%ld" , (long)i]]];
        }
        
        //初始化圆形图片视图
        
        _circleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 100 , 100 )];
        
        _circleImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2 - 40 );
        
        _circleImageView.backgroundColor = [UIColor clearColor];
        
        _circleImageView.animationImages = images;
        
        _circleImageView.animationDuration = 1.0f;
        
        [self addSubview:_circleImageView];
        
        //初始化标题Label
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,  _circleImageView.frame.origin.y + CGRectGetHeight(_circleImageView.frame) + 10, CGRectGetWidth(self.frame), 30)];
        
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        _titleLabel.textColor = [UIColor lightGrayColor];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        [self addSubview:self.titleImageView];
        
        self.titleImageView.hidden = YES;
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0 ,  _circleImageView.frame.origin.y + CGRectGetHeight(_circleImageView.frame) + 10, CGRectGetWidth(self.frame), 30);
    
    _titleImageView.frame = CGRectMake(0 , _circleImageView.frame.origin.y + CGRectGetHeight(_circleImageView.frame) + 10, 117 , 32);
    
    _titleImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , _titleImageView.center.y);
    
    _circleImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2 - 40 );
    
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
    
    //判断是否设置了标题文字 如果没有 显示标题图片
    
    if (!_title) {
        
        self.titleImageView.hidden = NO;
        
    }
    
//    [_circleImageView.layer addAnimation:[self rotationGear:- M_PI * 6.0f] forKey:@"Rotation"];
    
    [_circleImageView startAnimating];
    
}

#pragma mark ---停止加载动画

- (void)stopLoadingAnimation{
    
//    [_circleImageView.layer removeAnimationForKey:@"Rotation"];
    
    
    [_circleImageView stopAnimating];
    
}

#pragma mark ---旋转动画

-(CABasicAnimation *)rotationGear:(float)degree{
    
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: degree ];
    
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    rotationAnimation.duration = 2;
    
    rotationAnimation.repeatCount = INT_MAX;//设置到最大的整数值
    
    rotationAnimation.cumulative = NO;
    
    rotationAnimation.removedOnCompletion = NO;
    
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    return rotationAnimation;
    
}


#pragma mark ---LazyLoading

-(UIImageView *)titleImageView{
    
    if (_titleImageView == nil) {
        
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , _circleImageView.frame.origin.y + CGRectGetHeight(_circleImageView.frame) + 10, 117 , 32)];
        
        _titleImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , _titleImageView.center.y);
        
        _titleImageView.image = [UIImage leeTheme_ImageFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:detail_load_image];
        
    }
    
    return _titleImageView;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
