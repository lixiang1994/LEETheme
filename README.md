
# LEETheme - 最好用的轻量级主题管理框架

[![License GPL](https://img.shields.io/aur/license/yaourt.svg?maxAge=2592000)](https://github.com/lixiang1994/LEETheme/blob/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/LEETheme.svg?style=flat)](http://cocoapods.org/?q= LEETheme)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/LEETheme.svg?style=flat)](http://cocoapods.org/?q= LEETheme)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS7%2B-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYWebImage.svg?branch=master)]()



演示
==============

![朋友圈Demo演示](https://github.com/lixiang1994/LEETheme/blob/master/朋友圈Demo日夜间切换演示.gif)

特性
==============
- 两种设置模式,可根据对象单独添加设置,可通过JSON配置统一设置,满足不同风格的开发者。
- 轻量级设计,整个框架只有2个文件构成。
- 支持所有NSObject子类对象,包含所有常用视图对象的颜色和图片等设置。
- 支持动态添加主题,可实现网络主题切换功能。
- 语法优雅,高效简洁,一行代码完成对象设置。
- 当前主题记忆功能,下一次启动自动布置。
- 异步切换主题样式，避免主线程阻塞。
- 完善的文档注释和使用教程。

用法
==============

###独立设置模式

	// 添加背景颜色
	imageView.lee_theme
    .LeeAddBackgroundColor(@"red" , [UIColor redColor])
    .LeeAddBackgroundColor(@"blue" , [UIColor blueColor]);
	
	// 添加图片
	imageView.lee_theme
    .LeeAddImage(@"red" , [UIImage imageNamed:@"red.png"])
    .LeeAddImage(@"blue" , [UIImage imageNamed:@"blue.png"]);
	
	// 添加自定义设置 (每个主题标签对应一个block , 当触发其中添加的主题后会执行相应的block)
	imageView.lee_theme
    .LeeAddCustomConfig(RED , ^(UIImageView *item){
        
        item.hidden = YES; //简单举例 红色主题启动时 将这个imageview对象隐藏
    })
    .LeeAddCustomConfig(BLUE , ^(UIImageView *item){
        
        item.hidden = NO; //或者随便做一些其他羞羞的事
    })
    .LeeAddCustomConfig(GRAY , ^(UIImageView *item){
        
        item.hidden = NO;
    });


LEETheme支持对任何NSObject子类的对象进行其持有属性的设置 , 例如UIImageView类的对象持有image属性 , 那么使用LEETheme就可以为它设置不同主题对应的image属性值, 以此类推 , 当然所有类型的对象都可以添加自定义Block设置.

###JSON设置模式
	
未完 待补充


###启用主题

未完 待补充


安装
==============

### CocoaPods

1. 将 cocoapods 更新至最新版本.
2. 在 Podfile 中添加 `pod 'LEETheme'`。
3. 执行 `pod install` 或 `pod update`。
4. 导入 `<LEETheme/LEETheme.h>`。

### 手动安装

1. 下载 LEETheme 文件夹内的所有内容。
2. 将 LEETheme 内的源文件添加(拖放)到你的工程。
3. 导入 `LEETheme.h`。

系统要求
==============
该项目最低支持 `iOS 7.0` 和 `Xcode 7.0`。


许可证
==============
LEETheme 使用 GPL V3 许可证，详情见 LICENSE 文件。

相关链接
==============
[我的简书](http://www.jianshu.com/users/a6da0db100c8)
