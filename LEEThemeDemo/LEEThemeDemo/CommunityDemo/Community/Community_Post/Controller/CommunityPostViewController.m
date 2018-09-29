//
//  CommunityPostViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityPostViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "SDAutoLayout.h"

#import "TZImagePickerController.h"

#import "YYLabel+Extend.h"

#import "MierFaceInputView.h"

#import "CommunityPostImageView.h"

#import "CommunityPostLocationViewController.h"

#import "CommunityCircleListViewController.h"

#import "CommunityPostAPI.h"

#import "LEEAlert.h"

#import "MierProgressHUD.h"

#define HISTORYPOSTCONTENT @"HISTORYPOSTCONTENT" //历史发帖内容

@interface CommunityPostViewController ()<YYTextViewDelegate , YYTextKeyboardObserver , TZImagePickerControllerDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIActionSheetDelegate , CLLocationManagerDelegate>

@property (nonatomic , strong ) YYTextView *titleTextView; //标题文本视图

@property (nonatomic , strong ) YYTextView *contentTextView; //内容文本视图

@property (nonatomic , strong ) UIView *lineView; //分隔线视图

@property (nonatomic , strong ) UIView *locationView; //位置视图

@property (nonatomic , strong ) UILabel *locationLabel; //位置Label

@property (nonatomic , strong ) UIButton *locationCloseButton; //位置关闭按钮

@property (nonatomic , strong ) UIView *toolbar; //工具栏

@property (nonatomic , strong ) MierFaceInputView *faceView; //米尔表情输入视图

@property (nonatomic , strong ) UIButton *faceButton; //表情按钮

@property (nonatomic , strong ) UIButton *photoButton; //相片按钮

@property (nonatomic , strong ) UIButton *locationButton; //位置按钮

@property (nonatomic , strong ) UIButton *circleButton; //圈子按钮

@property (nonatomic , strong ) NSMutableArray *contentImageUrlArray; //内容图片Url数组

@property (nonatomic , strong ) CommunityPostAPI *api;

@property (nonatomic , strong ) CLLocationManager *locationManager; //定位管理器

@property (nonatomic , assign ) CGFloat longitude; //经度

@property (nonatomic , assign ) CGFloat latitude; //纬度

@property (nonatomic , assign ) BOOL isPublish; //是否发布中

@end

@implementation CommunityPostViewController

- (void)dealloc{
    
    _titleTextView = nil;
    
    _contentTextView = nil;
    
    _lineView = nil;
    
    _locationView = nil;
    
    _locationLabel = nil;
    
    _locationCloseButton = nil;
    
    _toolbar = nil;
    
    _faceView = nil;
    
    _faceButton = nil;
    
    _photoButton = nil;
    
    _locationButton = nil;
    
    _circleButton = nil;
    
    _contentImageUrlArray = nil;
    
    _circleModel = nil;
    
    _api = nil;
    
    _locationManager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    
    [self initData];
    
    //初始化子视图
    
    [self initSubview];
    
    //设置自动布局
    
    [self configAutoLayout];
    
    //设置主题模式
    
    [self configTheme];
    
    //设置Block
    
    [self configBlock];
    
    //加载数据
    
    [self loadData];
}

#pragma mark - 设置NavigationBar

