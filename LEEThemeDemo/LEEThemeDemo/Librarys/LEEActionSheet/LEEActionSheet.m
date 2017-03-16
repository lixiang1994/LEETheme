
/*!
 *  @header LEEActionSheet.m
 *
 *
 *  @brief  操作列表
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */

#import "LEEActionSheet.h"

#import <Accelerate/Accelerate.h>

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LEEActionSheet ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) UIWindow *actionSheetWindow;

@property (nonatomic , strong ) NSMutableArray <LEEActionSheetCustom *>*customActionSheetArray;

@end

@protocol LEEActionSheetProtocol <NSObject>

- (void)closeActionSheetWithCompletionBlock:(void (^)())completionBlock;

@end

@implementation LEEActionSheet

- (void)dealloc{
    
    _system = nil;
    
    _custom = nil;
    
    _mainWindow = nil;
    
    _actionSheetWindow = nil;
}

+ (LEEActionSheet *)shareActionSheetManager{
    
    static LEEActionSheet *actionSheetManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        actionSheetManager = [LEEActionSheet actionSheet];
    });
    
    return actionSheetManager;
}

+ (LEEActionSheet *)actionSheet{
    
    LEEActionSheet *actionSheet = [[LEEActionSheet alloc]init];
    
    return actionSheet;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [LEEActionSheet shareActionSheetManager].mainWindow = window;
}

+ (void)closeCustomActionSheet{
    
    [self closeCustomActionSheetWithCompletionBlock:nil];
}

+ (void)closeCustomActionSheetWithCompletionBlock:(void (^)())completionBlock{
    
    if ([LEEActionSheet shareActionSheetManager].customActionSheetArray.count) {
        
        LEEActionSheetCustom *custom = [LEEActionSheet shareActionSheetManager].customActionSheetArray.lastObject;
        
        if ([custom respondsToSelector:@selector(closeActionSheetWithCompletionBlock:)]) [custom performSelector:@selector(closeActionSheetWithCompletionBlock:) withObject:completionBlock];
        
    }
    
}


#pragma mark LazyLoading

- (LEEActionSheetSystem *)system{
    
    if (!_system) _system = [[LEEActionSheetSystem alloc]init];
    
    return _system;
}

- (LEEActionSheetCustom *)custom{
    
    if (!_custom) _custom = [[LEEActionSheetCustom alloc]init];
    
    return _custom;
}

- (NSMutableArray *)customActionSheetArray{
    
    if (!_customActionSheetArray) _customActionSheetArray = [NSMutableArray array];
    
    return _customActionSheetArray;
}

- (UIWindow *)actionSheetWindow{
    
    if (!_actionSheetWindow) {
        
        _actionSheetWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _actionSheetWindow.backgroundColor = [UIColor clearColor];
        
        _actionSheetWindow.windowLevel = UIWindowLevelAlert;
        
        _actionSheetWindow.hidden = YES;
    }
    
    return _actionSheetWindow;
}

@end

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, LEEActionSheetCustomBackGroundStype) {
    /** 自定义背景样式 模糊 */
    LEEActionSheetCustomBackGroundStypeBlur,
    /** 自定义背景样式 半透明 */
    LEEActionSheetCustomBackGroundStypeTranslucent,
};

typedef NS_ENUM(NSInteger, LEEActionSheetCustomSubViewType) {
    /** 自定义子视图类型 标题 */
    LEEActionSheetCustomSubViewTypeTitle,
    /** 自定义子视图类型 内容 */
    LEEActionSheetCustomSubViewTypeContent,
    /** 自定义子视图类型 自定义视图 */
    LEEActionSheetCustomSubViewTypeCustomView,
};

@interface LEEActionSheetConfigModel ()

/* 以下为配置模型属性 ╮(╯▽╰)╭ 无视就好 */

@property (nonatomic , copy ) NSString *modelTitleStr;
@property (nonatomic , copy ) NSString *modelContentStr;
@property (nonatomic , copy ) NSString *modelCancelButtonTitleStr;
@property (nonatomic , copy ) NSString *modelDestructiveButtonTitleStr;

@property (nonatomic , strong ) NSMutableArray *modelButtonArray;
@property (nonatomic , strong ) NSMutableArray *modelCustomSubViewsQueue;

@property (nonatomic , strong ) UIView *modelCustomContentView;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelSubViewMargin;
@property (nonatomic , assign ) CGFloat modelTopSubViewMargin;
@property (nonatomic , assign ) CGFloat modelBottomSubViewMargin;
@property (nonatomic , assign ) CGFloat modelLeftSubViewMargin;
@property (nonatomic , assign ) CGFloat modelRightSubViewMargin;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;
@property (nonatomic , assign ) CGFloat modelActionSheetMaxWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetMaxHeight;
@property (nonatomic , assign ) CGFloat modelActionSheetOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelActionSheetCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelActionSheetCustomBackGroundStypeColorAlpha;

@property (nonatomic , strong ) UIColor *modelActionSheetViewColor;
@property (nonatomic , strong ) UIColor *modelActionSheetWindowBackGroundColor;

@property (nonatomic , assign ) BOOL modelIsActionSheetWindowTouchClose;
@property (nonatomic , assign ) BOOL modelIsCustomButtonClickClose;
@property (nonatomic , assign ) BOOL modelIsAddQueue;

@property (nonatomic , copy ) void(^modelCancelButtonAction)();
@property (nonatomic , copy ) void(^modelDestructiveButtonAction)();
@property (nonatomic , copy ) void(^modelCancelButtonBlock)(UIButton *button);
@property (nonatomic , copy ) void(^modelDestructiveButtonBlock)(UIButton *button);
@property (nonatomic , copy ) void(^modelFinishConfig)(UIViewController *vc);

@property (nonatomic , assign ) LEEActionSheetCustomBackGroundStype modelActionSheetCustomBackGroundStype;

@end

@implementation LEEActionSheetConfigModel

