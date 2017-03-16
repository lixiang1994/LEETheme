//
//  FontSizeManager.m
//  MierMilitaryNews
//
//  Created by liuxin on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "FontSizeManager.h"

#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) < 568.0)
#define IS_IPHONE_5         (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) == 568.0)
#define IS_IPHONE_6         (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) == 667.0)
#define IS_IPHONE_6P        (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) == 736.0)

@interface FontSizeManager ()

@end

@implementation FontSizeManager

+ (CGFloat)textFontSizeForDefault:(CGFloat )fontSize{
    
    CGFloat size = fontSize;
    
    if (IS_IPHONE_4_OR_LESS){
        
        size = fontSize * 1.0f;
    
    } else if (IS_IPHONE_5){
        
        size = fontSize * 1.0f;
    
    } else if (IS_IPHONE_6){
      
        size = fontSize * 1.05f;
    
    } else if (IS_IPHONE_6P){
      
        size = fontSize * 1.15f;
    }
    
    return size;
    
}

+ (CGFloat)textFontSizeForWebContent:(CGFloat)fontSize{
    
    CGFloat size = fontSize;
    
    if (IS_IPHONE_4_OR_LESS){
        
        size = fontSize * 1.0f;
        
    } else if (IS_IPHONE_5){
        
        size = fontSize * 1.0f;
        
    } else if (IS_IPHONE_6){
        
        size = fontSize * 1.1f;
        
    } else if (IS_IPHONE_6P){
        
        size = fontSize * 1.2f;
    }
    
    return size;
}


@end
