//
//  CommunityPostLocationViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/11.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityPostLocationViewController.h"

#import "SDAutoLayout.h"

#import "CommunityPostAPI.h"

#import "LoadingView.h"

#import "MierProgressHUD.h"

@interface CommunityPostLocationViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) UITableView *tableView;

@property (nonatomic , strong ) NSMutableArray *dataArray;

@property (nonatomic , strong ) NSArray *provinceArray;

@property (nonatomic , strong ) NSArray *cityArray;

@property (nonatomic , strong ) NSArray *areaArray;

@property (nonatomic , strong ) NSDictionary *provinceInfo;

@property (nonatomic , strong ) NSDictionary *cityInfo;

@property (nonatomic , strong ) NSDictionary *areaInfo;

@property (nonatomic , strong ) CommunityPostAPI *api;

@property (nonatomic , strong ) LoadingView *loadingView;

@end

static NSString * const LocationCellID = @"LocationCell";

@implementation CommunityPostLocationViewController

- (void)dealloc{
    
    _tableView = nil;
    
    _dataArray = nil;
    
    _provinceArray = nil;
    
    _cityArray = nil;
    
    _areaArray = nil;
    
    _provinceInfo = nil;
    
    _cityInfo = nil;
    
    _areaInfo = nil;
    
    _api = nil;
    
    _loadingView = nil;
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

-(void)configNavigationBar{
    
    __weak typeof(self) weakSelf = self;
    
    //设置导航栏
    
    [[MierNavigationBar bar]
     .configStyle(MierNavigationBarStyleTypeWhite)
     .configTitleItemTitle(@"选择地址")
     .configLeftItemAction(^(){
        
        if (weakSelf) {
            
            if (weakSelf.cityInfo) {
                
                weakSelf.cityInfo = nil;
                
                weakSelf.areaArray = nil;
                
                [weakSelf.dataArray removeAllObjects];
                
                [weakSelf.dataArray addObjectsFromArray:weakSelf.cityArray];
                
                [weakSelf.tableView reloadData];
                
            } else if (weakSelf.provinceInfo) {
                
                weakSelf.provinceInfo = nil;
                
                weakSelf.cityArray = nil;
                
                [weakSelf.dataArray removeAllObjects];
                
                [weakSelf.dataArray addObjectsFromArray:weakSelf.provinceArray];
                
                [weakSelf.tableView reloadData];
                
            } else {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
    })
     show:self];
}

#pragma mark - 初始化数据

- (void)initData{
    
    _dataArray = [NSMutableArray array];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.width, self.view.height - 64.0f) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LocationCellID];
    
    [self.view addSubview:_tableView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    _tableView.sd_layout
    .topSpaceToView(self.view, 64.0f)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    _tableView.sd_resetLayout
    .topSpaceToView(self.view , 44.0f + VIEWSAFEAREAINSETS(self.view).top)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.tableView.lee_theme
    .LeeConfigBackgroundColor(common_bg_color_5)
    .LeeConfigSeparatorColor(common_bar_divider1);
}

#pragma mark - 设置Block

- (void)configBlock{
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    [self.loadingView showLoadingProgress];
    
    __weak typeof(self) weakSelf = self;
    
    [self.api loadProvinceDataWithResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        if (weakSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject[@"data"]];
                        
                        [array insertObject:@{@"id" : @(-1) , @"name" : @"当前位置"} atIndex:0];
                        
                        weakSelf.provinceArray = array;
                        
                        [weakSelf loadProvinceData];
                        
                        [weakSelf.loadingView hiddenLoadingView];
                        
                    } else {
                        
                        [weakSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:weakSelf action:@selector(loadData)];
                    }
                    
                    break;
                    
                default:
                    
                    [weakSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:weakSelf action:@selector(loadData)];
                    
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 加载省数据

- (void)loadProvinceData{
    
    if (self.provinceArray) {
        
        [self.dataArray removeAllObjects];
        
        [self.dataArray addObjectsFromArray:self.provinceArray];
        
        [self.tableView reloadData];
    }
    
}

#pragma mark - 加载市数据

- (void)loadCityData:(NSDictionary *)provinceInfo{
    
    if (provinceInfo) {
        
        [self.view showLoading:@"加载中"];
        
        __weak typeof(self) weakSelf = self;
        
        [self.api loadCityDataWithProvinceId:provinceInfo[@"id"] ResultBlock:^(RequestResultType requestResultType, id responseObject) {
            
            if (weakSelf) {
                
                switch (requestResultType) {
                        
                    case RequestResultTypeSuccess:
                        
                        if ([responseObject[@"error"] integerValue] == 0) {
                            
                            weakSelf.cityArray = responseObject[@"data"];
                            
                            if (weakSelf.cityArray.count) {
                                
                                weakSelf.provinceInfo = provinceInfo; //设置省Id
                                
                                [weakSelf.dataArray removeAllObjects];
                                
                                [weakSelf.dataArray addObjectsFromArray:weakSelf.cityArray];
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.view hide];
                            
                            } else {
                                
                                [weakSelf.view showFailure:@"暂无数据"];
                            }
                            
                        } else {
                            
                            [weakSelf.view showFailure:@"加载失败 请重试"];
                        }
                        
                        break;
                        
                    default:
                        
                        [weakSelf.view showFailure:@"加载失败 请重试"];
                        
                        break;
                }
                
            }
            
        }];

    }
    
}

#pragma mark - 加载区数据

- (void)loadAreaData:(NSDictionary *)cityInfo{
    
    if (cityInfo) {
        
        [self.view showLoading:@"加载中"];
        
        __weak typeof(self) weakSelf = self;
        
        [self.api loadAreaDataWithCityId:cityInfo[@"id"] ResultBlock:^(RequestResultType requestResultType, id responseObject) {
            
            if (weakSelf) {
                
                switch (requestResultType) {
                        
                    case RequestResultTypeSuccess:
                        
                        if ([responseObject[@"error"] integerValue] == 0) {
                            
                            weakSelf.areaArray = responseObject[@"data"];
                            
                            if (weakSelf.areaArray.count) {
                                
                                weakSelf.cityInfo = cityInfo; //设置市Id
                                
                                [weakSelf.dataArray removeAllObjects];
                                
                                [weakSelf.dataArray addObjectsFromArray:weakSelf.areaArray];
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.view hide];
                                
                            } else {
                                
                                [weakSelf.view showFailure:@"暂无数据"];
                            }
                            
                        } else {
                            
                            [weakSelf.view showFailure:@"加载失败 请重试"];
                        }
                        
                        break;
                        
                    default:
                        
                        [weakSelf.view showFailure:@"加载失败 请重试"];
                        
                        break;
                }
                
            }
            
        }];
        
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
    
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCellID];
    
    NSDictionary *info = self.dataArray[indexPath.row];
    
    cell.textLabel.text = info[@"name"];
    
    cell.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    if (![cell.selectedBackgroundView isMemberOfClass:[UIView class]]) cell.selectedBackgroundView = [UIView new];
    
    cell.selectedBackgroundView.lee_theme.LeeConfigBackgroundColor(common_bg_color_6);
    
    // 判断是否为当前位置 (当前位置 id为-1)
    
    if ([info[@"id"] integerValue] == -1) {
        
        cell.textLabel.lee_theme.LeeConfigTextColor(common_bg_blue_4);
        
    } else {
        
        cell.textLabel.lee_theme.LeeConfigTextColor(common_font_color_2);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *info = self.dataArray[indexPath.row];
    
    // 判断是否为当前位置 (当前位置 id为-1)
    
    if ([info[@"id"] integerValue] == -1) {
        
        if (self.currentLocationBlock) self.currentLocationBlock();
    
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
    
        if (self.cityInfo) {
            
            self.areaInfo = info;
            
            if (self.selectedBlock) self.selectedBlock(self.provinceInfo[@"name"] , self.cityInfo[@"name"] , self.areaInfo[@"name"]);
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else if (self.provinceInfo) {
            
            [self loadAreaData:info];
            
        } else {
            
            [self loadCityData:info];
        }
        
    }
    
}

#pragma mark - LazyLoading

- (CommunityPostAPI *)api{
    
    if (!_api) {
        
        _api = [[CommunityPostAPI alloc] init];
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
