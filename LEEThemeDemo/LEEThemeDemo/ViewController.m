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

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
}

#pragma mark - 初始化子视图

- (void)initSubviews{
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button1.frame = CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button1 setTitle:@"改变红色主题" forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button2.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button2 setTitle:@"改变蓝色主题" forState:UIControlStateNormal];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button3.frame = CGRectMake(20, 180, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button3 setTitle:@"改变灰色主题" forState:UIControlStateNormal];
    
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button4.frame = CGRectMake(20, 240, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button4 setTitle:@"改变绿色主题" forState:UIControlStateNormal];
    
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button4 addTarget:self action:@selector(button4Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button4];
    
//    [button1 setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]] forState:UIControlStateNormal];
    
//    button1.lee_theme
//    .LeeAddButtonImage(RED , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]] , UIControlStateNormal)
//    .LeeAddButtonImage(BLUE , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huaji" ofType:@"jpg"]] , UIControlStateNormal)
//    .LeeAddButtonImage(GRAY , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]] , UIControlStateNormal);
    
//    button1.lee_theme
//    .LeeAddButtonBackgroundImage(RED , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]] , UIControlStateNormal)
//    .LeeAddButtonBackgroundImage(BLUE , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huaji" ofType:@"jpg"]] , UIControlStateNormal)
//    .LeeAddButtonBackgroundImage(GRAY , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]] , UIControlStateNormal)   .LeeAddButtonBackgroundImage(RED , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huaji" ofType:@"jpg"]] , UIControlStateHighlighted)
//    .LeeAddButtonBackgroundImage(BLUE , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]] , UIControlStateHighlighted)
//    .LeeAddButtonBackgroundImage(GRAY , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]] , UIControlStateHighlighted);
    
//    button1.lee_theme
//    .LeeAddButtonTitleColor(RED , [UIColor whiteColor] , UIControlStateNormal)
//    .LeeAddButtonTitleColor(BLUE , [UIColor blackColor] , UIControlStateNormal)
//    .LeeAddButtonTitleColor(GRAY , [UIColor grayColor] , UIControlStateNormal)
//    .LeeAddButtonTitleColor(RED , [UIColor redColor] , UIControlStateHighlighted)
//    .LeeAddButtonTitleColor(BLUE , [UIColor greenColor] , UIControlStateHighlighted)
//    .LeeAddButtonTitleColor(GRAY , [UIColor orangeColor] , UIControlStateHighlighted);
    
//    button1.lee_theme
//    .LeeConfigButtonTitleColor(@"ident2" , UIControlStateNormal)
//    .LeeConfigButtonTitleColor(@"ident1" , UIControlStateHighlighted);
    
    button1.lee_theme
    .LeeConfigButtonBackgroundImage(@"ident2" , UIControlStateNormal)
    .LeeConfigButtonBackgroundImage(@"ident1" , UIControlStateHighlighted)
    .LeeConfigButtonBackgroundImage(@"ident1" , UIControlStateSelected);
    
    button1.lee_theme
    .LeeCustomConfig(@"ident1" , ^(id value){
        
        NSLog(@"%@" , value);
        
    });
    
}

#pragma mark - 设置主题样式

- (void)configThemeStyle{
    
//    self.view.lee_theme
//    .LeeAddCustomConfig(RED , ^(UIView *item){
//        
//        item.backgroundColor = [UIColor redColor];
//    })
//    .LeeAddCustomConfig(BLUE , ^(UIView *item){
//        
//        item.backgroundColor = [UIColor blueColor];
//    })
//    .LeeAddCustomConfig(GRAY , ^(UIView *item){
//        
//        item.backgroundColor = [UIColor grayColor];
//    });
    
//    self.view.lee_theme
//    .LeeAddBackgroundColor(RED , [UIColor redColor])
//    .LeeAddBackgroundColor(BLUE , [UIColor blueColor])
//    .LeeAddBackgroundColor(GRAY , [UIColor grayColor]);
    
    self.view.lee_theme.LeeConfigBackgroundColor(@"ident1");
    
}

- (void)button1Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:RED];
    
}

- (void)button2Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:BLUE];
    
}

- (void)button3Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:GRAY];
    
}

- (void)button4Action:(UIButton *)sender{
    
    //启用主题
    
    [LEETheme startTheme:GREEN];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
