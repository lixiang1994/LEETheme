//
//  NewsToolbarView.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/8.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "NewsToolbarView.h"

#import "SDAutoLayout.h"

#import "LEECoolButton.h"

@interface NewsToolbarView ()

@property (nonatomic , strong ) UIView *lineView;

@property (nonatomic , strong ) UIButton *editItem;

@property (nonatomic , strong ) UIButton *commentItem;

@property (nonatomic , strong ) LEECoolButton *favItem;

@property (nonatomic , strong ) UIButton *shareItem;

@property (nonatomic , strong ) UIButton *reportItem;


@property (nonatomic , strong ) NSMutableArray *itemArray;

@property (nonatomic , strong ) NSMutableArray *blockArray;

@property (nonatomic , assign ) NewsToolbarStyleType styleType;

@end

@implementation NewsToolbarView

- (void)dealloc{
    
    _lineView = nil;
    
    _editItem = nil;
    
    _commentItem = nil;
    
    _favItem = nil;
    
    _shareItem = nil;
    
    _itemArray = nil;
    
    _blockArray = nil;
    
}

+(NewsToolbarView *)toolbar{
    
    NewsToolbarView *toobar = [[NewsToolbarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]) - 49.0f, CGRectGetWidth([[UIScreen mainScreen] bounds]), 49.0f)];
    
    return toobar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemArray = [NSMutableArray array];
        
        _blockArray = [NSMutableArray array];
        
        //初始化子视图
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    //初始化分隔线
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5f)];
    
    [self addSubview:_lineView];
    
    //初始化编辑项 (必加)
    
    _editItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_editItem setTitle:@"参与评论可升级军衔..." forState:UIControlStateNormal];
    
    [_editItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _editItem.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _editItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _editItem.titleLabel.font = [UIFont systemFontOfSize:13];
    
    _editItem.backgroundColor = [UIColor clearColor];
    
    _editItem.layer.borderWidth = 0.5f;
    
    [_editItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_editItem];
    
    //暂时添加到数组
    
    [_itemArray addObject:_editItem];
    
}