- (void)dealloc{
    
    _modelTitleStr = nil;
    _modelContentStr = nil;
    _modelCancelButtonTitleStr = nil;
    _modelButtonArray = nil;
    _modelCustomSubViewsQueue = nil;
    _modelCustomContentView = nil;
    _modelActionSheetViewColor = nil;
    _modelActionSheetWindowBackGroundColor = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        
        //初始化默认值
        
        _modelCornerRadius = 12.0f; //默认ActionSheet圆角半径
        _modelSubViewMargin = 10.0f; //默认ActionSheet内部控件之间间距
        _modelTopSubViewMargin = 20.0f; //默认ActionSheet顶部距离控件的间距
        _modelBottomSubViewMargin = 20.0f; //默认ActionSheet底部距离控件的间距
        _modelLeftSubViewMargin = 10.0f; //默认ActionSheet左侧距离控件的间距
        _modelRightSubViewMargin = 10.0f; //默认ActionSheet右侧距离控件的间距
        _modelActionSheetBottomMargin = 10.0f; //默认ActionSheet底部距离屏幕的间距
        _modelActionSheetMaxWidth = (screenWidth > screenHeight ? screenHeight : screenWidth) - 20.0f; //默认最大宽度屏幕宽度减20 (去除左右10间距)
        _modelActionSheetMaxHeight = (screenWidth > screenHeight ? screenWidth : screenHeight) - 20.0f; //默认最大高度屏幕高度减20 (去除上下10间距)
        _modelActionSheetOpenAnimationDuration = 0.3f; //默认ActionSheet打开动画时长
        _modelActionSheetCloseAnimationDuration = 0.2f; //默认ActionSheet关闭动画时长
        _modelActionSheetCustomBackGroundStypeColorAlpha = 0.6f; //自定义背景样式渲染颜色透明度 默认为半透明背景样式 透明度为0.6f
        
        _modelActionSheetViewColor = [UIColor whiteColor]; //默认ActionSheet颜色
        _modelActionSheetWindowBackGroundColor = [UIColor blackColor]; //默认ActionSheet背景半透明或者模糊颜色
        
        _modelIsActionSheetWindowTouchClose = NO; //默认点击window不关闭
        _modelIsCustomButtonClickClose = YES; //默认点击自定义按钮关闭
        _modelIsAddQueue = YES; //默认加入队列
        
        _modelActionSheetCustomBackGroundStype = LEEActionSheetCustomBackGroundStypeTranslucent; //默认为半透明背景样式
    }
    return self;
}

- (LEEConfigActionSheetToString)LeeTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelTitleStr = str;
            
            //是否加入队列
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEEActionSheetCustomSubViewTypeTitle];
            
            if ([weakSelf.modelCustomSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEActionSheetCustomSubViewTypeTitle)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToString)LeeContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelContentStr = str;
            
            //是否加入队列
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEEActionSheetCustomSubViewTypeContent];
            
            if ([weakSelf.modelCustomSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEActionSheetCustomSubViewTypeContent)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToString)LeeCancelButtonTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelCancelButtonTitleStr = str;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToButtonBlock)LeeCancelButtonAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^buttonAction)()){
        
        if (weakSelf) {
            
            if (buttonAction) weakSelf.modelCancelButtonAction = buttonAction;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToString)LeeDestructiveButtonTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        if (weakSelf) {
            
            weakSelf.modelDestructiveButtonTitleStr = str;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToButtonBlock)LeeDestructiveButtonAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^buttonAction)()){
        
        if (weakSelf) {
            
            if (buttonAction) weakSelf.modelDestructiveButtonAction = buttonAction;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToButtonAndBlock)LeeAddButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^buttonAction)()){
        
        if (weakSelf) {
            
            [weakSelf.modelButtonArray addObject:@{@"title" : title , @"actionblock" : buttonAction}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToCustomLabel)LeeCustomTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addLabel)(UILabel *label)){
        
        if (weakSelf) {
            
            NSDictionary *customSubViewInfo = @{@"type" : @(LEEActionSheetCustomSubViewTypeTitle) , @"block" : addLabel};
            
            if (weakSelf.modelTitleStr) {
                
                for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
                    
                    if ([item[@"type"] integerValue] == LEEActionSheetCustomSubViewTypeTitle) {
                        
                        [weakSelf.modelCustomSubViewsQueue replaceObjectAtIndex:[weakSelf.modelCustomSubViewsQueue indexOfObject:item] withObject:customSubViewInfo];
                        
                        break;
                    }
                    
                }
                
            } else {
                
                [weakSelf.modelCustomSubViewsQueue addObject:customSubViewInfo];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToCustomLabel)LeeCustomContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addLabel)(UILabel *label)){
        
        if (weakSelf) {
            
            NSDictionary *customSubViewInfo = @{@"type" : @(LEEActionSheetCustomSubViewTypeContent) , @"block" : addLabel};
            
            if (weakSelf.modelContentStr) {
                
                for (NSDictionary *item in weakSelf.modelCustomSubViewsQueue) {
                    
                    if ([item[@"type"] integerValue] == LEEActionSheetCustomSubViewTypeContent) {
                        
                        [weakSelf.modelCustomSubViewsQueue replaceObjectAtIndex:[weakSelf.modelCustomSubViewsQueue indexOfObject:item] withObject:customSubViewInfo];
                        
                        break;
                    }
                    
                }
                
            } else {
                
                [weakSelf.modelCustomSubViewsQueue addObject:customSubViewInfo];
            }
            
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToCustomButton)LeeCustomCancelButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        if (weakSelf) {
            
            if (addButton) weakSelf.modelCancelButtonBlock = addButton;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToCustomButton)LeeCustomDestructiveButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        if (weakSelf) {
            
            if (addButton) weakSelf.modelDestructiveButtonBlock = addButton;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToView)LeeCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        if (weakSelf) {
            
            weakSelf.modelCustomContentView = view;
            
            //是否加入队列
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , LEEActionSheetCustomSubViewTypeCustomView];
            
            if ([weakSelf.modelCustomSubViewsQueue filteredArrayUsingPredicate:predicate].count == 0) [weakSelf.modelCustomSubViewsQueue addObject:@{@"type" : @(LEEActionSheetCustomSubViewTypeCustomView)}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToCustomButton)LeeAddCustomButton{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^addButton)(UIButton *button)){
        
        if (weakSelf) {
            
            [weakSelf.modelButtonArray addObject:@{@"title" : @"按钮" , @"block" : addButton}];
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomCornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelCornerRadius = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomTopSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelTopSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomBottomSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBottomSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomLeftSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelLeftSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomRightSubViewMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelRightSubViewMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetBottomMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetBottomMargin = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetMaxWidth = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetMaxHeight = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetOpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetOpenAnimationDuration = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetCloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetCloseAnimationDuration = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToColor)LeeCustomActionSheetViewColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetViewColor = color;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToColor)LeeCustomActionSheetViewBackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetWindowBackGroundColor = color;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetViewBackGroundStypeTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetCustomBackGroundStype = LEEActionSheetCustomBackGroundStypeTranslucent;
            
            weakSelf.modelActionSheetCustomBackGroundStypeColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToFloat)LeeCustomActionSheetViewBackGroundStypeBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelActionSheetCustomBackGroundStype = LEEActionSheetCustomBackGroundStypeBlur;
            
            weakSelf.modelActionSheetCustomBackGroundStypeColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheet)LeeCustomActionSheetTouchClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) {
            
            weakSelf.modelIsActionSheetWindowTouchClose = YES;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheet)LeeCustomButtonClickNotClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) {
            
            weakSelf.modelIsCustomButtonClickClose = NO;
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToBool)LeeAddQueue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL result){
        
        if (weakSelf) {
            
            weakSelf.modelIsAddQueue = result;
        }
        
        return weakSelf;
    };
    
}


