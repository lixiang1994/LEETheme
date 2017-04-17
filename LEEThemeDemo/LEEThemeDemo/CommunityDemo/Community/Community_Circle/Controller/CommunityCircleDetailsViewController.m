//
//  CommunityCircleDetailsViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleDetailsViewController.h"

#import "SDAutoLayout.h"

#import "MJRefresh.h"

#import "CommunityCircleAPI.h"

#import "LoadingView.h"

#import "MierProgressHUD.h"

#import "CommunityPostCell.h"

#import "CommunityCircleDetailsCellHeaderView.h"

#import "CommunityCircleDetailsHeaderView.h"

#import "CommunityDetailsViewController.h"

#import "CommunityPostViewController.h"

typedef enum {
    
    NewestListType = 0, //最新发布帖子类型
    
    LastReplyListType //最后回复帖子类型
    
} ListType;

@interface CommunityCircleDetailsViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) MierNavigationBar *navigationBar; //导航栏视图

@property (nonatomic , strong ) CommunityCircleDetailsHeaderView *headerView; //头部视图

@property (nonatomic , strong ) UITableView *tableView; //列表视图

@property (nonatomic , strong ) NSMutableArray *dataArray; //数据源数组

@property (nonatomic , assign ) NSInteger page; //页数

@property (nonatomic , assign ) ListType listType; //列表类型

@property (nonatomic , strong ) CommunityCircleAPI *api;

@property (nonatomic , strong ) LoadingView *loadingView;

@property (nonatomic , strong ) CommunityCircleModel *model;

@end

static NSString * const CommunityPostCellID = @"CommunityPostCell";

static NSString * const CommunityCircleDetailsCellHeaderViewID = @"CommunityCircleDetailsCellHeaderView";

@implementation CommunityCircleDetailsViewController

- (void)dealloc{
    
    _tableView = nil;
    
    _dataArray = nil;
    
    _loadingView = nil;
    
    _model = nil;
    
    _api = nil;
    
    _circleId = nil;
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
    
    //设置刷新
    
    [self configRefresh];
    
    //加载数据
    
    [self loadData];
}

#pragma mark - 设置NavigationBar

- (void)configNavigationBar{
    
    __weak typeof(self) weakSelf = self;
    
    //设置导航栏
    
    _navigationBar = [MierNavigationBar bar]
    .configStyle(MierNavigationBarStyleTypeWhite)
    .configTitleItemTitle(@" ")
    .configLeftItemAction(^(){
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    });
    
    [_navigationBar show:self];
}

#pragma mark - 初始化数据

