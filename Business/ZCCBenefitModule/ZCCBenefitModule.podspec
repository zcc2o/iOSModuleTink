Pod::Spec.new do |s|
  s.name         = 'ZCCBenefitModule'
  s.version      = '1.0.0'
  s.summary      = '权益业务模块 — 用户权益列表、详情展示'
  s.homepage     = 'https://github.com/example/ZCCBenefitModule'
  s.license      = { :type => 'MIT' }
  s.author       = 'ComponentizedApp'
  s.source       = { :git => 'https://github.com/example/ZCCBenefitModule.git', :tag => s.version.to_s }
  s.platform     = :ios, '15.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks   = 'UIKit', 'Foundation'
  s.requires_arc = true

  s.dependency 'ZCCMediator'
  s.dependency 'ZCCUIComponent'
  s.dependency 'ZCCLogComponent'
end
