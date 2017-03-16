//
//  CommunityDetailsContentFooterView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/7.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsContentFooterView.h"

#import "SDAutoLayout.h"

#import "LEECoolButton.h"

#import "FontSizeManager.h"

#import "MierProgressHUD.h"

@interface CommunityDetailsContentFooterView ()

@property (nonatomic , strong ) UILabel *timeLabel; //时间Label

@property (nonatomic , strong ) UIButton *deleteButton; //删除按钮

@property (nonatomic , strong ) LEECoolButton *praiseButton; //赞按钮

@property (nonatomic , strong ) UIView *bottomLineView; //底部分隔线视图

@end

@implementation CommunityDetailsContentFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
        
        //设置主题模式
        
        [self configTheme];
        
    }
    return self;
}

#pragma mark - 初始化数据

-(void)initData{
    
}

#pragma mark - 初始化子视图

-(void)initSubview{
    
    //时间Label
    
    _timeLabel = [[UILabel alloc] init];
    
    _timeLabel.font = [UIFont systemFontOfSize:[FontSizeManager textFontSizeForDefault:14.0f]];
    
    [self addSubview:_timeLabel];
    
    //删除按钮
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _deleteButton.hidden = YES;
    
    _deleteButton.titleLabel.font = self.timeLabel.font;
    
    _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [self addSubview:_deleteButton];
    
    //初始化赞按钮
    
    _praiseButton = [LEECoolButton coolButtonWithImage:nil ImageFrame:CGRectMake(102, 6, 16, 16)];
    
    _praiseButton.imageOn = [UIImage imageNamed:@"drawer_digg_btn_pressed"];
    
    _praiseButton.imageOff = [UIImage imageNamed:@"drawer_digg_btn_normal"];
    
    _praiseButton.circleColor = [UIColor colorWithRed:52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
    
    _praiseButton.lineColor = [UIColor colorWithRed:41/255.0f green:128/255.0f blue:185/255.0f alpha:1.0f];
    
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    _praiseButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [_praiseButton addTarget:self action:@selector(praiseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_praiseButton];
    
    //底部分隔线视图
    
    _bottomLineView = [UIView new];
    
    [self addSubview:_bottomLineView];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
    //时间Label
    
    _timeLabel.sd_layout
    .leftSpaceToView(self , 15.0f)
    .topSpaceToView(self , 15.0)
    .heightIs(20.0f);
    
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200.0f];
    
    //删除按钮
    
    _deleteButton.sd_layout
    .leftSpaceToView(self.timeLabel , 10.0f)
    .centerYEqualToView(self.timeLabel)
    .widthIs(50.0f)
    .heightIs(30.0f);
    
    //赞按钮
    
    _praiseButton.sd_layout
    .rightSpaceToView(self, 15.0f)
    .centerYEqualToView(self.timeLabel)
    .widthIs(120.0f)
    .heightIs(30.0f);
    
    _praiseButton.titleLabel.sd_layout
    .rightSpaceToView(self.praiseButton , 20.0f);
    
    [self.praiseButton.titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //底部分隔线视图
    
    _bottomLineView.sd_layout
    .topSpaceToView(self.praiseButton , 15.0f)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(10.0f);
    
    [self setupAutoHeightWithBottomView:self.bottomLineView bottomMargin:0.0f];
}

#pragma mark - 设置主题

-(void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.timeLabel.lee_theme.LeeConfigTextColor(common_font_color_4);
    
    self.deleteButton.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4 , UIControlStateNormal);
    
    self.praiseButton.lee_theme.LeeConfigButtonTitleColor(common_font_color_4 , UIControlStateNormal);
    
    self.bottomLineView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
}

#pragma mark - 删除按钮点击事件

- (void)deleteButtonAction:(id)sender{
    
    if (self.deleteBlock) {
        
        self.deleteBlock();
    }
    
}

#pragma mark - 赞按钮点击事件

- (void)praiseButtonAction:(LEECoolButton *)sender{
    
    if (sender.selected){
        
        [MierProgressHUD showMessage:@"您已经赞过该帖子!"];
        
    } else {
        
        [sender select];
        
        sender.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4, UIControlStateNormal);
        
        if (self.praiseBlock) self.praiseBlock();
    }
    
}

