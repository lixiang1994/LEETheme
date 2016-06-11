
/*!
 *  @header TableViewController.m
 *          LEEThemeDemo
 *
 *  @brief  表视图控制器
 *
 *  @author 李响
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    16/4/22.
 */

#import "TableViewController.h"

#import "LEETheme.h"

#import "CustomTableViewCell.h"

#import "TableDetailViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.rowHeight = 100.0f;
    
    //除了可以根据主题设置自身属性外 , 还可以设置外部的东西 例如:视图控制器的标题
    
    __block typeof(self) Self = self;
    
    self.view.lee_theme
    .LeeAddCustomConfig(RED , ^(UIView *item){
        
        Self.navigationItem.title = @"红色主题列表";
    })
    .LeeAddCustomConfig(BLUE , ^(UIView *item){
        
        Self.navigationItem.title = @"蓝色主题列表";
    })
    .LeeAddCustomConfig(GRAY , ^(UIView *item){
        
        Self.navigationItem.title = @"灰色主题列表";
    });
    
//    self.navigationController.navigationBar.lee_theme
//    .LeeConfigBackIndicatorImage(@"ident1")
//    .LeeConfigBackIndicatorTransitionMaskImage(@"ident2");
//    .LeeAddBackIndicatorImage(RED , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]])
//    .LeeAddBackIndicatorImage(BLUE , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huaji" ofType:@"jpg"]])
//    .LeeAddBackIndicatorImage(GRAY , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]])
//    .LeeAddBackIndicatorTransitionMaskImage(RED , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picImage" ofType:@"jpg"]])
//    .LeeAddBackIndicatorTransitionMaskImage(BLUE , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huaji" ofType:@"jpg"]])
//    .LeeAddBackIndicatorTransitionMaskImage(GRAY , [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huajis" ofType:@"jpg"]]);
    
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

    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableDetailViewController *tdVC = [[TableDetailViewController alloc] init];
    
    [self.navigationController pushViewController:tdVC animated:YES];
    
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
