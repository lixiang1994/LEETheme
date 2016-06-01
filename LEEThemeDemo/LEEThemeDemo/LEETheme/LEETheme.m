/*!
 *  @header LEETheme.m
 *          LEEThemeDemo
 *
 *  @brief  LEE主题管理
 *
 *  @author LEE
 *  @copyright    Copyright © 2016年 lee. All rights reserved.
 *  @version    V1.0
 */


#import "LEETheme.h"

#import <objc/runtime.h>

NSString * const LEEThemeChangingNotificaiton = @"LEEThemeChangingNotificaiton";
NSString * const LEEThemeCurrentTag = @"LEEThemeCurrentTag";


@interface LEETheme ()

@property (nonatomic , copy ) NSString *currentTag;

@property (nonatomic , copy ) NSMutableSet *allTags;

@end

@implementation LEETheme

+ (LEETheme *)shareTheme{
    
    static LEETheme *themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        themeManager = [[LEETheme alloc]init];
    });
    
    return themeManager;
}

+ (void)startTheme:(NSString *)tag{
    
    [LEETheme shareTheme].currentTag = tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeChangingNotificaiton object:nil userInfo:nil];
}

+ (NSString *)currentThemeTag{
    
    return [LEETheme shareTheme].currentTag ? [LEETheme shareTheme].currentTag : [[NSUserDefaults standardUserDefaults] objectForKey:LEEThemeCurrentTag];
}

- (void)setCurrentTag:(NSString *)currentTag{
    
    _currentTag = currentTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:LEEThemeCurrentTag];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - LazyLoading

- (NSMutableSet *)allTags{
    
    if (!_allTags) _allTags = [NSMutableSet set];

    return _allTags;
}

@end

#pragma mark - ----------------主题设置模型----------------

@interface LEEThemeConfigModel ()

@property (nonatomic , copy ) void(^modelInitCurrentThemeConfig)();

@property (nonatomic , copy ) NSString *modelCurrentThemeTag;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeTintColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeTextColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBarTintColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBorderColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeShadowColorConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeBackgroundColorConfigInfo;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeImageConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeImageNameConfigInfo;
@property (nonatomic , copy ) NSMutableDictionary *modelThemeImagePathConfigInfo;

@property (nonatomic , assign ) CGFloat modelChangeThemeAnimationDuration;

@end

@implementation LEEThemeConfigModel

- (void)dealloc{
    
    _modelCurrentThemeTag = nil;
    _modelThemeConfigInfo = nil;
    
    _modelThemeTintColorConfigInfo = nil;
    _modelThemeTextColorConfigInfo = nil;
    _modelThemeBarTintColorConfigInfo = nil;
    _modelThemeBorderColorConfigInfo = nil;
    _modelThemeShadowColorConfigInfo = nil;
    _modelThemeBackgroundColorConfigInfo = nil;
    
    _modelThemeImageConfigInfo = nil;
    _modelThemeImageNameConfigInfo = nil;
    _modelThemeImagePathConfigInfo = nil;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认属性值
        
        _modelChangeThemeAnimationDuration = 0.2f; //默认更改主题动画时长为0.2秒
    }
    return self;
}

- (void)initCurrentThemeConfigHandle:(NSString *)tag{
    
    if ([[LEETheme currentThemeTag] isEqualToString:tag]) {
        
        if (self.modelInitCurrentThemeConfig) self.modelInitCurrentThemeConfig();
    }
    
}

- (LEEConfigThemeToTagAndBlock)LeeAddCustomConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , LEEThemeConfigBlock configBlock){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToTagsAndBlock)LeeAddCustomConfigs{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSArray *tags , LEEThemeConfigBlock configBlock){
        
        [[LEETheme shareTheme].allTags addObjectsFromArray:tags];
        
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
            
            [weakSelf initCurrentThemeConfigHandle:tag];
        }];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeTintColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddTextColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeTextColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddBarTintColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBarTintColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddBorderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBorderColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeShadowColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToColor)LeeAddBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIColor *color){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeBackgroundColorConfigInfo setObject:color forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToImage)LeeAddImage{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , UIImage *image){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeImageConfigInfo setObject:image forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddImageName{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imageName){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeImageNameConfigInfo setObject:imageName forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToString)LeeAddImagePath{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *imagePath){
        
        [[LEETheme shareTheme].allTags addObject:tag];
        
        [weakSelf.modelThemeImagePathConfigInfo setObject:imagePath forKey:tag];
        
        [weakSelf initCurrentThemeConfigHandle:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToFloat)LeeChangeThemeAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        _modelChangeThemeAnimationDuration = number;
        
        return weakSelf;
    };
    
}