-(void)configNavigationBar{
    
    __weak typeof(self) weakSelf = self;
    
    //设置导航栏
    
    [[MierNavigationBar bar]
     .configStyle(MierNavigationBarStyleTypeWhite)
     .configTitleItemTitle(@"发表帖子")
     .configLeftItemAction(^(){
        
        if (weakSelf) {
            
            if (weakSelf.contentTextView.attributedText.length) {
                
                [LEEAlert alert].config
                .LeeTitle(@"是否保存未发布的内容?")
                .LeeAction(@"保存" , ^{
                    
                    if (weakSelf) {
                        
                        // 保存内容
                        
                        [weakSelf saveContent];
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    
                })
                .LeeCancelAction(@"取消" , ^{
                    
                    if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
                })
                .LeeShow();
                
            } else {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
    })
     .configRightItemTitle(@"发布")
     .configRightItemAction(^(){
        
        if (weakSelf) [weakSelf publishAction];
    })
     show:self];
}

#pragma mark - 初始化数据

- (void)initData{
    
    //内容图片Url数组
    
    _contentImageUrlArray = [NSMutableArray array];
    
    //默认圈子
    
    if (!_circleModel) {
        
        _circleModel = [[CommunityCircleModel alloc] init];
        
        _circleModel.circleId = @"671";
        
        _circleModel.circleName = @"战友畅谈";
    }
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //标题文本视图
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    parser.emoticonMapper = [YYLabel faceMapper];
    
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    
    mod.fixedLineHeight = 16.0f + 10.0f;
    
    _titleTextView = [[YYTextView alloc] init];
    
    _titleTextView.delegate = self;
    
    _titleTextView.textParser = parser;
    
    _titleTextView.linePositionModifier = mod;
    
    _titleTextView.font = [UIFont systemFontOfSize:18.0f];
    
    _titleTextView.placeholderFont = [UIFont systemFontOfSize:18.0f];
    
    _titleTextView.placeholderText = @"文章标题";
    
    _titleTextView.placeholderTextColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    
    _titleTextView.textContainerInset = UIEdgeInsetsMake(5, 15, 10, 15);
    
    [self.view addSubview:_titleTextView];
    
    //内容文本视图
    
    _contentTextView = [[YYTextView alloc] init];
    
    _contentTextView.delegate = self;
    
    _contentTextView.textParser = parser;
    
    _contentTextView.font = [UIFont systemFontOfSize:16.0f];
    
    _contentTextView.placeholderFont = [UIFont systemFontOfSize:16.0f];
    
    _contentTextView.placeholderText = @"正文内容";
    
    _contentTextView.placeholderTextColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    
    _contentTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    _contentTextView.allowsPasteImage = YES; /// Pasts image
    
    _contentTextView.allowsPasteAttributedString = YES; /// Paste attributed string
    
    [self.view addSubview:_contentTextView];
    
    NSMutableDictionary *contentAttributes = [NSMutableDictionary dictionary];
    
    [contentAttributes setObject:[UIFont systemFontOfSize:16.0f] forKey:NSFontAttributeName];
    
    [contentAttributes setObject:LEEColorFromIdentifier([LEETheme currentThemeTag], common_font_color_3) forKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 8.0f;
    
    [contentAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    _contentTextView.typingAttributes = contentAttributes;
    
    //分隔线视图
    
    _lineView = [[UIView alloc] init];
    
    [self.view addSubview:_lineView];
    
    //工具栏
    
    _toolbar = [[UIView alloc] init];
    
    _toolbar.backgroundColor = [UIColor redColor];
    
    _toolbar.layer.borderWidth = 0.5f;
    
    [self.view addSubview:_toolbar];
    
    //表情按钮
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_faceButton setImage:[UIImage imageNamed:@"find_circle_post_expression_nor"] forState:UIControlStateNormal];
    
    [_faceButton setImage:[UIImage imageNamed:@"find_circle_post_expression_pre"] forState:UIControlStateHighlighted];
    
    [_faceButton addTarget:self action:@selector(faceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar addSubview:_faceButton];
    
    //相片按钮
    
    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_photoButton setImage:[UIImage imageNamed:@"find_circle_post_pic_nor"] forState:UIControlStateNormal];
    
    [_photoButton setImage:[UIImage imageNamed:@"find_circle_post_pic_pre"] forState:UIControlStateHighlighted];
    
    [_photoButton addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar addSubview:_photoButton];
    
    //位置按钮
    
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_locationButton setImage:[UIImage imageNamed:@"find_circle_post_place_nor"] forState:UIControlStateNormal];
    
    [_locationButton setImage:[UIImage imageNamed:@"find_circle_post_place_pre"] forState:UIControlStateHighlighted];
    
    [_locationButton addTarget:self action:@selector(locationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar addSubview:_locationButton];
    
    //圈子按钮
    
    _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_circleButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [_circleButton setTitle:self.circleModel.circleName forState:UIControlStateNormal];
    
    [_circleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    
    [_circleButton setImage:[UIImage imageNamed:@"find_combined_btn"] forState:UIControlStateNormal];
    
    [_circleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, -70)];
    
    [_circleButton addTarget:self action:@selector(circleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar addSubview:_circleButton];
    
    //位置视图
    
    _locationView = [[UIView alloc] init];
    
    _locationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    _locationView.hidden = YES;
    
    [self.view addSubview:_locationView];
    
    //位置Label
    
    _locationLabel = [[UILabel alloc] init];
    
    _locationLabel.textColor = [UIColor whiteColor];
    
    _locationLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.locationView addSubview:_locationLabel];
    
    //位置关闭按钮
    
    _locationCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_locationCloseButton setImage:[UIImage imageNamed:@"location_close"] forState:UIControlStateNormal];
    
    [_locationCloseButton addTarget:self action:@selector(locationCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.locationView addSubview:_locationCloseButton];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //标题文本视图
    
    _titleTextView.sd_layout
    .topSpaceToView(self.view , 64.0f)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(45.0f);
    
    //内容文本视图
    
    _contentTextView.sd_layout
    .topSpaceToView(self.titleTextView , 0.0f)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.toolbar , 0.0f);
    
    //分隔线视图
    
    _lineView.sd_layout
    .topSpaceToView(self.titleTextView , 0.0f)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(0.5f);
    
    //工具栏
    
    _toolbar.sd_layout
    .yIs(self.view.height - 49.0f)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49.0f);
    
    //表情按钮
    
    _faceButton.sd_layout
    .leftSpaceToView(self.toolbar , 15.0f)
    .topSpaceToView(self.toolbar , 7.0f)
    .widthIs(35.0f)
    .heightIs(35.0f);
    
    //相片按钮
    
    _photoButton.sd_layout
    .leftSpaceToView(self.faceButton , 15.0f)
    .topSpaceToView(self.toolbar , 7.0f)
    .widthIs(35.0f)
    .heightIs(35.0f);
    
    //位置按钮
    
    _locationButton.sd_layout
    .leftSpaceToView(self.photoButton , 15.0f)
    .topSpaceToView(self.toolbar , 7.0f)
    .widthIs(35.0f)
    .heightIs(35.0f);
    
    //圈子按钮
    
    _circleButton.sd_layout
    .rightSpaceToView(self.toolbar , 15.0f)
    .topSpaceToView(self.toolbar , 7.0f)
    .widthIs(80.0f)
    .heightIs(35.0f);
    
    //位置视图
    
    _locationView.sd_layout
    .bottomSpaceToView(self.toolbar , 0.0f)
    .leftEqualToView(self.toolbar)
    .rightEqualToView(self.toolbar)
    .heightIs(30.0f);
    
    //位置Label
    
    _locationLabel.sd_layout
    .topEqualToView(self.locationView)
    .leftSpaceToView(self.locationView , 15.0f)
    .rightSpaceToView(self.locationView , 15.0f)
    .heightIs(30.0f);
    
    //位置关闭按钮
    
    _locationCloseButton.sd_layout
    .centerYEqualToView(self.locationView)
    .rightSpaceToView(self.locationView , 5.0f)
    .heightRatioToView(self.locationView , 1)
    .widthEqualToHeight();
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    _titleTextView.sd_layout
    .topSpaceToView(self.view , 44.0f + VIEWSAFEAREAINSETS(self.view).top);
    
    _toolbar.sd_layout
    .yIs(self.view.height - 49.0f - VIEWSAFEAREAINSETS(self.view).bottom)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49.0f + VIEWSAFEAREAINSETS(self.view).bottom);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_7);
    
    self.titleTextView.lee_theme
    .LeeConfigBackgroundColor(common_bg_color_7)
    .LeeConfigTextColor(common_font_color_1)
    .LeeAddCustomConfig(DAY , ^(YYTextView *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDefault;
    })
    .LeeAddCustomConfig(NIGHT , ^(YYTextView *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDark;
    });
    
    self.contentTextView.lee_theme
    .LeeConfigBackgroundColor(common_bg_color_7)
    .LeeConfigTextColor(common_font_color_3)
    .LeeAddCustomConfig(DAY , ^(YYTextView *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDefault;
    })
    .LeeAddCustomConfig(NIGHT , ^(YYTextView *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDark;
    });
    
    self.lineView.lee_theme.LeeConfigBackgroundColor(common_bar_divider1);
    
    self.toolbar.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.toolbar.layer.lee_theme.LeeConfigBorderColor(common_bar_divider1);
    
    self.circleButton.lee_theme.LeeConfigButtonTitleColor(common_bg_blue_4 , UIControlStateNormal);
}

