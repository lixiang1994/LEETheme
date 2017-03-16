//
//  CommunityDetailsContentView.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsContentView.h"

#import <WebKit/WebKit.h>

#import "SDAutoLayout.h"

#import "NewsToolbarView.h"

#import "CommunityDetailsContentHeaderView.h"

#import "CommunityDetailsContentFooterView.h"

#import "MierPhotoBrowser.h"

#import "ContentImageCacheManager.h"

#import "FontSizeManager.h"

#import "SetManager.h"

#import "LEEAlert.h"

#import "MierProgressHUD.h"

@interface CommunityDetailsContentView ()<WKUIDelegate , WKNavigationDelegate , WKScriptMessageHandler>

@property (nonatomic , strong ) WKWebView *webView;

@property (nonatomic , strong ) CommunityDetailsContentHeaderView *headerView; //头部视图

@property (nonatomic , strong ) CommunityDetailsContentFooterView *footerView; //底部视图

@property (nonatomic , strong ) NSArray *imageUrlArray; //图片Url数组

@property (nonatomic , strong ) ContentImageCacheManager *imageCache; //内容图片缓存管理

@end

@implementation CommunityDetailsContentView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_webView) {
        
        [_webView stopLoading];
        
        _webView.navigationDelegate = nil;
        
        _webView.UIDelegate = nil;
        
        _webView = nil;
    }
    
    _headerView = nil;
    
    _footerView = nil;
    
    _imageUrlArray = nil;
    
    _imageCache = nil;
    
    _api = nil;
    
    _model = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
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
    }
    
    return self;
}

#pragma mark - 添加通知

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 从后台回到前台

- (void)willEnterForegroundNotification:(NSNotification *)notify{
    
    if (!self.webView.title) {
        
        [self.webView reload];
    }
    
}

#pragma mark - 初始化数据

- (void)initData{
    
    // 初始化配置数据
    
    [ContentImageCacheManager initData];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //webView
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    webConfig.preferences = [[WKPreferences alloc] init]; // 设置偏好设置
    
    webConfig.preferences.minimumFontSize = 10; // 默认为0
    
    webConfig.preferences.javaScriptEnabled = YES; // 默认认为YES
    
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO; // 在iOS上默认为NO，表示不能自动通过窗口打开
    
    webConfig.userContentController = [[WKUserContentController alloc] init]; // 通过JS与webview内容交互
    
    [webConfig.userContentController addScriptMessageHandler:self name:@"clickImage"]; // 注入JS对象
    
    [webConfig.userContentController addScriptMessageHandler:self name:@"showImage"]; // 注入JS对象
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) configuration:webConfig];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.UIDelegate = self;
    
    _webView.navigationDelegate = self;
    
    _webView.scrollView.bounces = NO;
    
    _webView.scrollView.bouncesZoom = NO;
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.scrollView.directionalLockEnabled = YES;
    
    _webView.scrollView.scrollEnabled = NO;
    
    [self addSubview:_webView];
    
    //头部视图
    
    _headerView = [[CommunityDetailsContentHeaderView alloc] init];
    
    [self addSubview:_headerView];
    
    //底部视图
    
    _footerView = [[CommunityDetailsContentFooterView alloc] init];
    
    [self addSubview:_footerView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    //头部视图
    
    _headerView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthRatioToView(self.webView , 1)
    .heightIs(0);
    
    //webview
    
    _webView.sd_layout
    .topSpaceToView(self.headerView , 0.0f);
    
    //底部视图
    
    _footerView.sd_layout
    .xIs(0)
    .topSpaceToView(self.webView , 0.0f)
    .widthRatioToView(self.webView , 1)
    .heightIs(0);
    
    [self setupAutoHeightWithBottomView:self.footerView bottomMargin:0.0f];
    
    __weak typeof(self) weakSelf = self;
    
    [self setDidFinishAutoLayoutBlock:^(CGRect rect) {
        
        if (weakSelf) {
            
            if (weakSelf.updateHeightBlock) weakSelf.updateHeightBlock();
        }
        
    }];
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.webView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
}

#pragma mark - 设置Block

