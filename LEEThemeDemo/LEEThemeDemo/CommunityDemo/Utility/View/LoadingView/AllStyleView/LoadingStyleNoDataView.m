//
//  LoadingStyleNoDataView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "LoadingStyleNoDataView.h"


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@interface LoadingStyleNoDataView ()

@property (nonatomic , strong ) UILabel *titleLabel;//标题Label

@property (nonatomic , strong ) UIImageView *imageView;//图片视图

@end

@implementation LoadingStyleNoDataView

-(void)dealloc{
    
    _titleLabel = nil;
    
    _imageView = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化图片视图 并添加手势
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 100 , 100 )];
        
        _imageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2 - 40);
        
        _imageView.image = [UIImage imageNamed:@"no_network14"];
        
        _imageView.userInteractionEnabled = YES;
        
        [_imageView addGestureRecognizer:tap];
        
        [self addSubview:_imageView];
        
        
        //初始化标题Label
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.frame.origin.y + CGRectGetHeight(_imageView.frame) + 10 , CGRectGetWidth(self.frame), 30)];
        
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        _titleLabel.textColor = [UIColor grayColor];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _imageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2 - 40);
    
    _titleLabel.frame = CGRectMake(0, _imageView.frame.origin.y + CGRectGetHeight(_imageView.frame) + 10 , CGRectGetWidth(self.frame), 30);
    
}

#pragma mark ---获取标题

-(void)setTitle:(NSString *)title{
    
    if (_title != title) {
        
        _title = title;
        
    }
    
    _titleLabel.text = title;
    
}

#pragma mark ---图片视图点击事件

- (void)imageViewTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.target) {
        
        if ([self.target respondsToSelector:self.action]) {
            
            SuppressPerformSelectorLeakWarning([self.target performSelector:self.action withObject:self];);
            
        }
        
    }
    
}



@end
