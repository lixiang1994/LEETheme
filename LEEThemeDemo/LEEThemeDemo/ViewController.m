//
//  ViewController.m
//  LEEThemeDemo
//
//  Created by 李响 on 16/4/22.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "ViewController.h"

#import "MBProgressHUD.h"

@interface ViewController ()<UIScrollViewDelegate>

/**
 红色主题标签
 */
@property (nonatomic , copy ) NSString *redTag;

@property (nonatomic , strong ) UIScrollView *scrollView;

@end

@implementation ViewController

/**
 
 该视图主要为了演示各个控件对象以及自定义对象如何进行主题设置, 并同时模拟了新增主题的使用方法.
 目前为某一对象进行设置的方式为两种, 下面都有演示, 两种方式也支持同时使用.
 下面所用的控件对象都使用默认方式设置了两种主题的样式 (DAY 和 NIGHT), 并使用JSON方式设置了标识符 用于新增主题的演示 (red).
 除了这些 下面还演示了如何添加自定义方法的设置 并且输出log打印调用结果等.
 
 注: 红色主题仅在本页面演示使用 , 除本页面外仅提供DAY和NIGHT两种主题
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _redTag = @"red";
    
    // 检查红色主题
    
    [self checkRedTheme];
    
    // 初始化数据
    
    [self initData];
    
    // 初始化子视图
    
    [self initSubviews];
    
    // 设置主题样式
    
    [self configTheme];
}

#pragma mark - 初始化数据

- (void)initData{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 初始化子视图

- (void)initSubviews{
    
    CGFloat centerX = CGRectGetWidth(self.view.frame) / 2;
    
    // 滑动视图
    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);

    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    // view
    
    UIView *view = [[UIView alloc] init];
    
    view.frame = CGRectMake(0, 10, 120, 100);
    
    view.center = CGPointMake(centerX, view.center.y);
    
    view.clipsToBounds = YES;
    
    view.layer.borderWidth = 0.5f;
    
    view.layer.cornerRadius = 5.0f;
    
    [self.scrollView addSubview:view];
    
    
    view.lee_theme
    .LeeAddBackgroundColor(DAY, LEEColorRGB(200, 200, 200))
    .LeeAddBackgroundColor(NIGHT, LEEColorRGB(40, 40, 40))
    .LeeConfigBackgroundColor(@"ident1")
    .LeeAddCustomConfig(DAY, ^(UIView *item) {
        
        item.alpha = 1.0f;
    })
    .LeeAddCustomConfig(NIGHT, ^(UIView *item) {
        
        item.alpha = 1.0f;
    })
    .LeeCustomConfig(@"ident5", ^(UIView *item, id value) {
        
        item.alpha = [value floatValue];
    });
    
    view.layer.lee_theme
    .LeeAddBorderColor(DAY, LEEColorRGB(160, 160, 160))
    .LeeAddBorderColor(NIGHT, LEEColorRGB(70, 70, 70))
    .LeeConfigBorderColor(@"ident2");
    
    // label
    
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(0, 130, 200, 30);
    
    label.center = CGPointMake(centerX, label.center.y);
    
    label.text = @"这是一个Label";
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.scrollView addSubview:label];
    
    
    label.lee_theme
    .LeeAddTextColor(DAY, LEEColorRGB(0, 0, 0))
    .LeeAddTextColor(NIGHT, LEEColorRGB(200, 200, 200))
    .LeeConfigTextColor(@"ident1");
    
    
    // button
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 180, 200, 40.0f);
    
    button.center = CGPointMake(centerX, button.center.y);
    
    [button setTitle:@"这是一个按钮" forState:UIControlStateNormal];
    
    [button setTitle:@"点击了这个按钮" forState:UIControlStateHighlighted];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    [button.layer setBorderWidth:0.5f];
    
    [button.layer setCornerRadius:5.0f];
    
    [self.scrollView addSubview:button];
    
    
    button.lee_theme
    .LeeAddButtonTitleColor(DAY, LEEColorRGB(0, 0, 0), UIControlStateNormal)
    .LeeAddButtonTitleColor(NIGHT, LEEColorRGB(200, 200, 200), UIControlStateNormal)
    .LeeConfigButtonTitleColor(@"ident1", UIControlStateNormal)
    .LeeAddButtonImage(DAY, [UIImage imageNamed:@"true_day"], UIControlStateNormal)
    .LeeAddButtonImage(NIGHT, [UIImage imageNamed:@"true_night"], UIControlStateNormal)
    .LeeConfigButtonImage(@"ident4", UIControlStateNormal);
    
    button.layer.lee_theme
    .LeeAddBorderColor(DAY, LEEColorRGB(160, 160, 160))
    .LeeAddBorderColor(NIGHT, LEEColorRGB(70, 70, 70))
    .LeeConfigBorderColor(@"ident2");
    
    
    // imageView
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.frame = CGRectMake(0, 240, 120, 120);
    
    imageView.center = CGPointMake(centerX, imageView.center.y);
    
    [self.scrollView addSubview:imageView];
    
    
    imageView.lee_theme
    .LeeAddImage(DAY, @"image_day")
    .LeeAddImage(NIGHT, @"image_night")
    .LeeConfigImage(@"ident3");
    
    
    // slider
    
    UISlider *slider = [[UISlider alloc] init];
    
    slider.frame = CGRectMake(0, 380, 200, 40.0f);
    
    slider.center = CGPointMake(centerX, slider.center.y);
    
    slider.value = 0.4f;
    
    [self.scrollView addSubview:slider];
    
    
    slider.lee_theme
    .LeeAddSelectorAndColor(DAY, @selector(setMinimumTrackTintColor:), LEEColorRGB(33, 151, 216))
    .LeeAddSelectorAndColor(NIGHT, @selector(setMinimumTrackTintColor:), LEEColorRGB(28, 124, 177))
    .LeeConfigKeyPathAndIdentifier(@"minimumTrackTintColor", @"ident1");
    //.LeeConfigSelectorAndIdentifier(@selector(setMinimumTrackTintColor:), @"ident1");
 
    
    // switch
    
    UISwitch *switchItem = [[UISwitch alloc] initWithFrame:CGRectMake(0, 440, 120, 40.0f)];
    
    switchItem.center = CGPointMake(centerX, switchItem.center.y);
    
    [self.scrollView addSubview:switchItem];
    
    
    switchItem.lee_theme
    .LeeAddOnTintColor(DAY, LEEColorRGB(33, 151, 216))
    .LeeAddOnTintColor(NIGHT, LEEColorRGB(28, 124, 177))
    .LeeConfigOnTintColor(@"ident1");
    
    
    // textfield
    
    UITextField *textfield = [[UITextField alloc] init];
    
    textfield.frame = CGRectMake(0, 440, 200, 40.0f);
    
    textfield.center = CGPointMake(centerX, textfield.center.y);
    
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    
    textfield.placeholder = @"这是一个输入框";
    
    [self.scrollView addSubview:textfield];
    
    
    textfield.lee_theme
    .LeeAddBackgroundColor(DAY, LEEColorRGB(255, 255, 255))
    .LeeAddBackgroundColor(NIGHT, LEEColorRGB(30, 30, 30))
    .LeeAddTextColor(DAY, LEEColorRGB(0, 0, 0))
    .LeeAddTextColor(NIGHT, LEEColorRGB(200, 200, 200))
    .LeeConfigTextColor(@"ident1")
    .LeeAddPlaceholderColor(DAY, LEEColorRGB(200, 200, 200))
    .LeeAddPlaceholderColor(NIGHT, LEEColorRGB(80, 80, 80))
    .LeeConfigPlaceholderColor(@"ident2");
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 500)];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBackgroundColor(NIGHT , LEEColorRGB(55, 55, 55));
    
    // 添加方法选择器以及参数测试 可为对象添加其自定义的方法设置 并传入指定的参数
    
    self.lee_theme
    .LeeAddSelectorAndValues(DAY , @selector(test:), [UIColor whiteColor] , nil)
    .LeeAddSelectorAndValues(NIGHT, @selector(test:), [UIColor blackColor] , nil);
}

- (void)test:(CGColorRef)color{
    
    // 测试方法的参数类型为 CGColor , 上面设置时参数传入的为UIColor对象 , 但调用时会自动转换为CGColor类型 , CGImage也同样支持 , 如遇到不支持的类型可提Issues , 我会及时补充.
    
    NSLog(@"自定义方法测试 %@" , color);
}

#pragma mark - 检查红色主题

- (void)checkRedTheme{
    
    if ([[LEETheme allThemeTag] containsObject:self.redTag]) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"启用红色主题" style:UIBarButtonItemStyleDone target:self action:@selector(startRedItemAction)];
        
        self.navigationItem.rightBarButtonItem = item;
        
    } else {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下载红色主题" style:UIBarButtonItemStyleDone target:self action:@selector(downloadRedItemAction)];
        
        self.navigationItem.rightBarButtonItem = item;
    }
    
}

#pragma mark - 下载红色主题点击事件

- (void)downloadRedItemAction{
    
    // 预备唱! 大菊花吱呀吱溜溜的转..这里的风景呀真好看..天好看 地好看..还有一群快乐的小伙伴
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [hud setFrame:self.view.bounds];
    
    [hud setDetailsLabelText:@"下载主题中..."];
    
    [hud setRemoveFromSuperViewOnHide:YES];
    
    [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:16.0f]];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [self.view addSubview:hud];
    
    [hud show:YES];
    
    // 模拟下载新的主题配置
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        hud.mode = MBProgressHUDModeText;
        
        [hud setDetailsLabelText:@"红色主题下载完成!"];
        
        [hud hide:YES afterDelay:2.0f];
        
        // 假装得到了请求的配置json数据
        
        NSString *redJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_red_json" ofType:@"json"];
        
        NSString *redJson = [NSString stringWithContentsOfFile:redJsonPath encoding:NSUTF8StringEncoding error:nil];
        
        // 假装下载图片资源 并缓存到沙盒的指定目录下 (建议路径 XXXX/主题资源文件夹/主题名字文件夹/)
        
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *themePath = [documentsPath stringByAppendingPathComponent:@"theme_resources"];
        
        NSString *path = [themePath stringByAppendingPathComponent:self.redTag];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 下载的图片资源建议让服务器根据当前的设备型号去给予 2x 或 3x的图片, 不建议2x,3x一起给, 这样可以减少将近一半的大小, 自己体会.
        
        NSArray *imageNameArray = @[@"image_red@2x.png" , @"image_red@3x.png" , @"true_red@2x.png" , @"true_red@3x.png"];
        
        for (NSString *imageName in imageNameArray) {
            
            UIImage *image = [UIImage imageNamed:imageName];
            
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [imageData writeToFile:[path stringByAppendingPathComponent:imageName] atomically:YES];
        }
        
        // 添加假装得到的的配置json数据 (添加后LEETheme会自动存储 无需下一次运行时再添加 当然同样的主题添加再多次也无所谓)
        
        [LEETheme addThemeConfigWithJson:redJson Tag:self.redTag ResourcesPath:path];
        
        // 检查红色主题
        
        [self checkRedTheme];
    });
    
}

#pragma mark - 启用红色主题点击事件

- (void)startRedItemAction{
    
    // 启用新的主题
    
    [LEETheme startTheme:self.redTag];
}

#pragma mark - 单击手势事件

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)tap{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 键盘通知事件

- (void)keyboardWillShow:(NSNotification *)notify{
    
    NSDictionary *info = [notify userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯
    
    //double duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
    //获取第一响应者视图
    
    UIView *firstResponderView = [self findFirstResponder:self.scrollView];
    
    if (firstResponderView) {
        
        //将第一响应者视图移动到可显示区域
        
        [self.scrollView scrollRectToVisible:firstResponderView.frame animated:YES];
    }

}

- (void)keyboardWillHidden:(NSNotification *)notify{
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 查找第一响应者

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
