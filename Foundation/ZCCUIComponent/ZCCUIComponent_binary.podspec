Pod::Spec.new do |s|
  s.name         = "ZCCUIComponent"
  s.version      = "1.0.0"
  s.summary      = "ZCCUIComponent"
  s.homepage     = "https://github.com/example/ZCCUIComponent"
  s.license      = { :type => "MIT" }
  s.author       = "ComponentizedApp"
  s.source       = { :git => "https://github.com/example/ZCCUIComponent.git", :tag => s.version.to_s }
  s.platform     = :ios, "15.0"
  s.frameworks   = "UIKit"
  s.frameworks   = "Foundation"
  s.requires_arc = true
  s.dependency "ZCCLogComponent"
  s.vendored_frameworks = "Binary/ZCCUIComponent.framework"
end
