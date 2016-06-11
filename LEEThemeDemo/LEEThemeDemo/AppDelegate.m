//
//  AppDelegate.m
//  LEEThemeDemo
//
//  Created by 李响 on 16/4/22.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "TableViewController.h"

#import "LEETheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark ---获取document路径

- (NSString *)documentPath{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return array.firstObject;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *json = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_red_json.json"] encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigJson:json WithTag:RED WithResourcesPath:nil];
    
    NSString *json2 = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_blue_json.json"] encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigJson:json2 WithTag:BLUE WithResourcesPath:nil];
    
    NSString *json3 = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_gray_json.json"] encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigJson:json3 WithTag:GRAY WithResourcesPath:nil];
    
    //延迟5秒添加主题 , 模拟动态添加主题功能
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *json4 = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_green_json.json"] encoding:NSUTF8StringEncoding error:nil];
        
        [LEETheme addThemeConfigJson:json4 WithTag:GREEN WithResourcesPath:[self documentPath]];

    });

    //设置默认主题
    
    [LEETheme defaultTheme:RED];
    
    //初始化window
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    ViewController *systemVC = [[ViewController alloc] init];
    
    systemVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"视图" image:[UIImage imageNamed:@""] tag:0];
    
    [tabBarController addChildViewController:systemVC];
    
    UINavigationController *tableNC = [[UINavigationController alloc] initWithRootViewController:[[TableViewController alloc] init]];
    
    tableNC.navigationBar.lee_theme.LeeConfigTintColor(@"ident1");
    
//    tableNC.navigationBar.lee_theme
//    .LeeAddBarTintColor(RED , [UIColor redColor])
//    .LeeAddBarTintColor(BLUE , [UIColor blueColor])
//    .LeeAddBarTintColor(GRAY , [UIColor grayColor]);
    
    tableNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"列表" image:[UIImage imageNamed:@""] tag:1];
    
    [tabBarController addChildViewController:tableNC];
    
//    tabBarController.tabBar.translucent = NO;
    
//    tabBarController.tabBar.lee_theme
//    .LeeAddBarTintColor(RED , [UIColor redColor])
//    .LeeAddBarTintColor(BLUE , [UIColor blueColor])
//    .LeeAddBarTintColor(GRAY , [UIColor grayColor]);
    
//    tabBarController.tabBar.lee_theme
//    .LeeAddBackgroundImage(RED , [UIImage imageNamed:@"huajis.jpg"])
//    .LeeAddBackgroundImage(BLUE , [UIImage imageNamed:@"huaji.jpg"])
//    .LeeAddBackgroundImage(GRAY , [UIImage imageNamed:@"picImage.jpg"]);
    
    self.window.rootViewController = tabBarController;
    
    //模拟沙盒图片
    
    UIImage *testImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"]];
    
    NSData *imageData = UIImagePNGRepresentation(testImage);
    
    [imageData writeToFile:[[self documentPath] stringByAppendingPathComponent:@"test.png"] atomically:YES];
    
    return YES;
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
