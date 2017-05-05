//
//  TabBarController.m
//  LEEThemeDemo
//
//  Created by 李响 on 2017/5/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTabBarItems];
    
    [self configTheme];
}

- (void)configTheme {
    
    __weak typeof(self) weakSelf = self;
    
    self.tabBar.lee_theme
    .LeeAddCustomConfigs(@[DAY , NIGHT] , ^(UITabBar *bar){
        
        if (weakSelf) [weakSelf initTabBarItems];
    })
    .LeeAddBarTintColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBarTintColor(NIGHT , LEEColorRGB(40, 40, 40))
    .LeeChangeThemeAnimationDuration(0.0f);
}

#pragma mark - 初始化TabBar选项

- (void)initTabBarItems {
    
    //选项属性数组
    
    NSArray *itemUnselectImageNameArray = @[@"tab_theme" , @"tab_demo"];
    
    NSArray *itemSelectImageNameArray = @[@"tab_theme_sel" , @"tab_demo_sel"];
    
    NSArray *nameArray = @[@"演示" , @"demo"];
    
    NSArray *classArray = @[@"ViewController" , @"TableViewController"];
    
    NSMutableArray *ncArray = [[NSMutableArray alloc] init];
    
    //循环创建
    
    for (NSInteger i = 0; i < classArray.count; i++) {
        
        UINavigationController *nc = self.viewControllers[i];
        
        if (!nc) {
            
            nc = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(classArray[i])alloc] init]];
            
            nc.navigationBar.lee_theme
            .LeeAddBarTintColor(DAY , LEEColorRGB(255, 255, 255))
            .LeeAddBarTintColor(NIGHT , LEEColorRGB(85, 85, 85))
            .LeeAddCustomConfig(DAY , ^(UINavigationBar *item){
                
                item.barStyle = UIBarStyleDefault;
            })
            .LeeAddCustomConfig(NIGHT , ^(UINavigationBar *item){
                
                item.barStyle = UIBarStyleBlack;
            });
            
        }
        
        NSString *unSelectImageName = [[LEETheme currentThemeTag] isEqualToString:DAY] ? itemUnselectImageNameArray[i] : [NSString stringWithFormat:@"%@_night" , itemUnselectImageNameArray[i]];
        
        NSString *selectImageName = [[LEETheme currentThemeTag] isEqualToString:DAY] ? itemSelectImageNameArray[i] : [NSString stringWithFormat:@"%@_night" , itemSelectImageNameArray[i]];
        
        UIImage *unSelectImage = [[UIImage imageNamed:unSelectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *selectImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *tabBarItem  = [[UITabBarItem alloc] initWithTitle:nameArray[i] image:unSelectImage selectedImage:selectImage];
        
        if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
            
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(33, 151, 216)} forState:UIControlStateSelected];
            
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(159, 159, 159)} forState:UIControlStateNormal];
            
        } else {
            
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(28, 125, 178)} forState:UIControlStateSelected];
            
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(230, 230, 230)} forState:UIControlStateNormal];
        }
        
        nc.tabBarItem = tabBarItem;
        
        //将导航控制器添加到数组中
        
        [ncArray addObject:nc];
    }
    
    self.viewControllers = ncArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
