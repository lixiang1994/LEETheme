Pod::Spec.new do |s|

s.name         = "LEETheme"
s.version      = "1.0.0"
s.summary      = "最好用的主题管理库"

s.homepage     = "https://github.com/lixiang1994/LEETheme"
# s.screenshots  = "https://github.com/lixiang1994/LEETheme/blob/master/朋友圈Demo日夜间切换演示.gif"

s.license      = "GPL"

s.author             = { "LEE" => "applelixiang@126.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/gsdios/SDAutoLayout.git", :tag => "2.1.1"}

s.source_files  = "SDAutoLayoutDemo/SDAutoLayout/**/*.{h,m}"

# s.public_header_files = "Classes/**/*.h"


s.requires_arc = true

# s.dependency "JSONKit", "~> 1.4"

end
