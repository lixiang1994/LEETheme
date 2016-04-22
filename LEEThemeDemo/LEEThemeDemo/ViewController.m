//
//  ViewController.m
//  LEEThemeDemo
//
//  Created by 李响 on 16/4/22.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "ViewController.h"

#import "LEETheme.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    //初始化子视图
    
    [self initSubviews];
    
    //设置主题样式
    
    [self configThemeStyle];
    
}

#pragma mark - 初始化子视图

- (void)initSubviews{
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button1.frame = CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button1 setTitle:@"改变红色主题" forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    
    [button1 configThemeWithTag:@"red" ConfigBlock:^(UIButton *item) {
        
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } CompatibleTags:@"blue",@"gray",nil];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button2.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button2 setTitle:@"改变蓝色主题" forState:UIControlStateNormal];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    [button2 configThemeWithTag:@"blue" ConfigBlock:^(UIButton *item) {
        
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }CompatibleTags:@"red",@"gray",nil];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button3.frame = CGRectMake(20, 180, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button3 setTitle:@"改变灰色主题" forState:UIControlStateNormal];
    
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    [button3 configThemeWithTag:@"gray" ConfigBlock:^(UIButton *item) {
        
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }CompatibleTags:@"blue",@"red",nil];
    
}

#pragma mark - 设置主题样式

- (void)configThemeStyle{
 
    [self.view configThemeWithTag:@"red" ConfigBlock:^(UIView *item) {
        
        item.backgroundColor = [UIColor redColor];
    }];
    
    [self.view configThemeWithTag:@"blue" ConfigBlock:^(UIView *item) {
        
        item.backgroundColor = [UIColor blueColor];
    }];
    
    [self.view configThemeWithTag:@"gray" ConfigBlock:^(UIView *item) {
        
        item.backgroundColor = [UIColor grayColor];
    }];
    
}

- (void)button1Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:@"red"];
    
}

- (void)button2Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:@"blue"];
    
}

- (void)button3Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:@"gray"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
