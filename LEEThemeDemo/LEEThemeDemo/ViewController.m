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
    
    [self configTheme];
     }

#pragma mark - 初始化子视图

- (void)initSubviews{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
