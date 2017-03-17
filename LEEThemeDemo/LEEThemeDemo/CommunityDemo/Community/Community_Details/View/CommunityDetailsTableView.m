//
//  CommunityDetailsTableView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsTableView.h"

#import "SDAutoLayout.h"

#import "MJRefresh.h"

#import "CorrelationStateManager.h"

#import "CommunityCommentCell.h"

#import "CommunityDetailsCommentCellHeaderView.h"

#import "LoadingView.h"

#import "LEEAlert.h"

#import "MierProgressHUD.h"

#import "CommunityCommentAPI.h"

#import "CommunityCommentListAPI.h"

#import "AppDelegate.h"

@interface CommunityDetailsTableView ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) NSMutableDictionary *commentModelDic; //评论数据模型字典 [key 评论ID : value 数据模型]

@property (nonatomic , strong ) NSMutableArray *hotDataArray; //热门评论数据源数组

@property (nonatomic , strong ) NSMutableArray *allDataArray; //全部评论数据源数组

@property (nonatomic , assign ) NSInteger totalCommentCount; //全部评论数量

@property (nonatomic , assign ) NSInteger page; //页数

@property (nonatomic , strong ) CommunityCommentAPI *commentApi; //评论Api

@property (nonatomic , strong ) CommunityCommentListAPI *commentListApi; //评论列表Api

@property (nonatomic , strong ) UIMenuController *menuController;

@property (nonatomic , strong ) NSIndexPath *selectIndexPath; //选中的indexPath

@property (nonatomic , assign ) BOOL isMenuVisible; //菜单是否显示

@end

static NSString * const CommunityCommentCellID = @"CommunityCommentCell";

static NSString * const CommunityDetailsCommentCellHeaderViewID = @"CommunityDetailsCommentCellHeaderView";

@implementation CommunityDetailsTableView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tableHeaderView = nil;
    
    self.delegate = nil;
    
    self.dataSource = nil;
    
    _commentModelDic = nil;
    
    _hotDataArray = nil;
    
    _allDataArray = nil;
    
    _commentApi = nil;
    
    _commentListApi = nil;
    
    _menuController = nil;
    
    _selectIndexPath = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        //添加通知
        
        [self addNotification];
        
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

#pragma mark - 添加通知

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuControllerNotify:) name:UIMenuControllerWillShowMenuNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenuControllerNotify:) name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void)showMenuControllerNotify:(NSNotification *)notify{
    
    self.isMenuVisible = YES;
}

- (void)hideMenuControllerNotify:(NSNotification *)notify{
    
    self.isMenuVisible = NO;
}

#pragma mark - 初始化数据

- (void)initData{
    
    _commentModelDic = [NSMutableDictionary dictionary];
    
    _hotDataArray = [NSMutableArray array];
    
    _allDataArray = [NSMutableArray array];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerClass:[CommunityCommentCell class] forCellReuseIdentifier:CommunityCommentCellID];
    
    [self registerClass:[CommunityDetailsCommentCellHeaderView class] forHeaderFooterViewReuseIdentifier:CommunityDetailsCommentCellHeaderViewID];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
}

#pragma mark - 设置Block

- (void)configBlock{
    
}

#pragma mark - 设置刷新

- (void)configRefresh{
    
    __weak typeof(self) weakSelf = self;
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (weakSelf){
            
            [weakSelf loadDataWithPage:weakSelf.page + 1 ResultBlock:^(BOOL result) {
                
                if (!weakSelf) return;
                    
                if (result) weakSelf.page += 1;
            }];
            
        }
        
    }];
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    //加载新数据
    
    [self.mj_footer beginRefreshing];
}