#pragma mark - LazyLoading

- (NSMutableDictionary *)modelThemeConfigInfo{
    
    if (!_modelThemeConfigInfo) _modelThemeConfigInfo = [NSMutableDictionary dictionary];

    return _modelThemeConfigInfo;
}

- (NSMutableDictionary *)modelThemeTintColorConfigInfo{
    
    if (!_modelThemeTintColorConfigInfo) _modelThemeTintColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeTintColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeTextColorConfigInfo{
    
    if (!_modelThemeTextColorConfigInfo) _modelThemeTextColorConfigInfo = [NSMutableDictionary dictionary];

    return _modelThemeTextColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeBarTintColorConfigInfo{
    
    if (!_modelThemeBarTintColorConfigInfo) _modelThemeBarTintColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBarTintColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeBorderColorConfigInfo{
    
    if (!_modelThemeBorderColorConfigInfo) _modelThemeBorderColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBorderColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeShadowColorConfigInfo{
    
    if (!_modelThemeShadowColorConfigInfo) _modelThemeShadowColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeShadowColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeBackgroundColorConfigInfo{
    
    if (!_modelThemeBackgroundColorConfigInfo) _modelThemeBackgroundColorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeBackgroundColorConfigInfo;
}

- (NSMutableDictionary *)modelThemeImageConfigInfo{
    
    if (!_modelThemeImageConfigInfo) _modelThemeImageConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeImageConfigInfo;
}

- (NSMutableDictionary *)modelThemeImageNameConfigInfo{
    
    if (!_modelThemeImageNameConfigInfo) _modelThemeImageNameConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeImageNameConfigInfo;
}

- (NSMutableDictionary *)modelThemeImagePathConfigInfo{
    
    if (!_modelThemeImagePathConfigInfo) _modelThemeImagePathConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelThemeImagePathConfigInfo;
}

@end

#pragma mark - ----------------主题设置----------------

@implementation NSObject (LEEThemeConfigObject)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"dealloc"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            method_exchangeImplementations(originalMethod, leeMethod);
        }];
        
    });
    
}

- (void)lee_dealloc{
    
    if ([self isLeeTheme]) [[NSNotificationCenter defaultCenter] removeObserver:self name:LEEThemeChangingNotificaiton object:nil];
    
    if ([self isLeeTheme]) objc_removeAssociatedObjects(self);
    
    [self lee_dealloc];
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeConfigNotify:) name:LEEThemeChangingNotificaiton object:nil];
}

- (void)changeThemeConfigNotify:(NSNotification *)notify{
    
    [self changeThemeConfigWithAboutConfigBlock:nil];
}

- (BOOL)isChangeTheme{
    
    return (!self.lee_theme.modelCurrentThemeTag || ![self.lee_theme.modelCurrentThemeTag isEqualToString:[LEETheme currentThemeTag]]) ? YES : NO;
}

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        self.lee_theme.modelCurrentThemeTag = [LEETheme currentThemeTag];
        
        NSDictionary *themeConfigInfo = self.lee_theme.modelThemeConfigInfo;
        
        LEEThemeConfigBlock configBlock = themeConfigInfo[[LEETheme currentThemeTag]];
        
        [UIView beginAnimations:@"LEEThemeChangeAnimations" context:nil];
        
        [UIView setAnimationDuration:self.lee_theme.modelChangeThemeAnimationDuration];
        
        if (configBlock) configBlock(self);
        
        if (aboutConfigBlock) aboutConfigBlock();
        
        [UIView commitAnimations];
    }
    
}

- (LEEThemeConfigModel *)lee_theme{
    
    LEEThemeConfigModel *model = objc_getAssociatedObject(self, _cmd);
    
    if (!model) {
        
        model = [LEEThemeConfigModel new];
        
        objc_setAssociatedObject(self, _cmd, model , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addNotification];
        
        [self setIsLeeTheme:YES];
        
        __weak typeof(self) weakSelf = self;
        
        model.modelInitCurrentThemeConfig = ^(){
            
            if (weakSelf) {
                
                [weakSelf changeThemeConfigWithAboutConfigBlock:nil];
            }
            
        };
        
    }
    
    return model;
}

