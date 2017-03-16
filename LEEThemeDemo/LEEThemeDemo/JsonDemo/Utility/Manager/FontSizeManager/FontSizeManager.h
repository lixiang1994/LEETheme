//
//  FontSizeManager.h
//  MierMilitaryNews
//
//  Created by liuxin on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontSizeManager : NSObject

+ (CGFloat)textFontSizeForDefault:(CGFloat )fontSize;

+ (CGFloat)textFontSizeForWebContent:(CGFloat)fontSize;

@end
