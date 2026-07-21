Pod::Spec.new do |s|
  s.name         = 'ZCCCertificateModule'
  s.version      = '1.0.0'
  s.summary      = '办证模块 — 提供办证按钮状态与不动产证办理跳转'
  s.homepage     = 'https://github.com/example/ZCCCertificateModule'
  s.license      = { :type => 'MIT' }
  s.author       = 'ComponentizedApp'
  s.source       = { :git => 'https://github.com/example/ZCCCertificateModule.git', :tag => s.version.to_s }
  s.platform     = :ios, '15.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks   = 'UIKit', 'Foundation'
  s.requires_arc = true
  s.dependency 'ZCCMediator'
  s.dependency 'ZCCLogComponent'
end