#pragma mark - 设置Block

- (void)configBlock{
    
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    // 获取当前位置
    
    [self getCurrentLocation];
    
    // 键盘相关处理
    
    YYTextKeyboardManager *manager = [YYTextKeyboardManager defaultManager];
    
    [manager addObserver:self];
    
    // 获取历史发帖内容
    
    [self getHistoryContent];
}

#pragma mark - 获取当前位置

- (void)getCurrentLocation{
    
    // 初始化定位管理器
    
    _locationManager = [[CLLocationManager alloc] init];
    
    // 设置代理
    
    _locationManager.delegate = self;
    
    // 设置定位精确度到米
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 设置过滤器为无
    
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [_locationManager requestWhenInUseAuthorization];
    
    // 开始定位
    
    [_locationManager startUpdatingLocation];
}

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition{
    
    YYTextKeyboardManager *manager = [YYTextKeyboardManager defaultManager];
    
//    CGRect fromFrame = [manager convertRect:transition.fromFrame toView:self.view];
    CGRect toFrame =  [manager convertRect:transition.toFrame toView:self.view];
//    BOOL fromVisible = transition.fromVisible;
    BOOL toVisible = transition.toVisible;
    NSTimeInterval animationDuration = transition.animationDuration;
    UIViewAnimationCurve curve = transition.animationCurve;
    
    [UIView beginAnimations:@"" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    [UIView setAnimationCurve:curve];
    
    if (self.locationView.hidden) {
        
        self.contentTextView.sd_layout.bottomSpaceToView(self.toolbar , 0.0f);
        
    } else {
        
        self.contentTextView.sd_layout.bottomSpaceToView(self.toolbar , self.locationView.height);
    }
    
    // 适配iPhone X效果
    
    if (toVisible) {
        
        self.toolbar.sd_layout.heightIs(49.0f);
        
    } else {
        
        self.toolbar.sd_layout.heightIs(49.0f + VIEWSAFEAREAINSETS(self.view).bottom);
    }
    
    self.toolbar.sd_layout.yIs(toFrame.origin.y - self.toolbar.height);
    
    [self.contentTextView updateLayout];
    
    [UIView commitAnimations];
}

#pragma mark - 发布事件

- (void)publishAction{
    
    if (self.isPublish) return;
    
    YYTextView *textview;
    
    if (self.titleTextView.isFirstResponder) textview = self.titleTextView;
    
    if (self.contentTextView.isFirstResponder) textview = self.contentTextView;
    
    [textview resignFirstResponder];
    
    // 非空判断
    
    if (!self.titleTextView.text.length) {
        
        [MierProgressHUD showMessage:@"标题别忘咯"];
        
        return;
    }
    
    if (!self.contentTextView.text.length) {
        
        [MierProgressHUD showMessage:@"写点内容吧"];
        
        return;
    }
    
    //限制输入字数
    
    if (self.titleTextView.text.length > 20) {
        
        [MierProgressHUD showMessage:@"标题字数超出限制"];
        
        return;
    }
    
    // 筛选过滤图片
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    NSAttributedString *contentString = self.contentTextView.attributedText;
    
    [contentString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, contentString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value) {
            
            if ([value isKindOfClass:[YYTextAttachment class]]) {
                
                YYTextAttachment *attachment = value;
                
                if ([attachment.content isKindOfClass:[CommunityPostImageView class]]) {
                    
                    CommunityPostImageView *imageView = attachment.content;
                    
                    [imageArray addObject:imageView.image];
                }
                
            }
            
        }
        
    }];
    
    self.isPublish = YES;
    
    // 上传图片
    
    __weak typeof(self) weakSelf = self;
    
    [self uploadImageArray:imageArray Index:0 ProgressBlock:^(NSInteger index) {
        
        if (weakSelf) {
            
            [weakSelf.view showLoading:[NSString stringWithFormat:@"正在上传(%ld/%ld)" , imageArray.count , (index + 1)]];
        }
        
    } CompleteBlock:^(BOOL result) {
        
        if (weakSelf) {
            
            if (result) {
                
                // 发送帖子
                
                [weakSelf sendPost];
                
            } else {
                
                weakSelf.isPublish = NO;
                
                [MierProgressHUD showFailure:@"上传失败 稍后重试"];
            }
            
        }
        
    }];
    
}

