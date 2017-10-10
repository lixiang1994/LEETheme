//
//  CommunityCircleListViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleListViewController.h"

#import "CommunityCircleAPI.h"

#import "CommunityCircleListCell.h"

#import "CommunityCircleListCollectionReusableView.h"

#import "CommunityCircleDetailsViewController.h"

#import "LoadingView.h"

@interface CommunityCircleListViewController ()<UICollectionViewDelegateFlowLayout , UICollectionViewDataSource>

@property (nonatomic , strong ) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic , strong ) UICollectionView *collectionView;

@property (nonatomic , strong ) NSMutableArray *dataArray;

@property (nonatomic , strong ) CommunityCircleAPI *api;

@property (nonatomic , strong ) LoadingView *loadingView;

@end

@implementation CommunityCircleListViewController

- (void)dealloc{
    
    _flowLayout = nil;
    
    _collectionView = nil;
    
    _dataArray = nil;
    
    _api = nil;
    
    _loadingView = nil;
}

- (void)viewDidLoad {
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
     .configTitleItemTitle(@"圈子列表")
     .configLeftItemAction(^(){
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    })
     show:self];
}

#pragma mark - 初始化数据

- (void)initData{
    
    _dataArray = [NSMutableArray array];
    
    
    CGFloat width = (self.view.width - 40) / 2;
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _flowLayout.itemSize = CGSizeMake(width , 70.0f);
    
    _flowLayout.minimumInteritemSpacing = 10;
    
    _flowLayout.minimumLineSpacing = 10;
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.width, self.view.height - 64.0f) collectionViewLayout:self.flowLayout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[CommunityCircleListCell class] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerClass:[CommunityCircleListCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    

}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    self.collectionView.top = VIEWSAFEAREAINSETS(self.view).top + 44.0f;
    
    self.collectionView.height = self.view.height - self.collectionView.top;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, VIEWSAFEAREAINSETS(self.view).bottom, 0);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
    
    self.collectionView.lee_theme.LeeConfigBackgroundColor(common_bg_color_5);
}

#pragma mark - 设置Block

- (void)configBlock{
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    [self.loadingView showLoadingProgress];
    
    __weak typeof(self) weakSelf = self;
    
    [self.api loadCircleListDataResultBlock:^(RequestResultType requestResultType, id responseObject) {
       
        __strong typeof(weakSelf) strongSelf = self;
        
        if (strongSelf) {
            
            switch (requestResultType) {
                
                case RequestResultTypeSuccess:
                
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        [strongSelf.api analyticalCircleListDataWithData:responseObject ResultBlock:^(NSMutableArray *array) {
                           
                            if (array.count) {
                                
                                [strongSelf.dataArray addObjectsFromArray:array];
                                
                                [strongSelf.collectionView reloadData];
                                
                                [strongSelf.loadingView hiddenLoadingView];
                            
                            } else {
                                
                                [strongSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:strongSelf action:@selector(loadData)];
                            }
                            
                        }];
                        
                    } else {
                        
                        [strongSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:strongSelf action:@selector(loadData)];
                    }
                    
                    break;
                    
                default:
                    
                    [strongSelf.loadingView showLoadingNoDataWithText:@"加载失败 点击重试" AddTarget:strongSelf action:@selector(loadData)];
                    
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout , UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityCircleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.section][indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityCircleModel *model = self.dataArray[indexPath.section][indexPath.item];
    
    if (self.isSelect) {
        
        if (self.selectedBlock) self.selectedBlock(model);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
    
        CommunityCircleDetailsViewController *vc = [[CommunityCircleDetailsViewController alloc] init];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.circleId = model.circleId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.collectionView.width, 50.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    CommunityCircleModel *firstModel = [self.dataArray[indexPath.section] firstObject];
    
    CommunityCircleListCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    [view configTitle:firstModel.circleGroupName];
    
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64 - 44)];
        
        [self.view addSubview:_loadingView];
    }
    
    return _loadingView;
}

@end
