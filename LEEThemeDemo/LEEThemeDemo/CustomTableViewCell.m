
/*!
 *  @header CustomTableViewCell.m
 *          LEEThemeDemo
 *
 *  @brief  自定义CELL
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/4/22.
 */

#import "CustomTableViewCell.h"

#import "LEETheme.h"

@interface CustomTableViewCell ()

@property (nonatomic , strong ) UIImageView *picImageView;

@property (nonatomic , strong ) UILabel *titleLabel;

@end

@implementation CustomTableViewCell

- (void)dealloc{
    
    _picImageView = nil;
    
    _titleLabel = nil;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        //初始化子视图
        
        [self initSubviews];
        
        //设置主题样式
        
        [self configThemeStyle];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
}

#pragma mark - 初始化子视图

- (void)initSubviews{
    
    _picImageView = [[UIImageView alloc] init];
    
    _picImageView.frame = CGRectMake(15, 10, 80, 80);
    
//    _picImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]];
    
    [self.contentView addSubview:_picImageView];
    
    _titleLabel = [[UILabel alloc]init];
 
    _titleLabel.frame = CGRectMake(100, 10, CGRectGetWidth(self.contentView.frame) - 120, 80);
    
    _titleLabel.text = @"大家好,我是帅比LEE,这是用来演示主题变更的CELL";
    
    _titleLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_titleLabel];
    
}

#pragma mark - 设置主题样式

- (void)configThemeStyle{
    
    _picImageView.lee_theme
    .LeeConfigImage(@"ident1");
//    .LeeAddImage(RED , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]])
//    .LeeAddImage(BLUE , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huaji" ofType:@"jpg"]])
////    .LeeAddImage(GRAY , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]]);
//    .LeeAddImagePath(GRAY , [[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]);
    
    _titleLabel.lee_theme
    .LeeAddCustomConfig(RED , ^(UILabel *item){
        
        item.textColor = [UIColor redColor];
    })
    .LeeAddCustomConfig(BLUE , ^(UILabel *item){
        
        item.textColor = [UIColor blueColor];
    })
    .LeeAddCustomConfig(GRAY , ^(UILabel *item){
        
        item.textColor = [UIColor grayColor];
    });
    
}

@end