#pragma mark - 发送帖子

- (void)sendPost{
    
    [self.view showLoading:@"正在发布"];
    
    NSString *content = [self.contentTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    for (NSString *imageUrl in self.contentImageUrlArray) {
        
        NSRange range = [content rangeOfString:YYTextAttachmentToken];
        
        if (range.location != NSNotFound) {
            
            NSString *imageString = [NSString stringWithFormat:@"<img class=\"image\" src=\"\" data-src=\"%@\"/>" , imageUrl];
            
            content = [content stringByReplacingCharactersInRange:range withString:imageString];
        }
        
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.api sendPostDataWithCircleId:self.circleModel.circleId Title:self.titleTextView.text Content:content Address:self.locationLabel.text Longitude:0.0 Latitude:0.0 ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            strongSelf.isPublish = NO;
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        if (strongSelf.postSuccessBlock) strongSelf.postSuccessBlock();
                        
                        [MierProgressHUD showSuccess:@"发布成功"];
                        
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                        
                        [MierProgressHUD showFailure:responseObject[@"msg"]];
                    }
                    
                    break;
                    
                default:
                    
                    [MierProgressHUD showFailure:@"发布失败 请重试"];
                    
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 上传图片

- (void)uploadImageArray:(NSArray *)array Index:(NSInteger)index ProgressBlock:(void (^)(NSInteger))progressBlock CompleteBlock:(void (^)(BOOL))completeBlock{
    
    if (array.count) {
        
        UIImage *image = array[index];
        
        __weak typeof(self) weakSelf = self;
        
        [self.api uploadImage:image ResultBlock:^(RequestResultType requestResultType, id responseObject) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf) {
                
                if (requestResultType == RequestResultTypeSuccess) {
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        [strongSelf.contentImageUrlArray addObject:responseObject[@"data"][@"fileName"]];
                        
                        if (array.count > index + 1) {
                            
                            if (progressBlock) progressBlock(index);
                            
                            NSInteger currentInex = index + 1;
                            
                            [strongSelf uploadImageArray:array Index:currentInex ProgressBlock:progressBlock CompleteBlock:completeBlock];
                            
                        } else {
                            
                            if (completeBlock) completeBlock(YES);
                        }
                        
                    } else {
                        
                        if (completeBlock) completeBlock(NO);
                    }
                    
                } else {
                    
                    if (completeBlock) completeBlock(NO);
                }
                
            }
            
        }];
        
    } else {
        
        if (completeBlock) completeBlock(YES);
    }
    
}

