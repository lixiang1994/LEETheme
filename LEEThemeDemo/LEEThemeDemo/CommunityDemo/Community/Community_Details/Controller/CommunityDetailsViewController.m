//
//  CommunityDetailsViewController.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsViewController.h"

#import "SDAutoLayout.h"

#import "MierProgressHUD.h"

#import "LoadingView.h"

#import "AllShareView.h"

#import "NewsToolbarView.h"

#import "PublishCommentView.h"

#import "CommunityDetailsTableView.h"

#import "CommunityDetailsContentView.h"

#import "CommunityCircleDetailsViewController.h"

@interface CommunityDetailsViewController ()

@property (nonatomic , strong ) UIButton *circleButton; //导航栏圈子按钮

@property (nonatomic , strong ) CommunityDetailsContentView *headerView; //列表头部视图

@property (nonatomic , strong ) CommunityDetailsTableView *tableView;

@property (nonatomic , strong ) PublishCommentView *publishCommentView;//发表评论视图

@property (nonatomic , strong ) LoadingView *loadingView; //加载视图

@property (nonatomic , strong ) NewsToolbarView *toolbar; //工具栏

@property (nonatomic , strong ) CommunityDetailsAPI *api;

@property (nonatomic , strong ) CommunityDetailsModel *model; //社区详情数据模型

@end

@implementation CommunityDetailsViewController

- (void)dealloc{
    
    _tableView.tableHeaderView = nil;
    
    _tableView = nil;
    
    [_headerView releaseHandle];
    
    _headerView = nil;
    
    _publishCommentView = nil;
    
    _loadingView = nil;
    
    _toolbar = nil;
    
    _api = nil;
    
    _model = nil;
    
    _circleId = nil;
    
    _postId = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
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
    
    //设置工具栏
    
    [self configToolBar];
    
    //加载数据
    
    [self loadData];
    
}

#pragma mark - 设置NavigationBar