- (void)setLee_theme:(LEEThemeConfigModel *)lee_theme{
    
    objc_setAssociatedObject(self, @selector(lee_theme), lee_theme , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLeeTheme{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsLeeTheme:(BOOL)isLeeTheme{
    
    objc_setAssociatedObject(self, @selector(isLeeTheme), @(isLeeTheme) , OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation CALayer (LEEThemeConfigLayer)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        void (^tempAboutConfigBlock)() = aboutConfigBlock;
        
        aboutConfigBlock = ^(){
            
            if (tempAboutConfigBlock) tempAboutConfigBlock();
            
            UIColor *borderColor = self.lee_theme.modelThemeBorderColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *shadowColor = self.lee_theme.modelThemeShadowColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (borderColor) [self setBorderColor:borderColor.CGColor];
            
            if (shadowColor) [self setShadowColor:shadowColor.CGColor];
            
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation CAShapeLayer (LEEThemeConfigShapeLayer)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){

        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIView (LEEThemeConfigView)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        void (^tempAboutConfigBlock)() = aboutConfigBlock;
        
        aboutConfigBlock = ^(){
            
            if (tempAboutConfigBlock) tempAboutConfigBlock();
            
            UIColor *backgroundColor = self.lee_theme.modelThemeBackgroundColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *tintColor = self.lee_theme.modelThemeTintColorConfigInfo[[LEETheme currentThemeTag]];

            if (backgroundColor) [self setValue:backgroundColor forKey:@"backgroundColor"];
            
            if (tintColor) [self setValue:tintColor forKey:@"tintColor"];
            
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIButton (LEEThemeConfigButton)



@end

@implementation UITextField (LEEThemeConfigTextField)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){
            
            UIColor *textColor = self.lee_theme.modelThemeTextColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (textColor) [self setValue:textColor forKey:@"textColor"];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UITextView (LEEThemeConfigTextView)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){
            
            UIColor *textColor = self.lee_theme.modelThemeTextColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (textColor) [self setValue:textColor forKey:@"textColor"];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UILabel (LEEThemeConfigLabel)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
     
        aboutConfigBlock = ^(){
          
            UIColor *textColor = self.lee_theme.modelThemeTextColorConfigInfo[[LEETheme currentThemeTag]];
            
            UIColor *shadowColor = self.lee_theme.modelThemeShadowColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (textColor) [self setValue:textColor forKey:@"textColor"];
            
            if (shadowColor) [self setShadowColor:shadowColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UINavigationBar (LEEThemeConfigNavigationBar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = self.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (barTintColor) [self setBarTintColor:barTintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UITabBar (LEEThemeConfigTabBar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = self.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (barTintColor) [self setBarTintColor:barTintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end

@implementation UIToolbar (LEEThemeConfigToolbar)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){
            
            UIColor *barTintColor = self.lee_theme.modelThemeBarTintColorConfigInfo[[LEETheme currentThemeTag]];
            
            if (barTintColor) [self setBarTintColor:barTintColor];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
    }
    
}

@end





@implementation UIImageView (LEEThemeConfigImageView)

- (void)changeThemeConfigWithAboutConfigBlock:(void (^)())aboutConfigBlock{
    
    if ([self isChangeTheme]) {
        
        aboutConfigBlock = ^(){
        
            UIImage *image = self.lee_theme.modelThemeImageConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *imageName = self.lee_theme.modelThemeImageNameConfigInfo[[LEETheme currentThemeTag]];
            
            NSString *imagePath = self.lee_theme.modelThemeImagePathConfigInfo[[LEETheme currentThemeTag]];
            
            if (image) [self setImage:image];
            
            if (imageName) [self setImage:[UIImage imageNamed:imageName]];
            
            if (imagePath) [self setImage:[UIImage imageWithContentsOfFile:imagePath]];
        };
        
        [super changeThemeConfigWithAboutConfigBlock:aboutConfigBlock];
        
    }
    
}

@end




#pragma mark - ----------------工具扩展----------------

@implementation UIColor (LEEThemeColor)

+ (UIColor *)leeTheme_ColorWithHexString:(NSString *)hexString{
    
    if (!hexString) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 0:
            return nil;
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            alpha = 0, red = 0, blue = 0, green = 0;
            break;
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start:(NSUInteger) start length:(NSUInteger) length{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}

@end