- (void)configBlock{
    
    __weak typeof(self) weakSelf = self;
    
    self.headerView.openUserHomeBlock = ^(){
        
        if (weakSelf) {
            
            if (weakSelf.openUserHomeBlock) weakSelf.openUserHomeBlock();
        }
        
    };
    
    self.footerView.praiseBlock = ^(){
        
        if (weakSelf) [weakSelf praiseHandle];
    };
    
    self.footerView.deleteBlock = ^(){
        
        if (weakSelf) {
            
            [LEEAlert alert].custom.config
            .LeeTitle(@"提示")
            .LeeCancelButtonTitle(@"取消")
            .LeeContent(@"长官:你确定要删除该帖子吗?")
            .LeeAddButton(@"确定", ^(){
                
                if (weakSelf) [weakSelf deleteHandle];
            })
            .LeeShow();
        }
        
    };
    
}

#pragma mark - 加载数据

- (void)loadData{
    
    NSString *htmlString = nil;
    
    if ([self.model.isNewVersion isEqualToString:@"false"]) {
        
        htmlString = [self createHtml:self.model.content PhotoArray:self.model.photoArray];
        
    } else {
        
        htmlString = self.model.content;
    }
    
    NSString *backgroundColor = [[LEETheme currentThemeTag] isEqualToString:DAY] ? @"#ffffff" : @"#252525";
    
    NSString *fontColor = [[LEETheme currentThemeTag] isEqualToString:DAY] ? @"#333333" : @"#777777";
    
    NSString *fontSize = [NSString stringWithFormat:@"%.0f" , [FontSizeManager textFontSizeForWebContent:16.0f + [SetManager shareManager].fontSizeLevel * 2]];
    
    NSString *webContentStyleCSS = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WebContentStyle" ofType:@"css"] encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *webContentStyleCSSPath = [[ContentImageCacheManager getCachePath:@"css"] stringByAppendingPathComponent:@"WebContentStyle.css"];
    
    webContentStyleCSS = [NSString stringWithFormat:webContentStyleCSS , backgroundColor , fontColor , fontSize];
    
    [webContentStyleCSS writeToFile:webContentStyleCSSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *frame = [NSString stringWithFormat:@"\
                       <html>\
                       <head>\
                       <meta http-equiv =\"Content-Type\" content=\"text/html; charset=utf-8\"/>\
                       <meta name = \"viewport\" content=\"width = device-width, initial-scale = 1, user-scalable=no\"/>\
                       <title></title>\
                       <link href=\"../css/WebContentStyle.css\" rel=\"stylesheet\" type=\"text/css\"/>\
                       <script src=\"../js/jquery-1.12.3.min.js\"></script>\
                       </head>\
                       <body>\
                       <div class = \"content\">%@</div>\
                       </body>\
                       <script src=\"../js/WebContentHandle.js\"></script>\
                       </html>" , htmlString];
    
    NSString *htmlPath = [[ContentImageCacheManager getCachePath:@"html"] stringByAppendingPathComponent:@"communityContent.html"];
    
    [frame writeToFile:htmlPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

#pragma mark - 创建Html (社区旧版本兼容处理)

- (NSString *)createHtml:(NSString *)content PhotoArray:(NSArray *)photoArray{
    
    NSMutableString *contentString = [NSMutableString stringWithFormat:@"<p>%@</p>\n" , content];
    
    for (NSDictionary *info in photoArray) {
        
        [contentString appendFormat:@"<img class=\"image\" src=\"\" data-src=\"%@\" />" , info[@"img"]];
    }
    
    return contentString;
}

#pragma mark - 获取数据模型

- (void)setModel:(CommunityDetailsModel *)model{
    
    _model = model;
    
    self.headerView.model = model;
    
    self.footerView.model = model;
    
    [self loadData];
}

#pragma mark - 点赞处理

- (void)praiseHandle{
    
    self.model.praiseCount += 1;
    
    __weak typeof(self) weakSelf = self;
    
    [self.api praisePostWithPostId:self.model.postId CircleId:self.model.circleModel.circleId AuthorId:self.model.authorId AuthorName:self.model.authorName Title:self.model.title ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        if (weakSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                    
                    [weakSelf.footerView praiseState:YES];
                    
                    break;
                    
                default:
                    
                    weakSelf.model.praiseCount -= 1;
                    
                    [weakSelf.footerView praiseState:NO];
                    
                    [MierProgressHUD showFailure:@"点赞失败 请重试"];
                    
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 删除处理

- (void)deleteHandle{
    
    __weak typeof(self) weakSelf = self;
    
    [self.api deletePostWithPostId:self.model.postId CircleId:self.model.circleModel.circleId ResultBlock:^(RequestResultType requestResultType, id responseObject) {
        
        if (weakSelf) {
            
            switch (requestResultType) {
                    
                case RequestResultTypeSuccess:
                    
                    [MierProgressHUD showSuccess:@"删除成功"];
                    
                    if (weakSelf.deleteBlock) weakSelf.deleteBlock();
                    
                    break;
                    
                default:
                    
                    [MierProgressHUD showFailure:@"删除失败 稍后重试"];
                    
                    break;
            }
            
        }
        
    }];
    
}

#pragma mark - 释放处理

- (void)releaseHandle{
    
    //移除JS对象
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"clickImage"];
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"showImage"];
}

#pragma mark - 更新webview高度

- (void)updateWebViewHeight{
    
    __weak typeof(self) weakSelf = self;
    
    [self.webView evaluateJavaScript:@"getContentHeight()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        if (weakSelf) {
            
            if (!error) {
                
                CGFloat height = [response floatValue];
                
                if (weakSelf.webView.height != height) {
                    
                    weakSelf.webView.sd_layout.heightIs(height);
                    
                    [weakSelf updateLayout];
                }
                
            }
            
        }
        
    }];
    
}

#pragma mark - 加载图片

- (void)loadImages{
    
    for (NSInteger i = 0; i < self.imageUrlArray.count ; i++) {
        
        [self loadImage:i];
    }
    
}

#pragma mark - 加载图片

- (void)loadImage:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    
    if (self.imageUrlArray.count) {
        
        NSURL *imageUrl = [NSURL URLWithString:self.imageUrlArray[index]];
        
        if (!self.imageCache) self.imageCache = [[ContentImageCacheManager alloc] init];
        
        //设置加载中状态
        
        NSString *configJS = [NSString stringWithFormat:@"configImgState('1' , '%ld');" , index];
        
        [self.webView evaluateJavaScript:configJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
            if (!weakSelf) return;
            
            //加载图片
            
            [weakSelf.imageCache loadImage:imageUrl ResultBlock:^(NSString *cachePath, BOOL result) {
                
                if (!weakSelf) return;
                
                //判断结果 并设置相应的状态
                
                if (result) {
                    
                    //设置图片Url和完成状态
                    
                    NSString *js = [NSString stringWithFormat:@"configImgState('4' , '%ld'); setImageUrl('%ld' , '%@');" , index , index , [NSURL fileURLWithPath:cachePath].absoluteString];
                    
                    [weakSelf.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                        
                        if (weakSelf) {
                            
                            if (!error) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    //更新webview高度
                                    
                                    [weakSelf updateWebViewHeight];
                                });
                            }
                            
                        }
                        
                    }];
                    
                } else {
                    
                    //设置加载失败状态
                    
                    NSString *configJS = [NSString stringWithFormat:@"configImgState('2' , '%ld');" , index];
                    
                    [weakSelf.webView evaluateJavaScript:configJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                        
                    }];
                    
                }
                
            }];
            
        }];
        
    }
    
}