- (void)configNavigationBar{
    
    //初始化控件
    
    _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _circleButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _circleButton.lee_theme.LeeConfigButtonTitleColor(common_font_color_4 , UIControlStateNormal);
    
    [_circleButton addTarget:self action:@selector(openCircleDetailsViewController) forControlEvents:UIControlEventTouchUpInside];
    
    //设置控件
    
    __weak typeof(self) weakSelf = self;
    
    [[MierNavigationBar bar]
     .configStyle(MierNavigationBarStyleTypeWhite)
     .configLeftItemAction(^(){
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    })
     .configTitleItemTitle(@"                       ") //空格占位
     .configTitleItemAction(^(){
        
        if (weakSelf) {
            
            //列表滑到到顶部
            
            [weakSelf.tableView setContentOffset:CGPointZero animated:YES];
        }
        
    })
     .configRightItemView(self.circleButton)
     show:self];
    
    //布局控件
    
    _circleButton.sd_layout
    .leftSpaceToView(self.circleButton.superview , 5.0f)
    .centerYEqualToView(self.circleButton.superview)
    .heightIs(44.0f);
    
    _circleButton.imageView.sd_layout
    .leftEqualToView(self.circleButton)
    .centerYEqualToView(self.circleButton)
    .widthIs(20.0f)
    .heightIs(20.0f);
    
    _circleButton.titleLabel.sd_layout
    .leftSpaceToView(self.circleButton.imageView , 5.0f)
    .centerYEqualToView(self.circleButton)
    .heightIs(20.0f);
    
    [_circleButton.titleLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    [_circleButton setupAutoWidthWithRightView:self.circleButton.titleLabel rightMargin:0.0f];
}

#pragma mark - 设置工具栏

- (void)configToolBar{
    
    //初始化工具栏
    
    _toolbar = [NewsToolbarView toolbar];
    
    [self.view addSubview:_toolbar];
    
    __weak typeof(self) weakSelf = self;
    
    _toolbar
    .configEditItem(^(){
        
        if (weakSelf) {
            
            //发表评论
            
            [weakSelf.publishCommentView configPlaceHolderWithText:@"参与评论可升级军衔"];
            
            [weakSelf.publishCommentView configContext:nil];
            
            [weakSelf.publishCommentView show];
        }
        
    })
    .configFavItem(^(){
        
        if (weakSelf) {
            
            //收藏
            
            [weakSelf favButtonClick];
        }
        
    })
    .configShareItem(^(){
        
        if (weakSelf) {
            
            //分享
            
            [weakSelf openShare];
        }
        
    })
    .configStyle(NewsToolbarStyleTypeNormal);
    
    [_toolbar show];
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //初始化详情列表视图
    
    _tableView = [[CommunityDetailsTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    
    //初始化头部视图
    
    _headerView = [[CommunityDetailsContentView alloc]initWithFrame:CGRectMake(0, 0 , CGRectGetWidth(self.tableView.frame) , CGRectGetHeight(self.tableView.frame))];
    
    _headerView.api = self.api;
    
    self.tableView.tableHeaderView = _headerView;
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
}

#pragma mark - 设置Block

- (void)configBlock{
    
    __weak typeof(self) weakSelf = self;
    
    self.headerView.loadedFinishBlock = ^(){
        
        if (weakSelf) {
            
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            
            weakSelf.tableView.model = weakSelf.model;
            
            [weakSelf.loadingView hiddenLoadingView];
            
            weakSelf.toolbar.userInteractionEnabled = YES; //启用工具栏
            
            [UIView animateWithDuration:0.25f animations:^{
                
                if (weakSelf) weakSelf.tableView.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                if (weakSelf) [weakSelf.headerView updateWebViewHeight];
            }];
            
        }
        
    };
    
    self.headerView.updateHeightBlock = ^(){
        
        if (weakSelf) {
            
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        }
        
    };
    
    self.headerView.deleteBlock = ^(){
        
        if (weakSelf) {
            
            if (weakSelf.deleteBlock) weakSelf.deleteBlock(weakSelf.postId);
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    };
    
    self.headerView.openUserHomeBlock = ^(){
        
        if (weakSelf) {
            
            //打开用户主页
            
            [weakSelf openUserHomeViewControllerWithUid:weakSelf.model.authorId UserName:weakSelf.model.authorName];
        }
        
    };
    
    self.tableView.openUserHomeBlock = ^(NSString *uid , NSString *username){
        
        if (weakSelf) {
            
            //打开用户主页
            
            [weakSelf openUserHomeViewControllerWithUid:uid UserName:username];
        }
        
    };
    
    self.tableView.openReplyBlock = ^(CommunityCommentModel *model , NSString *placeholder){
        
        if (weakSelf) {
            
            [weakSelf.publishCommentView configPlaceHolderWithText:placeholder];
            
            [weakSelf.publishCommentView configContext:model];
            
            [weakSelf.publishCommentView show];
        }
        
    };
    
    self.tableView.scrollBlock = ^(CGPoint contentOffset){
        
        if (weakSelf) {
            
            [weakSelf.headerView updateWebViewHeight];
        }
        
    };
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    //禁用工具栏
    
    self.toolbar.userInteractionEnabled = NO;
    
    //隐藏列表视图
    
    self.tableView.alpha = 0.0f;
    
    [self.loadingView showLoadingProgress];
    
    __weak typeof(self) weakSelf = self;
    
    [self.api loadPostDetailsDataWithPostId:self.postId CircleId:self.circleId ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = self;
        
        if (strongSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        //解析数据 (异步)
                        
                        [strongSelf.api analyticalDataWithData:responseObject ResultBlock:^(CommunityDetailsModel *model) {
                            
                            if (model) {
                                
                                strongSelf.model = model;
                                
                                strongSelf.headerView.model = model;
                                
                                //strongSelf.tableView.model = model;
                                
                                [strongSelf.circleButton setTitle:model.circleModel.circleName forState:UIControlStateNormal];
                                
                                [strongSelf.circleButton setImageWithURL:[NSURL URLWithString:model.circleModel.circleImageUrl] forState:UIControlStateNormal options:YYWebImageOptionSetImageWithFadeAnimation];
                                
                                //检测是否收藏
                                
                                [strongSelf checkFav];
                                
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

#pragma mark - 检查收藏状态

- (void)checkFav{
    
    //更新收藏状态
    
    self.toolbar.configFavItemState(YES);
}

#pragma mark - 收藏按钮点击

- (void)favButtonClick{
    
    //检查收藏许可
    /*
    if ([PermissionManager collectPermit]) {
        
        if (![CoreStatus isNetworkEnable]) {
            
            [self.view showMessage:@"无网络连接"];
            
            self.toolbar.configFavItemState([CollectionManager checkDataWithType:CollectionTypePost Identifier:self.model.postId]);
            
            return;
        }
     
        __weak typeof(self) weakSelf = self;
        
        //判断是否已收藏
        
        if ([CollectionManager checkDataWithType:CollectionTypePost Identifier:self.model.postId]) {
            
            //删除
            
            [CollectionManager deleteDataWithType:CollectionTypePost Identifier:self.model.postId ResultBlock:^(BOOL result) {
                
                if (weakSelf) {
                    
                    if (result){
                        
                        [weakSelf.view showRemoveFavorites:@"已取消"];
                        
                        //更新收藏状态
                        
                        weakSelf.toolbar.configFavItemState(NO);
                        
                    } else {
                        
                        [weakSelf.view showFailure:@"取消失败"];
                        
                        //更新收藏状态
                        
                        weakSelf.toolbar.configFavItemState(YES);
                    }
                    
                }
                
            }];
            
        } else {
            
            //增加
            
            [CollectionManager addDataWithType:CollectionTypePost Identifier:self.model.postId Model:self.model ResultBlock:^(BOOL result) {
                
                if (weakSelf) {
                    
                    if (result){
                        
                        [weakSelf.view showAddFavorites:@"收藏成功"];
                        
                        //更新收藏状态
                        
                        weakSelf.toolbar.configFavItemState(YES);
                        
                    } else {
                        
                        [weakSelf.view showFailure:@"收藏失败"];
                        
                        //更新收藏状态
                        
                        weakSelf.toolbar.configFavItemState(NO);
                    }
                    
                }
                
            }];
            
        }
        
    }
    */
}

#pragma mark - 发表评论

- (void)publishCommentWithText:(NSString *)text Context:(id)context{
    
    //1分钟重复发送判断
    
    //请求发送评论
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView sendComment:text RootComment:context ResultBlock:^(BOOL result) {
        
        if (weakSelf) {
            
            if (result) {
                
                //清空评论内容
                
                [weakSelf.publishCommentView clear];
            }
            
        }
        
    }];
    
}

#pragma mark - 打开分享

- (void)openShare{
    
    __weak typeof(self) weakSelf = self;
    
    AllShareView *shareView = [[AllShareView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , 0) ShowMore:YES];
    
    shareView.OpenShareBlock = ^(ShareType type){
        
        if (weakSelf) {
            
            [weakSelf.view showLoading:@""];
            
            //下载分享图片 完成后执行分享
            
            [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:weakSelf.model.shareImageUrl] options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                
            } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                return image;
                
            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                if (weakSelf) {
                    
                    if (!image) {
                        
                        image = [UIImage imageNamed:@"shareImage"];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // 开始分享
                        
                        [MierProgressHUD hide];
                    });
                    
                }
                
            }];
            
        }
        
    };
    
    shareView.OpenMoreBlock = ^(MoreType type){
      
        switch (type) {
            
            case MoreTypeToTheme:
            {
                
                // 切换主题
                
                if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
                    
                    [LEETheme startTheme:NIGHT];
                    
                } else {
                    
                    [LEETheme startTheme:DAY];
                }
                
            }
                break;
                
            default:
                break;
        }
        
    };
    
    [shareView show];
}

#pragma mark - 打开圈子详情

- (void)openCircleDetailsViewController{
    
    if (self.model) {
        
        CommunityCircleDetailsViewController *vc = [[CommunityCircleDetailsViewController alloc] init];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.circleId = self.model.circleModel.circleId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 打开用户主页

- (void)openUserHomeViewControllerWithUid:(NSString *)uid UserName:(NSString *)username{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LazyLoading

- (CommunityDetailsAPI *)api{
    
    if (!_api) {
        
        _api = [[CommunityDetailsAPI alloc] init];
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

- (PublishCommentView *)publishCommentView{
    
    if (!_publishCommentView) {
        
        _publishCommentView = [[PublishCommentView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        _publishCommentView.publishCommentAndContextBlock = ^(NSString *text , id context){
            
            if (weakSelf) {
                
                //发表评论
                
                [weakSelf publishCommentWithText:text Context:context];
            }
            
        };
        
    }
    
    return _publishCommentView;
}

@end
