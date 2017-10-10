//
//  Mier_CommunityViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/24.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "Mier_CommunityViewController.h"

#import "SDAutoLayout.h"

#import "CommunityNavigationBarSegmentedView.h"

#import "CommunityEssenceTableView.h"

#import "CommunityClassifyTableView.h"

#import "CommunityCircleListViewController.h"

#import "CommunityCircleDetailsViewController.h"

#import "CommunityPostViewController.h"

#import "CommunityDetailsViewController.h"

@interface Mier_CommunityViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong ) CommunityNavigationBarSegmentedView *segmentedView;

@property (nonatomic , strong ) UIScrollView *scrollView;

@property (nonatomic , strong ) CommunityEssenceTableView *essenceTableView; //精华列表

@property (nonatomic , strong ) CommunityClassifyTableView *newestTableView; //最新列表

@property (nonatomic , strong ) CommunityClassifyTableView *nearbyTableView; //附近列表

@property (nonatomic , strong ) UIView *postView; //发帖视图

@property (nonatomic , strong ) UIButton *postButton; //发帖按钮

@end

@implementation Mier_CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
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
    
    self.segmentedView = [[CommunityNavigationBarSegmentedView alloc] init];
    
    UIImageView *circleListImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_circle_titlebar_ic_list"]];
    
    circleListImageView.contentMode = UIViewContentModeCenter;
    
    //设置导航栏
    
    [[MierNavigationBar bar]
     .configStyle(MierNavigationBarStyleTypeWhite)
     .configTitleItemView(self.segmentedView)
     .configLeftItemAction(^(){
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    })
     .configRightItemView(circleListImageView)
     .configRightItemAction(^(){
        
        if (weakSelf) {
            
            [weakSelf openCricleListViewController];
        }
    })
     show:self];
    
    self.segmentedView.sd_layout
    .leftEqualToView(self.segmentedView.superview)
    .centerYEqualToView(self.segmentedView.superview)
    .heightIs(44.0f);
    
    circleListImageView.sd_layout
    .leftSpaceToView(circleListImageView.superview , 15.0f)
    .centerYEqualToView(circleListImageView.superview)
    .widthIs(30.0f)
    .heightIs(30.0f);
}

#pragma mark - 初始化数据

- (void)initData{
    
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    // 初始化滑动视图
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.width, self.view.height - 64.0f)];
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.bounces = NO;
    
    _scrollView.delegate = self;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    
    // 精华列表
    
    _essenceTableView = [[CommunityEssenceTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStyleGrouped];
    
    [self.scrollView addSubview:_essenceTableView];
    
    // 最新列表
    
    _newestTableView = [[CommunityClassifyTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStyleGrouped];
    
    _newestTableView.type = CommunityListTypeNewest;
    
    [self.scrollView addSubview:_newestTableView];
    
    // 附近列表
    
    _nearbyTableView = [[CommunityClassifyTableView alloc] initWithFrame:CGRectMake(self.scrollView.width * 2, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStyleGrouped];
    
    _nearbyTableView.type = CommunityListTypeNearby;
    
    //    [self.scrollView addSubview:_nearbyTableView];
    
    //发帖视图
    
    _postView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50.0f, self.view.width, 50.0f)];
    
    _postView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_postView];
    
    //发帖按钮
    
    _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _postButton.sd_cornerRadius = @4.0f;
    
    [_postButton setTitle:@"发帖" forState:UIControlStateNormal];
    
    [_postButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    
    [_postButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    [_postButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [_postButton setImage:[UIImage imageNamed:@"biz_subject_Post"] forState:UIControlStateNormal];
    
    [_postButton addTarget:self action:@selector(openPostViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.postView addSubview:_postButton];
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    [_scrollView setupAutoContentSizeWithRightView:self.scrollView.subviews.lastObject rightMargin:0.0f];
    
    _postButton.sd_layout
    .topSpaceToView(self.postView, 5.0f)
    .leftSpaceToView(self.postView , 15.0f)
    .rightSpaceToView(self.postView , 15.0f)
    .heightIs(40.0f);
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    self.scrollView.top = VIEWSAFEAREAINSETS(self.view).top + 44.0f;
    
    self.scrollView.height = self.view.height - self.scrollView.top;
    
    self.postView.sd_layout
    .bottomSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(50.0f + VIEWSAFEAREAINSETS(self.view).bottom);
    
    self.essenceTableView.height = self.scrollView.height;
    
    self.newestTableView.height = self.scrollView.height;
    
    self.nearbyTableView.height = self.scrollView.height;
    
    self.essenceTableView.contentInset = UIEdgeInsetsMake(0, 0, self.postView.height, 0);
    
    self.newestTableView.contentInset = UIEdgeInsetsMake(0, 0, self.postView.height, 0);
    
    self.nearbyTableView.contentInset = UIEdgeInsetsMake(0, 0, self.postView.height, 0);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_7);
    
    self.postButton.lee_theme.LeeConfigBackgroundColor(common_bg_blue_4);
}

#pragma mark - 设置Block

- (void)configBlock{
    
    __weak typeof(self) weakSelf = self;
    
    self.segmentedView.didSelectItemBlock = ^(NSInteger index){
        
        if (weakSelf) {
            
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.width * index, 0) animated:YES];
            
            [weakSelf loadTableDataWithIndex:index];
        }
        
    };
    
    self.essenceTableView.openCircleListBlock = ^{
        
        if (weakSelf) {
            
            [weakSelf openCricleListViewController];
        }
        
    };
    
    self.essenceTableView.openCircleDetailsBlock = ^(CommunityCircleModel *model){
        
        if (weakSelf) {
            
            CommunityCircleDetailsViewController *vc = [[CommunityCircleDetailsViewController alloc] init];
            
            vc.circleId = model.circleId;
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    
    self.essenceTableView.openPostDetailsBlock = ^(CommunityListModel *model){
        
        if (weakSelf) [weakSelf openPostDetailsViewController:model];
    };
    
    self.newestTableView.openPostDetailsBlock = ^(CommunityListModel *model){
        
        if (weakSelf) [weakSelf openPostDetailsViewController:model];
    };
    
    self.nearbyTableView.openPostDetailsBlock = ^(CommunityListModel *model){
        
        if (weakSelf) [weakSelf openPostDetailsViewController:model];
    };
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    //加载数据
    
    [self.essenceTableView loadData];
}

#pragma mark - 加载列表数据

- (void)loadTableDataWithIndex:(NSInteger)index{
    
    //根据下标 加载对应列表视图的数据
    
    switch (index) {
            
        case 0:
            
            [self.essenceTableView loadData];
            
            break;
            
        case 1:
            
            [self.newestTableView loadData];
            
            break;
            
        case 2:
            
            [self.nearbyTableView loadData];
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 打开圈子列表

- (void)openCricleListViewController{
    
    CommunityCircleListViewController *vc = [[CommunityCircleListViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 打开发帖

- (void)openPostViewController{
    
    CommunityPostViewController *vc = [[CommunityPostViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
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
        
        if (weakSelf) {
            
            [weakSelf.essenceTableView deletePost:postId];
            
            [weakSelf.newestTableView deletePost:postId];
        }
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    self.segmentedView.selectIndex = page;
    
    [self loadTableDataWithIndex:page];
}

@end