- (LEEConfigActionSheet)LeeShow{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig(nil);
        }
        
        return weakSelf;
    };
    
}

- (LEEConfigActionSheetToViewController)LeeShowFromViewController{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIViewController *viewController){
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig(viewController);
        }
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelButtonArray{
    
    if (!_modelButtonArray) _modelButtonArray = [NSMutableArray array];
    
    return _modelButtonArray;
}

- (NSMutableArray *)modelCustomSubViewsQueue{
    
    if (!_modelCustomSubViewsQueue) _modelCustomSubViewsQueue = [NSMutableArray array];
    
    return _modelCustomSubViewsQueue;
}

@end

#pragma mark - =====================系统=====================

@interface LEEActionSheetSystem ()<UIActionSheetDelegate>

@property (nonatomic , strong ) NSMutableDictionary *actionSheetViewButtonIndexDic;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@end

@implementation LEEActionSheetSystem

- (void)dealloc{
    
    _config = nil;
    
    _actionSheetViewButtonIndexDic = nil;
    
    _currentKeyWindow = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)configActionSheetWithShow:(UIViewController *)vc{
    
    NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : nil;
    
    NSString *message = self.config.modelContentStr ? self.config.modelContentStr : nil;
    
    NSString *cancelButtonTitle = self.config.modelCancelButtonTitleStr || self.config.modelCancelButtonAction ? self.config.modelCancelButtonTitleStr ? self.config.modelCancelButtonTitleStr : @"取消" : nil ;
    
    NSString *destructiveButtonTitle = self.config.modelDestructiveButtonTitleStr || self.config.modelDestructiveButtonAction ? self.config.modelDestructiveButtonTitleStr ? self.config.modelDestructiveButtonTitleStr : @"销毁" : nil ;
    
    if (iOS8) {
        
        __weak typeof(self) weakSelf = self;
        
        //使用 UIAlertController
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (cancelButtonTitle) {
         
            void (^cancelButtonAction)() = weakSelf.config.modelCancelButtonAction;
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                if (cancelButtonAction) cancelButtonAction();
                
                if (weakSelf) weakSelf.config = nil;
            }];
            
            [alertController addAction:alertAction];
        }
        
        if (destructiveButtonTitle) {
            
            void (^destructiveButtonAction)() = weakSelf.config.modelDestructiveButtonAction;
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                if (destructiveButtonAction) destructiveButtonAction();
                
                if (weakSelf) weakSelf.config = nil;
            }];
            
            [alertController addAction:alertAction];
        }
        
        for (NSDictionary *buttonDic in self.config.modelButtonArray) {
            
            NSString *buttonTitle = buttonDic[@"title"];
            
            void (^buttonAction)() = buttonDic[@"actionblock"];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (buttonAction) buttonAction();
                
                if (weakSelf) weakSelf.config = nil;
            }];
            
            [alertController addAction:alertAction];
        }
        
        if (vc) {
            
            [vc presentViewController:alertController animated:YES completion:^{}];
            
        } else {
            
            if (self.currentKeyWindow) {
                
                [[self getPresentedViewController:self.currentKeyWindow.rootViewController] presentViewController:alertController animated:YES completion:^{}];
                
            } else {
                
                /*
                 * keywindow的rootViewController 获取不到 建议传入视图控制器对象
                 *
                 * 建议: XXX.system.config.XXX().XXX().showFromViewController(视图控制器对象);
                 * 或者: 在appDelegate内设置主窗口 [LEEActionSheet configMainWindow:self.window];
                 */
                NSAssert(self, @"LEEActionSheet : keywindow的rootViewController 获取不到 建议传入视图控制器对象");
            }
            
        }
        
    } else {
        
        //使用UIActionSheet
        
        if (message) title = [NSString stringWithFormat:@"%@\n\n%@" , title , message];
        
        UIActionSheet *actionSheet = nil;
        
        //暂时傻逼式无奈处理 动态参数传递搞不定啊
        
        actionSheet = [self sbHandleActionSheetWithTitle:title CancelButtonTitle:cancelButtonTitle DestructiveButtonTitle:destructiveButtonTitle];
        
        [self.config.modelButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *buttonDic = obj;
            
            void (^buttonAction)() = buttonDic[@"actionblock"];
            
            [self.actionSheetViewButtonIndexDic setValue:buttonAction forKey:[NSString stringWithFormat:@"%ld" , actionSheet.firstOtherButtonIndex + idx]];
            
        }];
        
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    //清空按钮数组
    
    [self.config.modelButtonArray removeAllObjects];
}

