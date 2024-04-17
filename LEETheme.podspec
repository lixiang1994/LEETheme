Pod::Spec.new do |s|

s.name         = "LEETheme"
s.version      = "1.2.1"
s.summary      = "最好用的轻量级主题管理库"

s.homepage     = "https://github.com/lixiang1994/LEETheme"
# s.screenshots  = "https://github.com/lixiang1994/LEETheme/blob/master/朋友圈Demo日夜间切换演示.gif"

s.license      = "MIT"

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/lixiang1994/LEETheme.git", :tag => s.version}

s.source_files  = "LEETheme/**/*.{h,m}"

s.requires_arc = true

s.subspec 'Privacy' do |ss|
    ss.resource_bundles = {
        "LEETheme" => 'LEETheme/PrivacyInfo.xcprivacy'
    }
end
end
