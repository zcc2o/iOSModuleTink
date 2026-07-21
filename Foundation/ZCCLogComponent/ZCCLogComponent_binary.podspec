Pod::Spec.new do |s|
  s.name         = "ZCCLogComponent"
  s.version      = "1.0.0"
  s.summary      = "ZCCLogComponent"
  s.homepage     = "https://github.com/example/ZCCLogComponent"
  s.license      = { :type => "MIT" }
  s.author       = "ComponentizedApp"
  s.source       = { :git => "https://github.com/example/ZCCLogComponent.git", :tag => s.version.to_s }
  s.platform     = :ios, "15.0"
  s.frameworks   = "Foundation"
  s.requires_arc = true
  s.vendored_frameworks = "Binary/ZCCLogComponent.framework"
end
