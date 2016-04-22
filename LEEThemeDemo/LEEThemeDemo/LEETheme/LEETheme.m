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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEThemeChangingNotificaiton object:nil userInfo:@{@"tag" : tag}];
}

+ (NSString *)currentThemeTag{
    
    return [LEETheme shareTheme].currentTag ? [LEETheme shareTheme].currentTag : [[NSUserDefaults standardUserDefaults] objectForKey:@"LEEThemeCurrentTag"];
}

- (void)setCurrentTag:(NSString *)currentTag{
    
    _currentTag = currentTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:@"LEEThemeCurrentTag"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - LazyLoading

- (NSMutableSet *)allTags{
    
    if (!_allTags) _allTags = [NSMutableSet set];

    return _allTags;
}

@end

@implementation UIView (LEEThemeConfig)

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LEEThemeChangingNotificaiton object:nil];
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeConfig:) name:LEEThemeChangingNotificaiton object:nil];
    
}

- (void)changeThemeConfig:(NSNotification *)notify{
    
    NSDictionary *notifyInfo = notify.userInfo;
    
    NSDictionary *info = [self lee_themeConfigInfo];
    
    LEEThemeConfigBlock configBlock = info[notifyInfo[@"tag"]];
    
    [UIView beginAnimations:@"LEEThemeChangeAnimations" context:nil];
    
    [UIView setAnimationDuration:0.2f];
    
    if (configBlock) configBlock(self);
    
    [UIView commitAnimations];   
}

- (void)configThemeWithTag:(NSString *)tag ConfigBlock:(LEEThemeConfigBlock)configBlock{
    
    if (!tag) return;
    
    if (!configBlock) return;
    
    [self addNotification];
    
    [[LEETheme shareTheme].allTags addObject:tag];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[self lee_themeConfigInfo]];
    
    [info setObject:configBlock forKey:tag];
    
    [self lee_setThemeConfigInfo:info];
    
    if ([[LEETheme currentThemeTag] isEqualToString:tag]) if (configBlock) configBlock(self);
}

- (void)configThemeWithTag:(NSString *)tag ConfigBlock:(LEEThemeConfigBlock)configBlock CompatibleTags:(NSString *)tags,...{
    
    [self configThemeWithTag:tag ConfigBlock:configBlock];
    
    if (tags) {
    
        NSMutableArray *tagsArray = [NSMutableArray array];
    
        [tagsArray addObject:tags];
        
        va_list tagsVaList;
        
        NSString *eachTag;
        
        va_start(tagsVaList, tags);
        
        while ((eachTag = va_arg(tagsVaList, NSString *))) {
            
            [tagsArray addObject:eachTag];
        }
        
        va_end(tagsVaList);
        
        if (tagsArray.count > 0) {
            
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[self lee_themeConfigInfo]];
            
            for (NSString *tagItem in tagsArray) {
                
                if (![info objectForKey:tagItem]) {
                
                    [info setObject:configBlock forKey:tagItem];
                    
                    if ([[LEETheme currentThemeTag] isEqualToString:tagItem]) if (configBlock) configBlock(self);
                }
                
            }
            
            [self lee_setThemeConfigInfo:info];
        }
        
    }
    
}

- (NSDictionary *)lee_themeConfigInfo{
    
    return objc_getAssociatedObject(self, @selector(lee_themeConfigInfo));
}

- (void)lee_setThemeConfigInfo:(NSDictionary *)info{
    
    objc_setAssociatedObject(self, @selector(lee_themeConfigInfo), info , OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end