- (NewsToolbarConfigBlock)configEditItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            //移除原有编辑项
            
            [weakSelf.itemArray removeObject:weakSelf.editItem];
            
            //添加编辑项
            
            [weakSelf.itemArray addObject:weakSelf.editItem];
            
            [weakSelf.blockArray addObject:block];
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigBlock)configCommentItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            //初始化
            
            weakSelf.commentItem = [UIButton buttonWithType:UIButtonTypeCustom];
            
            weakSelf.commentItem.backgroundColor = [UIColor clearColor];
            
            [weakSelf.commentItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:weakSelf.commentItem];
            
            //评论标签
            
            UILabel *commentLabel = [[UILabel alloc] init];
            
            commentLabel.hidden = YES;
            
            commentLabel.backgroundColor = [UIColor redColor];
            
            commentLabel.textAlignment = NSTextAlignmentCenter;
            
            commentLabel.font = [UIFont systemFontOfSize:11.0f];
            
            commentLabel.textColor = [UIColor whiteColor];
            
            commentLabel.layer.cornerRadius = 7.0f;
            
            commentLabel.layer.masksToBounds = YES;
            
            commentLabel.tag = 1234;
            
            [weakSelf.commentItem addSubview:commentLabel];
            
            commentLabel.sd_layout
            .centerXIs(35)
            .topSpaceToView(weakSelf.commentItem, 3.0f)
            .minWidthIs(14)
            .heightIs(14);
            
            [commentLabel setSingleLineAutoResizeWithMaxWidth:60.0f];
            
            [weakSelf.itemArray addObject:weakSelf.commentItem];
            
            [weakSelf.blockArray addObject:block];
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigBlock)configFavItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            //初始化
            
            weakSelf.favItem = [LEECoolButton coolButtonWithImage:nil ImageFrame:CGRectMake(14.5, 14.5, 20, 20)];
            
            weakSelf.favItem.backgroundColor = [UIColor clearColor];
            
            weakSelf.favItem.circleColor = [UIColor colorWithRed:52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
            
            weakSelf.favItem.lineColor = [UIColor colorWithRed:41/255.0f green:128/255.0f blue:185/255.0f alpha:1.0f];
            
            [weakSelf.favItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:weakSelf.favItem];
            
            [weakSelf.itemArray addObject:weakSelf.favItem];
            
            [weakSelf.blockArray addObject:block];
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigBlock)configShareItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            //初始化
            
            weakSelf.shareItem = [UIButton buttonWithType:UIButtonTypeCustom];
            
            weakSelf.shareItem.backgroundColor = [UIColor clearColor];
            
            [weakSelf.shareItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:weakSelf.shareItem];
            
            [weakSelf.itemArray addObject:weakSelf.shareItem];
            
            [weakSelf.blockArray addObject:block];
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigBlock)configReportItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)()){
        
        if (weakSelf) {
            
            //初始化
            
            weakSelf.reportItem = [UIButton buttonWithType:UIButtonTypeCustom];
            
            weakSelf.reportItem.backgroundColor = [UIColor clearColor];
            
            [weakSelf.reportItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:weakSelf.reportItem];
            
            [weakSelf.itemArray addObject:weakSelf.reportItem];
            
            [weakSelf.blockArray addObject:block];
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigString)configEditItemTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) {
            
            [weakSelf.editItem setTitle:string forState:UIControlStateNormal];
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigString)configCommentItemTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) {
            
            if (weakSelf.commentItem) {
                
                UILabel *commentLabel = [weakSelf.commentItem viewWithTag:1234];
                
                if ([string isEqualToString:@"0"] || string == nil || [string isEqualToString:@""]){
                    
                    commentLabel.hidden = YES;
                    
                } else {
                    
                    commentLabel.hidden = NO;
                    
                    if (string.integerValue > 9999) {
                        
                        NSInteger wan = string.integerValue / 10000;
                        
                        NSInteger qian = (string.integerValue - wan * 10000) / 1000;
                        
                        NSString *commentCount = nil;
                        
                        if (qian && wan < 100) {
                            
                            commentCount = [NSString stringWithFormat:@"%ld.%ld万    ", wan , qian];
                            
                        } else {
                            
                            commentCount = [NSString stringWithFormat:@"%ld万    ", wan];
                        }
                        
                        commentLabel.text = commentCount;
                        
                    } else {
                        
                        commentLabel.text = [NSString stringWithFormat:@"%@    ", string];
                    }
                    
                }
                
                [commentLabel updateLayout];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigBool)configFavItemState{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL state){
        
        if (weakSelf) {
            
            if (weakSelf.favItem) {
                
                weakSelf.favItem.selected = state;
            }
            
        }
        
        return weakSelf;
    };
    
}

- (NewsToolbarConfigStyle)configStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NewsToolbarStyleType type){
    
        if (weakSelf) {
            
            weakSelf.styleType = type;
        }
        
        return weakSelf;
    };
    
}

