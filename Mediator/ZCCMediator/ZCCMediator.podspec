Pod::Spec.new do |s|
  s.name         = 'ZCCMediator'
  s.version      = '1.0.0'
  s.summary      = '基于有赞 Bifrost 模式的中介层 — 协议注册/查找，解耦业务模块间通信'
  s.homepage     = 'https://github.com/example/ZCCMediator'
  s.license      = { :type => 'MIT' }
  s.author       = 'ComponentizedApp'
  s.source       = { :git => 'https://github.com/example/ZCCMediator.git', :tag => s.version.to_s }
  s.platform     = :ios, '15.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks   = 'Foundation', 'UIKit'
  s.requires_arc = true
end