- (void)initData{
    
    _dataArray = [NSMutableArray array];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 20) style:UITableViewStyleGrouped];
    
    _tableView.hidden = YES;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[CommunityPostCell class] forCellReuseIdentifier:CommunityPostCellID];
    
    [_tableView registerClass:[CommunityCircleDetailsCellHeaderView class] forHeaderFooterViewReuseIdentifier:CommunityCircleDetailsCellHeaderViewID];
    
    [self.view addSubview:_tableView];
    
    [self.view sendSubviewToBack:_tableView];
    
    _headerView = [[CommunityCircleDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 200)];
    
    self.tableView.tableHeaderView = _headerView;
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
    
    self.headerView.backBlock = ^(){
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.headerView.openPostBlock = ^(){
        
        if (weakSelf) {
            
            CommunityPostViewController *vc = [[CommunityPostViewController alloc] init];
            
            vc.circleModel = weakSelf.model;
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    
}

#pragma mark - 设置刷新

- (void)configRefresh{
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (!weakSelf) return;
        
        [weakSelf loadDataWithPage:weakSelf.page + 1 ResultBlock:^(NSInteger result) {
            
            if (!weakSelf) return;
            
            switch (result) {
                    
                case 0:
                    
                    [weakSelf.loadingView showLoadingPromptBarWithText:@"长官 请稍后再试" AutoHideTime:2.0f];
                    
                    [weakSelf.tableView.mj_footer endRefreshing];
                    
                    break;
                    
                case 1:
                    
                    weakSelf.page += 1;
                    
                    [weakSelf.tableView.mj_footer endRefreshing];
                    
                    break;
                    
                case 2:
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }];
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    __weak typeof(self) weakSelf = self;
    
    //显示加载视图
    
    [self.loadingView showLoadingProgress];
    
    //加载新数据
    
    [self loadDataWithPage:1 ResultBlock:^(NSInteger result) {
        
        if (!weakSelf) return;
        
        [weakSelf retractNavigationBar];
        
        if (result) {
        
            weakSelf.tableView.hidden = NO;
            
            weakSelf.page = 1;
            
            [weakSelf.loadingView hiddenLoadingView];
            
        } else {
            
            [weakSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:weakSelf action:@selector(loadData)];
        }
        
    }];
    
}

- (void)loadDataWithPage:(NSInteger)page ResultBlock:(void(^)(NSInteger))resultBlock{
    
    //判断列表类型
    
    NSString *type = nil;
    
    switch (self.listType) {
            
        case NewestListType:
            
            type = @"dateline";
            
            break;
            
        case LastReplyListType:
            
            type = @"lastpost";
            
            break;
            
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //加载数据
    
    [self.api loadCircleDetailsDataWithCircleId:self.circleId Page:page Type:type ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                {
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        //解析数据 (异步)
                        
                        [strongSelf.api analyticalCircleDetailsDataWithData:responseObject ResultBlock:^(NSDictionary *result) {
                            
                            strongSelf.model = result[@"circleInfo"];
                            
                            strongSelf.navigationBar.configTitleItemTitle(strongSelf.model.circleName);
                            
                            [strongSelf.headerView configPicImageUrl:strongSelf.model.circleHeadImageUrl IconImageUrl:strongSelf.model.circleImageUrl Title:strongSelf.model.circleName Describe:strongSelf.model.circleDescription];
                            
                            NSArray *postArray = result[@"postArray"];
                            
                            if (page == 1) {
                                
                                [strongSelf.dataArray removeAllObjects];
                                
                                [strongSelf.dataArray addObjectsFromArray:postArray];
                                
                                [strongSelf.tableView reloadData];
                                
                                if (resultBlock) resultBlock(1);
                                
                            } else {
                                
                                [strongSelf.dataArray addObjectsFromArray:postArray];
                                
                                [strongSelf.tableView reloadDataWithExistedHeightCache];
                            
                                if (resultBlock) resultBlock(postArray.count ? 1 : 2);
                            }
                            
                        }];
                        
                    } else {
                        
                        if (resultBlock) resultBlock(0);
                    }
                    
                }
                    break;
                    
                default:
                {
                    if (resultBlock) resultBlock(0);
                }
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 移除帖子

- (void)deletePost:(NSString *)postId{
    
    if (self.dataArray.count) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == $POSTID"];
        
        NSDictionary *varDict = [NSDictionary dictionaryWithObjectsAndKeys:postId, @"POSTID", nil];
        
        predicate = [predicate predicateWithSubstitutionVariables:varDict];
        
        NSArray *result = [self.dataArray filteredArrayUsingPredicate:predicate];
        
        NSMutableArray *indexPathArray = [NSMutableArray array];
        
        for (CommunityListModel *model in result) {
            
            NSInteger index = [self.dataArray indexOfObject:model];
            
            [indexPathArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
        [self.dataArray removeObjectsInArray:result];
        
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - 展开导航栏

- (void)spreadNavigationBar{
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.navigationBar.top = 0.0f;
        
        self.navigationBar.height = 64.0f;
    }];
    
}

#pragma mark - 收起导航栏

- (void)retractNavigationBar{
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.navigationBar.top = - 64.0f;
        
        self.navigationBar.height = 84.0f;
    }];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = self.dataArray[indexPath.row];
    
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CommunityPostCell class] contentViewWidth:tableView.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityPostCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityPostCellID];
    
    cell.model = self.dataArray[indexPath.row];
    
    cell.isShowCircle = NO;
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityListModel *model = self.dataArray[indexPath.row];
    
    CommunityDetailsViewController *vc = [[CommunityDetailsViewController alloc] init];
    
    vc.postId = model.postId;
    
    vc.circleId = model.circleId;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    vc.deleteBlock = ^(NSString *postId){
        
        if (weakSelf) [weakSelf deletePost:postId];
    };
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CommunityCircleDetailsCellHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CommunityCircleDetailsCellHeaderViewID];
    
    __block typeof(view) blockHeaderView = view;
    
    [view configPostCount:self.model.postCount WithIsShowSort:YES];
    
    switch (self.listType) {
            
        case NewestListType:
            
            [view selectedNewest];
            
            break;
            
        case LastReplyListType:
            
            [view selectedLastReply];
            
            break;
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    
    view.selectedNewestBlock = ^(){
        
        if (weakSelf) {
            
            weakSelf.listType = NewestListType;
            
            [weakSelf.tableView.mj_footer resetNoMoreData];
            
            [weakSelf.view showLoading:@""];
            
            [weakSelf loadDataWithPage:1 ResultBlock:^(NSInteger result) {
                
                if (!weakSelf) return;
                
                if (result) {
                    
                    [weakSelf.view hide];
                    
                } else {
                    
                    //最新发表加载失败 切换回最后回复选中状态
                    
                    [blockHeaderView selectedLastReply];
                    
                    weakSelf.listType = LastReplyListType;
                    
                    [weakSelf.view showFailure:@"加载失败 请重试"];
                }
                
            }];
            
        }
        
    };
    
    view.selectedLastReplyBlock = ^(){
        
        if (weakSelf) {
            
            weakSelf.listType = LastReplyListType;
            
            [weakSelf.tableView.mj_footer resetNoMoreData];
            
            [weakSelf.view showLoading:@""];
            
            [weakSelf loadDataWithPage:1 ResultBlock:^(NSInteger result) {
                
                if (!weakSelf) return;
                
                if (result) {
                    
                    [weakSelf.view hide];
                    
                } else {
                    
                    //最后回复加载失败 切换回最新发表选中状态
                    
                    [blockHeaderView selectedNewest];
                    
                    weakSelf.listType = NewestListType;
                    
                    [weakSelf.view showFailure:@"加载失败 请重试"];
                }
                
            }];
            
        }
        
    };
    
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 64) {
        
        if (!self.tableView.bounces) self.tableView.bounces = YES;
        
        [self spreadNavigationBar];
        
    } else {
        
        if (self.tableView.bounces) self.tableView.bounces = NO;
        
        [self retractNavigationBar];
    }
    
}

#pragma mark - LazyLoading

- (CommunityCircleAPI *)api{
    
    if (!_api) {
        
        _api = [[CommunityCircleAPI alloc] init];
    }
    
    return _api;
}

- (LoadingView *)loadingView{
    
    if (!_loadingView) {
        
        _loadingView = [[LoadingView alloc] initWithFrame:self.tableView.frame];
        
        [self.view addSubview:_loadingView];
        
        [self.view bringSubviewToFront:_loadingView];
    }
    
    return _loadingView;
}

@end