- (UIActionSheet *)sbHandleActionSheetWithTitle:(NSString *)title CancelButtonTitle:(NSString *)cancelButtonTitle DestructiveButtonTitle:(NSString *)destructiveButtonTitle{
    
    NSArray *array = self.config.modelButtonArray;
    
    switch (array.count) {
        case 0:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles: nil];
            break;
        case 1:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"], nil];
            break;
        case 2:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"], nil];
            break;
        case 3:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"], nil];
            break;
        case 4:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"], nil];
            break;
        case 5:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"],array[4][@"title"], nil];
            break;
        case 6:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"],array[4][@"title"],array[5][@"title"], nil];
            break;
        case 7:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"],array[4][@"title"],array[5][@"title"],array[6][@"title"], nil];
            break;
        case 8:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"],array[4][@"title"],array[5][@"title"],array[6][@"title"],array[7][@"title"], nil];
            break;
        case 9:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"],array[4][@"title"],array[5][@"title"],array[6][@"title"],array[7][@"title"],array[8][@"title"], nil];
            break;
        case 10:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array[0][@"title"],array[1][@"title"],array[2][@"title"],array[3][@"title"],array[4][@"title"],array[5][@"title"],array[6][@"title"],array[7][@"title"],array[8][@"title"],array[9][@"title"], nil];
            break;
        default:
            return [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles: nil];
            break;
    }
    
    return nil;
}

#pragma mark Tool

- (UIViewController *)getPresentedViewController:(UIViewController *)vc{
    
    if (vc.presentedViewController) {
        
        return [self getPresentedViewController:vc.presentedViewController];
        
    } else {
        
        return vc;
    }
    
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        
        if (self.config.modelCancelButtonAction) self.config.modelCancelButtonAction();
        
    } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        if (self.config.modelDestructiveButtonAction) self.config.modelDestructiveButtonAction();
        
    } else {
        
        void (^buttonAction)() = self.actionSheetViewButtonIndexDic[[NSString stringWithFormat:@"%ld" , buttonIndex]];
        
        if (buttonAction) buttonAction();
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //清空UIActionSheet按钮下标字典
    
    [self.actionSheetViewButtonIndexDic removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    
    //延迟释放模型 防止循环引用
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf) weakSelf.config = nil;
    });
    
}

#pragma mark LazyLoading

- (LEEActionSheetConfigModel *)config{
    
    if (!_config) {
        
        _config = [[LEEActionSheetConfigModel alloc]init];
        
        __weak typeof(self) weakSelf = self;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        _config.modelFinishConfig = ^(UIViewController *vc){
            
            [strongSelf configActionSheetWithShow:vc];
        };
        
    }
    
    return _config;
}

- (NSMutableDictionary *)actionSheetViewButtonIndexDic{
    
    if (!_actionSheetViewButtonIndexDic) _actionSheetViewButtonIndexDic = [NSMutableDictionary dictionary];
    
    return _actionSheetViewButtonIndexDic;
}

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LEEActionSheet shareActionSheetManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LEEActionSheet shareActionSheetManager].mainWindow) [LEEActionSheet shareActionSheetManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

@end

#pragma mark - ====================自定义====================

@interface LEEActionSheetViewController ()

@property (nonatomic , weak ) LEEActionSheetConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIImageView *actionSheetBackgroundImageView;

@property (nonatomic , strong ) UIView *actionSheetView;

@property (nonatomic , strong ) UIScrollView *actionSheetScrollView;

@property (nonatomic , strong ) UIButton *actionSheetCancelButton;

@property (nonatomic , strong ) NSMutableArray *actionSheetSubViewArray;

@property (nonatomic , strong ) NSMutableArray *actionSheetButtonArray;

@property (nonatomic , copy ) void (^closeAction)();

@end

@implementation LEEActionSheetViewController
{
    CGFloat actionSheetViewMaxWidth;
    CGFloat actionSheetViewMaxHeight;
    CGFloat actionSheetViewWidth;
    CGFloat actionSheetViewHeight;
    CGFloat customViewHeight;
    UIDeviceOrientation currentOrientation;
    BOOL isShowingActionSheet;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _actionSheetBackgroundImageView = nil;
    
    _actionSheetView = nil;
    
    _actionSheetScrollView = nil;
    
    _actionSheetCancelButton = nil;
    
    _actionSheetButtonArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.actionSheetBackgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.actionSheetBackgroundImageView];
    
    [self addNotification];
    
    currentOrientation = (UIDeviceOrientation)self.interfaceOrientation; //默认当前方向
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)changeOrientationNotification:(NSNotification *)notify{
    
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortraitUpsideDown &&
        [UIDevice currentDevice].orientation != UIDeviceOrientationFaceUp &&
        [UIDevice currentDevice].orientation != UIDeviceOrientationFaceDown) currentOrientation = [UIDevice currentDevice].orientation; //设置当前方向
    
    if (self.config.modelActionSheetCustomBackGroundStype == LEEActionSheetCustomBackGroundStypeBlur) {
        
        self.actionSheetBackgroundImageView.image = [[self getCurrentKeyWindowImage] LeeActionSheet_ApplyTintEffectWithColor:[self.config.modelActionSheetWindowBackGroundColor colorWithAlphaComponent:self.config.modelActionSheetCustomBackGroundStypeColorAlpha]];
    }
    
    if (iOS8) [self updateOrientationLayout];
}

- (void)updateOrientationLayout{
    
    actionSheetViewMaxHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]) >  CGRectGetWidth([[UIScreen mainScreen] bounds]) ? self.config.modelActionSheetMaxHeight : CGRectGetHeight([[UIScreen mainScreen] bounds]) - 20.0f; //更新最大高度 (iOS 8 以上处理)
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    if (isShowingActionSheet) actionSheetViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - actionSheetViewFrame.size.height) - self.config.modelActionSheetBottomMargin;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    [self updateActionSheetViewSubViewsLayout]; //更新子视图布局
    
    self.actionSheetView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , self.actionSheetView.center.y);
    
    self.actionSheetBackgroundImageView.frame = self.view.frame;
}

