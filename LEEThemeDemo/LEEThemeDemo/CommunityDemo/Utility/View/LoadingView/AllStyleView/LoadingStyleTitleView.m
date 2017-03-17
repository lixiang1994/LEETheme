//
//  LoadingStyleTitleView.m
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "LoadingStyleTitleView.h"

@interface LoadingStyleTitleView ()

@property (nonatomic , strong ) UILabel *titleLabel;//标题Label

@end

@implementation LoadingStyleTitleView

-(void)dealloc{
    
    _titleLabel = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化标题Label
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        _titleLabel.textColor = [UIColor grayColor];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
}

#pragma mark ---获取标题

-(void)setTitle:(NSString *)title{
    
    if (_title != title) {
        
        _title = title;
        
    }
    
    _titleLabel.text = title;
    
}


@end
