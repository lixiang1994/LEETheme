//
//  MierPhotoBrowser.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/18.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "MierPhotoBrowser.h"

#import "MierProgressHUD.h"

@class MierPhotoBrowserCell;

@interface MierPhotoBrowser ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong ) UICollectionView *collectionView; //集合视图

@property (nonatomic , strong ) UICollectionViewFlowLayout *flowLayout; //布局

@property (nonatomic , strong ) UIView *topView;

@property (nonatomic , strong ) UIView *bottomView;

@property (nonatomic , strong ) UILabel *pageLable; //页码Label

@property (nonatomic , strong ) UIButton *saveButton; //保存按钮

@property (nonatomic , strong ) UIImageView *tempImageView; //临时视图

@property (nonatomic , assign ) NSInteger currentIndex; //当前下标

@end

@implementation MierPhotoBrowser

- (void)dealloc{
    
    _imageUrlArray = nil;
    
    _collectionView = nil;
    
    _flowLayout = nil;
    
    _pageLable = nil;
    
    _saveButton = nil;
    
    _tempImageView = nil;
}

+ (MierPhotoBrowser *)browser{
    
    return [[MierPhotoBrowser alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化数据
        
        [self initData];
        
        //初始化视图
        
        [self initSubView];
        
        //设置自动布局
        
        [self configAutoLayout];
        
        //设置主题模式
        
        [self configTheme];
        
    }
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    // 初始化flowLayout
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置单元格的左右最小间距
    
    _flowLayout.minimumInteritemSpacing = 0;
    
    // 设置单元格的上下最小间距
    
    _flowLayout.minimumLineSpacing = 0;
    
    // 设置滑动方向
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置边界
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 初始化集合视图
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
    
    _collectionView.hidden = YES;
    
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[MierPhotoBrowserCell class] forCellWithReuseIdentifier:@"CELL"];
    
    [self addSubview:_collectionView];
    
    // 初始化顶部视图
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20.0f)];
    
    [self addSubview:_topView];
    
    // 初始化底部视图
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 80, self.frame.size.width, 80)];
    
    [_bottomView.layer addSublayer:[self shadowAsInverseWithSize:CGSizeMake(self.frame.size.width, 80)]];
    
    [self addSubview:_bottomView];
    
    // 初始化页码Label
    
    _pageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 20)];
    
    _pageLable.textColor = [UIColor whiteColor];
    
    _pageLable.font = [UIFont systemFontOfSize:16.0f];
    
    _pageLable.textAlignment = NSTextAlignmentCenter;
    
    [self.bottomView addSubview:_pageLable];
    
    //初始化保存按钮
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _saveButton.hidden = YES;
    
    _saveButton.frame = CGRectMake(self.frame.size.width - 60.0f, 20.0f, 40.0f, 40.0f);
    
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_saveButton addTarget:self action:@selector(saveImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:_saveButton];
}

#pragma mark - 设置自动布局

-(void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
}

#pragma mark - 获取图片Url数组

- (void)setImageUrlArray:(NSArray *)imageUrlArray{
    
    if (imageUrlArray && imageUrlArray.count) {
        
        //处理Url对象类型
        
        NSMutableArray *tempImageUrlArray = [NSMutableArray array];
        
        for (id url in imageUrlArray) {
            
            if ([url isKindOfClass:[NSString class]]) {
                
                [tempImageUrlArray addObject:[NSURL URLWithString:url]];
                
            } else if ([url isKindOfClass:[NSURL class]]) {
                
                [tempImageUrlArray addObject:url];
                
            } else {
                
                NSLog(@"图片Url对象类型错误 应为NSUrl或NSString. [当前类型: %@]" , NSStringFromClass([url class]));
            }
            
        }
        
        if (imageUrlArray.count == tempImageUrlArray.count) {
            
            _imageUrlArray = tempImageUrlArray;
        }
        
    }
    
}

#pragma mark - 显示

- (void)show{
    
    //非空验证
    
    if (!self.imageUrlArray) return;
    
    if (self.index >= self.imageUrlArray.count) return;
    
    //设置当前下标与页数
    
    self.currentIndex = self.index;
    
    self.pageLable.text = [NSString stringWithFormat:@"%ld/%ld",self.index + 1,(unsigned long)self.imageUrlArray.count];
    
    //添加到window上 并根据图片视图属性显示动画
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview:self];
    
    if (self.imageView) {
        
        CGRect currentRect = [self.imageView convertRect: self.imageView.bounds toView:window];
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        
        [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.tempImageView = [[UIImageView alloc] initWithImage:image];
        
        self.tempImageView.frame = currentRect;
        
        [self addSubview:self.tempImageView];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect tempImageViewFrame = self.tempImageView.frame;
            
            tempImageViewFrame.size.width = self.frame.size.width;
            
            tempImageViewFrame.size.height = self.frame.size.width * (currentRect.size.height / currentRect.size.width);
            
            tempImageViewFrame.origin.x = 0;
            
            tempImageViewFrame.origin.y = (self.frame.size.height - tempImageViewFrame.size.height) * 0.5f;
            
            self.tempImageView.frame = tempImageViewFrame;
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
            
        } completion:^(BOOL finished) {
            
            self.tempImageView.hidden = YES;
            
            self.collectionView.hidden = NO;
            
            [self.collectionView reloadData];
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }];
        
    } else {
        
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.alpha = 1.0f;
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
        }];
        
        self.collectionView.hidden = NO;
        
        [self.collectionView reloadData];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

