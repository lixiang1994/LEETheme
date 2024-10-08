
# LEETheme - 更新日志

V1.2.2
==============
增加图片缓存

V1.2.1
==============
添加隐私清单

V1.1.11
==============
增加Swift Package Manager支持

V1.1.10
==============
- 内部优化 顺便修复后台系统APP进程页面 无法跟随系统主题更新截图样式的问题.

V1.1.9
==============
- 修复Pods配置问题
- 适配iOS13 `_placeholderLabel.textColor`私有方法问题

V1.1.8
==============
- 更换开源协议为MIT

V1.1.7
==============
- 调整持续集成配置 (其他无改动)

V1.1.6
==============
- 优化清空标识符设置 
- 优化移除某一标识符设置
- 优化标识符模式的`selector`设置方法 并且参数支持多个标识符 (原来设置一个`selector`, 参数只能包含一个标识符)
- 增加`LEEThemeHelper.h`文件 优化文件结构
- 其他小细节完善


V1.1.5
==============
- 增加一些容错处理 防止因某些对象nil可能造成的崩溃


V1.1.4
==============
- 修复添加新主题配置的资源路径问题 该问题会导致无法找到沙盒内的图片资源


V1.1.3
==============
- 调整内部Hook


V1.1.2
==============
- 添加Framework 调整git目录结构 调整pods引用路径
- 完善Travis Ci
- 调整说明


V1.1.1
==============
- 修复同一对象同一方法相同主题的不同参数设置无法存储的问题
- 完善Demo 增加过渡动画效果演示, 增加状态栏设置, 修复YYkit的demo切换主题卡顿问题等.
- 增加部分非主线程处理
- 暂时去除动画时间设置
- 增加了一些容错处理


V1.1.0
==============
- 设置机制全面重构, 采用SEL与KVC结合的方式进行对象方法属性等设置.
- 设置存储结构优化, 更简洁更安全.
- 代码结构优化 细分两大模式 目前分为默认模式和json模式.
- 颜色快捷设置方法支持传入十六进制颜色字符串
- 图片快捷设置方法支持传入UIImage对象, 图片名称字符串, 完整的图片文件路径字符串 
- 增加对象任意方法的设置 不再局限于属性(默认 json模式均支持)
- 增加移除任意方法或属性的设置.
- 增加移除对象全部的设置.
- 增加移除对象某一主题的设置.
- 增加主题改变Block设置.
- 优化主题设置Json添加的处理 (原添加过的json会持久化存储).
- 增加移除某一主题设置json (如果移除的为当前的主题 会自动启用默认的主题).
- 规范部分方法名称 移除了一些多余的方法.
- 增加获取配置值的宏和十六进制字符串转color的宏


V1.0.7
==============
- 优化释放 , 调整category内部方法 防止冲突.


V1.0.6
==============
- 增加默认更改主题动画时长设置 优化初始样式设置.


V1.0.5
==============
- 提供keyPath属性设置方法.


V1.0.4
==============
- 优化JSON模式内部处理机制 完善介绍注意事项.


V1.0.3
==============
- 内部机制优化 , 优化掉1000+行代码 , 增加更多属性快捷设置方法 , 完善注释.


V1.0.2
==============
- 优化内部代码结构 - 增加获取JSON配置信息中 UIImage UIColor对象的方法.


V1.0.1
==============
- 发布到Pods.


V1.0.0
==============
- 初始版本发布.