- (void)loadDataWithPage:(NSInteger)page ResultBlock:(void(^)(BOOL result))resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    //加载数据
    
    [self.commentListApi loadCommentListDataWithID:self.model.postId CircleId:self.model.circleModel.circleId Page:page ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                {
                    
                    if ([responseObject[@"error"] integerValue] == 0) {
                        
                        //解析数据 (异步)
                        
                        [strongSelf.commentListApi analyticalCommentListDataWithData:responseObject ResultBlock:^(NSDictionary *result) {
                            
                            NSArray *hotCommentArray = result[@"hotCommentArray"];
                            
                            NSArray *allCommentArray = result[@"allCommentArray"];
                            
                            if (result[@"totalCommentCount"]) {
                                
                                strongSelf.totalCommentCount = [result[@"totalCommentCount"] integerValue];
                            }
                            
                            if (hotCommentArray.count) {
                                
                                [strongSelf.hotDataArray removeAllObjects];
                                
                                for (CommunityCommentModel *model in hotCommentArray) {
                                    
                                    //添加数据模型
                                    
                                    [strongSelf.commentModelDic setObject:model forKey:model.commentId];
                                    
                                    //添加评论ID (对应字典的key)
                                    
                                    [strongSelf.hotDataArray addObject:model.commentId];
                                }
                                
                            }
                            
                            if (allCommentArray.count) {
                                
                                for (CommunityCommentModel *model in [strongSelf filterRepeatCommentsWithNewDataArray:allCommentArray]) {
                                    
                                    //添加数据模型
                                    
                                    [strongSelf.commentModelDic setObject:model forKey:model.commentId];
                                    
                                    //添加评论ID (对应字典的key)
                                    
                                    [strongSelf.allDataArray addObject:model.commentId];
                                }
                                
                                //判断当前加载的页数 大于1为上拉刷新 等于1为下拉刷新或第一次加载
                                
                                if (page == 1) {
                                    
                                    strongSelf.page = 1; //重置页数
                                    
                                    [strongSelf reloadData];
                                    
                                } else {
                                    
                                    [strongSelf reloadDataWithExistedHeightCache];
                                }
                                
                                //结束刷新
                                
                                [strongSelf.mj_footer endRefreshing];
                                
                            } else {
                                
                                //提示没有更多评论
                                
                                [strongSelf.mj_footer endRefreshingWithNoMoreData];
                            }
                            
                            if (resultBlock) resultBlock(allCommentArray.count ? YES : NO);
                        }];
                        
                    } else {
                        
                        if (resultBlock) resultBlock(NO);
                    }
                    
                }
                    break;
                    
                default:
                {
                    if (resultBlock) resultBlock(NO);
                }
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 过滤重复的评论数据

- (NSArray *)filterRepeatCommentsWithNewDataArray:(NSArray *)newDataArray{
    
    if (newDataArray && newDataArray.count) {
        
        NSMutableArray *tempNewsDataArray = [NSMutableArray array];
        
        NSMutableArray *tempOldDataArray = self.allDataArray;
        
        for (CommunityCommentModel *model in newDataArray) {
            
            NSArray *result = [tempOldDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@" , model.commentId]];
            
            if (!result.count) {
                
                [tempNewsDataArray addObject:model];
            }
            
        }
        
        return tempNewsDataArray;
    }
    
    return nil;
}


#pragma mark - 获取数据模型

- (void)setModel:(CommunityDetailsModel *)model{
    
    _model = model;
    
    [self loadData];
}

#pragma mark - 发表评论

- (void)sendComment:(NSString *)comment RootComment:(CommunityCommentModel *)rootComment ResultBlock:(void (^)(BOOL))resultBlock{
    
    [MierProgressHUD showLoading:@"正在发表.."];
    
    __weak typeof(self) weakSelf = self;
    
    [self.commentApi sendCommentDataWithPostId:self.model.postId PostAuthorId:self.model.authorId Content:comment RootCommentId:rootComment.commentId RootCommentUserId:rootComment.userId ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                {
                    //请求成功
                    
                    //生成评论模型 插入列表
                    
                    NSDictionary *info = responseObject[@"data"];
                    
                    CommunityCommentModel *model = [[CommunityCommentModel alloc] init];
                    
                    model.commentId = [NSString stringWithFormat:@"%@" , info[@"commentId"]];
                    
                    model.commentContent = comment;
                    
                    model.userId = @"当前用户Id";
                    
                    model.userImg = @"当前用户头像";
                    
                    model.userName = @"当前用户昵称";
                    
                    model.userLevel = 6; //当前用户等级
                    
                    model.praiseCount = 0;
                    
                    model.publishTime = @"刚刚";
                    
                    if (rootComment) model.replysArray = @[@{@"id" : rootComment.commentId ,
                                                             @"userName" : rootComment.userName ,
                                                             @"content" : rootComment.commentContent}];
                    
                    //插入
                    
                    [strongSelf insertComment:model];
                    
                    //更新用户数据
                    
                    //提示成功
                    
                    [MierProgressHUD showSuccess:@"评论成功"];
                    
                    if (resultBlock) resultBlock(YES);
                }
                    break;
                    
                case RequestResultTypeNetWorkStatusNone:
                    
                    //无网络
                    
                    if (resultBlock) resultBlock(NO);
                    
                    [MierProgressHUD showFailure:@"无网络连接"];
                    
                    break;
                    
                default:
                    
                    //请求失败
                    
                    if (resultBlock) resultBlock(NO);
                    
                    [MierProgressHUD showFailure:@"评论失败"];
                    
                    break;
                    
            }
            
        }
        
    }];
    
}