- (void)updateOrientationLayoutWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    actionSheetViewMaxHeight = UIDeviceOrientationIsLandscape(currentOrientation) ? CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20.0f : self.config.modelActionSheetMaxHeight; //更新最大高度 (iOS 8 以下处理)
    
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortrait:
        {
            CGRect actionSheetViewFrame = self.actionSheetView.frame;
            
            actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;;
            
            actionSheetViewFrame.origin.y = CGRectGetHeight(self.view.frame);
            
            if (isShowingActionSheet) actionSheetViewFrame.origin.y = (CGRectGetHeight(self.view.frame) - actionSheetViewFrame.size.height) - self.config.modelActionSheetBottomMargin;
            
            self.actionSheetView.frame = actionSheetViewFrame;
            
            self.actionSheetView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, self.actionSheetView.center.y);
            
            self.actionSheetBackgroundImageView.transform = CGAffineTransformIdentity;
            
            self.actionSheetBackgroundImageView.frame = self.view.frame;
        }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        {
            CGRect actionSheetViewFrame = self.actionSheetView.frame;
            
            actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;;
            
            actionSheetViewFrame.origin.y = CGRectGetWidth(self.view.frame);
            
            if (isShowingActionSheet) actionSheetViewFrame.origin.y = (CGRectGetWidth(self.view.frame) - actionSheetViewFrame.size.height) - self.config.modelActionSheetBottomMargin;
            
            self.actionSheetView.frame = actionSheetViewFrame;
            
            self.actionSheetView.center = CGPointMake(CGRectGetHeight(self.view.frame) / 2, self.actionSheetView.center.y);
            
            self.actionSheetBackgroundImageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            
            self.actionSheetBackgroundImageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        }
            break;
            
        case UIInterfaceOrientationLandscapeRight:
        {
            CGRect actionSheetViewFrame = self.actionSheetView.frame;
            
            actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight ? actionSheetViewMaxHeight : actionSheetViewHeight;;
            
            actionSheetViewFrame.origin.y = CGRectGetWidth(self.view.frame);
            
            if (isShowingActionSheet) actionSheetViewFrame.origin.y = (CGRectGetWidth(self.view.frame) - actionSheetViewFrame.size.height) - self.config.modelActionSheetBottomMargin;
            
            self.actionSheetView.frame = actionSheetViewFrame;
            
            self.actionSheetView.center = CGPointMake(CGRectGetHeight(self.view.frame) / 2 , self.actionSheetView.center.y);
            
            self.actionSheetBackgroundImageView.transform = CGAffineTransformMakeRotation(-(M_PI / 2));
            
            self.actionSheetBackgroundImageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        }
            break;
            
        default:
            break;
    }
    
    [self updateActionSheetViewSubViewsLayout]; //更新子视图布局
}

- (void)updateActionSheetViewSubViewsLayout{

    CGRect actionSheetScrollViewFrame = self.actionSheetScrollView.frame;
    
    actionSheetScrollViewFrame.size.height = _actionSheetCancelButton ? CGRectGetHeight(self.actionSheetView.frame) - CGRectGetHeight(self.actionSheetCancelButton.frame) - 10 : CGRectGetHeight(self.actionSheetView.frame);
    
    self.actionSheetScrollView.frame = actionSheetScrollViewFrame;
    
    if (_actionSheetCancelButton) {
        
        CGRect actionSheetCancelButtonFrame = self.actionSheetCancelButton.frame;
        
        actionSheetCancelButtonFrame.origin.y = CGRectGetHeight(self.actionSheetScrollView.frame) + 10;
        
        self.actionSheetCancelButton.frame = actionSheetCancelButtonFrame;
    }

}

- (void)updateActionSheetScrollViewSubViewsLayout{
    
    actionSheetViewHeight = 0.0f;
    
    actionSheetViewWidth = self.config.modelActionSheetMaxWidth;
    
    if (self.actionSheetSubViewArray.count > 0) actionSheetViewHeight += self.config.modelTopSubViewMargin;
    
    for (UIView *subView in self.actionSheetSubViewArray) {
        
        CGRect subViewFrame = subView.frame;
        
        subViewFrame.origin.y = actionSheetViewHeight;
        
        if (subView == self.config.modelCustomContentView) customViewHeight = subViewFrame.size.height;
        
        subView.frame = subViewFrame;
        
        actionSheetViewHeight += subViewFrame.size.height;
        
        actionSheetViewHeight += self.config.modelSubViewMargin;
    }
    
    if (self.actionSheetSubViewArray.count > 0) {
        
        actionSheetViewHeight -= self.config.modelSubViewMargin;
        
        actionSheetViewHeight += self.config.modelBottomSubViewMargin;
    }
    
    for (UIButton *button in self.actionSheetButtonArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.y = actionSheetViewHeight;
        
        button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height;
    }
    
    self.actionSheetScrollView.contentSize = CGSizeMake(actionSheetViewWidth, actionSheetViewHeight);
    
    if (_actionSheetCancelButton) actionSheetViewHeight += CGRectGetHeight(self.actionSheetCancelButton.frame) + 10.0f;
    
    if (iOS8) [self updateOrientationLayout]; //更新方向布局 iOS 8 以上处理
    
    if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //更新方向布局 iOS 8 以下处理
}


