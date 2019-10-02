//
//  MJRefreshGifHeader+UniversalRefresh.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/9/21.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "UniversalRefresh.h"

#import "SetManager.h"

/**
 *  刷新中动画图片数组
 */
static NSArray *refreshingImageArray;

@implementation MJRefreshGifHeader (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    /*
    if (self) {
        
        if (!refreshingImageArray) {
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            for (NSInteger i = 1; i < 32; i++) {
                
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_%.2ld.png" , i]];
                
                if (image) [imageArray addObject:image];
            }
            
            refreshingImageArray = [imageArray copy];
        }
        
        //设置动画图片
        
        self.gifView.image = refreshingImageArray.firstObject;
        
        [self setImages:refreshingImageArray duration:1.0f forState:MJRefreshStateRefreshing];
        
        // 设置文字
        
        [self setTitle:@"           准备集合" forState:MJRefreshStateIdle];
        
        [self setTitle:@"           集合完毕" forState:MJRefreshStatePulling];
        
        [self setTitle:@"           全军出击" forState:MJRefreshStateRefreshing];
        
        // 设置字体
        
        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        
        // 设置颜色
        
        self.stateLabel.textColor = [UIColor grayColor];
        
        // 设置Label左边距
        
        self.labelLeftInset = -30.0f;
        
        // 隐藏时间
        
        self.lastUpdatedTimeLabel.hidden = YES;
         
    }
    return self;
    */
    /** 临时改回原来的low样式*/
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    
    //设置图片
    
    header.arrowView.image = [UIImage imageNamed:@"refresh"];
    
    // 设置文字
    
    [header setTitle:@"开始装弹" forState:MJRefreshStateIdle];
    
    [header setTitle:@"正在装弹" forState:MJRefreshStatePulling];
    
    [header setTitle:@"让子弹飞一会" forState:MJRefreshStateRefreshing];
    
    // 设置字体
    
    header.stateLabel.font = [UIFont systemFontOfSize:16.0f];
    
    // 设置颜色
    
    header.stateLabel.textColor = [UIColor grayColor];
    
    // 隐藏时间
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    //设置菊花样式
    
    header.lee_theme
    .LeeAddCustomConfig(DAY , ^(MJRefreshNormalHeader *item){
        
        item.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    })
    .LeeAddCustomConfig(NIGHT , ^(MJRefreshNormalHeader *item){
        
        item.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    });
    
    return (id)header;
}

@end

@implementation MJRefreshBackNormalFooter (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //去除箭头图片
        
        self.arrowView.image = nil;
        
        // 设置文字
        
        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
        
        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        
        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        
        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        
        // 设置颜色
        
        self.stateLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
        
        //设置菊花样式
        
        self.lee_theme
        .LeeAddCustomConfig(DAY , ^(MJRefreshAutoNormalFooter *item){
            
            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        })
        .LeeAddCustomConfig(NIGHT , ^(MJRefreshAutoNormalFooter *item){
            
            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        });
        
    }
    return self;
}

@end



@implementation MJRefreshAutoNormalFooter (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 设置文字
        
        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
        
        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        
        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        
        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        
        // 设置颜色
        
        self.stateLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
        
        // 设置无数据隐藏
        
        self.automaticallyHidden = YES;
        
        // 设置菊花样式
        
        self.lee_theme
        .LeeAddCustomConfig(DAY , ^(MJRefreshAutoNormalFooter *item){
            
            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        })
        .LeeAddCustomConfig(NIGHT , ^(MJRefreshAutoNormalFooter *item){
            
            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        });
        
    }
    return self;
}

@end