#pragma mark - 点赞状态

- (void)praiseState:(BOOL)success{
    
    //判断是否成功
    
    if (success) {
        
        //更新点赞数
        
        [self updatePraiseCount];
        
        //添加相关状态
        
//        [CorrelationStateManager addType:CorrelationTypeCommunityDetails State:CorrelationStatePraise Identifier:self.model.postId];
        
    } else {
        
        //取消选中状态
        
        [self.praiseButton deselect];
    }
    
}

#pragma mark - 更新点赞数

- (void)updatePraiseCount{
    
    //设置点赞数 并做超限处理
    
    NSInteger praiseCount = self.model.praiseCount;
    
    NSString *praiseCountString = nil;
    
    if (praiseCount > 9999) {
        
        NSInteger wan = praiseCount / 10000;
        
        NSInteger qian = (praiseCount - wan * 10000) / 1000;
        
        if (qian && wan < 100) {
            
            praiseCountString = [NSString stringWithFormat:@"%ld.%ld万人赞过", wan , qian];
            
        } else {
            
            praiseCountString = [NSString stringWithFormat:@"%ld万人赞过", wan];
        }
        
    } else {
        
        praiseCountString = [NSString stringWithFormat:@"%ld人赞过" , praiseCount];
    }
    
    [self.praiseButton setTitle:praiseCountString forState:UIControlStateNormal];
}

#pragma mark - 设置数据

- (void)setModel:(CommunityDetailsModel *)model{
    
    _model = model;
    
    self.timeLabel.text = [self dateCompareCurrentTimeWithDate:[NSDate dateWithTimeIntervalSince1970:model.time.floatValue]];
    
//    self.praiseButton.selected = [CorrelationStateManager checkType:CorrelationTypeCommunityDetails State:CorrelationStatePraise Identifier:model.postId];
    
    if (self.praiseButton.selected) self.model.praiseCount += 1;
    
    [self updatePraiseCount];
    
    // 判断是否为当前登录用户 显示删除按钮
    
//    if ([UserManager shareManager].isLogin) {
//        
//        if ([[UserManager shareManager].userModel.uid isEqualToString:model.authorId]) {
//            
//            self.deleteButton.hidden = NO;
//        }
//        
//    }
    
}

- (NSString *)dateCompareCurrentTimeWithDate:(NSDate *)date{
    
    //获取两时间对比相差的时间戳
    
    NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:date];
    
    //判断相差时间
    
    if (timeDifference > 0 && timeDifference < 60) {
        
        return @"刚刚";
        
    } else if (timeDifference >= 60 && timeDifference < 60 * 60 ){
        
        return [NSString stringWithFormat:@"%.0f分钟前" , timeDifference / 60];
        
    } else if (timeDifference >= 60 * 60 && timeDifference < 60 * 60 * 24){
        
        return [NSString stringWithFormat:@"%.0f小时前" , timeDifference / (60 * 60)];
        
    } else if (timeDifference >= 60 * 60 * 24 && timeDifference < 60 * 60 * 24 * 7){
        
        return [NSString stringWithFormat:@"%.0f天前" , timeDifference / (60 * 60 * 24)];
        
    } else if (timeDifference >= 60 * 60 * 24 * 7 && timeDifference < 60 * 60 * 24 * 30){
        
        return [NSString stringWithFormat:@"%.0f星期前" , timeDifference / (60 * 60 * 24 * 7)];
        
    } else if (timeDifference >= 60 * 60 * 24 * 30 && timeDifference < 60 * 60 * 24 * 30 * 12){
        
        return [NSString stringWithFormat:@"%.0f个月前" , timeDifference / (60 * 60 * 24 * 30)];
        
    } else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yy-MM-dd"];
        
        return [dateFormatter stringFromDate:date];
    }
    
}

@end
