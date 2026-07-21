Pod::Spec.new do |s|
  s.name         = "ZCCAssetModule"
  s.version      = "1.0.0"
  s.summary      = "ZCCAssetModule"
  s.homepage     = "https://github.com/example/ZCCAssetModule"
  s.license      = { :type => "MIT" }
  s.author       = "ComponentizedApp"
  s.source       = { :git => "https://github.com/example/ZCCAssetModule.git", :tag => s.version.to_s }
  s.platform     = :ios, "15.0"
  s.frameworks   = "UIKit"
  s.frameworks   = "Foundation"
  s.frameworks   = "WebKit"
  s.requires_arc = true
  s.dependency "ZCCBaseAssetModule"
  s.source_files        = "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"
end
