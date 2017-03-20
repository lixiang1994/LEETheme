//
//  TableViewController.m
//  LEEThemeDemo
//
//  Created by 李响 on 2017/3/16.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "TableViewController.h"

#import "Mier_CommunityViewController.h"

#import "WBStatusTimelineViewController.h"

#import "T1HomeTimelineItemsViewController.h"

@interface TableViewController ()

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation TableViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 显示UINavigationBar
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    
    [self initData];
    
    // 设置主题样式
    
    [self configTheme];
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.title = @"演示Demo";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _dataArray = [NSMutableArray array];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        
        [_dataArray addObject:@"米尔社区(来自米尔军事)"];
    }
    
    [_dataArray addObject:@"新浪微博(来自YYKitDemo)"];
    
    [_dataArray addObject:@"Twitter(来自YYKitDemo)"];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBackgroundColor(NIGHT , LEEColorRGB(55, 55, 55));
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY , LEEColorRGB(187, 187, 187))
    .LeeAddSeparatorColor(NIGHT , LEEColorRGB(119, 119, 119));
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // 设置主题
    
    cell.lee_theme
    .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
    .LeeAddBackgroundColor(NIGHT , LEEColorRGB(55, 55, 55));
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    cell.textLabel.lee_theme
    .LeeAddTextColor(DAY , [UIColor blackColor])
    .LeeAddTextColor(NIGHT , [UIColor whiteColor]);
    
    cell.selectedBackgroundView = [UIView new];
    
    cell.selectedBackgroundView.lee_theme
    .LeeAddBackgroundColor(DAY , LEEColorRGB(221, 221, 221))
    .LeeAddBackgroundColor(NIGHT , LEEColorRGB(85, 85, 85));
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        
        case 0:
        {
            Mier_CommunityViewController *vc = [[Mier_CommunityViewController alloc] init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
            
        case 1:
        {
            
            WBStatusTimelineViewController *vc = [[WBStatusTimelineViewController alloc] init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            
            T1HomeTimelineItemsViewController *vc = [[T1HomeTimelineItemsViewController alloc] init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