#pragma mark - 表情按钮事件

- (void)faceButtonAction{
    
    YYTextView *textview;
    
    if (self.titleTextView.isFirstResponder) textview = self.titleTextView;
    
    if (self.contentTextView.isFirstResponder) textview = self.contentTextView;
    
    if (textview.inputView) {
        
        textview.inputView = nil;
        
    } else {
        
        textview.inputView = self.faceView;
    }
    
    //更新输入视图
    
    [textview reloadInputViews];
}

#pragma mark - 相片按钮事件

- (void)photoButtonAction{
    
    YYTextView *textview;
    
    if (self.titleTextView.isFirstResponder) textview = self.titleTextView;
    
    if (self.contentTextView.isFirstResponder) textview = self.contentTextView;
    
    if (textview) [textview resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - 位置按钮事件

- (void)locationButtonAction{
    
    __weak typeof(self) weakSelf = self;
    
    CommunityPostLocationViewController *vc = [[CommunityPostLocationViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.currentLocationBlock = ^(){
        
        if (weakSelf) {
            
            // 获取当前位置
            
            [weakSelf getCurrentLocation];
        }
        
    };
    
    vc.selectedBlock = ^(NSString *province , NSString *city , NSString *area){
        
        if (weakSelf) {
            
            weakSelf.locationView.hidden = NO;
            
            weakSelf.locationLabel.text = [NSString stringWithFormat:@"%@ %@ %@" , province , city , area];
        }
        
    };
    
}

#pragma mark - 位置关闭按钮事件

- (void)locationCloseButtonAction:(UIButton *)sender{
    
    self.locationView.hidden = YES;
    
    self.contentTextView.sd_layout.bottomSpaceToView(self.toolbar , 0.0f);;
    
    [self.contentTextView updateLayout];
    
    // 清空
    
    self.locationLabel.text = @"";
    
    self.longitude = 0.0f;
    
    self.latitude = 0.0f;
}

#pragma mark - 圈子按钮事件

- (void)circleButtonAction{
    
    __weak typeof(self) weakSelf = self;
    
    CommunityCircleListViewController *vc = [[CommunityCircleListViewController alloc] init];
    
    vc.isSelect = YES;
    
    vc.selectedBlock = ^(CommunityCircleModel *model){
        
        if (weakSelf) {
            
            weakSelf.circleModel = model;
            
            [weakSelf.circleButton setTitle:model.circleName forState:UIControlStateNormal];
        }
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 插入图片

- (void)insertImageArray:(NSArray *)imageArray{
    
    __weak typeof(self) weakSelf = self;
    
    YYTextView *textview = self.contentTextView;
    
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithAttributedString:textview.attributedText];
    
    NSMutableAttributedString *contentImageText = [[NSMutableAttributedString alloc] init];
    
    for (UIImage *image in imageArray){
        
        [contentImageText appendString:@"\n"];
        
        NSData *newImageData = UIImageJPEGRepresentation(image, 0.5f);
        
        YYImage *image = [YYImage imageWithData:newImageData];
        
        image.preloadAllAnimatedImageFrames = YES;
        
        CommunityPostImageView *imageView = [[CommunityPostImageView alloc] initWithImage:image];
        
        imageView.frame = CGRectMake(0, 0, textview.width - 30, (textview.width - 30) * (image.size.height / image.size.width));
        
        imageView.deleteBlock = ^(id deleteImageView){
            
            if (weakSelf) [weakSelf removeImage:deleteImageView];
        };
        
        NSMutableAttributedString *attachment = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleToFill attachmentSize:imageView.size alignToFont:[textview font] alignment:YYTextVerticalAlignmentCenter];
        
        attachment.lineSpacing = 8.0f;
        
        [contentImageText appendAttributedString:attachment];
        
        [contentImageText appendString:@"\n"];
    }
    
    [contentText insertAttributedString:contentImageText atIndex:textview.selectedRange.location];
    
    contentText.font = [UIFont systemFontOfSize:16.0f];
    
    contentText.color = LEEColorFromIdentifier([LEETheme currentThemeTag], common_font_color_3);
    
    contentText.lineSpacing = 8.0f;
    
    textview.attributedText = contentText;
}

#pragma mark - 移除图片

- (void)removeImage:(UIImageView *)imageView{
    
    __weak typeof(self) weakSelf = self;
    
    NSAttributedString *contentString = self.contentTextView.attributedText;
    
    [contentString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, contentString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (weakSelf) {
            
            if (value) {
                
                if ([value isKindOfClass:[YYTextAttachment class]]) {
                    
                    YYTextAttachment *attachment = value;
                    
                    if ([attachment.content isKindOfClass:[CommunityPostImageView class]]) {
                        
                        // 判断是否为要移除的图片视图对象
                        
                        if (imageView == attachment.content) {
                            
                            NSMutableAttributedString *currentContentString = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.contentTextView.attributedText];
                            
                            NSInteger location = range.location;
                            
                            NSInteger length = range.length;
                            
                            // 判断图片前后换行
                            
                            // 前面换行符
                            
                            if (location) {
                                
                                NSRange frontNewlinesRange = NSMakeRange(range.location - 1, 1);
                                
                                if ([[currentContentString attributedSubstringFromRange:frontNewlinesRange].string isEqualToString:@"\n"]) {
                                    
                                    location = frontNewlinesRange.location;
                                    
                                    length += frontNewlinesRange.length;
                                }
                                
                            }
                            
                            // 后面换行符
                            
                            if (currentContentString.length - location > length) {
                                
                                NSRange backNewlinesRange = NSMakeRange(range.location + range.length, 1);
                                
                                if ([[currentContentString attributedSubstringFromRange:backNewlinesRange].string isEqualToString:@"\n"]) {
                                    
                                    length += backNewlinesRange.length;
                                }
                                
                            }
                            
                            [currentContentString deleteCharactersInRange:NSMakeRange(location, length)];
                            
                            weakSelf.contentTextView.attributedText = currentContentString;
                            
                            weakSelf.contentTextView.selectedRange = NSMakeRange(weakSelf.contentTextView.attributedText.string.length, 0);
                            
                            [weakSelf.contentTextView scrollRangeToVisible:NSMakeRange(location, 0)];
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }];
    
}

#pragma mark - 获取图片数量

- (NSInteger)getImageCount{
    
    __block NSInteger count = 0;
    
    __weak typeof(self) weakSelf = self;
    
    NSAttributedString *contentString = self.contentTextView.attributedText;
    
    [contentString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, contentString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (weakSelf) {
            
            if (value) {
                
                if ([value isKindOfClass:[YYTextAttachment class]]) {
                    
                    YYTextAttachment *attachment = value;
                    
                    if ([attachment.content isKindOfClass:[CommunityPostImageView class]]) {
                        
                        count ++;
                    }
                    
                }
                
            }
            
        }
        
    }];
    
    return count;
}

#pragma mark - 保存内容

- (void)saveContent{
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    if (self.titleTextView.attributedText.length) {
        
        [info setObject:self.titleTextView.text forKey:@"title"];
    }
    
    if (self.contentTextView.attributedText.length) {
        
        __weak typeof(self) weakSelf = self;
        
        NSMutableArray *imageArray = [NSMutableArray array];
        
        NSAttributedString *contentString = self.contentTextView.attributedText;
        
        [contentString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, contentString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            
            if (weakSelf) {
                
                if (value) {
                    
                    if ([value isKindOfClass:[YYTextAttachment class]]) {
                        
                        YYTextAttachment *attachment = value;
                        
                        if ([attachment.content isKindOfClass:[CommunityPostImageView class]]) {
                            
                            CommunityPostImageView *imageView = attachment.content;
                            
                            [imageArray addObject:[imageView.image imageDataRepresentation]];
                        }
                        
                    }
                    
                }
                
            }
            
        }];
        
        [info setObject:imageArray forKey:@"contentImage"];
        
        [info setObject:self.contentTextView.text forKey:@"content"];
        
        [info setObject:[NSDate date] forKey:@"time"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:HISTORYPOSTCONTENT];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取历史内容

- (void)getHistoryContent{
    
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYPOSTCONTENT];
    
    if (info) {
        
        NSString *titleString = [info objectForKey:@"title"];
        
        if (titleString) {
            
            self.titleTextView.text = titleString;
        }
        
        NSString *contentString = [info objectForKey:@"content"];
        
        if (contentString) {
            
            __weak typeof(self) weakSelf = self;
            
            NSArray *imageArray = [info objectForKey:@"contentImage"];
            
            // 处理图片占位字符
            
            for (NSInteger i = 0 ; i < imageArray.count ; i++) {
                
                NSRange range = [contentString rangeOfString:YYTextAttachmentToken];
                
                if (range.length) {
                    
                    contentString = [contentString stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"<image%ld>" , i]];
                }
                
            }
            
            NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:contentString];
            
            for (NSInteger i = 0 ; i < imageArray.count ; i++){
                
                YYImage *image = [YYImage imageWithData:imageArray[i]];
                
                image.preloadAllAnimatedImageFrames = YES;
                
                CommunityPostImageView *imageView = [[CommunityPostImageView alloc] initWithImage:image];
                
                imageView.frame = CGRectMake(0, 0, self.view.width - 30, (self.view.width - 30) * (image.size.height / image.size.width));
                
                imageView.deleteBlock = ^(id deleteImageView){
                    
                    if (weakSelf) [weakSelf removeImage:deleteImageView];
                };
                
                NSMutableAttributedString *attachment = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleToFill attachmentSize:imageView.size alignToFont:[self.contentTextView font] alignment:YYTextVerticalAlignmentCenter];
                
                attachment.lineSpacing = 8.0f;
                
                NSRange range = [contentText.string rangeOfString:[NSString stringWithFormat:@"<image%ld>" , i]];
                
                if (range.length) [contentText replaceCharactersInRange:range withAttributedString:attachment];
            }
            
            contentText.font = [UIFont systemFontOfSize:16.0f];
            
            contentText.color = LEEColorFromIdentifier([LEETheme currentThemeTag], common_font_color_3);
            
            contentText.lineSpacing = 8.0f;
            
            self.contentTextView.attributedText = contentText;
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:HISTORYPOSTCONTENT];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YYTextViewDelegate

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView{
    
    //标题视图
    
    if (textView == self.titleTextView) {
        
        //判断是否超过指定行数
        
        if (textView.textLayout.rowCount < 3) {
            
            //添加动画
            
            [UIView beginAnimations:@"" context:nil];
            
            [UIView setAnimationDuration:0.25f];
            
            //如果内容高度大于默认高度 则改变高度
            
            if (textView.textLayout.rowCount > 1) {
                
                textView.sd_layout.heightIs(textView.contentSize.height);
                
            } else {
                
                textView.sd_layout.heightIs(45.0f);
            }
            
            //更新相关视图
            
            [UIView commitAnimations];
            
            textView.scrollEnabled = NO;
            
        } else {
            
            textView.scrollEnabled = YES;
        }
        
        //判断文本视图内容是否不为空
        
        if (textView.text.length > 0) {
            
            [self.faceView deleteButtonEnable:YES];
            
        } else {
            
            [self.faceView deleteButtonEnable:NO];
        }
        
    }
    
    //内容视图
    
    if (textView == self.contentTextView) {
        
        //判断文本视图内容是否不为空
        
        if (textView.text.length > 0) {
            
            [self.faceView deleteButtonEnable:YES];
            
        } else {
            
            [self.faceView deleteButtonEnable:NO];
        }
        
    }
    
}

#pragma mark - ActionView delegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    switch (buttonIndex) {
            
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
                
                //设置拍照后的图片可被编辑
                
                picker.allowsEditing = YES;
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            
            picker.delegate = self;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        case 1:
        {
            
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - [self getImageCount] delegate:self];
            
            imagePickerVC.navigationBar.barTintColor = LEEColorFromIdentifier([LEETheme currentThemeTag], common_bg_blue_4);
            
            imagePickerVC.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            
            imagePickerVC.oKButtonTitleColorNormal = LEEColorFromIdentifier([LEETheme currentThemeTag], common_bg_blue_4);
            
            imagePickerVC.allowPickingVideo = NO;
            
            imagePickerVC.allowPickingOriginalPhoto = NO;
            
            imagePickerVC.pickerDelegate = self;
            
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    NSData *newImageData = UIImageJPEGRepresentation(image, 0.1f);
    
    //    UIImage *newImage = [UIImage imageWithData:newImageData];
    
    // 插入图片
    
    [self insertImageArray:@[image]];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    // 插入图片
    
    [self insertImageArray:photos];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                [manager requestWhenInUseAuthorization];
            }
            
            break;
            
        case kCLAuthorizationStatusDenied:
            
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                [LEEAlert alert].config
                .LeeTitle(@"您的位置功能尚未开启\n需要您前往设置中开启")
                .LeeContent(@"开启后可获取您的当前位置")
                .LeeAction(@"去打开" , ^{
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    
                    [manager requestWhenInUseAuthorization];
                })
                .LeeCancelAction(@"算了" , nil)
                .LeeShow();
            }
            
            break;
            
        default:
            break;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    // 获取经纬度
    
    self.longitude = newLocation.coordinate.longitude;
    
    self.latitude = newLocation.coordinate.latitude;
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0){
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //将获得的所有信息显示到label上
            
            NSLog(@"%@" , placemark.name);
            
            //获取城市
            
            NSString *city = placemark.locality;
            
            if (!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                
                city = placemark.administrativeArea;
            }
            
            self.locationView.hidden = NO;
            
            self.locationLabel.text = [NSString stringWithFormat:@"%@ %@ %@" , placemark.administrativeArea , city , placemark.subLocality];
            
        } else if (error == nil && [array count] == 0) {
            
            NSLog(@"No results were returned.");
            
        } else if (error != nil) {
            
            NSLog(@"An error occurred = %@", error);
        }
        
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
}

#pragma mark - LazyLoading

- (CommunityPostAPI *)api{
    
    if (!_api) {
        
        _api = [[CommunityPostAPI alloc] init];
    }
    
    return _api;
}

- (MierFaceInputView *)faceView{
    
    if (!_faceView) {
        
        _faceView = [[MierFaceInputView alloc] initWithFrame:CGRectMake(0 , self.view.height , self.view.width , 220) InfoDic:nil MaxLineNumber:3 MaxSingleCount:5];
        
        [_faceView deleteButtonEnable:NO]; //默认不启用
        
        _faceView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
        
        __weak typeof(self) weakSelf = self;
        
        _faceView.selectedFaceBlock = ^(NSString *faceName){
            
            if (weakSelf) {
                
                //插入表情字符
                
                YYTextView *textview;
                
                if (weakSelf.titleTextView.isFirstResponder) textview = weakSelf.titleTextView;
                
                if (weakSelf.contentTextView.isFirstResponder) textview = weakSelf.contentTextView;
                
                [textview insertText:faceName];
            }
            
        };
        
        _faceView.deleteBlock = ^(){
            
            if (weakSelf) {
                
                //删除
                
                YYTextView *textview;
                
                if (weakSelf.titleTextView.isFirstResponder) textview = weakSelf.titleTextView;
                
                if (weakSelf.contentTextView.isFirstResponder) textview = weakSelf.contentTextView;
                
                [textview deleteBackward];
            }
            
        };
        
    }
    
    return _faceView;
}

@end
