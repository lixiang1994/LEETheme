//
//  NewThemeTableViewController.m
//  LEEThemeDemo
//
//  Created by 李响 on 2017/6/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewThemeTableViewController.h"

#import "NewThemeTableViewCell.h"

#import "MBProgressHUD.h"

@interface NewThemeTableViewController ()

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation NewThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    
    [self initData];
    
    // 设置主题样式
    
    [self configTheme];
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.navigationItem.title = @"新主题列表";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = item;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _dataArray = [NSMutableArray array];
    
    [_dataArray addObject:@{@"tag" : @"red" , @"title" : @"红色" , @"color" : LEEColorRGB(194, 43, 79)}];
    
    [_dataArray addObject:@{@"tag" : @"blue" , @"title" : @"蓝色" , @"color" : LEEColorRGB(93, 178, 212)}];
    
    [_dataArray addObject:@{@"tag" : @"green" , @"title" : @"绿色" , @"color" : LEEColorRGB(136, 190, 106)}];
    
    [_dataArray addObject:@{@"tag" : @"gray" , @"title" : @"紫色" , @"color" : LEEColorRGB(147, 114, 176)}];
    
    [self.tableView registerClass:[NewThemeTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.navigationItem.leftBarButtonItem.lee_theme
    .LeeAddTintColor(DAY, [UIColor blackColor])
    .LeeAddTintColor(NIGHT, [UIColor whiteColor])
    .LeeConfigTintColor(@"ident7");
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBackgroundColor(NIGHT , LEEColorRGB(55, 55, 55))
    .LeeConfigBackgroundColor(@"ident7");
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY , LEEColorRGB(187, 187, 187))
    .LeeAddSeparatorColor(NIGHT , LEEColorRGB(119, 119, 119));
    
    self.tableView.lee_theme.LeeThemeChangingBlock(^(NSString *tag, UITableView *item) {
       
        // 检查显示的cell的主题状态
        
        for (NewThemeTableViewCell *cell in item.visibleCells) {
            
            [cell checkThemeState];
        }
        
    });
    
}

#pragma mark - 返回事件

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下载主题

- (void)downloadThemeWithTag:(NSString *)tag CompleteBlock:(void (^)())completeBlock{
    
    // 预备唱! 大菊花吱呀吱溜溜的转..这里的风景呀真好看..天好看 地好看..还有一群快乐的小伙伴
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [hud setFrame:self.view.bounds];
    
    [hud setDetailsLabelText:@"下载主题中..."];
    
    [hud setRemoveFromSuperViewOnHide:YES];
    
    [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:16.0f]];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [self.view addSubview:hud];
    
    [hud show:YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 模拟下载新的主题配置
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        hud.mode = MBProgressHUDModeText;
        
        [hud setDetailsLabelText:@"下载完成!"];
        
        [hud hide:YES afterDelay:2.0f];
        
        // 假装得到了请求的配置json数据
        
        NSString *redJsonPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tag_%@_json" , tag] ofType:@"json"];
        
        NSString *redJson = [NSString stringWithContentsOfFile:redJsonPath encoding:NSUTF8StringEncoding error:nil];
        
        // 假装下载图片资源 并缓存到沙盒的指定目录下 (建议路径 XXXX/主题资源文件夹/主题名字文件夹/)
        
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *themePath = [@"theme_resources" stringByAppendingPathComponent:tag];
        
        NSString *path = [documentsPath stringByAppendingPathComponent:themePath];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 下载的图片资源建议让服务器根据当前的设备型号去给予 2x 或 3x的图片, 不建议2x,3x一起给, 这样可以减少将近一半的大小, 自己体会.
        
        // demo工程内图片名称数组
        
        NSArray *imageNameArray = @[[NSString stringWithFormat:@"image_%@@2x.png" , tag] ,
                                    [NSString stringWithFormat:@"image_%@@3x.png" , tag] ,
                                    [NSString stringWithFormat:@"true_%@@2x.png" , tag] ,
                                    [NSString stringWithFormat:@"true_%@@3x.png" , tag]];
        
        // 要存储的沙盒中的图片名称
        
        NSArray *imageNames = @[@"image@2x.png" , @"image@3x.png" , @"true@2x.png" , @"true@3x.png"];
        
        [imageNameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImage *image = [UIImage imageNamed:name];
            
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [imageData writeToFile:[path stringByAppendingPathComponent:imageNames[idx]] atomically:YES];
        }];
        
        // 添加假装得到的的配置json数据 (添加后会自动存储 无需下一次运行时再添加 当然同样的主题添加再多次也无所谓 值得注意的是ResourcesPath参数传入的是资源路径字符串 其中不包括Documents目录的路径 仅仅为Documents目录之后的路径. 如果资源在mainBundle中 则传入nil)
        
        [LEETheme addThemeConfigWithJson:redJson Tag:tag ResourcesPath:themePath];
        
        // 调用完成Block
        
        if (completeBlock) completeBlock();
    });
    
}

#pragma mark - 移除主题

- (void)removeThemeWithTag:(NSString *)tag{
    
    // 移除新的主题配置
    
    [LEETheme removeThemeConfigWithTag:tag];
    
    // 移除图片资源
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *themePath = [documentsPath stringByAppendingPathComponent:@"theme_resources"];
    
    NSString *path = [themePath stringByAppendingPathComponent:tag];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    NewThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.info = self.dataArray[indexPath.row];
    
    cell.clickBlock = ^(NewThemeTableViewCell *weakCell, NewThemeState state) {
      
        if (!weakSelf) return ;
        
        NSString *tag = weakCell.info[@"tag"];
        
        switch (state) {
                
            case NewThemeStateDownload:
            {
                [weakSelf downloadThemeWithTag:tag CompleteBlock:^{
                    
                    // 更新状态
                    
                    [weakCell checkThemeState];
                }];
            }
                break;
                
            case NewThemeStateStart:
            {
                [LEETheme startTheme:tag];
            }
                break;
                
            case NewThemeStateRemove:
            {
                [weakSelf removeThemeWithTag:tag];
                
                // 更新状态
                
                [weakCell checkThemeState];
            }
                break;
                
            default:
                break;
        }
        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
