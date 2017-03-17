//
//  CommunityClassifyTableView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityClassifyTableView.h"

#import "SDAutoLayout.h"

#import "UniversalRefresh.h"

#import "CommunityPostCell.h"

#import "LoadingView.h"

@interface CommunityClassifyTableView ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) NSMutableArray *dataArray; //数据源数组

@property (nonatomic , assign ) NSInteger page; //页数

@property (nonatomic , strong ) CommunityAPI *api;

@property (nonatomic , strong ) LoadingView *loadingView;

@property (nonatomic , assign ) BOOL isLoading; //是否加载中

@end

static NSString * const CommunityPostCellID = @"CommunityPostCell";

@implementation CommunityClassifyTableView

- (void)dealloc{
    
    _dataArray = nil;
    
    _api = nil;
    
    _loadingView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
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
        
    }
    
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
    _dataArray = [NSMutableArray array];
    
    self.hidden = YES;
    
    self.delegate = self;
    
    self.dataSource = self;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contentInset = UIEdgeInsetsMake(0, 0, 50.0f, 0);
    
    [self registerClass:[CommunityPostCell class] forCellReuseIdentifier:CommunityPostCellID];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
}

#pragma mark - 设置Block

- (void)configBlock{
    
}

#pragma mark - 设置刷新

- (void)configRefresh{
    
    __weak typeof(self) weakSelf = self;
    
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        if (!weakSelf) return;
        
        [weakSelf loadDataWithPage:1 ResultBlock:^(NSInteger result) {
            
            if (!weakSelf) return;
            
            if (result) {
                
                weakSelf.page = 1;
                
                [weakSelf.mj_footer resetNoMoreData];
                
            } else {
                
                [weakSelf.loadingView showLoadingPromptBarWithText:@"加载失败 稍后重试" AutoHideTime:2.0f];
            }
            
            [weakSelf.mj_header endRefreshing];
        }];
        
    }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (!weakSelf) return;
        
        [weakSelf loadDataWithPage:weakSelf.page + 1 ResultBlock:^(NSInteger result) {
            
            if (!weakSelf) return;
            
            switch (result) {
                    
                case 0:
                    
                    [weakSelf.loadingView showLoadingPromptBarWithText:@"长官 请稍后再试" AutoHideTime:2.0f];
                    
                    [weakSelf.mj_footer endRefreshing];
                    
                    break;
                    
                case 1:
                    
                    weakSelf.page += 1;
                    
                    [weakSelf.mj_footer endRefreshing];
                    
                    break;
                    
                case 2:
                    
                    [weakSelf.mj_footer endRefreshingWithNoMoreData];
                    
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }];
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    //判断是否正在加载中或列表已经显示
    
    if (self.isLoading || !self.hidden) return;
    
    //设置加载中
    
    self.isLoading = YES;
    
    //显示加载视图
    
    [self.loadingView showLoadingProgress];
    
    //加载新数据
    
    __weak typeof(self) weakSelf = self;
    
    [self loadDataWithPage:1 ResultBlock:^(NSInteger result) {
        
        if (!weakSelf) return;
        
        if (result) {
            
            weakSelf.page = 1;
            
            weakSelf.hidden = NO;
            
            [weakSelf.loadingView hiddenLoadingView];
            
        } else {
            
            [weakSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:weakSelf action:@selector(loadData)];
        }
        
    }];

}

- (void)loadDataWithPage:(NSInteger)page ResultBlock:(void(^)(NSInteger))resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    //加载数据
    
    [self.api loadDataWithPage:page Type:self.type ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            strongSelf.isLoading = NO;
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                {
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        //解析数据 (异步)
                        
                        [strongSelf.api analyticalDataWithData:responseObject ResultBlock:^(NSDictionary *result) {
                            
                            NSArray *postArray = result[@"postArray"];
                            
                            if (page == 1) {
                                
                                [strongSelf.dataArray removeAllObjects];
                                
                                [strongSelf.dataArray addObjectsFromArray:postArray];
                                
                                [strongSelf reloadData];
                                
                                if (resultBlock) resultBlock(1);
                                
                            } else {
                                
                                [strongSelf.dataArray addObjectsFromArray:postArray];
                                
                                [strongSelf reloadDataWithExistedHeightCache];
                                
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
        
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    
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
    
    cell.isShowCircle = YES;
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.openPostDetailsBlock) self.openPostDetailsBlock(self.dataArray[indexPath.row]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

#pragma mark - LazyLoading

- (CommunityAPI *)api{
    
    if (!_api) {
        
        _api = [[CommunityAPI alloc] init];
    }
    
    return _api;
}

- (LoadingView *)loadingView{
    
    if (!_loadingView) {
        
        _loadingView = [[LoadingView alloc] initWithFrame:self.frame];
        
        [self.superview addSubview:_loadingView];
        
        [self.superview bringSubviewToFront:_loadingView];
    }
    
    return _loadingView;
}

@end
