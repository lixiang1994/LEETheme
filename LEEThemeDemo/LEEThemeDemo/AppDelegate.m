//
//  AppDelegate.m
//  LEEThemeDemo
//
//  Created by 李响 on 16/4/22.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarController.h"

#import "LEEBubble.h"

#import "LEETheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 获取document路径

- (NSString *)documentPath{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return array.firstObject;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置主题
    
    [self configTheme];
    
    // 初始化window
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[TabBarController alloc] init];
    
    // 初始化气泡
    
    LEEBubble *bubble = [[LEEBubble alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.window.frame) - 58, CGRectGetHeight(self.window.frame) - 123, 48, 48)];
    
    bubble.edgeInsets = UIEdgeInsetsMake(64, 0 , 0 , 0);
    
    [self.window addSubview:bubble];
    
    bubble.lee_theme
    .LeeThemeChangingBlock(^(NSString *tag, LEEBubble * item) {
        
        if ([tag isEqualToString:DAY]) {
            
            item.image = [UIImage imageNamed:@"night"];
            
        } else if ([tag isEqualToString:NIGHT]) {
            
            item.image = [UIImage imageNamed:@"day"];
        
        } else {
            
            item.image = [UIImage imageNamed:@"day"];
        }
        
    });
    
    __weak typeof(self) weakSelf = self;
    
    bubble.clickBubbleBlock = ^(){
        
        if (weakSelf){
            
            /*  这是一种巧妙的方法 良好的过渡效果可以很好地提高体验 可以根据你的使用场景来进行尝试
                
                关于文字颜色改变时增加过渡的动画效果这点很不好处理, 如果增加动画处理 那么最终导致切换主题时文字颜色与其他颜色或图片不能很好地统一过渡, 效果上总会有些不自然.
                原理: 切换主题前 获取当前window的截图 并覆盖到window上 > 执行主题切换 > 将覆盖的截图通过动画隐藏 显示出切换完成的真实画面.
                场景: 比较适用于阅读类APP切换日夜间主题场景.
                优点: 过渡效果自然统一, 可根据自行调整不同的动画效果等.
                缺点: 如果当前显示的内容不处于静止状态 那么会产生一种残影的感觉, 例如 列表滑动时切换
                总结: 可以根据你的使用场景来进行尝试, 一切只为了更好的体验 但也无需强求.
             */
            
            // 覆盖截图
            
            UIView *tempView = [weakSelf.window snapshotViewAfterScreenUpdates:NO];
            
            [weakSelf.window addSubview:tempView];
            
            // 切换主题
            
            if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
                
                [LEETheme startTheme:NIGHT];
                
            } else {
                
                [LEETheme startTheme:DAY];
            }
            
            // 增加动画 移除覆盖
            
            [UIView animateWithDuration:1.0f animations:^{
                
                tempView.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                
                [tempView removeFromSuperview];
            }];
            
        }
        
    };
    
    return YES;
}

#pragma mark - 设置主题

- (void)configTheme{
    
    NSString *dayJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_day" ofType:@"json"];
    
    NSString *nightJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_night" ofType:@"json"];
    
    NSString *dayJson = [NSString stringWithContentsOfFile:dayJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *nightJson = [NSString stringWithContentsOfFile:nightJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    
    [LEETheme defaultTheme:DAY];
    
//    [LEETheme defaultChangeThemeAnimationDuration:0.0f];
    
    [LEETheme addThemeConfigWithJson:dayJson Tag:DAY ResourcesPath:nil];
    
    [LEETheme addThemeConfigWithJson:nightJson Tag:NIGHT ResourcesPath:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