- (void)show{
    
    //主题样式
    
    switch (self.styleType) {
            
        case NewsToolbarStyleTypeNormal:
            
            self.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
            
            self.lineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
            
            self.editItem.lee_theme
            .LeeConfigBackgroundColor(common_bg_color_8)
            .LeeConfigButtonTitleColor(common_font_color_4 , UIControlStateNormal);
            
            self.editItem.layer.lee_theme.LeeConfigBorderColor(common_bar_divider1);

            if (_commentItem) {
                
                self.commentItem.lee_theme.LeeConfigButtonImage(newstoolbar_comment_btn_image, UIControlStateNormal);
            }
            
            if (_shareItem) {
                
                self.shareItem.lee_theme.LeeConfigButtonImage(newstoolbar_share_btn_image, UIControlStateNormal);
            }
            
            if (_reportItem) {
                
                self.reportItem.lee_theme.LeeConfigButtonImage(newstoolbar_report_btn_image, UIControlStateNormal);
            }
            
            if (_favItem) {
                
                self.favItem.lee_theme
                .LeeConfigKeyPathAndIdentifier(@"imageOn" , newstoolbar_collection_btn_select_image)
                .LeeConfigKeyPathAndIdentifier(@"imageOff" , newstoolbar_collection_btn_noselect_image);
            }
            
            self.lee_theme.LeeAddCustomConfigs(@[DAY , NIGHT] , ^(NewsToolbarView *item){
                
            });
            
            break;
            
        case NewsToolbarStyleTypeGallery:
            
            self.backgroundColor = LEEColorFromIdentifier(NIGHT, common_bg_color_6);
            
            self.lineView.backgroundColor = LEEColorFromIdentifier(NIGHT, common_bar_divider1);
            
            self.editItem.backgroundColor = LEEColorFromIdentifier(NIGHT, common_bg_color_8);
            
            [self.editItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            self.editItem.layer.borderColor = LEEColorFromIdentifier(NIGHT, common_bar_divider1).CGColor;
            
            if (self.commentItem) {
                
                [self.commentItem setImage:LEEImageFromIdentifier(NIGHT, newstoolbar_comment_btn_image) forState:UIControlStateNormal];
            }
            
            if (_favItem) {
                
                self.favItem.imageOff = LEEImageFromIdentifier(NIGHT, newstoolbar_collection_btn_noselect_image);
                
                self.favItem.lee_theme.LeeConfigKeyPathAndIdentifier(@"imageOn" , newstoolbar_collection_btn_select_image);
            }

            if (_shareItem) {
                
                [self.shareItem setImage:LEEImageFromIdentifier(NIGHT, newstoolbar_share_btn_image) forState:UIControlStateNormal];
            }
            
            break;
        default:
            break;
    }

    //布局
    
    NSInteger editIndex = [self.itemArray indexOfObject:self.editItem];
    
    for (NSInteger i = 0 ; i < self.itemArray.count ; i++) {
        
        UIView *item = self.itemArray[i];
        
        if (i < editIndex) { //编辑项左侧
            
            if (i == 0) {
                
                item.sd_layout
                .leftSpaceToView(self , 0.0f)
                .centerYEqualToView(self)
                .heightRatioToView(self , 1)
                .widthEqualToHeight();
                
            } else {
                
                item.sd_layout
                .leftSpaceToView(self.itemArray[i - 1] , 0.0f)
                .centerYEqualToView(self)
                .heightRatioToView(self , 1)
                .widthEqualToHeight();
            }
            
        } else if (i > editIndex) { //编辑项右侧
            
            if (i == self.itemArray.count - 1) {
                
                item.sd_layout
                .rightSpaceToView(self , 0.0f)
                .centerYEqualToView(self)
                .heightRatioToView(self , 1)
                .widthEqualToHeight();
                
            } else {
                
                item.sd_layout
                .rightSpaceToView(self.itemArray[i + 1] , 0.0f)
                .centerYEqualToView(self)
                .heightRatioToView(self , 1)
                .widthEqualToHeight();
            }
            
        } else { //编辑项
            
            if (i == 0) {
                
                if (self.itemArray.count == 1) {
                    
                    item.sd_layout
                    .leftSpaceToView(self , 10.0f)
                    .rightSpaceToView(self , 10.0f)
                    .centerYEqualToView(self)
                    .heightIs(30.0f);
                
                } else {
                    
                    item.sd_layout
                    .leftSpaceToView(self , 10.0f)
                    .rightSpaceToView(self.itemArray[i + 1] , 5.0f)
                    .centerYEqualToView(self)
                    .heightIs(30.0f);
                }
        
            } else if (i == self.itemArray.count - 1) {
                
                item.sd_layout
                .leftSpaceToView(self.itemArray[i - 1] , 5.0f)
                .rightSpaceToView(self , 10.0f)
                .centerYEqualToView(self)
                .heightIs(30.0f);
                
            } else {
                
                item.sd_layout
                .leftSpaceToView(self.itemArray[i - 1] , 5.0f)
                .rightSpaceToView(self.itemArray[i + 1] , 5.0f)
                .centerYEqualToView(self)
                .heightIs(30.0f);
            }
            
        }
        
        //更新上一项
        
        [self.itemArray[i ? i - 1 : 0] updateLayout];
    }
    
    //更新编辑项
    
    for (UIView *item in self.itemArray) {
        
        [item updateLayout];
    }
    
}

#pragma mark - 选项点击事件

- (void)itemAction:(UIButton *)sender{
    
    // 判断按钮类型
    
    if ([sender isKindOfClass:[LEECoolButton class]]) {
        
        LEECoolButton *cool = (LEECoolButton *)sender;
        
        if (cool.selected) {
            
            [cool deselect];
            
        } else {
            
            [cool select];
        }
    }
    
    void (^block)() = self.blockArray[[self.itemArray indexOfObject:sender]];
    
    if (block) block();
}

@end