#pragma mark - 隐藏

- (void)hide{
    
    if (self.imageView && self.currentIndex == self.index) {
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        
        CGRect currentRect = [self.imageView convertRect: self.imageView.bounds toView:window];
        
        self.tempImageView.hidden = NO;
        
        self.collectionView.hidden = YES;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.tempImageView.frame = currentRect;
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
        } completion:^(BOOL finished) {
            
            [self.tempImageView removeFromSuperview];
            
            [self removeFromSuperview];
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.alpha = 0.0f;
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
        
    }
    
}

#pragma mark - 保存图片事件

- (void)saveImageAction{
    
    //获取当前图片的URL
    
    NSURL *url = [self.imageUrlArray objectAtIndex:self.currentIndex];
    
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    
    if ([manager.cache containsImageForKey:[manager cacheKeyForURL:url]]) {
        
        //获取图片
        
        UIImage *image = [manager.cache getImageForKey:[manager cacheKeyForURL:url]];
        
        if (image) {
            
            //存储图片到本地相册
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            
        } else {
            
            [self showMessage:@"保存图片失败"];
        }
        
    } else {
        
        [self showMessage:@"保存图片失败"];
    }
    
}

#pragma mark - 图片保存回调方法

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSString *msg = nil ;
    
    if (error){
        
        msg = @"保存图片失败";
        
    } else {
        
        msg = @"已成功存入相册";
    }
    
    [self showMessage:msg];
}

#pragma mark - 阴影处理

- (CAGradientLayer *)shadowAsInverseWithSize:(CGSize)size{
    
    long top = strtoul([@"00" UTF8String], 0, 16);
    long bot = strtoul([@"dd" UTF8String], 0, 16);
    
    UIColor *topColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:top / 255.0f];
    UIColor *botColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:bot / 255.0f];
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, size.width, size.height);
    layer.frame = newShadowFrame;
    
    // 添加渐变的颜色组合
    layer.colors = [NSArray arrayWithObjects:(id)topColor.CGColor,(id)botColor.CGColor, nil];
    
    return layer;
}

#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MierPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    cell.loadFinishBlock = ^(NSURL *url , UIImage *image){
        
        if (weakSelf) {
            
            //判断是否为当前显示的图片 如果是则显示保存按钮
            
            if (weakSelf.currentIndex == [weakSelf.imageUrlArray indexOfObject:url]) {
                
                weakSelf.saveButton.hidden = NO;
            }
            
        }
        
    };
    
    cell.hideBlock = ^(){
        
        if (weakSelf) {
            
            [weakSelf hide];
        }
        
    };
    
    cell.url = self.imageUrlArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //设置当前页数与下标
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    self.pageLable.text = [NSString stringWithFormat:@"%ld/%ld",page + 1,(unsigned long)self.imageUrlArray.count];
    
    self.currentIndex = page;
    
    //获取当前图片的URL 并查询缓存 显示隐藏保存按钮
    
    id url = [self.imageUrlArray objectAtIndex:self.currentIndex];
    
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    
    if ([manager.cache containsImageForKey:[manager cacheKeyForURL:url]]) {
        
        self.saveButton.hidden = NO;
        
    } else {
        
        self.saveButton.hidden = YES;
    }
    
}

@end

#pragma mark - / CELL /

@interface MierPhotoBrowserCell ()<MBProgressHUDDelegate , UIScrollViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic , strong ) UIScrollView *scrollView; //滑动视图

@property (nonatomic , strong ) UIImageView *imageView; //图片视图

@property (nonatomic , strong ) UILabel *promptLable; //提示Label

@property (nonatomic , strong ) MBProgressHUD *HUD; //HUD提示框

@property (nonatomic , strong ) MBRoundProgressView *roundProgressView; //进度条视图

@end

@implementation MierPhotoBrowserCell

