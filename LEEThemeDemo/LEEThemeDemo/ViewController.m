//
//  ViewController.m
//  LEEThemeDemo
//
//  Created by 李响 on 16/4/22.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "ViewController.h"

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 100, 120, 40.0f);
    
    button.center = CGPointMake(self.view.frame.size.width * 0.5f, button.center.y);
    
    [button setTitle:@"切换主题" forState:UIControlStateNormal];
    
    [button.layer setBorderWidth:0.5f];
    
    [button.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.5f].CGColor];
    
    [button.layer setCornerRadius:5.0f];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    button.lee_theme
    .LeeAddButtonTitleColor(DAY , [UIColor blackColor] , UIControlStateNormal)
    .LeeAddButtonTitleColor(NIGHT , [UIColor whiteColor] , UIControlStateNormal);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBackgroundColor(NIGHT , LEEColorRGB(55, 55, 55));
}

- (void)buttonAction:(UIButton *)sender{
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        
        [LEETheme startTheme:NIGHT];
        
    } else {
        
        [LEETheme startTheme:DAY];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
