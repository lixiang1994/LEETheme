
/*!
 *  @header LEEActionSheet.h
 *          
 *
 *  @brief  操作列表
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LEEActionSheetSystem , LEEActionSheetCustom , LEEActionSheetConfigModel;

typedef LEEActionSheetConfigModel *(^LEEConfigActionSheet)();
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToBool)(BOOL);
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToInteger)(NSInteger number);
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToFloat)(CGFloat number);
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToString)(NSString *str);
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToView)(UIView *view);
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToColor)(UIColor *color);
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToButtonAndBlock)(NSString *title , void(^buttonAction)());
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToButtonBlock)(void(^buttonAction)());
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToCustomTextField)(void(^addTextField)(UITextField *textField));
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToCustomButton)(void(^addButton)(UIButton *button));
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToCustomLabel)(void(^addLabel)(UILabel *label));
typedef LEEActionSheetConfigModel *(^LEEConfigActionSheetToViewController)(UIViewController *viewController);


/*
 
 *********************************************************************************
 *
 * 在使用LEEActionSheet的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ    : 可以添加SDAutoLayout群 497140713 在这里找我到(LEE)
 * Email : applelixiang@126.com
 * GitHub: https://github.com/lixiang1994/LEEActionSheet
 * 简书:    http://www.jianshu.com/users/a6da0db100c8
 *
 *********************************************************************************
 
 */


@interface LEEActionSheet : NSObject

/**
 *  系统类型
 */
@property (nonatomic , strong ) LEEActionSheetSystem *system;
/**
 *  自定义类型
 */
@property (nonatomic , strong ) LEEActionSheetCustom *custom;

/** 初始化ActionSheet */

+ (LEEActionSheet *)actionSheet;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow *)window;

/** 关闭自定义ActionSheet */

+ (void)closeCustomActionSheet;

+ (void)closeCustomActionSheetWithCompletionBlock:(void (^)())completionBlock;

@end

@interface LEEActionSheetConfigModel : NSObject

/*
 *************************说明************************
 
 LEEActionSheet 目前提供两种方案 1.使用系统ActionSheet  2.使用自定义ActionSheet
 
 1.系统ActionSheet [LEEActionSheet actionSheet].system.cofing.XXXXX.LeeShow();
 
 2.自定义ActionSheet [LEEActionSheet actionSheet].custom.cofing.XXXXX.LeeShow();
 
 两种ActionSheet的设置方法如下,其中系统ActionSheet类型支持基本设置,自定义ActionSheet支持全部设置/
 
 设置方法结束后在最后请不要忘记使用.LeeShow()方法显示ActionSheet.
 
 最低支持iOS7及以上
 
 *****************************************************
 */

/* ActionSheet 基本设置 */

/** 设置 ActionSheet 标题 -> 格式: .LeeTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToString LeeTitle;
/** 设置 ActionSheet 内容 -> 格式: .LeeContent(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToString LeeContent;
/** 设置 ActionSheet 取消按钮标题 -> 格式: .LeeCancelButtonTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToString LeeCancelButtonTitle;
/** 设置 ActionSheet 取消按钮响应事件Block(取消按钮点击后会自动关闭ActionSheet 请勿再次调用关闭方法) -> 格式: .LeeCancelButtonAction(^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToButtonBlock LeeCancelButtonAction;
/** 设置 ActionSheet 销毁按钮标题 -> 格式: .LeeDestructiveButtonTitle(@@"") */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToString LeeDestructiveButtonTitle;
/** 设置 ActionSheet 销毁按钮响应事件Block -> 格式: .LeeDestructiveButtonAction(^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToButtonBlock LeeDestructiveButtonAction;
/** 设置 ActionSheet 添加按钮 -> 格式: .LeeAddButton(@@"" , ^(){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToButtonAndBlock LeeAddButton;

/* ActionSheet 自定义设置 */

