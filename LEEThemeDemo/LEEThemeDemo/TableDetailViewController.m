
/*!
 *  @header TableDetailViewController.m
 *          LEEThemeDemo
 *
 *  @brief  列表详情视图控制器
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/4/22.
 */

#import "TableDetailViewController.h"

#import "UIView+SDAutoLayout.h"

#import "LEETheme.h"

@interface TableDetailViewController ()

@end

@implementation TableDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    button1.lee_theme
    .LeeAddCustomConfigs(@[RED,BLUE,GRAY] , ^(UIButton *item){
        
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button2.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button2 setTitle:@"改变蓝色主题" forState:UIControlStateNormal];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    button2.lee_theme
    .LeeAddCustomConfigs(@[RED,BLUE,GRAY] , ^(UIButton *item){
        
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button3.frame = CGRectMake(20, 180, CGRectGetWidth(self.view.frame) - 40, 40);
    
    [button3 setTitle:@"改变灰色主题" forState:UIControlStateNormal];
    
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    button3.lee_theme
    .LeeAddCustomConfigs(@[RED,BLUE,GRAY] , ^(UIButton *item){
        
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
    
    
    UIView *customView = [[UIView alloc] init];
    
    [self.view addSubview:customView];
    
    UITextField *customTextField = [[UITextField alloc] init];
    
    customTextField.placeholder = @"一个输入框";
    
    customTextField.text = @"帅比LEE";
    
    [customView addSubview:customTextField];
    
    customView.sd_layout
    .leftSpaceToView(self.view , 20)
    .rightSpaceToView(self.view , 20)
    .topSpaceToView(button3 , 20)
    .heightIs(100);
    
    customTextField.sd_layout
    .leftSpaceToView(customView , 20)
    .rightSpaceToView(customView , 20)
    .topSpaceToView(customView,10)
    .heightIs(30);
    
    customTextField.lee_theme
    .LeeAddTextColor(RED , [UIColor redColor])
    .LeeAddTextColor(BLUE , [UIColor blueColor])
    .LeeAddTextColor(GRAY , [UIColor grayColor])
    .LeeChangeThemeAnimationDuration(10.0f);
    
    customView.lee_theme
    .LeeAddCustomConfigs(@[RED,BLUE,GRAY] , ^(UIButton *item){
        
        [item setBackgroundColor:[UIColor whiteColor]];
    });

}

#pragma mark - 设置主题样式

- (void)configThemeStyle{
    
    self.view.lee_theme
    .LeeAddCustomConfig(RED , ^(UIView *item){
        
        item.backgroundColor = [UIColor redColor];
    })
    .LeeAddCustomConfig(BLUE , ^(UIView *item){
        
        item.backgroundColor = [UIColor blueColor];
    })
    .LeeAddCustomConfig(GRAY , ^(UIView *item){
        
        item.backgroundColor = [UIColor grayColor];
    })
    .LeeChangeThemeAnimationDuration(2.0f);
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
