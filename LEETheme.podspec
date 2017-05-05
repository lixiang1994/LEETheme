Pod::Spec.new do |s|

s.name         = "LEETheme"
s.version      = "1.1.0"
s.summary      = "最好用的轻量级主题管理库"

s.homepage     = "https://github.com/lixiang1994/LEETheme"
# s.screenshots  = "https://github.com/lixiang1994/LEETheme/blob/master/朋友圈Demo日夜间切换演示.gif"

s.license      = "GPL"

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/lixiang1994/LEETheme.git", :tag => "1.1.0"}

s.source_files  = "LEEThemeDemo/LEEThemeDemo/LEETheme/**/*.{h,m}"

# s.public_header_files = "Classes/**/*.h"

s.requires_arc = true

end
