Pod::Spec.new do |s|
  s.name         = 'ZCCContractModule'
  s.version      = '1.0.0'
  s.summary      = '合同模块 — 提供合同按钮状态与签署跳转'
  s.homepage     = 'https://github.com/example/ZCCContractModule'
  s.license      = { :type => 'MIT' }
  s.author       = 'ComponentizedApp'
  s.source       = { :git => 'https://github.com/example/ZCCContractModule.git', :tag => s.version.to_s }
  s.platform     = :ios, '15.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks   = 'UIKit', 'Foundation'
  s.requires_arc = true
  s.dependency 'ZCCMediator'
  s.dependency 'ZCCLogComponent'
end