- (void)dealloc{
    
    _url = nil;
    
    _loadFinishBlock = nil;
    
    _hideBlock = nil;
    
    _scrollView = nil;
    
    _imageView = nil;
    
    _promptLable = nil;
    
    _HUD = nil;
    
    _roundProgressView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化滑动视图
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        _scrollView.maximumZoomScale = 3;
        
        _scrollView.minimumZoomScale = 1;
        
        _scrollView.zoomScale = 1;
        
        _scrollView.delegate = self;
        
        [self.contentView addSubview:_scrollView];
        
        // 初始化单击手势
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [self.scrollView addGestureRecognizer:tap];
        
        // 初始化图片视图
        
        _imageView = [[UIImageView alloc]init];
        
        _imageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_imageView];
        
        // 初始化图片点击手势
        
        UITapGestureRecognizer *imageDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        
        imageDoubleTap.numberOfTapsRequired = 2;
        
        imageDoubleTap.numberOfTouchesRequired = 1;
        
        [self.imageView addGestureRecognizer:imageDoubleTap];
        
        // 当没有检测到图片双击手势时 或者 检测图片双击手势失败，单击手势才有效
        
        [tap requireGestureRecognizerToFail:imageDoubleTap];
        
        // 初始化提示Label
        
        _promptLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame) * 0.5f)];
        
        _promptLable.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5f, CGRectGetHeight(self.frame) * 0.5f);
        
        _promptLable.hidden = YES;
        
        _promptLable.text = @"加载失败 点击重试";
        
        _promptLable.textColor = [UIColor lightGrayColor];
        
        _promptLable.textAlignment = NSTextAlignmentCenter;
        
        _promptLable.backgroundColor = [UIColor darkGrayColor];
        
        _promptLable.userInteractionEnabled = YES;
        
        [_promptLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadImage)]];
        
        [self.contentView addSubview:_promptLable];
        
    }
    return self;
}

#pragma mark - 获取图片Url

- (void)setUrl:(NSURL *)url{
    
    _url = url;
    
    if (_url) [self loadImage];
}

#pragma mark - 加载图片

- (void)loadImage{
    
    //缩放比例
    
    self.scrollView.zoomScale = 1;
    
    //进度条归0
    
    [self.roundProgressView setProgress:0.0f];
    
    //显示提示框
    
    [self.HUD showAnimated:YES];
    
    //隐藏提示Label
    
    self.promptLable.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [self.imageView setImageWithURL:self.url placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        if (weakSelf) {
            
            //计算加载进度百分比 并设置进度条
            
            float progressFloat = (float)receivedSize/(float)expectedSize;
            
            [weakSelf.roundProgressView setProgress:progressFloat];
        }
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        return image;
        
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf){
            
            //隐藏提示框
            
            [strongSelf.HUD hideAnimated:NO];
            
            if (error) {
                
                strongSelf.promptLable.hidden = NO;
                
            } else {
                
                //获取图片宽高 并设置大小
                
                CGFloat width =  image.size.width;
                
                CGFloat height = image.size.height;
                
                CGFloat ratio = height ? (width / height) : 0;
                
                strongSelf.imageView.frame = CGRectMake(0, 0, strongSelf.scrollView.frame.size.width, ratio ? strongSelf.scrollView.frame.size.width / ratio : 0);
                
                strongSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(strongSelf.imageView.frame), CGRectGetHeight(strongSelf.imageView.frame));
                
                if (strongSelf.imageView.frame.size.height > strongSelf.scrollView.frame.size.height){
                    
                    strongSelf.imageView.center = CGPointMake(strongSelf.scrollView.contentSize.width / 2, strongSelf.scrollView.contentSize.height / 2);
                    
                } else {
                    
                    strongSelf.imageView.center = CGPointMake(CGRectGetWidth(strongSelf.scrollView.frame) / 2 , CGRectGetHeight(strongSelf.scrollView.frame) / 2);
                }
                
                //调用加载完成回调Block
                
                if (strongSelf.loadFinishBlock) strongSelf.loadFinishBlock(url , image);
            }
            
        }
        
    }];
    
}

#pragma mark - 单击事件

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (self.hideBlock) self.hideBlock();
}

#pragma mark - 图片双击事件

- (void)imageTapAction:(UITapGestureRecognizer *)tap{
    
    [UIView beginAnimations:@"" context:nil];
    
    [UIView setAnimationDuration:0.15f];
    
    if (self.scrollView.zoomScale == 1.0f) {
        
        self.scrollView.zoomScale = 1.5f; //1.5倍放大
        
    } else {
        
        self.scrollView.zoomScale = 1.0f; //还原缩放比例
    }
    
    [UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    //当scrollView正在缩放的时候会频繁响应的方法
    
    //x和y轴的增量:
    
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    
    //条件运算符
    
    CGFloat delta_x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    
    CGFloat delta_y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    
    //让imageView一直居中
    
    //实时修改imageView的center属性 保持其居中
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    //提示框隐藏时 删除提示框视图
    
    [hud removeFromSuperview];
    
    hud.customView = nil;
    
    hud = nil;
}

#pragma mark - LazyLoading

- (MBProgressHUD *)HUD{
    
    if (!_HUD) {
        
        _HUD = [[MBProgressHUD alloc] initWithView:self];
        
        [self addSubview:_HUD];
        
        _HUD.mode = MBProgressHUDModeCustomView;//设置自定义视图模式
        
        _HUD.delegate = self;
        
        _HUD.backgroundColor = [UIColor clearColor];
        
        _HUD.customView = self.roundProgressView;
    }
    
    return _HUD;
}

- (MBRoundProgressView *)roundProgressView{
    
    if (!_roundProgressView) {
        
        _roundProgressView = [[MBRoundProgressView alloc]initWithFrame:CGRectMake(0, 0, 64 , 64 )];
    }
    
    return _roundProgressView;
}

@end
