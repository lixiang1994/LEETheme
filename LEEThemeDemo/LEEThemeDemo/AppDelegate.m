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
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    ViewController *systemVC = [[ViewController alloc] init];
    
    systemVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"视图" image:[UIImage imageNamed:@""] tag:0];
    
    [tabBarController addChildViewController:systemVC];
    
    UINavigationController *tableNC = [[UINavigationController alloc] initWithRootViewController:[[TableViewController alloc] init]];
    
    tableNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"列表" image:[UIImage imageNamed:@""] tag:1];
    
    [tabBarController addChildViewController:tableNC];
    
    self.window.rootViewController = tabBarController;
    
    // 设置主题
    
    tableNC.navigationBar.lee_theme
    .LeeAddBarTintColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBarTintColor(NIGHT , LEEColorRGB(85, 85, 85))
    .LeeAddCustomConfig(DAY , ^(UINavigationBar *item){
        
        item.barStyle = UIBarStyleDefault;
    })
    .LeeAddCustomConfig(NIGHT , ^(UINavigationBar *item){
        
        item.barStyle = UIBarStyleBlack;
    });
    
    
    tabBarController.tabBar.lee_theme
    .LeeAddBarTintColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBarTintColor(NIGHT , LEEColorRGB(85, 85, 85));
    
    return YES;
}

#pragma mark - 设置主题

- (void)configTheme{
    
    NSString *dayJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_day" ofType:@"json"];
    
    NSString *nightJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_night" ofType:@"json"];
    
    NSString *dayJson = [NSString stringWithContentsOfFile:dayJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *nightJson = [NSString stringWithContentsOfFile:nightJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    
    [LEETheme defaultTheme:DAY];
    
    [LEETheme defaultChangeThemeAnimationDuration:0.1f];
    
    [LEETheme addThemeConfigJson:dayJson WithTag:DAY WithResourcesPath:nil];
    
    [LEETheme addThemeConfigJson:nightJson WithTag:NIGHT WithResourcesPath:nil];
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
