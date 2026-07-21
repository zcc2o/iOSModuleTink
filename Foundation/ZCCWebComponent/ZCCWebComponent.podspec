Pod::Spec.new do |s|
  s.name         = "ZCCWebComponent"
  s.version      = "1.0.0"
  s.summary      = "ZCCWebComponent"
  s.homepage     = "https://github.com/example/ZCCWebComponent"
  s.license      = { :type => "MIT" }
  s.author       = "ComponentizedApp"
  s.source       = { :git => "https://github.com/example/ZCCWebComponent.git", :tag => s.version.to_s }
  s.platform     = :ios, "15.0"
  s.frameworks   = "UIKit"
  s.frameworks   = "WebKit"
  s.requires_arc = true
  s.dependency "ZCCLogComponent"
  s.source_files        = "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"
end
