//
//  MainWindow.m
//  LEEThemeDemo
//
//  Created by Lee on 2019/10/2.
//  Copyright © 2019 lee. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 根据系统样式变化 重新启用相应的主题 以达到同步的效果
        if (@available(iOS 13.0, *)) {
            switch (self.traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    
                    [LEETheme startTheme:DAY];
                    
                    break;
                    
                case UIUserInterfaceStyleDark:
                    
                    [LEETheme startTheme:NIGHT];
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // 根据系统样式变化 重新启用相应的主题 以达到同步的效果
    if (@available(iOS 13.0, *)) {
        switch (self.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleLight:
                
                [LEETheme startTheme:DAY];
                
                break;
                
            case UIUserInterfaceStyleDark:
                
                [LEETheme startTheme:NIGHT];
                
                break;
                
            default:
                break;
        }
    }
}

@end
