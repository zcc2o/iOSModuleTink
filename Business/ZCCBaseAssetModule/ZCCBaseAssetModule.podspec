Pod::Spec.new do |s|
  s.name         = "ZCCBaseAssetModule"
  s.version      = "1.0.0"
  s.summary      = "ZCCBaseAssetModule"
  s.homepage     = "https://github.com/example/ZCCBaseAssetModule"
  s.license      = { :type => "MIT" }
  s.author       = "ComponentizedApp"
  s.source       = { :git => "https://github.com/example/ZCCBaseAssetModule.git", :tag => s.version.to_s }
  s.platform     = :ios, "15.0"
  s.frameworks   = "UIKit"
  s.frameworks   = "Foundation"
  s.requires_arc = true
  s.dependency "ZCCMediator"
  s.dependency "ZCCUIComponent"
  s.dependency "ZCCWebComponent"
  s.dependency "ZCCLogComponent"
  s.source_files        = "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"
end