/** 设置 ActionSheet 自定义标题 -> 格式: .LeeCustomTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToCustomLabel LeeCustomTitle;
/** 设置 ActionSheet 自定义内容 -> 格式: .LeeCustomContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToCustomLabel LeeCustomContent;
/** 设置 ActionSheet 自定义取消按钮 -> 格式: .LeeCustomCancelButton(^(UIButton *button){ //code.. } */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToCustomButton LeeCustomCancelButton;
/** 设置 ActionSheet 自定义销毁按钮 -> 格式: .LeeCustomDestructiveButton(^(UIButton *button){ //code.. } */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToCustomButton LeeCustomDestructiveButton;
/** 设置 ActionSheet 自定义视图 -> 格式: .LeeCustomView(UIView) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToView LeeCustomView;
/** 设置 ActionSheet 添加自定义按钮 -> 格式: .LeeAddCustomButton(^(UIButton *button){ //code.. }) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToCustomButton LeeAddCustomButton;

/** 设置 ActionSheet 自定义圆角半径 -> 格式: .LeeCustomCornerRadius(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomCornerRadius;
/** 设置 ActionSheet 自定义控件间距 -> 格式: .LeeCustomSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomSubViewMargin;
/** 设置 ActionSheet 自定义顶部距离控件的间距 -> 格式: .LeeCustomTopSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomTopSubViewMargin;
/** 设置 ActionSheet 自定义底部距离控件的间距 -> 格式: .LeeCustomBottomSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomBottomSubViewMargin;
/** 设置 ActionSheet 自定义左侧距离控件的间距 -> 格式: .LeeCustomLeftSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomLeftSubViewMargin;
/** 设置 ActionSheet 自定义右侧距离控件的间距 -> 格式: .LeeCustomRightSubViewMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomRightSubViewMargin;
/** 设置 ActionSheet 自定义ActionSheet底部距离屏幕的间距 -> 格式: .LeeCustomActionSheetBottomMargin(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetBottomMargin;
/** 设置 ActionSheet 自定义ActionSheet最大宽度 -> 格式: .LeeCustomActionSheetMaxWidth(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetMaxWidth;
/** 设置 ActionSheet 自定义ActionSheet最大高度 -> 格式: .LeeCustomActionSheetMaxHeight(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetMaxHeight;
/** 设置 ActionSheet 自定义ActionSheet开启动画时长 -> 格式: .LeeCustomActionSheetOpenAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetOpenAnimationDuration;
/** 设置 ActionSheet 自定义ActionSheet关闭动画时长 -> 格式: .LeeCustomActionSheetCloseAnimationDuration(0.0f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetCloseAnimationDuration;

/** 设置 ActionSheet 自定义ActionSheet颜色 -> 格式: .LeeCustomActionSheetViewColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToColor LeeCustomActionSheetViewColor;
/** 设置 ActionSheet 自定义ActionSheet半透明或模糊背景颜色 -> 格式: .LeeCustomActionSheetViewBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToColor LeeCustomActionSheetViewBackGroundColor;

/** 设置 ActionSheet 自定义ActionSheet半透明背景样式及透明度 [默认] -> 格式: .LeeCustomActionSheetViewBackGroundStypeTranslucent(0.6f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetViewBackGroundStypeTranslucent;
/** 设置 ActionSheet 自定义ActionSheet模糊背景样式及透明度 -> 格式: .LeeCustomActionSheetViewBackGroundStypeBlur(0.6f) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToFloat LeeCustomActionSheetViewBackGroundStypeBlur;

/** 设置 ActionSheet 自定义ActionSheet背景触摸关闭 -> 格式: .LeeCustomActionSheetTouchClose() */
@property (nonatomic , copy , readonly ) LEEConfigActionSheet LeeCustomActionSheetTouchClose;
/** 设置 ActionSheet 自定义按钮点击不关闭ActionSheet -> 格式: .LeeCustomButtonClickNotClose() */
@property (nonatomic , copy , readonly ) LEEConfigActionSheet LeeCustomButtonClickNotClose;

/** 显示 ActionSheet 是否加入到队列 -> 格式: .LeeAddQueue(NO) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToBool LeeAddQueue;

/** 显示 ActionSheet 默认通过KeyWindow弹出 -> 格式: .LeeShow() */
@property (nonatomic , copy , readonly ) LEEConfigActionSheet LeeShow;
/** 显示 ActionSheet 通过指定视图控制器弹出 (仅适用系统类型)  -> 格式: .LeeShowFromViewController(UIViewController) */
@property (nonatomic , copy , readonly ) LEEConfigActionSheetToViewController LeeShowFromViewController;

@end

@interface LEEActionSheetSystem : NSObject
/** 开始设置 */
@property (nonatomic , strong ) LEEActionSheetConfigModel *config;

@end

@interface LEEActionSheetCustom : NSObject
/** 开始设置 */
@property (nonatomic , strong ) LEEActionSheetConfigModel *config;

@end

@interface LEEActionSheetViewController : UIViewController @end




/*
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *                 神兽保佑
 *                 代码无BUG!
 */






/* 以下是内部使用的工具类 ╮(╯▽╰)╭ 无视就好 不许乱动 "( *・ω・)✄╰ひ╯ */

@interface UIImage (LEEActionSheetImageEffects)

- (UIImage*)LeeActionSheet_ApplyLightEffect;

- (UIImage*)LeeActionSheet_ApplyExtraLightEffect;

- (UIImage*)LeeActionSheet_ApplyDarkEffect;

- (UIImage*)LeeActionSheet_ApplyTintEffectWithColor:(UIColor*)tintColor;

- (UIImage*)LeeActionSheet_ApplyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end
