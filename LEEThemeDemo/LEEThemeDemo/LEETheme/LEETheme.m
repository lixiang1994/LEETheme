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

@interface LEEThemeConfigModel ()

@property (nonatomic , copy ) NSString *modelCurrentThemeTag;

@property (nonatomic , assign ) CGFloat modelChangeThemeAnimationDuration;

@property (nonatomic , copy ) NSMutableDictionary *modelThemeConfigInfo;

@end

@implementation LEEThemeConfigModel

- (void)dealloc{
    
    _modelCurrentThemeTag = nil;
    _modelThemeConfigInfo = nil;
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

- (LEEConfigThemeToTagAndBlock)LeeAddTheme{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , LEEThemeConfigBlock configBlock){
        
        [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
        
        return weakSelf;
    };
    
}

- (LEEConfigThemeToTagsAndBlock)LeeAddThemes{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSArray *tags , LEEThemeConfigBlock configBlock){
        
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [weakSelf.modelThemeConfigInfo setObject:configBlock forKey:tag];
        }];
        
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

@end

@implementation UIView (LEEThemeConfigView)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews" , @"dealloc"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *leeSelString = [@"lee_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            
            method_exchangeImplementations(originalMethod, leeMethod);
        }];

    });
    
}

- (void)lee_layoutSubviews{
    
    [self lee_layoutSubviews];
    
    if ([self isLeeTheme]) [self changeThemeConfig];
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
    
    [self changeThemeConfig];
}

- (void)changeThemeConfig{
    
    if (!self.lee_theme.modelCurrentThemeTag || ![self.lee_theme.modelCurrentThemeTag isEqualToString:[LEETheme currentThemeTag]]) {
    
        self.lee_theme.modelCurrentThemeTag = [LEETheme currentThemeTag];
        
        NSDictionary *info = self.lee_theme.modelThemeConfigInfo;
        
        LEEThemeConfigBlock configBlock = info[[LEETheme currentThemeTag]];
        
        [UIView beginAnimations:@"LEEThemeChangeAnimations" context:nil];
        
        [UIView setAnimationDuration:self.lee_theme.modelChangeThemeAnimationDuration];
        
        if (configBlock) configBlock(self);
        
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

@implementation UIButton (LEEThemeConfigButton)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(@"layoutSubviews"));
        
        Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(@"lee_layoutSubviews"));
        
        method_exchangeImplementations(originalMethod, leeMethod);
        
    });
    
}

- (void)lee_layoutSubviews{
    
    [self lee_layoutSubviews];
    
    if ([self isLeeTheme]) [self changeThemeConfig];
}

@end