#pragma mark - WKUIDelegate

// 创建新的webview
// 可以指定配置对象、导航动作对象、window特性
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    // 创建一个新的WebView（标签带有 target='_blank' 时，导致WKWebView无法加载点击后的网页的问题。）
    // 接口的作用是打开新窗口委托
    
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    
    if (![frameInfo isMainFrame]) {
        
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

// webview关闭时回调
- (void)webViewDidClose:(WKWebView *)webView{
    
}

// 调用JS的alert()方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    completionHandler();
}

// 调用JS的confirm()方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    completionHandler(NO);
}

// 调用JS的prompt()方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    completionHandler(@"");
}

#pragma mark - WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //判断请求url 拦截非本地请求
    
    NSURL *url = navigationAction.request.URL;
    
    if ([url.scheme isEqualToString:@"file"]) {
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else {
        
        [[UIApplication sharedApplication] openURL:url];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }

}

// 决定是否接收响应
// 这个是决定是否接收response
// 要获取response，通过WKNavigationResponse对象获取
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 当main frame的导航开始请求时，会调用此方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame接收到服务重定向时，会回调此方法
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

// 当main frame的web内容开始到达时，会回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    __weak typeof(self) weakSelf = self;
    
    //初始化设置
    
    NSMutableDictionary *configInfo = [NSMutableDictionary dictionary];
    
    [configInfo setObject:@([FontSizeManager textFontSizeForWebContent:16.0f + [SetManager shareManager].fontSizeLevel * 2]) forKey:@"fontSize"];
    
    [configInfo setObject:[[LEETheme currentThemeTag] isEqualToString:DAY] ? @"333333" : @"777777" forKey:@"fontColor"];
    
    [configInfo setObject:[[LEETheme currentThemeTag] isEqualToString:DAY] ? @"ffffff" : @"252525" forKey:@"backgroundColor"];
    
    BOOL isClickLoad = NO;
    
    //非wifi下显示图片判断
    
