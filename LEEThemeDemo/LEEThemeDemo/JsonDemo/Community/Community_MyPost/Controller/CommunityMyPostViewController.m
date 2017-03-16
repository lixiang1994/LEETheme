//
//  CommunityMyPostViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/9.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityMyPostViewController.h"

#import "CommunityUserPostTableView.h"

#import "CommunityDetailsViewController.h"

@interface CommunityMyPostViewController ()

@property (nonatomic , strong ) CommunityUserPostTableView *tableView;

@end

@implementation CommunityMyPostViewController

- (void)dealloc{
    
    _tableView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //初始化数据
    
    [self initData];
    
    //初始化子视图
    
    [self initSubview];
    
    //设置自动布局
    
    [self configAutoLayout];
    
    //设置主题模式
    
    [self configTheme];
    
    //设置Block
    
    [self configBlock];
    
    //加载数据
    
    [self loadData];
}

#pragma mark - 设置NavigationBar

- (void)configNavigationBar{
    
    __weak typeof(self) weakSelf = self;
    
    //设置导航栏
    
    [[MierNavigationBar bar]
     .configStyle(MierNavigationBarStyleTypeWhite)
     .configTitleItemTitle(@"我的帖子")
     .configLeftItemAction(^(){
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    })
     show:self];
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _tableView = [[CommunityUserPostTableView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.width, self.view.height - 64.0f) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.tableView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
}

#pragma mark - 设置Block

- (void)configBlock{
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.openPostDetailsBlock = ^(CommunityListModel * model){
        
        if (weakSelf) [weakSelf openPostDetailsViewController:model];
    };
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    [self.tableView loadData];
}

#pragma mark - 打开帖子详情

- (void)openPostDetailsViewController:(CommunityListModel *)model{
    
    CommunityDetailsViewController *vc = [[CommunityDetailsViewController alloc] init];
    
    vc.postId = model.postId;
    
    vc.circleId = model.circleId;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    vc.deleteBlock = ^(NSString *postId){
        
        if (weakSelf) [weakSelf.tableView deletePost:postId];
    };
    
}

@end