#pragma mark - 插入评论

- (void)insertComment:(CommunityCommentModel *)commentModel{
    
    if (commentModel) {
        
        //插入评论
        
        [self.commentModelDic setObject:commentModel forKey:commentModel.commentId];
        
        [self.allDataArray insertObject:commentModel.commentId atIndex:0];
        
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - 评论点赞

- (void)praiseComment:(CommunityCommentModel *)model Cell:(CommunityCommentCell *)cell{
    
//    //判断点赞权限
//    
//    if (![PermissionManager praisePermit]) {
//    
//        //更新点赞状态
//        
//        model.isPraise = NO;
//        
//        [cell checkPraise];
//        
//        return;
//    }
    
    //该评论已删除
    
    if (model.checkState == 2){
        
        [MierProgressHUD showMessage:@"该评论已删除，不能点赞！"];
        
        //更新点赞状态
        
        model.isPraise = NO;
        
        [cell checkPraise];
        
        return;
    }
    
    //设置点赞数
    
    model.praiseCount = model.praiseCount + 1;
    
    //更新点赞状态
    
    model.isPraise = YES;
    
    //更新点赞数
    
    [cell updatePraiseCount];
    
    //更新数据模型
    
    [self.commentModelDic setObject:model forKey:model.commentId];
    
    //更新存在的cell
    
    [self reloadCommentCellWithModel:model ExceptCell:cell];
    
    //请求点赞
    
    [self.commentApi praiseCommentDataWithCommentId:model.commentId PostId:self.model.postId CircleId:self.model.circleModel.circleId AuthorId:self.model.authorId AuthorName:self.model.authorName Title:self.model.title ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        switch (requestResultType) {
                
            case RequestResultTypeSuccess:
                
                //添加相关状态
                
                [CorrelationStateManager addType:CorrelationTypeCommunityComment State:CorrelationStatePraise Identifier:model.commentId];
                
                break;
                
            default:
                
                break;
        }
        
    }];
    
}

#pragma mark - 评论删除

- (void)deleteComment:(CommunityCommentModel *)model{
    
    [self.superview showLoading:@"正在删除，请稍后..."];
    
    __weak typeof(self)weakSelf = self;
    
    [self.commentApi deleteCommentDataWithCommentId:model.commentId ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf){
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                {
                    [MierProgressHUD showMessage:@"删除成功"];
                    
                    NSArray *indexPathArray = [strongSelf getSameCommentIndexPathWithModel:model];
                    
                    [strongSelf.commentModelDic removeObjectForKey:model.commentId];
                    
                    [strongSelf.hotDataArray removeObject:model.commentId];
                    
                    [strongSelf.allDataArray removeObject:model.commentId];
                    
                    [strongSelf deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
                }
                    break;
                    
                case RequestResultTypeNetWorkStatusNone:
                    
                    [MierProgressHUD showMessage:@"网络不佳"];
                    
                    break;
                    
                default:
                    
                    [MierProgressHUD showMessage:@"删除失败，请重试！"];
                    
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 回复菜单项点击事件

- (void)replyItemClick{
    
    CommunityCommentModel *model = [self getCommentModelWithIndexPath:self.selectIndexPath];
    
    //该评论已删除
    
    if (model.checkState == 2){
        
        [MierProgressHUD showMessage:@"该评论已删除，不能进行回复！"];
        
        return;
    }
    
    if (self.openReplyBlock){
        
        self.openReplyBlock(model , [NSString stringWithFormat:@"回复%@:" , model.userName]);
    }
    
}

#pragma mark - 点赞菜单项点击事件

- (void)praiseItemClick{
    
    CommunityCommentCell *cell = [self cellForRowAtIndexPath:self.selectIndexPath];
    
    [cell praiseClick];
}

#pragma mark - 复制菜单项点击事件

- (void)copyItemClick{
    
    CommunityCommentModel *model = [self getCommentModelWithIndexPath:self.selectIndexPath];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = model.commentContent;
    
    [MierProgressHUD showMessage:@"已复制"];
}

#pragma mark - 举报菜单项点击事件

- (void)reportItemClick{
    
    CommunityCommentModel *model = [self getCommentModelWithIndexPath:self.selectIndexPath];
    
    //该评论已删除
    
    if (model.checkState == 2){
        
        [MierProgressHUD showMessage:@"该评论已删除，不能举报！"];
        
        return;
    }
    
    //打开举报评论
    
    if ([CorrelationStateManager checkType:CorrelationTypeCommunityComment State:CorrelationStateReport Identifier:model.commentId]){

        [MierProgressHUD showMessage:@"你已经举报过该评论" ];
        
        return;
    }
    
    [self showReportCommentAlertViewWithCommentID:model.commentId];
}

#pragma mark - 显示举报评论确认弹框

- (void)showReportCommentAlertViewWithCommentID:(NSString *)commentId{
    
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert alert].custom.config
    .LeeTitle(@"提示")
    .LeeCancelButtonTitle(@"取消")
    .LeeContent(@"长官：你确定要举报该评论吗？")
    .LeeAddButton(@"确定", ^(){
        
        __strong typeof(self) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            [strongSelf.commentApi reportCommentDataWithCommentId:commentId ResultBlock:^(RequestResultType requestResultType, id responseObject) {
                
                if (requestResultType == RequestResultTypeSuccess){
                    
                    [MierProgressHUD showMessage:@"举报成功"];
                    
                    //添加相关状态
                    
                    [CorrelationStateManager addType:CorrelationTypeCommunityComment State:CorrelationStateReport Identifier:commentId];
                    
                } else {
                    
                    [MierProgressHUD showMessage:@"网络不佳"];
                }
                
            }];
            
        }
        
    })
    .LeeShow();
}

#pragma mark - 获取相同评论的IndexPath

- (NSArray *)getSameCommentIndexPathWithModel:(CommunityCommentModel *)model{
    
    return [self getSameCommentIndexPathWithModel:model ExceptIndexPath:nil];
}

#pragma mark - 获取相同评论的IndexPath   ExceptIndexPath为除外的indexPath

- (NSArray *)getSameCommentIndexPathWithModel:(CommunityCommentModel *)model ExceptIndexPath:(NSIndexPath *)exceptIndexPath{
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    if (self.hotDataArray.count) {
        
        if ([self.hotDataArray indexOfObject:model.commentId] != NSNotFound) {
            
            [indexPathArray addObject:[NSIndexPath indexPathForRow:[self.hotDataArray indexOfObject:model.commentId] inSection:0]];
        }
        
    }
    
    if (self.allDataArray.count) {
        
        if ([self.allDataArray indexOfObject:model.commentId] != NSNotFound) {
            
            [indexPathArray addObject:[NSIndexPath indexPathForRow:[self.allDataArray indexOfObject:model.commentId] inSection:1]];
        }
        
    }
    
    //判断是否有除外的IndexPath 如果有找出并移除
    
    if (exceptIndexPath) {
        
        for (NSIndexPath *indexPath in indexPathArray) {
            
            if ([indexPath compare:exceptIndexPath] == NSOrderedSame) {
                
                [indexPathArray removeObject:indexPath];
                
                break;
            }
            
        }
        
    }
    
    return indexPathArray;
}

#pragma mark - 更新相同评论的Cell

- (void)reloadCommentCellWithModel:(CommunityCommentModel *)commentModel{
    
    [self reloadRowsAtIndexPaths:[self getSameCommentIndexPathWithModel:commentModel] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 更新相同评论的Cell ExceptCell为除外Cell

- (void)reloadCommentCellWithModel:(CommunityCommentModel *)commentModel ExceptCell:(CommunityCommentCell *)cell{
    
    [self reloadRowsAtIndexPaths:[self getSameCommentIndexPathWithModel:commentModel ExceptIndexPath:[self indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 根据IndexPath获取评论数据模型

- (id)getCommentModelWithIndexPath:(NSIndexPath *)indexPath{
    
    id model = nil;
    
    if (indexPath.section == 0) {
        
        model = [self.commentModelDic objectForKey:self.hotDataArray[indexPath.row]];
        
    } else {
        
        model = [self.commentModelDic objectForKey:self.allDataArray[indexPath.row]];
    }
    
    return model;
}

#pragma mark - 根据section获取评论数

- (NSInteger)getCommentCountWithSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.hotDataArray.count;
        
    } else {
        
        return self.allDataArray.count;
    }
    
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self getCommentCountWithSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityCommentModel *model = [self getCommentModelWithIndexPath:indexPath];
    
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CommunityCommentCell class] contentViewWidth:tableView.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = [self getCommentModelWithIndexPath:indexPath];
    
    CommunityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityCommentCellID];
    
    cell.model = model;
    
    cell.isMaster = [self.model.authorId isEqualToString:cell.model.userId];
    
    __weak typeof(self) weakSelf = self;
    
    cell.reloadCellBlock = ^(){
        
        if (weakSelf) {
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    };
    
    cell.openUserHomeBlock = ^(CommunityCommentModel *commentModel){
        
        if (weakSelf) {
            
            if (weakSelf.openUserHomeBlock) weakSelf.openUserHomeBlock(commentModel.userId , commentModel.userName);
        }
        
    };
    
    cell.praiseBlock = ^(CommunityCommentModel *commentModel , CommunityCommentCell *cell){
        
        if (weakSelf) {
            
            [weakSelf praiseComment:commentModel Cell:cell];
        }
        
    };
    
    cell.deleteBlock = ^(CommunityCommentModel *commentModel){
        
        if (weakSelf) {
            
            [weakSelf.menuController setMenuVisible:NO];
            
            [LEEAlert alert].custom.config
            .LeeTitle(@"提示")
            .LeeCancelButtonTitle(@"取消")
            .LeeContent(@"长官：你确定要删除该评论吗？")
            .LeeAddButton(@"确定", ^(){
                
                if (weakSelf) [weakSelf deleteComment:commentModel];
            })
            .LeeShow();
        }
        
    };
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self becomeFirstResponder];
    
    //坐标转换
    
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    
    CGRect rect = [tableView convertRect:cellRect toView:self];
    
    [self.menuController setTargetRect:rect inView:self];
    
    //暂时没卵用 待解决
    
    if ((rect.origin.y + rect.size.height / 2) > (CGRectGetHeight(self.window.frame) / 2)){
        
        self.menuController.arrowDirection = UIMenuControllerArrowDown;
        
    } else {
        
        self.menuController.arrowDirection = UIMenuControllerArrowUp;
    }
    
    if (self.selectIndexPath == indexPath) {
        
        [self.menuController setMenuVisible:!self.isMenuVisible animated:YES];
        
    } else {
        
        self.selectIndexPath = indexPath;
        
        [self.menuController setMenuVisible:YES animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self getCommentCountWithSection:section]) {
        
        return 50.0f;
        
    } else {
        
        return 0.0001f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CommunityDetailsCommentCellHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CommunityDetailsCommentCellHeaderViewID];
    
    switch (section) {
            
        case 0:
            
            [view configTitle:@"精彩评论" Count:self.hotDataArray.count];
            
            break;
            
        case 1:
            
            [view configTitle:@"全部评论" Count:self.totalCommentCount];
            
            break;
            
        default:
            break;
    }
    
    return view;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.menuController.menuVisible) [self.menuController setMenuVisible:NO animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //调用滑动block
    
    if (self.scrollBlock) self.scrollBlock(scrollView.contentOffset);
}

#pragma mark - 配置MenuController

- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(replyItemClick) ||
        action == @selector(praiseItemClick) ||
        action == @selector(copyItemClick) ||
        action == @selector(reportItemClick)) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - LazyLoading

- (CommunityCommentAPI *)commentApi{
    
    if (!_commentApi) {
        
        _commentApi = [[CommunityCommentAPI alloc] init];
    }
    
    return _commentApi;
}

- (CommunityCommentListAPI *)commentListApi{
    
    if (!_commentListApi) {
        
        _commentListApi = [[CommunityCommentListAPI alloc] init];
    }
    
    return _commentListApi;
}

- (UIMenuController *)menuController{
    
    if (!_menuController){
        
        UIMenuItem *replyItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replyItemClick)];
        
        UIMenuItem *praiseItem = [[UIMenuItem alloc] initWithTitle:@"点赞" action:@selector(praiseItemClick)];
        
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItemClick)];
        
        UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(reportItemClick)];
        
        _menuController = [UIMenuController sharedMenuController];
        
        [_menuController setMenuItems:[NSArray arrayWithObjects:replyItem, praiseItem, copyItem, reportItem, nil]];
    }
    
    return _menuController;
}

@end