- (void)configActionSheet{
    
    actionSheetViewHeight = 0.0f;
    
    actionSheetViewWidth = self.config.modelActionSheetMaxWidth;
    
    [self.actionSheetView addSubview:self.actionSheetScrollView];
    
    [self.view addSubview: self.actionSheetView];
    
    for (NSDictionary *item in self.config.modelCustomSubViewsQueue) {
        
        switch ([item[@"type"] integerValue]) {
                
            case LEEActionSheetCustomSubViewTypeTitle:
            {
                
                NSString *title = self.config.modelTitleStr ? self.config.modelTitleStr : @" ";
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, actionSheetViewHeight, actionSheetViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin, 0)];
                
                [self.actionSheetScrollView addSubview:titleLabel];
                
                [self.actionSheetSubViewArray addObject:titleLabel];
                
                titleLabel.textAlignment = NSTextAlignmentCenter;
                
                titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                
                titleLabel.textColor = [UIColor blackColor];
                
                titleLabel.text = title;
                
                titleLabel.numberOfLines = 0;
                
                void(^addLabel)(UILabel *label) = item[@"block"];
                
                if (addLabel) addLabel(titleLabel);
                
                CGRect titleLabelRect = [self getLabelTextHeight:titleLabel];
                
                CGRect titleLabelFrame = titleLabel.frame;
                
                titleLabelFrame.size.height = titleLabelRect.size.height;
                
                titleLabel.frame = titleLabelFrame;
                
            }
                break;
            case LEEActionSheetCustomSubViewTypeContent:
            {
                
                NSString *content = self.config.modelContentStr ? self.config.modelContentStr : @" ";
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.config.modelLeftSubViewMargin, actionSheetViewHeight, actionSheetViewWidth - self.config.modelLeftSubViewMargin - self.config.modelRightSubViewMargin, 0)];
                
                [self.actionSheetScrollView addSubview:contentLabel];
                
                [self.actionSheetSubViewArray addObject:contentLabel];
                
                contentLabel.textAlignment = NSTextAlignmentCenter;
                
                contentLabel.font = [UIFont systemFontOfSize:14.0f];
                
                contentLabel.textColor = [UIColor blackColor];
                
                contentLabel.text = content;
                
                contentLabel.numberOfLines = 0;
                
                void(^addLabel)(UILabel *label) = item[@"block"];
                
                if (addLabel) addLabel(contentLabel);
                
                CGRect contentLabelRect = [self getLabelTextHeight:contentLabel];
                
                CGRect contentLabelFrame = contentLabel.frame;
                
                contentLabelFrame.size.height = contentLabelRect.size.height;
                
                contentLabel.frame = contentLabelFrame;
            }
                break;
            case LEEActionSheetCustomSubViewTypeCustomView:
            {
                
                if (self.config.modelCustomContentView) {
                    
                    CGRect customContentViewFrame = self.config.modelCustomContentView.frame;
                    
                    customContentViewFrame.origin.y = actionSheetViewHeight;
                    
                    customViewHeight = customContentViewFrame.size.height;
                    
                    self.config.modelCustomContentView.frame = customContentViewFrame;
                    
                    [self.actionSheetScrollView addSubview:self.config.modelCustomContentView];
                    
                    [self.actionSheetSubViewArray addObject:self.config.modelCustomContentView];
                    
                    [self.config.modelCustomContentView addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
                
                    [self.config.modelCustomContentView layoutSubviews];
                }
                
            }
                break;
            default:
                break;
        }
        
    }
    
    if (self.config.modelDestructiveButtonTitleStr || self.config.modelDestructiveButtonAction || self.config.modelDestructiveButtonBlock) {
        
        UIButton *destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        destructiveButton.frame = CGRectMake(0, actionSheetViewHeight, actionSheetViewWidth, 57.0f);
        
        [destructiveButton setClipsToBounds:YES];
        
        [destructiveButton.layer setBorderWidth:0.5f];
        
        [destructiveButton.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [destructiveButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
        [destructiveButton setTitle:self.config.modelDestructiveButtonTitleStr ? self.config.modelDestructiveButtonTitleStr : @"销毁" forState:UIControlStateNormal];
        
        [destructiveButton setTitleColor:[UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [destructiveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [destructiveButton setBackgroundImage:[self getImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        
        [destructiveButton setBackgroundImage:[self getImageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2f]] forState:UIControlStateHighlighted];
        
        [destructiveButton addTarget:self action:@selector(destructiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.actionSheetScrollView addSubview:destructiveButton];
        
        [self.actionSheetButtonArray addObject:destructiveButton];
        
        if (self.config.modelDestructiveButtonBlock) self.config.modelDestructiveButtonBlock(destructiveButton);
    }
    
    for (NSDictionary *buttonDic in self.config.modelButtonArray) {
        
        NSString *buttonTitle = buttonDic[@"title"];
        
        void(^addButton)(UIButton *button) = buttonDic[@"block"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, actionSheetViewHeight, actionSheetViewWidth, 57.0f);
        
        [button setClipsToBounds:YES];
        
        [button.layer setBorderWidth:0.5f];
        
        [button.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[self getImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[self getImageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2f]] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.actionSheetScrollView addSubview:button];
        
        [self.actionSheetButtonArray addObject:button];
        
        if (addButton) addButton(button);
    }
    
    self.actionSheetScrollView.layer.cornerRadius = self.config.modelCornerRadius;
    
    if (self.config.modelCancelButtonTitleStr || self.config.modelCancelButtonAction || self.config.modelCancelButtonBlock) {
        
        self.actionSheetCancelButton.frame = CGRectMake(0, 10.0f, actionSheetViewWidth, 57.0f);
        
        [self.actionSheetCancelButton setClipsToBounds:YES];
        
        [self.actionSheetCancelButton.layer setBorderWidth:0.5f];
        
        [self.actionSheetCancelButton.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
        
        [self.actionSheetCancelButton.layer setCornerRadius:self.config.modelCornerRadius];
        
        [self.actionSheetCancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        
        [self.actionSheetCancelButton setTitle:self.config.modelCancelButtonTitleStr ? self.config.modelCancelButtonTitleStr : @"取消" forState:UIControlStateNormal];
        
        [self.actionSheetCancelButton setTitleColor:[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [self.actionSheetCancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [self.actionSheetCancelButton setBackgroundColor:self.config.modelActionSheetViewColor];
        
        [self.actionSheetCancelButton setBackgroundImage:[self getImageWithColor:self.config.modelActionSheetViewColor] forState:UIControlStateNormal];
        
        [self.actionSheetCancelButton setBackgroundImage:[self getImageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2f]] forState:UIControlStateHighlighted];
        
        [self.actionSheetCancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.actionSheetView addSubview:self.actionSheetCancelButton];
        
        if (self.config.modelCancelButtonBlock) self.config.modelCancelButtonBlock(self.actionSheetCancelButton);
    }
    
    [self updateActionSheetScrollViewSubViewsLayout];

    //开启显示动画
    
    [self showActionSheetAnimations];
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    if (self.config.modelCancelButtonAction) self.config.modelCancelButtonAction();
    
    [self closeAnimations];
}

- (void)destructiveButtonAction:(UIButton *)sender{
    
    if (self.config.modelDestructiveButtonAction) self.config.modelDestructiveButtonAction();
    
    [self closeAnimations];
}

- (void)buttonAction:(UIButton *)sender{
    
    NSInteger index = [self.actionSheetButtonArray indexOfObject:sender];
    
    if (self.config.modelButtonArray.count != self.actionSheetButtonArray.count) index --;
    
    void (^buttonAction)() = self.config.modelButtonArray[index][@"actionblock"];
    
    if (buttonAction) buttonAction();
    
    if (self.config.modelIsCustomButtonClickClose) [self closeAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.config.modelIsActionSheetWindowTouchClose) [self closeAnimations]; //拦截ActionSheetView点击响应
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *customView = (UIView *)object;
    
    if (customViewHeight != CGRectGetHeight(customView.frame)) [self updateActionSheetScrollViewSubViewsLayout];
}

#pragma mark start animations

- (void)showActionSheetAnimations{
    
    if (self.config.modelActionSheetCustomBackGroundStype == LEEActionSheetCustomBackGroundStypeBlur) {
        
        self.actionSheetBackgroundImageView.alpha = 0.0f;
        
        self.actionSheetBackgroundImageView.image = [[self getCurrentKeyWindowImage] LeeActionSheet_ApplyBlurWithRadius:10.0f tintColor:[self.config.modelActionSheetWindowBackGroundColor colorWithAlphaComponent:self.config.modelActionSheetCustomBackGroundStypeColorAlpha] saturationDeltaFactor:1.0f maskImage:nil];
    }
    
    [self.currentKeyWindow endEditing:YES]; //结束输入 收起键盘
    
    isShowingActionSheet = YES; //显示ActionSheet
    
    [LEEActionSheet shareActionSheetManager].actionSheetWindow.hidden = NO;
    
    [[LEEActionSheet shareActionSheetManager].actionSheetWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.config.modelActionSheetCustomBackGroundStype == LEEActionSheetCustomBackGroundStypeTranslucent) {
        
        [UIView animateWithDuration:self.config.modelActionSheetOpenAnimationDuration animations:^{
            
            weakSelf.view.backgroundColor = [weakSelf.config.modelActionSheetWindowBackGroundColor colorWithAlphaComponent:weakSelf.config.modelActionSheetCustomBackGroundStypeColorAlpha];
            
            if (iOS8) [self updateOrientationLayout]; //更新布局 iOS 8 以上处理
            
            if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //更新布局 iOS 8 以下处理
            
        } completion:^(BOOL finished) {}];
        
    } else if (weakSelf.config.modelActionSheetCustomBackGroundStype == LEEActionSheetCustomBackGroundStypeBlur) {
        
        [UIView animateWithDuration:self.config.modelActionSheetOpenAnimationDuration animations:^{
            
            weakSelf.actionSheetBackgroundImageView.alpha = 1.0f;
            
            if (iOS8) [self updateOrientationLayout]; //更新布局 iOS 8 以上处理
            
            if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //更新布局 iOS 8 以下处理
            
        } completion:^(BOOL finished) {}];
        
    }
    
}

#pragma mark close animations

- (void)closeAnimations{
    
    [self closeAnimationsWithCompletionBlock:nil];
}

- (void)closeAnimationsWithCompletionBlock:(void (^)())completionBlock{
    
    if (self.config.modelCustomContentView) [self.config.modelCustomContentView removeObserver:self forKeyPath:@"frame"];
    
    [[LEEActionSheet shareActionSheetManager].actionSheetWindow endEditing:YES]; //结束输入 收起键盘
    
    isShowingActionSheet = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.config.modelActionSheetCloseAnimationDuration animations:^{
        
        if (weakSelf.config.modelActionSheetCustomBackGroundStype == LEEActionSheetCustomBackGroundStypeTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelActionSheetCustomBackGroundStype == LEEActionSheetCustomBackGroundStypeBlur) {
            
            weakSelf.actionSheetBackgroundImageView.alpha = 0.0f;
        }
        
        if (iOS8) [self updateOrientationLayout]; //更新布局 iOS 8 以上处理
        
        if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:self.interfaceOrientation]; //更新布局 iOS 8 以下处理
        
    } completion:^(BOOL finished) {
        
        weakSelf.actionSheetView.transform = CGAffineTransformIdentity;
        
        weakSelf.actionSheetView.alpha = 1.0f;
        
        [LEEActionSheet shareActionSheetManager].actionSheetWindow.hidden = YES;
        
        [[LEEActionSheet shareActionSheetManager].actionSheetWindow resignKeyWindow];
        
        if (weakSelf.closeAction) weakSelf.closeAction();
        
        if (completionBlock) completionBlock();
    }];
    
}

#pragma mark Tool

- (UIImage *)getCurrentKeyWindowImage{
    
    UIGraphicsBeginImageContext(self.currentKeyWindow.frame.size);
    
    [self.currentKeyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGRect)getLabelTextHeight:(UILabel *)label{
    
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
    
    return rect;
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LEEActionSheet shareActionSheetManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LEEActionSheet shareActionSheetManager].mainWindow) [LEEActionSheet shareActionSheetManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

- (UIImageView *)actionSheetBackgroundImageView{
    
    if (!_actionSheetBackgroundImageView) _actionSheetBackgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    return _actionSheetBackgroundImageView;
}

- (UIView *)actionSheetView{
    
    if (!_actionSheetView) {
        
        _actionSheetView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.config.modelActionSheetMaxWidth, 0)];
        
        _actionSheetView.backgroundColor = [UIColor clearColor];
    }
    
    return _actionSheetView;
}

- (UIScrollView *)actionSheetScrollView{
    
    if (!_actionSheetScrollView) {
        
        _actionSheetScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.actionSheetView.frame), 0)];
        
        _actionSheetScrollView.backgroundColor = self.config.modelActionSheetViewColor;
        
        _actionSheetScrollView.directionalLockEnabled = YES;
        
        _actionSheetScrollView.bounces = NO;
    }
    
    return _actionSheetScrollView;
}

- (UIButton *)actionSheetCancelButton{
    
    if (!_actionSheetCancelButton) _actionSheetCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    return _actionSheetCancelButton;
}

- (NSMutableArray *)actionSheetSubViewArray{
    
    if (!_actionSheetSubViewArray) _actionSheetSubViewArray = [NSMutableArray array];
    
    return _actionSheetSubViewArray;
}

- (NSMutableArray *)actionSheetButtonArray{
    
    if (!_actionSheetButtonArray) _actionSheetButtonArray = [NSMutableArray array];
    
    return _actionSheetButtonArray;
}

#pragma mark  Rotation

- (BOOL)shouldAutorotate{
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (!iOS8) [self updateOrientationLayoutWithInterfaceOrientation:toInterfaceOrientation]; //iOS 8 以下处理
}

@end

@interface LEEActionSheetCustom ()<LEEActionSheetProtocol>

@property (nonatomic , strong ) LEEActionSheetViewController *actionSheetViewController;

@end

@implementation LEEActionSheetCustom

- (void)dealloc{
    
    _config = nil;
    
    _actionSheetViewController = nil;
}

- (void)showActionSheet{
    
    if (self.config) {
        
        [LEEActionSheet shareActionSheetManager].actionSheetWindow.backgroundColor = [self.config.modelActionSheetWindowBackGroundColor colorWithAlphaComponent:0.0f];
        
        [LEEActionSheet shareActionSheetManager].actionSheetWindow.rootViewController = self.actionSheetViewController;
        
        self.actionSheetViewController.config = self.config;
        
        [self.actionSheetViewController configActionSheet];
    }
    
}

#pragma mark LEEActionSheetProtocol

- (void)closeActionSheetWithCompletionBlock:(void (^)())completionBlock{
 
    [self.actionSheetViewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark LazyLoading

- (LEEActionSheetConfigModel *)config{
    
    if (!_config) {
        
        _config = [[LEEActionSheetConfigModel alloc]init];
        
        __weak typeof(self) weakSelf = self;
        
        _config.modelFinishConfig = ^(UIViewController *vc){
            
            
            if (weakSelf) {
                
                if ([LEEActionSheet shareActionSheetManager].customActionSheetArray.count) {
                    
                    if ([[LEEActionSheet shareActionSheetManager].customActionSheetArray containsObject:weakSelf]) {
                        
                        [weakSelf showActionSheet];
                        
                    } else {
                        
                        LEEActionSheetCustom *lastCustom = [LEEActionSheet shareActionSheetManager].customActionSheetArray.lastObject;
                        
                        [lastCustom closeActionSheetWithCompletionBlock:^{
                            
                            if (weakSelf) [weakSelf showActionSheet];
                        }];
                        
                        [[LEEActionSheet shareActionSheetManager].customActionSheetArray addObject:weakSelf];
                    }
                    
                } else {
                    
                    [weakSelf showActionSheet];
                    
                    [[LEEActionSheet shareActionSheetManager].customActionSheetArray addObject:weakSelf];
                }
                
            }

        };
        
    }
    
    return _config;
}

- (LEEActionSheetViewController *)actionSheetViewController{
    
    if (!_actionSheetViewController) {
        
        _actionSheetViewController = [[LEEActionSheetViewController alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        _actionSheetViewController.closeAction = ^(){
            
            if (weakSelf) {
                
                [LEEActionSheet shareActionSheetManager].actionSheetWindow.rootViewController = nil;
                
                weakSelf.actionSheetViewController = nil;
                
                if ([LEEActionSheet shareActionSheetManager].customActionSheetArray.lastObject == weakSelf) {
                    
                    [[LEEActionSheet shareActionSheetManager].customActionSheetArray removeObject:weakSelf];
                    
                    if ([LEEActionSheet shareActionSheetManager].customActionSheetArray.count) {
                        
                       [LEEActionSheet shareActionSheetManager].customActionSheetArray.lastObject.config.modelFinishConfig(nil);
                    }
                    
                } else {
                    
                    if (!weakSelf.config.modelIsAddQueue) [[LEEActionSheet shareActionSheetManager].customActionSheetArray removeObject:weakSelf];
                }
                
            }
            
        };
        
    }
    
    return _actionSheetViewController;
}

@end


#pragma mark - ====================工具类====================


@implementation UIImage (LEEActionSheetImageEffects)

-(UIImage*)LeeActionSheet_ApplyLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    
    return[self LeeActionSheet_ApplyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)LeeActionSheet_ApplyExtraLightEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    
    return[self LeeActionSheet_ApplyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)LeeActionSheet_ApplyDarkEffect {
    
    UIColor*tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    
    return[self LeeActionSheet_ApplyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)LeeActionSheet_ApplyTintEffectWithColor:(UIColor*)tintColor {
    
    const CGFloat EffectColorAlpha = 0.6;
    UIColor*effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if(componentCount == 2) {
        CGFloat b;
        if([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else{
        CGFloat r, g, b;
        if([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return[self LeeActionSheet_ApplyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:1.0f maskImage:nil];
}
-(UIImage*)LeeActionSheet_ApplyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage {
    /**
     *  半径,颜色,色彩饱和度
     */
    //  Check pre-conditions. 检查前提条件
    if(self.size.width <1||self.size.height <1){
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@",self.size.width,self.size.height,self);
        return nil;
    }
    if(!self.CGImage){
        NSLog(@"*** error: image must be backed by a CGImage: %@",self);
        return nil;
    }
    if(maskImage &&!maskImage.CGImage){
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = {CGPointZero , self.size};
    UIImage*effectImage = self;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor -1.)> __FLT_EPSILON__;
    if(hasBlur || hasSaturationChange) {
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext,1.0,-1.0);
        CGContextTranslateCTM(effectInContext,0,-self.size.height);
        CGContextDrawImage(effectInContext,imageRect,self.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        if(hasBlur){
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius *[[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius *3.* sqrt(2* M_PI)/4+0.5);
            if(radius %2 != 1) {
                radius += 1;// force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer,&effectInBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if(hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722+0.9278* s,0.0722-0.0722* s,0.0722-0.0722* s,0,
                0.7152-0.7152* s,0.7152+0.2848* s,0.7152-0.7152* s,0,
                0.2126-0.2126* s,0.2126-0.2126* s,0.2126+0.7873* s,0,
                0,0,0,1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for(NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i]* divisor);
            }
            if(hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer,&effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if(!effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if(effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context. 设置输出上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    // Draw base image. 绘制基准图像
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    // Draw effect image. 绘制效果图像
    if(hasBlur) {
        CGContextSaveGState(outputContext);
        if(maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint. 添加颜色渲染
    if(tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready. 输出图像
    UIImage*outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}
@end