//    if ([[SetManager shareManager] allowPic]) {
//        
//        if (![CoreStatus isWifiEnable]) {
//            
//            //设置当前状态为点击加载
//            
//            isClickLoad = YES;
//        }
//        
//    }
    
    [configInfo setObject:@(isClickLoad) forKey:@"isClickLoad"];
    
    [webView evaluateJavaScript:[NSString stringWithFormat:@"initial(%@)" , configInfo.jsonStringEncoded] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        if (weakSelf) {
            
            //获取内容字符串
            
            [weakSelf.webView evaluateJavaScript:@"getContentString()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
            }];
            
            //获取图片Url数组
            
            [weakSelf.webView evaluateJavaScript:@"getImageUrls()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
                if (weakSelf) {
                    
                    if (!error) {
                        
                        weakSelf.imageUrlArray = [response copy];
                        
                        if (!isClickLoad) [weakSelf loadImages]; // 加载图片
                    }
                    
                }
                
            }];
            
            //更新webview高度
            
            [weakSelf updateWebViewHeight];
            
            if (weakSelf.loadedFinishBlock) weakSelf.loadedFinishBlock();
        }
        
    }];
    
    /*
     
     //设置字体大小
     
     [self.webView evaluateJavaScript:@"configFontSize('20')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
     
     Log(@"response: %@ error: %@", response, error);
     }];
     
     //设置字体颜色
     
     [self.webView evaluateJavaScript:@"configFontColor('222222')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
     
     Log(@"response: %@ error: %@", response, error);
     }];
     
     //设置图片大小
     
     [self.webView evaluateJavaScript:@"configImgSize('1' , '320' , '160')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
     
     Log(@"response: %@ error: %@", response, error);
     }];
     
     */
    
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

// 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    
    //AFNetworking中的处理方式
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    
    __block NSURLCredential *credential = nil;
    
    //判断服务器返回的证书是否是服务器信任的
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        /*disposition：如何处理证书
         NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
         NSURLSessionAuthChallengeUseCredential：使用指定的证书    NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
         */
        if (credential) {
            
            disposition = NSURLSessionAuthChallengeUseCredential;
            
        } else {
            
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
    } else {
        
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    //安装证书
    
    if (completionHandler) completionHandler(disposition, credential);
}

// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    [webView reload];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
    // NSDictionary, and NSNull类型
    
    if ([message.name isEqualToString:@"showImage"]) {
        
        [self loadImage:[message.body integerValue]];
    }
    
    if ([message.name isEqualToString:@"clickImage"]) {
        
        NSDictionary *info = message.body;
        
        MierPhotoBrowser *browser = [MierPhotoBrowser browser];
        
        browser.imageUrlArray = [self.imageUrlArray copy];
        
        browser.index = [info[@"index"] integerValue];
        
        [browser show];
    }
    
}

@end
